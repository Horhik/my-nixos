# Edet this cnfiguration file to define what should be installed on your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{inputs, config, pkgs, callPackage, appimageTools, fetchFromGitHub, mkDerivation, pkgs-unstable, ... }:
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
  nixpkgs.config.allowUnfree = true; 
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
  # TODO create touchpad.nix
  # Define a user account. Don't forget to set a password with ‘passwd’.:wq
  users.defaultUserShell = pkgs.zsh;
  users.users.horhik = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "docker" "light" "adbusers" "docker" "display" "dialout" "libvirtd"]; # Enable ‘sudo’ for the user.
  };
  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-unstable;
  # List packages installed in system profile. To search, run:
  # $ nix search wget




  environment.systemPackages = with pkgs; [
    papirus-icon-theme pop-gtk-theme 
    wget git vim neovim emacs alacritty xterm zsh tmux stow dunst
    i3 surf dmenu st 
    #qutebrowser 
    xmobar xclip
    lightdm rofi nitrogen rofi-emoji
    mononoki fontmatrix
    element-desktop 
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
    taskwarrior timewarrior
    wirelesstools qdirstat
wineWowPackages.stable
    (wine.override { wineBuild = "wine64"; })
    wineWowPackages.staging
    (winetricks.override { wine = wineWowPackages.staging; })

    # MUSIC
    ardour
    giada
#    bespokesynth

    carla
    qjackctl

    
  ];
  nixpkgs.config.packageOverrides = pkgs: {
    giada = pkgs-unstable.giada;
    xmonad = pkgs-unstable.haskellPackages.xmonad_0_17_0;
  };
    # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "20.09"; # Did you read the comment?
  ### OH MY ZSH ###
  
  #programs.zsh.interactiveShellInit = ''
  #  export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/
  #  export CC=/usr/bin/clang
  #  export CXX=/usr/bin/clang++
  #  export _JAVA_AWT_WM_NONREPARENTING=1
  #  export ANDROID_SDK_ROOT=/home/horhik/Android/Sdk/
  #  export NDK_HOME=/home/horhik/Android/Sdk/ndk/22.0.7026061/
  #  ZSH_THEME="cloud"
  #  plugins=(git colorize colored-man-pages emoji rustup sudo zsh-syntax-highlighting zsh-autosuggestions zsh-completions)
  #  autoload -U compinit && compinit
  #  source $ZSH/oh-my-zsh.sh
  #  export PATH=$HOME/.local/bin:$PATH
  #  export PATH=/usr/local/bin:$PATH
  #  export PATH=$HOME/.cargo/bin:$PATH
  #  export PATH=$HOME/.emacs.d/bin:$PATH
  #  export PATH=$HOME/Desktop:$PATH
  #  export PATH=/home/horhik/code/projects/potato-notify:$PATH
  #  export PATH="/root/.deno/bin:$PATH"
  #  alias vim=nvim
  #  alias vi=vim
  #  alias libvirtdaemon="sudo start-stop-daemon --start libvirtd"
  #  alias virtm="sudo start-stop-daemon --start virtlogd &; sudo start-stop-daemon --start libvirtd &; virt-manager &" 
  #  alias clip=xclip -selection clipboard
  #  alias suspend="loginctl suspend"
  #  if [ -f '/home/horhik/yandex-cloud/path.bash.inc' ]; then source '/home/horhik/yandex-cloud/path.bash.inc'; fi
  #  if [ -f '/home/horhik/yandex-cloud/completion.zsh.inc' ]; then source '/home/horhik/yandex-cloud/completion.zsh.inc'; fi
  #  alias rd='rustc -g --emit="obj,link"'
  #  
  #  
  #  alias rdr=compile_and_run
  #  alias aia=ankiaudio
  #  alias picom="killall picom; picom --experimental-backends &;"
  #  alias cc="cargo check"
  #  alias ct="cargo test"
  #  alias gc="git clone"
  #  alias gs="git status"
  #  alias vim="nvim"
  #  
  #  neofetch
  #  
  #  eval $(thefuck --alias)
  #  source $ZSH/oh-my-zsh.sh
  #'';
  #
  #

	
  ### FONTS ###

  
  

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
