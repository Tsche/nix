{
  inputs,
  pkgs,
  home-manager,
  username,
  profile,
  hostname,
  ...
}:
{
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = {
    inherit username;
    inherit inputs;
  };

  home-manager.users.${username} = {
    imports = [ 
      ../profiles/${profile}/home.nix
      ../hosts/${hostname}/home.nix
    ];
    home = {
      username = "${username}";
      homeDirectory = "/home/${username}";
    };
  };
}
