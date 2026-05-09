{ inputs, lib, config, pkgs, username, ... }: {
  # Workaround for https://github.com/NixOS/nix/issues/8502
  services.logrotate.checkConfig = false;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "vps-8def0ca8";
  networking.domain = "vps.ovh.net";
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  
  system.stateVersion = "25.11";
}