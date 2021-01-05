{ config, pkgs, ... }:
{
  services.emacs = {
    enable = true;
    package = pkgs.emacsWithMyPackages;
    defaultEditor = true;
  };
  environment.systemPackages = if config.programs.sway.enable then [ pkgs.xwayland ] else [];
}
