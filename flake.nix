{
  description = "Main configuration on top of nix flakes";
  inputs = {
   #home-manager = {
   #  url = "github:rycee/home-manager/release-21.11";
   #  inputs = {
   #    nixpkgs.follows = "nixpkgs";
   #  };
   #};
    nur.url = "github:nix-community/NUR";
    #emacs-overlay.url = "github:nix-community/emacs-overlay";

    #nixpkgs.url = "path:/home/horhik/nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    eww.url = "github:elkowar/eww/master";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    master.url = "github:nixos/nixpkgs/master";
#    musnix = { url = "github:musnix/musnix"; };
  };

  outputs = inputs@{ self,  nur, nixpkgs, unstable, eww, ... }:
  let
    inherit (builtins) listToAttrs attrValues attrNames readDir;
    inherit (nixpkgs) lib;
    inherit (lib) removeSuffix;
    pkgs = (import nixpkgs) {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
#      overlays = attrValues self.overlays;
    };

  in
  {
      nixosConfigurations.lap = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
         #home-manager.nixosModules.home-manager
         #({
         #  home-manager.useGlobalPkgs = true;
         #  home-manager.useUserPackages = true;
         #  home-manager.users.horhik = {
         #    imports = [
         #      #./modules/picom.nix
#        #       ./modules/tmux.nix
#        #       ./modules/bspwm
         #    ];
         #  };
         #})
          { nixpkgs.overlays = [ nur.overlay ]; }
        ];
        inherit pkgs;
      };
    };
  }
