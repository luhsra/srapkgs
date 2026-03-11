{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    srapkgs.url = "github:luhsra/srapkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      srapkgs,
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
                srapkgs.overlays.default
              ];
            };
          }
        );
    in
    {
      # Qemu image for vm based testing
      packages = forEachSupportedSystem (
        { pkgs }:
        rec {
          vm = (pkgs.nixos [
            (import ./configuration.nix)
          ]).config.system.build.vm;
          default = vm;
        }
      );

      # Dev shell for the whole project (excluding kernel compilation).
      devShells = forEachSupportedSystem (
        { pkgs }:
        let
          # NOTE: Replace LLVM version here
          llvm = pkgs.llvmPackages;
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
            just
            gdb
            (python3.withPackages (pp: with pp; [ drgn ]))
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
                shellHook = ''
                  : "''${KBUILD_INPUT:?Error: KBUILD_INPUT is not set}"
                  : "''${KBUILD_OUTPUT:?Error: KBUILD_OUTPUT is not set}"
                  export KBUILD_INPUT KBUILD_OUTPUT
                '';
              };
        }
      );
    };
}
