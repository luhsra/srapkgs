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
    rev = "dfff5f6a2e2352d2f4551cdf8138d4d46b990ed3";
    hash = "sha256-OXAcsF/GTiBvVPhou4rk9IFqeH231ZcOKdHCgUIq7q0=";
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
    prettytable
  ];

  build-system = [ setuptools ];

  meta.mainProgram = "sra";
}
