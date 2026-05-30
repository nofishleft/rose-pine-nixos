{ self }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.rose-pine.zellij;
in
{
  options.rose-pine.zellij = {
    enable = lib.options.mkEnableOption "Enable Rose Pine theme for Zellij";
    package = self.packages.${pkgs.stdenv.hostPlatform.system}.zellij;
  };

  config = lib.mkIf cfg.enable {
    programs.zellij.themes =
      let
        themesDir = "${cfg.package}/share/zellij/themes";
        entries = builtins.readDir themesDir;
        themeFiles = lib.filterAttrs (_: type: type == "regular") entries;
      in
      lib.mapAttrs' (name: _: {
        name = lib.removeSuffix ".kdl" name;
        value = builtins.readFile "${themesDir}/${name}";
      }) themeFiles;

  };
}
