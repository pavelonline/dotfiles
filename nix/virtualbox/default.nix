{ config, ... }:
{
  virtualisation.virtualbox = {
    host = {
      enable = true;
      headless = true;
    };
  };
}
