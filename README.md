# antigravity-nix

Auto-updating Nix Flake packaging for Google Antigravity.

[![Update Antigravity](https://github.com/asychin/antigravity-nix/actions/workflows/update.yml/badge.svg)](https://github.com/asychin/antigravity-nix/actions/workflows/update.yml)
[![Flake Check](https://img.shields.io/badge/flake-check%20passing-success)](https://github.com/asychin/antigravity-nix)
[![NixOS](https://img.shields.io/badge/NixOS-ready-blue?logo=nixos)](https://nixos.org)

## 🚀 Why this fork?

This repository is an enhanced version of the original package. Here's what has been improved:

1.  **Simple Installation ("Sugar")**: Added **NixOS** and **Home Manager** modules. No need to manually configure packages anymore — just enable `programs.google-antigravity.enable = true`.
2.  **Frequent Updates**: The bot checks for new versions **every 6 hours** (originally 3x weekly). You'll get updates faster.
3.  **Modern Structure**: Codebase refactored to use **`flake-parts`**. This is the modern standard for Nix projects, making it easier to maintain and extend.
4.  **Clean Code**: Added `treefmt` for automatic code formatting to keep the codebase tidy.

## Installation

### NixOS Configuration (Recommended)

Add to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    antigravity-nix = {
      url = "github:asychin/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, antigravity-nix, ... }: {
    nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        antigravity-nix.nixosModules.default
        {
          programs.google-antigravity.enable = true;
        }
      ];
    };
  };
}
```

### Home Manager (Recommended)

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    antigravity-nix = {
      url = "github:asychin/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, antigravity-nix, ... }: {
    homeConfigurations.your-user = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        antigravity-nix.homeManagerModules.default
        {
          programs.google-antigravity.enable = true;
        }
      ];
    };
  };
}
```

### Quick Run

You can run Antigravity without installing it:

```bash
nix run github:asychin/antigravity-nix
```

## Advanced

For technical details, troubleshooting, and manual configuration (overlays), please see [docs/INTERNALS.md](docs/INTERNALS.md).

## License

MIT License. Google Antigravity is proprietary software by Google LLC.
