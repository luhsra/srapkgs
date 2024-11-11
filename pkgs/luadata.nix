{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "luadata";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fP/f6In9QrneRMeGw8/WWR01/2bM8YEtDL0qO7xt2vA=";
  };

  # do not run tests
  doCheck = false;

  # specific to buildPythonPackage, see its reference
  pyproject = true;
  build-system = [
    setuptools
    wheel
  ];
}
