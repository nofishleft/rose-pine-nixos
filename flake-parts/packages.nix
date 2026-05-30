{ self, inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        zellij = pkgs.callPackage ../pkgs/zellij.nix { };
      };
    };
}
