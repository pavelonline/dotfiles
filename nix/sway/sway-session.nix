{ stdenv, sway, writeText, swayConfig, ... }:

let
  sessionFile = writeText "sway.desktop" ''
    [Desktop Entry]
    Name=sway
    Comment=Sway Wayland session
    Exec=${sway}/bin/sway -c /etc/${swayConfig}"
    X-LightDM-Session-Type=wayland
  '';
in
stdenv.mkDerivation {
  name = "sway-session";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/share/xsessions
    cp ${sessionFile} $out/share/xsessions/sway.desktop
  '';
  passthru.providedSessions = [ "sway" ];
}
