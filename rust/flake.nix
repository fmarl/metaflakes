{
  description = "Rust Metaflake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    crane.url = "github:ipetkov/crane";

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
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import inputs.rust-overlay) ];
        };

        fenix-channel = inputs.fenix.packages.${system}.latest;

        fenix-toolchain = (fenix-channel.withComponents [
          "rustc"
          "cargo"
          "clippy"
          "rust-analysis"
          "rust-src"
          "rustfmt"
          "llvm-tools-preview"
        ]);

        craneLib = (inputs.crane.mkLib pkgs).overrideToolchain fenix-toolchain;

        cranePkg = craneLib.buildPackage {
          src = craneLib.cleanCargoSource ./.;

          doCheck = false;

          buildInputs = [ ];
        };

        code = inputs.code-nix.packages.${system}.default;
      in
      {
        packages.default = cranePkg;

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            fenix-toolchain
            rust-analyzer
          ];
        };
      });
}
