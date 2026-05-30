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
}
