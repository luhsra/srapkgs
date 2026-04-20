{
  description = "Flake for Linux kernel development in Project SRA";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      lib = nixpkgs.lib;
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      # See https://github.com/NixOS/nixpkgs/issues/368850#issuecomment-3186923233
      # Patch all LLVM versions
      fix-clang-wrappers =
        _final: prev:
        let
          only-llvmPackages = lib.filterAttrs (n: _: lib.hasPrefix "llvmPackages" n) prev;
          fix-clang-wrapper =
            v:
            v
            // {
              stdenv = v.stdenv // {
                mkDerivation =
                  attrs:
                  (v.stdenv.mkDerivation attrs).overrideAttrs (this: {
                    env = (this.env or { }) // {
                      # Fix `--target` spam.
                      NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING = 1;
                      # Fix `-nostdinc` warnings.
                      NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
                        (this.env.NIX_CFLAGS_COMPILE or "")
                        "-Wno-unused-command-line-argument"
                      ];
                    };
                  });
              };
            };
        in
        builtins.mapAttrs (_: fix-clang-wrapper) only-llvmPackages;
      forEachSupportedSystem =
        f:
        lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                fix-clang-wrappers
              ];
            };
          }
        );
    in
    {
      # Dev shell for the whole project (excluding kernel compilation).
      devShells = forEachSupportedSystem (
        { pkgs }:
        let
          # NOTE: Replace LLVM version here
          llvm = pkgs.llvmPackages_18;
          kernel_pkgs = with pkgs; [
            # Linux kernel extra stuff
            ccache
            llvm.clang
            llvm.lld
            llvm.llvm
            llvm.clang-tools
            libgcc
            curlFull
            ncurses
            pkg-config
            gdb
          ];
        in
        {
          default =
            pkgs.mkShell.override
              {
                stdenv = llvm.stdenv;
              }
              {
                hardeningDisable = [ "all" ];
                packages = kernel_pkgs ++ [
                  pkgs.qemu_kvm
                  pkgs.qemu-python-utils
                ];
                inputsFrom = [ pkgs.linux ];
                env = {
                  LLVM = 1;
                };
              };
        }
      );
    };
}
