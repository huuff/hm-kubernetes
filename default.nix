{ config, lib, pkgs, ... }:
with lib;
with types;
let 
  cfg = config.programs.kubernetes;
in {
  options.programs.kubernetes = {
    enable = mkEnableOption "Kubernetes";

    krew = {
      enable = mkEnableOption "Krew";
    };
  };

  # TODO: Obviously add krew to the path
  config = mkIf cfg.enable (mkMerge [
    ({
      home.packages = [ pkgs.kubectl ];
    })

    (mkIf cfg.krew.enable {
      home.packages = [ pkgs.krew ];

      systemd.user = {
        services.krew = {
          Unit = {
            Description = "Set up Kubernetes' Krew plugin manager";
          };

          Install = {
            WantedBy = [ "default.target" ];
          };

          Service = {
            Type = "oneshot";
            RemainAfterExit = true;
            Script = let
              krew = "${pkgs.krew}/bin/krew";
            in ''
              ${krew} update 
              ${krew} install krew
            ''; 
          };
        };
      };
    })
  ]);
}
