{ config, lib, pkgs, ... }:
let
  cfg = config.cfg.firefox;
in
{
  options.cfg.firefox.enable = lib.mkEnableOption "firefox";

  config = lib.mkIf cfg.enable {
    programs.firefox.enable = true;
  };
}