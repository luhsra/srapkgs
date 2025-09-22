{ lib
, pkgs
, fetchgit
, python3Packages }:

with python3Packages; buildPythonApplication {
  pname = "sra-cli";
  version = "2025.08.15-1";
  pyproject = true;

  src = fetchgit {
    url = "https://scm.sra.uni-hannover.de/published/sra-cli.git";
    rev = "8b310923efdc5c0f29fe9ba653b8241eaf4eaf7b";
    hash = "sha256-vH8S12LZ5+YY6NFVkxetxx4KPqLsef6cTa/NKjQ0jpk=";
  };

  # As in pyproject.toml
  dependencies = let
    studip_jsonapi = buildPythonPackage {
      pname = "studip_jsonapi";
      version = "0.0.3";
      pyproject = true;
      doCheck = false;

      src = pkgs.fetchgit {
        url = "https://github.com/luhsra/studip-jsonapi.git";
        rev = "v0.0.3";
        hash = "sha256-Yt3OMqoB0VFWCQwe0GQqFYu+mosV7YtNwfCLBCvPOvM=";
      };

      nativeBuildInputs = [
        setuptools
      ];
    };
  in [
    pyyaml
    python-dateutil
    requests
    requests-oauthlib
    fusepy
    python-gitlab
    gitpython
    platformdirs
    ldap3
    prettytable
    studip_jsonapi
  ];

  build-system = [ setuptools ];

  meta.mainProgram = "sra";
}
