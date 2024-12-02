{ pkgs }:

pkgs.mkShellNoCC {
  buildInputs = with pkgs; [
    texliveFull
    gnumake
    poppler_utils
    pdftk
    python3
    git
  ];
}
