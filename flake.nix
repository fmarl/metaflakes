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
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        fenix = inputs.fenix;
        rust-overlay = inputs.rust-overlay;
        code = edinix.packages.${system}.code {
          profiles.nix.enable = true;
        };
      in
      {
        devShells = {
          default =
            let
              pkgs = import nixpkgs { inherit system; };
            in
            pkgs.mkShell {
              buildInputs = [
                code.editor
                code.tooling
              ];
            };

          go = import ./go/shell.nix { inherit system nixpkgs edinix; };

          rust = import ./rust/shell.nix {
            inherit
              system
              nixpkgs
              fenix
              rust-overlay
              edinix
              ;
          };

          clojure = import ./clojure/shell.nix { inherit system nixpkgs edinix; };

          agda = import ./agda/shell.nix { inherit system nixpkgs; };

          ocaml = import ./ocaml/shell.nix { inherit system nixpkgs; };

          haskell = import ./haskell/shell.nix { inherit system nixpkgs; };

          scala = import ./scala/shell.nix { inherit system nixpkgs; };

          python = import ./python/shell.nix { inherit system nixpkgs; };

          kernel = import ./kernel/shell.nix { inherit system nixpkgs; };

          security = import ./security/shell.nix { inherit system nixpkgs; };

          ebpf = import ./ebpf/shell.nix { inherit system nixpkgs; };
        };
      }
    )
    // {
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

        scala = {
          path = ./scala;
          description = "Scala template using the sbt buildsystem";
        };

        haskell = {
          path = ./haskell;
          description = "Haskell template using haskellNix and stack";
        };

        ocaml = {
          path = ./ocaml;
          description = "OCaml template using the dune buildsystem";
        };

        clojure = {
          path = ./clojure;
          description = "Clojure template optimized for vscode";
        };

        agda = {
          path = ./agda;
          description = "Agda template using the default agda package";
        };
      };
    };
}
