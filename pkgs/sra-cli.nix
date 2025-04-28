{ lib
, pkgs
, fetchgit
, python3Packages }:

with python3Packages; buildPythonApplication {
  pname = "sra-cli";
  version = "2025.04.28-0";
  pyproject = true;

  src = fetchgit {
    url = "https://scm.sra.uni-hannover.de/published/sra-cli.git";
    rev = "96b1a60a1798bd8ea5f7d21b5d06dab5e4340f0c";
    hash = "sha256-MifSMH+mFBM2yIStC8Ubbitz1yMwvPGJXdJ5P3IQL0I=";
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
