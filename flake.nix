{
  description = "Google Antigravity - Next-generation agentic IDE (Nix package)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      flake = {
        # Version information for auto-update
        version = "1.11.5-5234145629700096";

        # Overlay for easy integration into NixOS configurations
        overlays.default = final: prev: {
          google-antigravity = final.callPackage ./package.nix { };
        };

        # NixOS Module
        nixosModules.default = import ./modules/nixos.nix;

        # Home Manager Module
        homeManagerModules.default = import ./modules/home-manager.nix;
      };

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Allow unfree packages
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        packages = {
          default = pkgs.callPackage ./package.nix { };
          google-antigravity = pkgs.callPackage ./package.nix { };
        };

        apps.default = {
          type = "app";
          program = "${self'.packages.default}/bin/antigravity";
        };

        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nix
            git
            curl
            jq
            gh
            nodejs_20
          ];

          shellHook = ''
            echo "Antigravity development environment"
            echo "Available commands:"
            echo "  ./scripts/check-version.sh  - Check current vs latest version"
            echo "  ./scripts/update-version.sh - Update to latest version"
            echo ""
            echo "First time setup:"
            echo "  npm install  - Install playwright-chromium locally"
            echo ""
            echo "Note: Requires google-chrome-stable to be installed system-wide for browser automation"
          '';
        };

        # Treefmt configuration
        treefmt = {
          projectRootFile = "flake.nix";
          programs.nixpkgs-fmt.enable = true;
          programs.prettier.enable = true;
          programs.shfmt.enable = true;
        };
      };
    };
}
