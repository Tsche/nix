{
  inputs,
  lib,
  config,
  pkgs,
  hostname,
  ...
}: {
  networking.hostName = hostname;

  nixpkgs = {
    # You can add overlays here
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };
  
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];    
  
  programs.zsh.enable = true;
  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Matthias Wippich";
        email = "mfwippich@gmail.com";
      };
      init.defaultBranch = "master";
      safe.directory = [ "/etc/nixos" ];
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    htop
  ];
}