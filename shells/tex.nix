{ pkgs }:

pkgs.mkShellNoCC {
  buildInputs = with pkgs; [
    texliveFull
    git
    gnumake
    ltex-ls
    pandoc
    poppler_utils
    pdftk
    python3
    texlab
  ];
}
