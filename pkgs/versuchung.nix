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
    rev = "466358f6e7c488e73b650b6c89916ddf62cc4e50";
    hash = "sha256-ZVMzQbhxO91gKDZAZNYbmg976kgibzFYbsQaHgouNw0=";
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
