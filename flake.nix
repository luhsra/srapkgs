{
  description = "SRA packages";

  outputs = { self, nixpkgs, ... }: let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
  in {
    packages = forAllSystems (system: rec {
      luadata = pkgs.${system}.python3Packages.callPackage ./pkgs/luadata.nix { };
      versuchung = pkgs.${system}.python3Packages.callPackage ./pkgs/versuchung.nix { inherit luadata; };
      sra-cli = pkgs.${system}.python3Packages.callPackage ./pkgs/sra-cli.nix { };
    });
  };
}
