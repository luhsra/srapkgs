{ lib
, pkgs
, fetchgit
, python3Packages }:

with python3Packages; buildPythonApplication {
  pname = "sra-cli";
  version = "2025.06.03-1";
  pyproject = true;

  src = fetchgit {
    url = "https://scm.sra.uni-hannover.de/published/sra-cli.git";
    rev = "2677e254e976ad83441c1c0501019a29152c6870";
    hash = "sha256-nunn9f0JKFwoy23V803O0zF1c14tfrhzx9hiMUfFL5g=";
  };

  configurePhase = ''
    sed -i /rauth/d pyproject.toml
  '';

  dependencies = [ pyyaml python-dateutil requests fusepy python-gitlab # rauth - deprecated
                   platformdirs ldap3 requests-oauthlib ];

  build-system = [ setuptools ];

  meta.mainProgram = "sra";

  # Add runtime deps, if any
  # makeWrapperArgs = ["--prefix PATH : ${
  #   lib.makeBinPath [ ]
  # }"];
}
