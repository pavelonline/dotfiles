{ config, pkgs, ... }:
{
  environment.systemPackages = [ cargo rust rust-analyzer ];
}
