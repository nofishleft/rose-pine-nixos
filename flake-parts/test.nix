{
  self,
  inputs,
  lib,
  ...
}:
{
  perSystem =
    { pkgs, system, ... }:
    {
      checks = {
        hm-test =
          (inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            modules = [
              self.homeModules.default

              {
                rose-pine.tty.variant = "rose-pine-moon";
                rose-pine.tty.bash.enable = true;
                rose-pine.tty.zsh.enable = true;
                rose-pine.tty.fish.enable = true;

                rose-pine.zellij.enable = true;
                rose-pine.zellij.variant = "rose-pine";

                home.username = "test";
                home.homeDirectory = "/tmp/test-home";
                home.stateVersion = "26.05";
              }
            ];
          }).activationPackage;
      }
      // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        nixos-module-test =
          (inputs.nixpkgs.lib.nixosSystem {
            inherit system;

            modules = [
              self.nixosModules.default

              {
                rose-pine.tty.enable = true;
                rose-pine.tty.variant = "rose-pine-moon";

                fileSystems."/".device = "test";
                fileSystems."/".fsType = "ext4";
                boot.loader.grub.enable = false;
                system.stateVersion = "26.05";
              }
            ];
          }).config.system.build.toplevel;
      };
    };
}
