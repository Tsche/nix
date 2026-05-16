{
  inputs,
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  imports = [ ../common.nix ];

  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kitty
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # enable networking
  networking.networkmanager.enable = true;
  users.users.${username}.extraGroups = [ "networkmanager" ];

  # enable GUI
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    kate
    dolphin
    konsole
    okular
    ark
    gwenview
    elisa
    khelpcenter
    print-manager
  ];

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  security.polkit.enable = true;
  services.dbus.enable = true;
  programs.dconf.enable = true;

  fonts.packages = with pkgs; [
    dejavu_fonts
    inter
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [
        "Inter"
        "Noto Sans"
      ];
      monospace = [ "JetBrains Mono" ];
      emoji = [ "Noto Color Emoji" ];
    };

    hinting = {
      enable = true;
      style = "slight";
    };

    antialias = true;

    subpixel = {
      rgba = "rgb";
    };
  };
}
