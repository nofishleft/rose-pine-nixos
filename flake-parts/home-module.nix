{ self, lib, ... }:
let
  modules = {
    chatterino = ../home-modules/chatterino.nix;
    tty = ../home-modules/tty.nix;
    zellij = import ../home-modules/zellij.nix { inherit self; };
  };
in
{
  flake.homeModules = modules // {
    default =
      { ... }:
      {
        imports = lib.attrValues modules;
      };
  };
}
