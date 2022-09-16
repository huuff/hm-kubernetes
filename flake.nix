{
  description = "Kubernetes module for Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
  };

  outputs = { self, nixpkgs }: {
    nixosModules.kubernetes = import ./default.nix;
  };
}
