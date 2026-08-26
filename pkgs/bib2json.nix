{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "bib2json";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "luhsra";
    repo = pname;
    rev = version;
    hash = "sha256-L7RDbdzhFBC5XetF1npnPaogfHaVDc251wHkbRgigyQ=";
  };

  cargoHash = "sha256-64yBOhvLJcA8qrQWwN1vdNEQgTj39GutA9OyAI8fZzE=";

  meta = {
    description = "Convert a BibTeX file to JSON (with Typst bibtexparser)";
    homepage = "https://github.com/luhsra/bib2json";
    license = lib.licenses.gpl3;
  };
}
