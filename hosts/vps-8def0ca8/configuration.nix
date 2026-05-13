{ inputs, lib, config, pkgs, username, ... }: {
  imports = [
    ./network.nix
  ];

  # Workaround for https://github.com/NixOS/nix/issues/8502
  services.logrotate.checkConfig = false;
  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
    };
    listenAddresses = [ 
      { addr = "10.1.1.1"; port = 22; }
    ];

    extraConfig = ''
      PermitUserEnvironment no
      PermitEmptyPasswords no
      ClientAliveInterval 300
      IgnoreRhosts yes
      GatewayPorts no
      TCPKeepAlive no
      HostbasedAuthentication no
      AllowAgentForwarding yes
    '';
  };

  environment.systemPackages = with pkgs; [
    kitty.terminfo
    gnupg
  ];

  system.stateVersion = "25.11";
}