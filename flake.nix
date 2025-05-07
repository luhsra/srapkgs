{
  description = "SRA packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: let
    supportedSystems = [ "aarch64-linux" "x86_64-linux"
                         "aarch64-darwin" "x86_64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgs = forAllSystems (system: import nixpkgs {
      inherit system; overlays = [ self.overlays.default ];
    });
  in {
    packages = forAllSystems (system: {
      inherit (pkgs.${system}) luadata versuchung sra-cli bib2json font-rotis;
    });
    overlays.default = final: prev: rec {
      font-rotis = final.callPackage ./pkgs/font-rotis.nix { };
      luadata = final.python3Packages.callPackage ./pkgs/luadata.nix { };
      versuchung = final.python3Packages.callPackage ./pkgs/versuchung.nix { inherit luadata; };
      sra-cli = final.python3Packages.callPackage ./pkgs/sra-cli.nix { };
      bib2json = final.python3Packages.callPackage ./pkgs/bib2json.nix { };
    };
    devShells = forAllSystems (system: {
      linux = import ./shells/linux.nix { pkgs = pkgs.${system}; };
      linux-llvm15 = import ./shells/linux-llvm15.nix { pkgs = pkgs.${system}; };
      tex = import ./shells/tex.nix { pkgs = pkgs.${system}; };
    });
    templates = nixpkgs.lib.attrsets.genAttrs [
      "linux" "latex" "typst" "devshell"
    ] (name: {
      path = ./templates/${name};
      description = (import ./templates/${name}/flake.nix).description;
    });
  };
}
