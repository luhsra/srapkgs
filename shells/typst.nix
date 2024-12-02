{ pkgs }:

pkgs.mkShellNoCC {
  buildInputs = with pkgs; [
    git
    pandoc
    typst
    tinymist
    typstyle
  ];
}
