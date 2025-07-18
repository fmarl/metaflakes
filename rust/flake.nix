{
  description = "Rust template flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    code-nix = {
      url = "github:fmarl/code-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        extensions.follows = "nix-vscode-extensions";
      };
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = { self, nixpkgs, flake-utils, code-nix, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        fenix = inputs.fenix;
        rust-overlay = inputs.rust-overlay;
      in {
        devShells.default =
          import ./shell.nix { inherit system nixpkgs fenix rust-overlay code-nix; };
      });
}
