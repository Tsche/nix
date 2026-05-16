{ config, lib, pkgs, ... }:
let
  cfg = config.cfg.vscode;
in
{
  options.cfg.vscode.enable = lib.mkEnableOption "vscode";

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.unstable.vscode;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
        ];
      };
    };
  };
}