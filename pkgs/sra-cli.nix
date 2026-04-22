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
    rev = "f1c6a80a4a56dc5f944d341a85c6ac01471633eb";
    hash = "sha256-DHGq4hMnbn8YH590mhW+39YEdZdw6ifw5xXt4MjDNn4=";
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
