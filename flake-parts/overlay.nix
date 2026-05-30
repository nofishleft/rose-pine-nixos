{ self, inputs, ... }:
{
  flake.overlays.default = final: prev: {
    phush.rose-pine = self.packages.${prev.system};
  };
}
