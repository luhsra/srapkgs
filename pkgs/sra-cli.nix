{ lib
, pkgs
, fetchgit
, python3Packages }:

with python3Packages; buildPythonApplication {
  pname = "sra-cli";
  version = "2025.06.03-3";
  pyproject = true;

  src = fetchgit {
    url = "https://scm.sra.uni-hannover.de/published/sra-cli.git";
    rev = "b3eb2ec1d24193131a7d4892d8a812a14b83dad4";
    hash = "sha256-QqZoCjEWW9texmv+micGn27chzHjEMh5FRa+j3M0C50=";
  };

  # As in pyproject.toml
  dependencies = [
    pyyaml
    python-dateutil
    requests
    requests-oauthlib
    fusepy
    python-gitlab
    gitpython
    platformdirs
    ldap3
  ];

  build-system = [ setuptools ];

  meta.mainProgram = "sra";
}
