{
  description = "SRA flake for Typst documents";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    srapkgs.url = "github:luhsra/srapkgs/master";
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    supportedSystems = [ "aarch64-linux" "x86_64-linux"
                         "aarch64-darwin" "x86_64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in {
    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      srapkgs = inputs.srapkgs.packages.${system};
    in {
      default = pkgs.mkShellNoCC {
        buildInputs = with pkgs; [
          git
          pandoc
          typst
          tinymist
          typstyle
        ];
        env = {
          # Supply Rotis. The package can only be installed from the uni network
          # TYPST_FONT_PATHS = "${srapkgs.font-rotis}/share/fonts/opentype";
        };
      };
    });
  };
}
