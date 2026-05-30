{ self, inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      checks.hm-test =
        (inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
            self.homeModules.default

            {
              rose-pine.zellij.enable = true;

              home.username = "test";
              home.homeDirectory = "/tmp/test-home";
              home.stateVersion = "26.05";
            }
          ];
        }).activationPackage;
    };
}
