{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.rose-pine.tty;

  variants = [
    "rose-pine"
    "rose-pine-dawn"
    "rose-pine-moon"
  ];

  themeFile = "${cfg.src}/dist/${cfg.variant}.conf";

  lines = lib.filter (line: line != "") (
    lib.splitString "\n" (builtins.readFile themeFile)
  );

  colors = map (
    line:
    let
      match = builtins.match "COLOR_[0-9]+=(.*)" line;
    in
    if match == null then
      throw "Invalid Rose Pine Linux TTY color line: ${line}"
    else
      builtins.head match
  ) lines;
in
{
  options.rose-pine.tty = {
    enable = lib.options.mkEnableOption "Enable Rose Pine theme for the Linux TTY";

    src = lib.mkOption {
      type = lib.types.path;
      default = pkgs.fetchFromGitHub {
        owner = "rose-pine";
        repo = "linux-tty";
        rev = "f9d1c1d7aa81277a3208a7a58030315814550e73";
        hash = "sha256-iQ2jf7VvGm4zJDZJYNARZTwtGj2gusMM26GnlKz7CPA=";
      };
      description = "Source tree for Rose Pine Linux TTY themes.";
    };

    variant = lib.mkOption {
      type = lib.types.enum variants;
      default = "rose-pine";
      example = "rose-pine-moon";
      description = "Variant theme to enable.";
    };
  };

  config = lib.mkIf cfg.enable {
    console.colors = colors;
  };
}
