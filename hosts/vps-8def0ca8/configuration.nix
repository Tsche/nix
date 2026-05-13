{ inputs, lib, config, pkgs, username, ... }: {
  # Workaround for https://github.com/NixOS/nix/issues/8502
  services.logrotate.checkConfig = false;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "vps-8def0ca8";
  networking.domain = "vps.ovh.net";
  networking.wireguard = {
    enable = true;
    interfaces.wg0 = {
      ips = ["10.1.1.1/24"];
      listenPort = 51820;
      privateKeyFile = "/etc/wireguard/server.key";
      # postSetup = [
      #   "${pkgs.iproute2}/bin/ip addr add 10.1.1.254/32 dev wg0"
      # ];
      # postShutdown = [
      #   "${pkgs.iproute2}/bin/ip addr del 10.1.1.254/32 dev wg0"
      # ];
      peers = [
         {
           allowedIPs = [ "10.1.1.10/32" ];
           publicKey = "r4F6ZNrZsUKmpR+/mtWioWSCY4tYe35ttJQt9rXMI2o=";
         }
         {
           allowedIPs = [ "10.1.1.20/32" ];
           publicKey = "Bd/MO9/3jCmx2LGHC6YQxLtw16h8vRWkfNxsKtI6cS0=";
         }
         {
           allowedIPs = [ "10.1.1.30/32" ];
           publicKey = "ewc2Mco0p0mvHw88NlBeDOMQXKbyD1UXF4Wh0b+HizA=";
         }
      ];
    };
  };

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 51820 ];
    trustedInterfaces = [ "wg0" ];
  };
  
  networking.nat = {
    enable = true;
    internalInterfaces = [ "wg0" ];
    externalInterface = "ens3";
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

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