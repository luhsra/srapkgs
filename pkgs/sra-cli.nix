{ lib
, pkgs
, fetchgit
, python3Packages }:

with python3Packages; buildPythonApplication {
  pname = "sra-cli";
  version = "2026.10.12";
  pyproject = true;

  src = fetchgit {
    url = "https://scm.sra.uni-hannover.de/published/sra-cli.git";
    rev = "d0c6527e73ec959c7ff31c147ee08ae55ad57b50";
    hash = "sha256-vz/sqnrL7/RtscW8A96piLnztLr/w6QFlcukqpoKYxg=";
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
