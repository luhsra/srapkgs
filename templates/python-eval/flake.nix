{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    srapkgs.url = "github:luhsra/srapkgs";
  };
  outputs =
    {
      self,
      nixpkgs,
      srapkgs,
      ...
    }:
    let
      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forEachSupportedSystem =
        f:
        nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ srapkgs.overlays.default ];
            };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              (python3.withPackages (
                pp: with pp; [
                  pandas
                  matplotlib
                  numpy
                  scipy
                  scikit-learn
                  versuchung
                  numba
                  pillow
                ]
              ))
            ];
          };
        }
      );
    };
}
