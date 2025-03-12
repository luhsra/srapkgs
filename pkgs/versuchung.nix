{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, papermill
, luadata
}:

buildPythonPackage rec {
  pname = "versuchung";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "stettberger";
    repo = "versuchung";
    rev = "cead6afbc26af4147571d3c51f8e115b51dd6f95";
    hash = "sha256-LV1flf8kwOIr/sDCAiGRAmPdi4hijAi57nc9/UpUSJ4=";
  };

  # do not run tests
  doCheck = false;

  dependencies = [
    papermill
    luadata
  ];

  # specific to buildPythonPackage, see its reference
  pyproject = true;
  build-system = [
    setuptools
    wheel
  ];
}
