{ lib
, pkgs
, fetchgit
, python3Packages }:

with python3Packages; buildPythonApplication {
  pname = "sra-cli";
  version = "0.3.0";
  pyproject = true;

  src = fetchgit {
    url = "https://scm.sra.uni-hannover.de/published/sra-cli.git";
    rev = "a645f37b4527b2fde6134ac93072d6d5aa2424ea";
    hash = "sha256-xnfVCH7aN+uzabwjauowFv1e6pcRmYlVUO3GAzCiUdQ=";
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
