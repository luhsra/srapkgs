{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  pkg-config,
  elfutils,
}:

buildPythonPackage rec {
  pname = "drgn";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZJPrmZzCRSEhb3aqfs+J7Y+uKAd7vnqmODhZNGWe7SI=";
  };

  # specific to buildPythonPackage, see its reference
  pyproject = true;
  build-system = [
    setuptools
    wheel
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    elfutils
  ];
}
