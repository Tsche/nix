{
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  imports = [ ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
