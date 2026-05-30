{ pkgs, lib, ... }:
(pkgs.runCommand "rose-pine-theme-zellij"
  {
    src = pkgs.fetchFromGitHub {
      owner = "rose-pine";
      repo = "zellij";
      rev = "f4b7c27f9515d964a78e07da8332530a45f060d5";
      hash = "sha256-eilCRSweo0wk4z6snBWFC67NMVvytfDfJqGWVXg6QRc=";
    };

    meta = {
      description = "Rose Pine theme for Zellij";
      homepage = "https://github.com/rose-pine/zellij";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
    };
  }
  ''
    mkdir -p $out/share/zellij
    ln -s $src/dist $out/share/zellij/themes
  ''
)
