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
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    htop
  ];
}