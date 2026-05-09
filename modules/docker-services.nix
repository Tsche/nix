{
  inputs,
  lib,
  config,
  pkgs,
  username,
  ...
}:
let
  cfg = config.services.docker-services;
in
{
  options.services.docker-services = {
    enable = lib.mkEnableOption "docker-services module";
    
    dnsServer.enable = lib.mkEnableOption "Technitium DNS Server" // { default = false; };
    compilerExplorer.enable = lib.mkEnableOption "Compiler Explorer" // { default = false; };
    codeServer.enable = lib.mkEnableOption "VS Code Server" // { default = false; };
    
    nginx.enable = lib.mkEnableOption "Nginx reverse proxy" // { default = cfg.enable; };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
    };

    users.users.${username}.extraGroups = [ "docker" ];

    systemd.services.docker-network-setup = {
      description = "Setup Docker proxy network";
      after = [ "docker.service" ];
      requires = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs.docker}/bin/docker network create -d bridge proxy 2>/dev/null || true
      '';
    };

    systemd.services.dns-server = lib.mkIf cfg.dnsServer.enable {
      description = "DNS Server (Technitium DNS)";
      after = [ "docker.service" "docker-network-setup.service" ];
      requires = [ "docker.service" "docker-network-setup.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        WorkingDirectory = "/etc/nixos/docker/dns";
        ExecStart = "${pkgs.docker}/bin/docker compose up -d";
        ExecStop = "${pkgs.docker}/bin/docker compose down";
        TimeoutStartSec = 0;
      };
    };

    systemd.services.compiler-explorer = lib.mkIf cfg.compilerExplorer.enable {
      description = "Compiler Explorer";
      after = [ "docker.service" "docker-network-setup.service" ];
      requires = [ "docker.service" "docker-network-setup.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        WorkingDirectory = "/etc/nixos/docker/compiler-explorer";
        ExecStart = "${pkgs.docker}/bin/docker compose up -d";
        ExecStop = "${pkgs.docker}/bin/docker compose down";
        TimeoutStartSec = 0;
      };
    };

    systemd.services.code-server = lib.mkIf cfg.codeServer.enable {
      description = "VS Code Server";
      after = [ "docker.service" "docker-network-setup.service" ];
      requires = [ "docker.service" "docker-network-setup.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        WorkingDirectory = "/etc/nixos/docker/vscode-server";
        ExecStart = "${pkgs.docker}/bin/docker compose up -d";
        ExecStop = "${pkgs.docker}/bin/docker compose down";
        TimeoutStartSec = 0;
      };
    };

    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = true;
      recommendedProxySettings = true;
      recommendedGzipSettings = true;

      virtualHosts."ce.pydong.org" = lib.mkIf cfg.compilerExplorer.enable {
        locations."/".proxyPass = "http://127.0.0.1:10240";
        locations."/".proxyWebsockets = true;
      };

      virtualHosts."ce.fuquery.org" = lib.mkIf cfg.compilerExplorer.enable {
        locations."/".proxyPass = "http://127.0.0.1:10240";
        locations."/".proxyWebsockets = true;
      };

      virtualHosts."dns.pydong.org" = lib.mkIf cfg.dnsServer.enable {
        locations."/".proxyPass = "http://127.0.0.1:5380";
        locations."/".proxyWebsockets = true;
      };

      virtualHosts."dns.fuquery.org" = lib.mkIf cfg.dnsServer.enable {
        locations."/".proxyPass = "http://127.0.0.1:5380";
        locations."/".proxyWebsockets = true;
      };

      virtualHosts."code.pydong.org" = lib.mkIf cfg.codeServer.enable {
        locations."/".proxyPass = "http://127.0.0.1:8080";
        locations."/".proxyWebsockets = true;
      };

      virtualHosts."code.fuquery.org" = lib.mkIf cfg.codeServer.enable {
        locations."/".proxyPass = "http://127.0.0.1:8080";
        locations."/".proxyWebsockets = true;
      };
    };

    # Open necessary ports in firewall
    networking.firewall = {
      enable = true;
      allowedTCPPorts = 
        [ 22 80 443 ] # SSH, HTTP, HTTPS
        ++ lib.optionals cfg.dnsServer.enable [ 53 5380 ]
        ++ lib.optionals cfg.compilerExplorer.enable [ 10240 ]
        ++ lib.optionals cfg.codeServer.enable [ 8080 ];
      allowedUDPPorts =
        lib.optionals cfg.dnsServer.enable [ 53 67 ];
    };
  };
}
