{
  description = "Go template flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    code-nix = {
      url = "github:fmarl/code-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        extensions.follows = "nix-vscode-extensions";
      };
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = { self, nixpkgs, flake-utils, code-nix }:
    flake-utils.lib.eachDefaultSystem (system: {
      devShells.default = import ./shell.nix { inherit system nixpkgs code-nix; };
    });
}
