# Edet this cnfiguration file to define what should be installed on your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{inputs, config, pkgs, callPackage, appimageTools, fetchFromGitHub, mkDerivation, pkgs-unstable, ... }:
#let
#  unstableTarball =
#    fetchTarball
#      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
#in
 {
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   }; 
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/wm.nix
    ./modules/syncthing.nix
    ./modules/discord.nix
    ./modules/gtk.nix
    ./modules/hosts.nix
    #./modules/vpn.nix
    ./modules/picom.nix
    ./modules/sound.nix
    ./modules/zsh.nix
    ./fonts.nix
#    ./modules/musnix

    #./themes/global_theme.nix
    ];
  # Use the systemd-boot EFI boot loader.
  # services.global_theme = {
  #   enable = true;
  #   scheme = "solarized";
  # };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true; 
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = ["acpi_osi=Linux" "acpi_backlight=vendor"];
#  nixpkgs.config = let 
    
#      unstable = import <nixos-unstable> {
#        config = config.nixpkgs.config;
#      };
#  in
#nixpkgs.config =  {
#    alloweBroken = true;
#    alloweUnfree = true;
#    packageOverrides = pkgs: {
#      haskellPackages.xmonad = unstable haskellPackages.xmonad_0_17_0
#      haskellPackages.xmonad-contrib =  haskellPackages.xmonad-contrib_0_17_0
#      haskellPackages.xmonad-extras =   haskellPackages.xmonad-extras_0_17_0
#    };
#};
  nixpkgs.config.allowBroken = true;
  networking.hostName = "lap"; # Define your hostname.
#  let theme = import ./themes/solarized.nix; 
#  in theme.colors // 
  environment.variables  = 
  {
#    QT_STYLE_OVERRIDE="kvantum";
    MAIN_DISK="/dev/nvme0n1";
    WIFI_DEVICE="wlp2s0";
    TERMINAL="alacritty";
  };


#    musnix.enable = true;
  #  let inputs = {
  #  home-manager = {
  #    url = "github:rycee/home-manager/release-20.09";
  #    inputs = {
  #      nixpkgs.follows = "nixpkgs";
  #    };
  #  };
  #  nur.url = "github:nix-community/NUR";
  #  emacs-overlay.url = "github:nix-community/emacs-overlay";
  #  neovim-overlay.url = "github:nix-community/neovim-nightly-overlay";
  #
  #  nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
  #  unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  #};
  #
  #  nur = final: prev: {
  #        nur = import inputs.nur { nurpkgs = final.unstable; pkgs = final.unstable; };
  #      };
    # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp2s0.useDHCP = true;


  virtualisation.docker.enable = true;

  virtualisation.libvirtd.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  
  networking.networkmanager.enable = true;
  programs.gnupg.agent.enable = true;
  programs.dconf.enable = true;
  programs.light.enable = true;
  # Configure keymap in X11
      # Enable CUPS to print documents.
  services.printing.enable = true;
  services.blueman.enable = true;
  services.tor.client.enable = true;
  services.tor.enable = true;
  hardware.bluetooth.enable = true;
  # Enable sound.

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.tapping = true;
  services.xserver.libinput.touchpad.disableWhileTyping = true;
  services = {
    syncthing = {
        enable = true;
        user = "horhik";
        dataDir = "/home/horhik/Sync";    # Default folder for new synced folders
        configDir = "/home/horhik/.config/syncthing";   # Folder for Syncthing's settings and keys
    };
};

  # TODO create touchpad.nix
  # Define a user account. Don't forget to set a password with ‘passwd’.:wq
  users.defaultUserShell = pkgs.zsh;
  users.users.horhik = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "docker" "light" "adbusers" "docker" "display" "dialout" "libvirtd"]; # Enable ‘sudo’ for the user.
  };
  system.autoUpgrade.enable = true;
  nix.gc.automatic = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-unstable;
  # List packages installed in system profile. To search, run:
  # $ nix search wget




  environment.systemPackages = with pkgs; [
    papirus-icon-theme pop-gtk-theme 
    wget git vim neovim emacs alacritty xterm zsh tmux stow dunst
    i3 surf dmenu st 
    #qutebrowser 
    xmobar xclip dbus
    lightdm rofi nitrogen rofi-emoji
    mononoki fontmatrix
    element-desktop dino
    firefox 
    sxhkd xdotool
    connman
    wpa_supplicant python3 xkblayout-state acpi yaru-theme xkb-switch
    pipewire  pulsemixer nerdfonts gnupg
    feh compton ninja meson cmake 
    anki clang_12 zathura redshift rustup neofetch tree
    killall audacity  thefuck
    polkit etcher gsettings-qt appimage-run pamixer unzip qjackctl gnome3.nautilus bluez pkgconfig pavucontrol bpytop 
    gnome3.gnome-settings-daemon
    gnome2.GConf
    gnome.gnome-tweaks
    spotify obsidian discord
    nfs-utils cifs-utils
    nfs-ganesha
    transmission
    virt-manager
    libsForQt5.qtstyleplugin-kvantum
    taskwarrior timewarrior tasksh
    wirelesstools qdirstat
#wineWowPackages.stable
#    (wine.override { wineBuild = "wine64"; })
#    wineWowPackages.staging
#    (winetricks.override { wine = wineWowPackages.staging; })
#
    # MUSIC
    ardour
    giada
    bespokesynth
  
    carla
    qjackctl

    mplayer 

        #haskellPackages.TaskMonad
        rofi-pass rofi-emoji gimp gcc flameshot obs-studio 
      tdesktop
      peek libreoffice
      thunderbird
      darktable 
      #XMONAD
      haskellPackages.xmonad_0_17_0
      haskellPackages.xmonad-contrib_0_17_0
      haskellPackages.xmonad-extras_0_17_0   
      #haskellPackages.xmonad-dbus
      haskellPackages.xmonad-utils
      ghc stack 
      kalendar
      vit
      tasksh
      lolcat
      taskwarrior-tui

];

  

  programs.adb.enable = true;
  services.emacs.package = pkgs.emacsUnstable;

  #nixpkgs.overlays = [
  #  (import (builtins.fetchTarball {
  #    url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  #    sha256 = "1p2ikx5krrz6r0x1jyfcb3jvj7yl3pz2l4lz5ilffr6pj1swwlk2";
  #  }))
  #];

   networking.firewall = {
   # if packets are still dropped, they will show up in dmesg
   logReversePathDrops = true;
   # wireguard trips rpfilter up
   extraCommands = ''
     ip46tables -t raw -I nixos-fw-rpfilter -p udp -m udp --sport 37581 -j RETURN
     ip46tables -t raw -I nixos-fw-rpfilter -p udp -m udp --dport 37581 -j RETURN
   '';
   extraStopCommands = ''
     ip46tables -t raw -D nixos-fw-rpfilter -p udp -m udp --sport 37581 -j RETURN || true
     ip46tables -t raw -D nixos-fw-rpfilter -p udp -m udp --dport 37581 -j RETURN || true
   '';
 };
}
