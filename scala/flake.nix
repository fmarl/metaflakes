{
  description = "Scala Template";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShells.default = import ./shell.nix { inherit system nixpkgs; };
    });
}
