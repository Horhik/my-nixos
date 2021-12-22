# This is a module which will try to fully change your global theme, e.g. your GTK theme, QT theme, VIM, Emacs, bspwm, e.t.c

# # # # # # # # # # # # # #  
# # # # # # # # # # # # # # 
# #   Avaliable thmes:  # #
# #   - gruvbox         # #
# #   - solarized       # #
# #   - nodrd           # #
# #   - dracula         # #
# # # # # # # # # # # # # #  
# # # # # # # # # # # # # # 

{config, pkgs, lib, ...}:
with lib;
  let 
    global_theme = config.global_theme;
  in {
    options.global_theme = {
      enable = mkEnableOption "enable global_theme";
      scheme = mkOption {
        type = types.str;
        default = "gruvbox";
        example = "solarized";
        description = ''
          Global color scheme for emacs, vim, your WM, e.t.c...
        '';
      };
    };

    config = {

    environment.variables  = import "/etc/nixos/themes/${global_theme.scheme}.nix";
    };
  }
