{
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      # See https://github.com/NixOS/nixpkgs/issues/368850#issuecomment-3186923233
      fix-clang-wrapper = _final: prev: {
        llvmPackages = prev.llvmPackages // {
          libcxxStdenv = prev.llvmPackages.libcxxStdenv // {
            mkDerivation =
              attrs:
              (prev.llvmPackages.libcxxStdenv.mkDerivation attrs).overrideAttrs (this: {
                env = (this.env or { }) // {
                  # Fix `--target` spam.
                  NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING = 1;
                  # Fix `-nostdinc` warnings.
                  NIX_CFLAGS_COMPILE = prev.lib.concatStringsSep " " [
                    (this.env.NIX_CFLAGS_COMPILE or "")
                    "-Wno-unused-command-line-argument"
                  ];
                };
              });
          };
        };
      };
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ fix-clang-wrapper ];
            };
          }
        );
    in
    {
      # Qemu image for vm based testing
      packages = forEachSupportedSystem (
        { pkgs }:
        {
          vm = pkgs.callPackage ./vm.nix { };
        }
      );

      apps = forEachSupportedSystem (
        { pkgs }:
        rec {
          run-vm = {
            type = "app";
            program = "${self.packages.${pkgs.stdenv.hostPlatform.system}.vm}/bin/run-nixos-vm";
          };
          default = run-vm;
        }
      );

      # Dev shell for the whole project (excluding kernel compilation).
      devShells = forEachSupportedSystem (
        { pkgs }:
        let
          kernel_pkgs = with pkgs; [
            # Linux kernel extra stuff
            ccache
            clang
            lld
            llvm
            libgcc
            curlFull
            clang-tools
            ncurses
            pkg-config
            just
            gdb
          ];
        in
        {
          default =
            pkgs.mkShell.override
              {
                # Use clang with libcxx, the only stdlib where std::format is
                # fully implemented
                stdenv = pkgs.libcxxStdenv;
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
