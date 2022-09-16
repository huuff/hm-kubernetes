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
            Description = "Set up Krew plugin manager for Kubernetes";
          };


          Install = {
            WantedBy = [ "default.target" ];
          };

          Service = {
            Environment = "PATH=${pkgs.git}/bin";
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = let
              krew = "${pkgs.krew}/bin/krew";
            in toString (pkgs.writeShellScript "update-krew" ''
              ${krew} update 
              ${krew} install krew
            ''); 
          };
        };
      };
    })
  ]);
}
