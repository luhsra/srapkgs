{ lib
, pkgs
, fetchgit
, python3Packages }:

with python3Packages; buildPythonApplication {
  pname = "sra-cli";
  version = "2025.05.11-0";
  pyproject = true;

  src = fetchgit {
    url = "https://scm.sra.uni-hannover.de/published/sra-cli.git";
    rev = "42977b70f6480a79677207731ac4aebb72e2a246";
    hash = "sha256-QHJRZcr/d/TFv0hxCgIdJx9Pa4vaDMVMSTjnhFwqEzQ=";
  };

  configurePhase = ''
    sed -i /rauth/d pyproject.toml
  '';

  dependencies = [ pyyaml python-dateutil requests fusepy python-gitlab # rauth - deprecated
                   platformdirs ldap3 ];

  build-system = [ setuptools ];

  meta.mainProgram = "sra";

  # Add runtime deps, if any
  # makeWrapperArgs = ["--prefix PATH : ${
  #   lib.makeBinPath [ ]
  # }"];
}
