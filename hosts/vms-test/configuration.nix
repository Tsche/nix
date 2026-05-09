# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ../../modules/docker-services.nix
  ];

  # Enable docker services
  services.docker-services = {
    enable = true;
    dnsServer.enable = true;
    compilerExplorer.enable = true;
    codeServer.enable = true;
    nginx.enable = true;
  };

  # WireGuard VPN interface
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.1.1.1/24" ];
    listenPort = 51820;
    privateKeyFile = "/etc/wireguard/private.key";
    postSetup = [
      "${pkgs.iproute2}/bin/ip addr add 10.1.1.254/32 dev wg0"
    ];
    postShutdown = [
      "${pkgs.iproute2}/bin/ip addr del 10.1.1.254/32 dev wg0"
    ];
    peers = [
      # {
      #   allowedIPs = [ "10.1.1.10/32" ];
      #   publicKeyFile = "/etc/wireguard/peer1.pub";
      # }
      # {
      #   allowedIPs = [ "10.1.1.20/32" ];
      #   publicKeyFile = "/etc/wireguard/peer2.pub";
      # }
      # {
      #   allowedIPs = [ "10.1.1.30/32" ];
      #   publicKeyFile = "/etc/wireguard/peer3.pub";
      # }
    ];
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
