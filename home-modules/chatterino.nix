{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.rose-pine.chatterino;

  themeFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".json" name) (
    builtins.readDir "${cfg.src}/dist"
  );

  themeNames = map (name: lib.removeSuffix ".json" name) (builtins.attrNames themeFiles);

  settingsDir =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "Library/Application Support/chatterino"
    else
      ".local/share/chatterino";
in
{
  options.rose-pine.chatterino = {
    enable = lib.options.mkEnableOption "Install Rose Pine theme for Chatterino";

    src = lib.mkOption {
      type = lib.types.path;
      default = pkgs.fetchFromGitHub {
        owner = "nofishleft";
        repo = "rose-pine-chatterino";
        rev = "393529962c40f532dcf9f0d720bb0e4467f4c863";
        hash = "sha256-o309oseoHSg80h6EAV2g4K70rMQjzDfIgIdHjCKkVQg=";
      };
      description = "Source tree for Rose Pine Chatterino themes.";
    };

    variant = lib.mkOption {
      type = lib.types.enum themeNames;
      default = "rose-pine";
      example = "rose-pine-moon";
      description = "Variant theme to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.file."${settingsDir}/Themes/${cfg.variant}.json".source = "${cfg.src}/dist/${cfg.variant}.json";
  };
}
