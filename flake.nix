{
  description = "A collection of flakes useful for a wide range of activities and projects";

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
  };
  
  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
    let
      fenix = inputs.fenix;
      rust-overlay = inputs.rust-overlay;
    in
    {
      devShells = {
        go = import ./go/default.nix { inherit system nixpkgs; };
        rust = import ./rust/default.nix { inherit system nixpkgs fenix rust-overlay; };
        kernel = import ./kernel/default.nix { inherit system nixpkgs; };
        security = import ./security/default.nix { inherit system nixpkgs; };
      };
    });
}