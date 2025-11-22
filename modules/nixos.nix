{ config, lib, pkgs, ... }:

let
  cfg = config.programs.google-antigravity;
in
{
  options.programs.google-antigravity = {
    enable = lib.mkEnableOption "Google Antigravity";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.google-antigravity;
      defaultText = lib.literalExpression "pkgs.google-antigravity";
      description = "The Google Antigravity package to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };
}
