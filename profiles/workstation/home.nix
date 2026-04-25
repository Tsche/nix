{
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  imports = [ ];

  programs.firefox.enable = true;

  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
      ];
    };
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    # spotify
    nixfmt
  ];
  #programs.git.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.11";
}
