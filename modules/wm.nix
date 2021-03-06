{config, pkgs, ...}:
{
  services.dbus.packages = with pkgs; [ gnome2.GConf ];
  programs.dconf.enable = true;
  services.xserver = {
    enable = true;
    layout = "us";
	  xkbOptions = "eurosign:e";
	  windowManager.i3.enable = true;
	  windowManager.bspwm.enable = true;
    displayManager.gdm.enable = true;
    displayManager.setupCommands = "xrandr --output HDMI-A-0 --right-of eDP";
    desktopManager.gnome.enable = true;
    windowManager.xmonad = {
	    enable = true;
      enableContribAndExtras = true;
	  };
  };
}
