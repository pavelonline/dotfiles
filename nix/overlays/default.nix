self: super: rec {
  unstablePkgs = import <nixpkgs-unstable> {};

  inherit (unstablePkgs) tdesktop firefox-wayland davfs2 i3status-rust clight;
  
  emacsWithMyPackages = self.pkgs.callPackage ./emacs { inherit unstablePkgs; };
}
