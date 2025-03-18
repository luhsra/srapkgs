{
  description = "SRA flake for Linux kernel development";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: let
    supportedSystems = [ "aarch64-linux" "x86_64-linux"
                         "aarch64-darwin" "x86_64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    devShells = forAllSystems (system: let pkgs = nixpkgs.legacyPackages.${system}; in {
      default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          clang_18
          lld_18
          llvm_18
          clang-tools_18
          ncurses
          pkg-config
          qemu qemu_kvm qemu-utils
          guestfs-tools
        ];
        inputsFrom = [ pkgs.linux ];
        hardeningDisable = [ "all" ];
        env = {
          LLVM = 1;
        };
      };
    });
  };
}
