{ config, pkgs, ... }:
{
  services.xserver.enable = true;
  services.xserver.displayManager = {
    defaultSession = "sway";
    gdm.enable = true;
    autoLogin = {
      enable = true;
      user = "svrg";
    };
  };
}
