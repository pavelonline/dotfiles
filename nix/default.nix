# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstablePkgs = import <unstable-packages> {};
in
{
  location.provider = "geoclue2";
  nixpkgs.overlays = [
    (import ./overlays)
  ];
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  imports =
    [
      ./cloudmount
      ./podman
      ./virtualbox
      ./libinput
      ./xkbconfig
      ./sway
      ./resolved
      ./zsh
      ./imports/plymouth
      ./displaymanager
      ./imports/emacs
      ./imports/rust
      ./imports/ipfs
      ./imports/clight
      ./imports/hardware/e15
      ./imports/steam
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "svrglnv"; # Define your hostname.
  networking.wireless.iwd.enable = true; # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  documentation = {
    enable = true;
    man.enable = true;
    nixos = {
      enable = true;
      includeAllModules = true;
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    script = "${pkgs.bluez}/bin/mpris-proxy";
    wantedBy = [ "default.target" ];
  };


  services.blueman.enable = true;

  services.ofono.enable = true;

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    powerOnBoot = false;
    config = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };
  };

  # services.kubernetes = {
  #   roles = [ "master" "node" ];
  #   apiserver.enable = true;
  #   easyCerts = true;
  #   controllerManager.enable = true;
  #   scheduler.enable = true;
  #   addonManager.enable = true;
  #   addons.dns.enable = true;
  #   kubelet.extraOpts = "--fail-swap-on=false";
  #   proxy.enable = true;
  #   flannel.enable = true;
  #   masterAddress = "localhost";
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.svrg = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (
    with pkgs; [
      xclip
      alacritty
      git
      iwd
      keepassxc
      # kubectl
      # kubernetes-helm
      rnix-lsp
      tdesktop
      firefox-wayland
    ]
  );

  environment.shells = [ pkgs.zsh ];

  services.logind.extraConfig = ''
    HandlePowerKey=hibernate
    HandleSuspendKey=suspend
    HandleHibernateKey=hibernate
    HandleLidSwitch=hybrid-sleep
    HandleLidSwitchExternalPower=hybrid-sleep
    HandleLidSwitchDocked=hybrid-sleep
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

  fonts.fonts = with pkgs ; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    fira-code-symbols
  ];
}
