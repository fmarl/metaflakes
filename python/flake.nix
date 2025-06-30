{
  description = "Python template flake";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system: {
      devShells = { default = import ./shell.nix { inherit system nixpkgs; }; };
    });
}
