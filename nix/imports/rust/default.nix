{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ cargo rust rust-analyzer ];
}
