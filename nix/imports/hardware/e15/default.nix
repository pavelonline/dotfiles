{ config, lib, pkgs, ... }:

{
  imports = [
    <nixos-hardware/lenovo/thinkpad>
    <nixos-hardware/common/pc/laptop/acpi_call.nix>
    <nixos-hardware/common/pc/laptop/ssd>

    ../comet-lake
  ];

  boot.kernelParams = [
    # Force use of the thinkpad_acpi driver for backlight control.
    # This allows the backlight save/load systemd service to work.
    "acpi_backlight=native"
  ];
}
