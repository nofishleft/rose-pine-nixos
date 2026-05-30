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

  themeScript = builtins.readFile "${cfg.src}/dist/${cfg.variant}.sh";
in
{
  options.rose-pine.tty = {
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

    bash.enable = lib.options.mkEnableOption "Rose Pine Linux TTY colors for Bash";

    zsh.enable = lib.options.mkEnableOption "Rose Pine Linux TTY colors for Zsh";

    fish.enable = lib.options.mkEnableOption "Rose Pine Linux TTY colors for Fish";
  };

  config = {
    programs.bash.initExtra = lib.mkIf cfg.bash.enable themeScript;

    programs.zsh.initContent = lib.mkIf cfg.zsh.enable (lib.mkOrder 1000 themeScript);

    programs.fish.interactiveShellInit = lib.mkIf cfg.fish.enable themeScript;
  };
}
