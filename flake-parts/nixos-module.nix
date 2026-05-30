{ lib, ... }:
let
  modules = {
    tty = ../nixos-modules/tty.nix;
  };
in
{
  flake.nixosModules = modules // {
    default =
      { ... }:
      {
        imports = lib.attrValues modules;
      };
  };
}
