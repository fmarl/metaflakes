{
  description =
    "A collection of flakes useful for a wide range of activities and projects";

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
    let
      fenix = inputs.fenix;
      rust-overlay = inputs.rust-overlay;
    in {
      devShells = flake-utils.lib.eachDefaultSystem (system: {
        default = let pkgs = import nixpkgs { inherit system; };
        in pkgs.mkShell { buildInputs = with pkgs; [ nixfmt ]; };
        go = import ./go/shell.nix { inherit system nixpkgs; };
        rust = import ./rust/shell.nix {
          inherit system nixpkgs fenix rust-overlay;
        };
        kernel = import ./kernel/shell.nix { inherit system nixpkgs; };
        security = import ./security/shell.nix { inherit system nixpkgs; };
        python = import ./python/shell.nix { inherit system nixpkgs; };
        ebpf = import ./ebpf/shell.nix { inherit system nixpkgs; };
      });

      templates = {
        go = {
          path = ./go;
          description = "Go template";
        };

        rust = {
          path = ./rust;
          description = "Rust template using fenix";
        };

        python = {
          path = ./python;
          description = "Python template";
        };
      };
    };
}
