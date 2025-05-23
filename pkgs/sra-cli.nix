{ lib
, pkgs
, fetchgit
, python3Packages }:

with python3Packages; buildPythonApplication {
  pname = "sra-cli";
  version = "2025.04.28-1";
  pyproject = true;

  src = fetchgit {
    url = "https://scm.sra.uni-hannover.de/published/sra-cli.git";
    rev = "f6d2805bb3a6b1bb35b2b72c3f593ff28b4ea87e";
    hash = "sha256-rcw/G3RSY0yJOueSFpa2mMGfkBMBRfOcwYJ/blC2e+I=";
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
