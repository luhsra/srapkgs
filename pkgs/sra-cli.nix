{ lib
, pkgs
, fetchgit
, python3Packages }:

with python3Packages; buildPythonApplication {
  pname = "sra-cli";
  version = "2025.06.03-2";
  pyproject = true;

  src = fetchgit {
    url = "https://scm.sra.uni-hannover.de/published/sra-cli.git";
    rev = "8090b4e0e5b087dc506091159477429bf97d2245";
    hash = "sha256-GTMn36xN/Evjlvt5oeZhOIgMAdoIu+z0L+T80p9P3Fg=";
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
