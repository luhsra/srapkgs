{
  description = "SRA flake for Latex documents";

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
          texliveFull
          git
          gnumake
          pandoc
          poppler_utils
          pdftk
          python3
          texlab
          ltex-ls
        ];
      };
    });
  };
}
