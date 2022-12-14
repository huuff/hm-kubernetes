{ config, lib, pkgs, ... }:
with lib;
with types;
let 
  cfg = config.programs.kubernetes;
in {
  options.programs.kubernetes = {
    enable = mkEnableOption "Kubernetes";

    enableBashIntegration = mkOption {
      default = true;
      type = bool;
      description = "Whether to enable Bash integration.";
    };

    enableZshIntegration = mkOption {
      default = true;
      type = bool;
      description = "Whether to enable Zsh integration.";
    };

    enableFishIntegration = mkOption {
      default = true;
      type = bool;
      description = "Whether to enable Fish integration.";
    };

    krew = {
      enable = mkEnableOption "Krew";

      plugins = mkOption {
        type = listOf str;
        default = [];
        description = "Names of krew plugins to install";
      };

    };
  };

  config = mkIf cfg.enable (mkMerge [
    ({
      home.packages = [ pkgs.kubectl ];

      programs = let
        kubectl = "${pkgs.kubectl}/bin/kubectl";
      in {
        bash.initExtra = mkIf cfg.enableBashIntegration ''
          source <("${kubectl}" completion bash)
        '';

        zsh.initExtra = mkIf cfg.enableZshIntegration ''
          source <("${kubectl}" completion zsh)
        '';

        fish.shellInit = mkIf cfg.enableFishIntegration ''
          "${kubectl}" completion fish | source
        '';
      };
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
            ExecStart = let
              krew = "${pkgs.krew}/bin/krew";
            in toString (pkgs.writeShellScript "update-krew" ''
              ${krew} update 
              ${krew} install krew ${concatStringsSep " " cfg.krew.plugins}
            ''); 
          };
        };
      };

      programs = {
        bash.initExtra = mkIf cfg.enableBashIntegration ''
          export PATH="$PATH:$HOME/.krew/bin"
        '';

        zsh.initExtra = mkIf cfg.enableZshIntegration ''
          export PATH="$PATH:$HOME/.krew/bin"
        '';

        fish.shellInit = mkIf cfg.enableFishIntegration ''
          fish_add_path "$HOME/.krew/bin"
        '';
      };
    })

  ]);
}
