{
  description = "Scheme template flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    edinix = {
      url = "github:fmarl/edinix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        extensions.follows = "nix-vscode-extensions";
      };
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      edinix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShells.default = import ./shell.nix { inherit system nixpkgs edinix; };
    });
}
