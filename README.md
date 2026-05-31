# Rose Pine for NixOS

A nix flake + home-manager modules for installing Rose Pine themes on NixOS

## Setup

Add this flake as an input:

```nix
{
  inputs.rose-pine-nixos.url = "github:nofishleft/rose-pine-nixos";
}
```

To reuse your existing `nixpkgs` and `home-manager` pins, make this flake's inputs follow yours:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    rose-pine-nixos = {
      url = "github:nofishleft/rose-pine-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };
}
```

Then pass it through your flake outputs and import the modules you need:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    rose-pine-nixos = {
      url = "github:nofishleft/rose-pine-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    { nixpkgs, home-manager, rose-pine-nixos, ... }:
    {
      nixosConfigurations.example = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix

          rose-pine-nixos.nixosModules.default

          home-manager.nixosModules.home-manager
          {
            home-manager.users.example = {
              imports = [
                rose-pine-nixos.homeModules.default
              ];
            };
          }
        ];
      };
    };
}
```

## Module index

| NixOS module | Description |
| --- | --- |
| [`tty`](#tty) | Sets the global Linux TTY color palette with `console.colors`. |

| Home Manager module | Description |
| --- | --- |
| [`chatterino`](#chatterino) | Installs a Rose Pine Chatterino theme file. |
| [`tty`](#tty-1) | Adds Linux TTY color setup scripts to shell init files. |
| [`zellij`](#zellij) | Installs Rose Pine Zellij themes and optionally selects one. |

## NixOS modules

### TTY

Sets the global Linux TTY theme through `console.colors`.

Upstream theme: [rose-pine/linux-tty](https://github.com/rose-pine/linux-tty)

```nix
{
  rose-pine.tty = {
    enable = true;
    variant = "rose-pine-moon";
  };
}
```

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `rose-pine.tty.enable` | boolean | `false` | Enables the TTY theme. |
| `rose-pine.tty.variant` | enum | `"rose-pine"` | Theme variant: `"rose-pine"`, `"rose-pine-dawn"`, or `"rose-pine-moon"`. |
| `rose-pine.tty.src` | path | `rose-pine/linux-tty` | Source tree used to read `dist/<variant>.conf`. |

## Home Manager modules

### Chatterino

Installs a Rose Pine Chatterino theme into Chatterino's `Themes` folder. Open Chatterino and select the custom theme manually after applying your Home Manager configuration.

Upstream theme: [nofishleft/rose-pine-chatterino](https://github.com/nofishleft/rose-pine-chatterino)

```nix
{
  rose-pine.chatterino = {
    enable = true;
    variant = "rose-pine-moon";
  };
}
```

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `rose-pine.chatterino.enable` | boolean | `false` | Installs the selected Chatterino theme. |
| `rose-pine.chatterino.variant` | enum | `"rose-pine"` | Theme variant: `"rose-pine"`, `"rose-pine-dawn"`, or `"rose-pine-moon"`. |
| `rose-pine.chatterino.src` | path | `nofishleft/rose-pine-chatterino` | Source tree used to install `dist/<variant>.json`. |

### TTY

Adds the upstream Linux TTY shell script to selected shell init hooks.

Upstream theme: [rose-pine/linux-tty](https://github.com/rose-pine/linux-tty)

```nix
{
  rose-pine.tty = {
    variant = "rose-pine-moon";
    bash.enable = true;
    zsh.enable = true;
    fish.enable = true;
  };
}
```

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `rose-pine.tty.variant` | enum | `"rose-pine"` | Theme variant: `"rose-pine"`, `"rose-pine-dawn"`, or `"rose-pine-moon"`. |
| `rose-pine.tty.src` | path | `rose-pine/linux-tty` | Source tree used to read `dist/<variant>.sh`. |
| `rose-pine.tty.bash.enable` | boolean | `false` | Adds the theme script to `programs.bash.initExtra`. |
| `rose-pine.tty.zsh.enable` | boolean | `false` | Adds the theme script to `programs.zsh.initContent`. |
| `rose-pine.tty.fish.enable` | boolean | `false` | Adds the theme script to `programs.fish.interactiveShellInit`. |

### Zellij

Installs Rose Pine Zellij themes and can set the active Zellij theme.

Upstream theme: [rose-pine/zellij](https://github.com/rose-pine/zellij)

```nix
{
  rose-pine.zellij = {
    enable = true;
    variant = "rose-pine";
  };
}
```

| Option | Type | Default | Description |
| --- | --- | --- | --- |
| `rose-pine.zellij.enable` | boolean | `false` | Enables the Zellij theme integration. |
| `rose-pine.zellij.package` | package | `self.packages.<system>.zellij` | Package containing the Zellij theme files. |
| `rose-pine.zellij.variant` | null or enum | `null` | Theme variant to select. When `null`, themes are installed without changing the active theme. |
