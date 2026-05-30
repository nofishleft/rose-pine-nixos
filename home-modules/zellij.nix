{ self }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.rose-pine.zellij;

  themesDir = "${cfg.package}/share/zellij/themes";

  themeFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".kdl" name) (
    builtins.readDir themesDir
  );

  themeNames = map (name: lib.removeSuffix ".kdl" name) (builtins.attrNames themeFiles);
in
{
  options.rose-pine.zellij = {
    enable = lib.options.mkEnableOption "Enable Rose Pine theme for Zellij";

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.zellij;
    };

    variant = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum themeNames);
      default = null;
      example = "rose-pine-moon";
      description = "Variant theme to enable";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zellij.themes = lib.mapAttrs' (name: _: {
      name = lib.removeSuffix ".kdl" name;
      value = builtins.readFile "${themesDir}/${name}";
    }) themeFiles;

    programs.zellij.settings = lib.mkIf (cfg.variant != null) {
      theme = cfg.variant;
    };
  };
}
