{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "font-rotis";
  version = "2025-05-07";

  src = fetchzip {
    url = "https://www.luis.uni-hannover.de/fileadmin/arbeitsplatzpc/luh_intern/Rotis-Font/Rotis.zip";
    stripRoot = false;
    hash = "sha256-SY3c6SOtz1TAcrv1nS+t57hLEnygT1JmV1hyasH53zM=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    description = " Hausschrift Rotis an der Leibniz Universität Hannover";
    homepage = "https://www.luis.uni-hannover.de/de/services/betrieb-und-infrastruktur/arbeitsplatz-pc/apc-dienste/hausschrift-luh-rotis";
    platforms = platforms.all;
  };
}
