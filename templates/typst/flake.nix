{
  description = "SRA flake for Typst documents";

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
          git
          pandoc
          typst
          tinymist
          typstyle
        ];
        env = {
          # Make loose fonts available here
          # By default, this includes fonts contained in our texmf template
          TYPST_FONT_PATHS = "texmf/fonts/opentype";
        };
      };
    });
  };
}
