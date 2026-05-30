{ self, lib, ... }:
let
  modules = {
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
