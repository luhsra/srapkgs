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
      luadata = final.callPackage ./pkgs/luadata.nix { };
      versuchung = final.callPackage ./pkgs/versuchung.nix { inherit luadata; };
      sra-cli = final.callPackage ./pkgs/sra-cli.nix { };
      bib2json = final.callPackage ./pkgs/bib2json.nix { };
    };
    devShells = forAllSystems (system: {
      linux = import ./shells/linux.nix { pkgs = pkgs.${system}; };
      linux-llvm15 = import ./shells/linux-llvm15.nix { pkgs = pkgs.${system}; };
      tex = import ./shells/tex.nix { pkgs = pkgs.${system}; };
    });
    templates = nixpkgs.lib.attrsets.genAttrs [
      "latex" "typst" "devshell"
    ] (name: {
      path = ./templates/${name};
      description = (import ./templates/${name}/flake.nix).description;
    }) // {
      "linux" = {
        path = ./templates/linux;
        description = "Linux development environment and vm tooling";
        welcomeText = ''
          Adjust KBUILD\_INPUT and KBUILD\_OUTPUT in .envrc if needed!

          Quickstart:

          1. direnv allow .

          2. just install-vmconfig

          3. just make

          4. just qemu
        '';
      };
    };
  };
}
