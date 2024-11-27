{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "bib2json";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "luhsra";
    repo = pname;
    rev = version;
    hash = "sha256-mDfge40tR3/QOaWA/aaU2wPKvKA/BrTTCZj2EpEFDjU=";
  };

  cargoHash = "sha256-Y5eqvsFicuiiGTjKBNwCLyPMITYGeNChwbCA90fJWvI=";

  meta = {
    description = "Convert a BibTeX file to JSON (with Typst bibtexparser)";
    homepage = "https://github.com/luhsra/bib2json";
    license = lib.licenses.gpl3;
  };
}
