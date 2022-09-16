{
  description = "Kubernetes module for Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
  };

  outputs = { self, nixpkgs }: {
    # TODO: Surely there's a default? Or at the very least just use nixosModules.default
    nixosModules.kubernetes = import ./default.nix;
  };
}
