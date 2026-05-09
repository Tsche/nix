{ ... }: {
  # Workaround for https://github.com/NixOS/nix/issues/8502
  services.logrotate.checkConfig = false;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "vps-8def0ca8";
  networking.domain = "vps.ovh.net";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOAiRJ661DOTWHv+YrIc0A29iGfJdO98bxqjA+WZ5ORC yubikey'' ];
  
  system.stateVersion = "25.11";
}