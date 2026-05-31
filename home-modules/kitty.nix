{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.rose-pine.kitty;

  variants = [
    "rose-pine"
    "rose-pine-dawn"
    "rose-pine-moon"
  ];
in
{
  options.rose-pine.kitty = {
    enable = lib.options.mkEnableOption "Enable Rose Pine theme for Kitty";

    src = lib.mkOption {
      type = lib.types.path;
      default = pkgs.fetchFromGitHub {
        owner = "rose-pine";
        repo = "kitty";
        rev = "efd4f01cb9887feaa7114ff21a887464295d0205";
        hash = "sha256-GyRyflUVp1BHg6S0emZ6ViALx8L130npnfyZQmdxhfA=";
      };
      description = "Source tree for Rose Pine Kitty assets.";
    };

    variant = lib.mkOption {
      type = lib.types.enum variants;
      default = "rose-pine";
      example = "rose-pine-moon";
      description = "Variant theme to enable.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty.themeFile = cfg.variant;

    xdg.configFile."kitty/kitty.app.png".source = "${cfg.src}/icons/kitty.app@2x.png";
  };
}
