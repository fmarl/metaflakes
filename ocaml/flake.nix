{
  description = "A flake demonstrating how to build OCaml projects with Dune";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-filter.url = "github:numtide/nix-filter";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      nix-filter,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        opkgs = pkgs.ocamlPackages;
        lib = pkgs.lib;

        # Filtered sources (prevents unecessary rebuilds)
        sources = {
          ocaml = nix-filter.lib {
            root = ./.;
            include = [
              ".ocamlformat"
              "dune-project"
              (nix-filter.lib.inDirectory "bin")
              (nix-filter.lib.inDirectory "lib")
              (nix-filter.lib.inDirectory "test")
            ];
          };

          nix = nix-filter.lib {
            root = ./.;
            include = [ (nix-filter.lib.matchExt "nix") ];
          };
        };
      in
      {
        packages.default = opkgs.buildDunePackage {
          pname = "hello";
          version = "0.1.0";
          duneVersion = "3";
          src = sources.ocaml;

          strictDeps = true;

          preBuild = ''
            dune build hello.opam
          '';
        };

        checks = {
          hello =
            let
              patchDuneCommand =
                let
                  subcmds = [
                    "build"
                    "test"
                    "runtest"
                    "install"
                  ];
                in
                lib.replaceStrings (lib.lists.map (subcmd: "dune ${subcmd}") subcmds) (
                  lib.lists.map (subcmd: "dune ${subcmd} --display=short") subcmds
                );

            in
            self.packages.${system}.hello.overrideAttrs (oldAttrs: {
              name = "check-${oldAttrs.name}";
              doCheck = true;
              buildPhase = patchDuneCommand oldAttrs.buildPhase;
              checkPhase = patchDuneCommand oldAttrs.checkPhase;
              # skip installation (this will be tested in the `hello-app` check)
              installPhase = "touch $out";
            });

          # Check Dune and OCaml formatting
          dune-fmt =
            pkgs.runCommand "check-dune-fmt"
              {
                nativeBuildInputs = [
                  opkgs.dune_3
                  opkgs.ocaml
                  pkgs.ocamlformat
                ];
              }
              ''
                echo "checking dune and ocaml formatting"
                dune build \
                  --display=short \
                  --no-print-directory \
                  --root="${sources.ocaml}" \
                  --build-dir="$(pwd)/_build" \
                  @fmt
                touch $out
              '';

          # Check documentation generation
          dune-doc =
            pkgs.runCommand "check-dune-doc"
              {
                ODOC_WARN_ERROR = "true";
                nativeBuildInputs = [
                  opkgs.dune_3
                  opkgs.ocaml
                  opkgs.odoc
                ];
              }
              ''
                echo "checking ocaml documentation"
                dune build \
                  --display=short \
                  --no-print-directory \
                  --root="${sources.ocaml}" \
                  --build-dir="$(pwd)/_build" \
                  @doc
                touch $out
              '';

          # Check Nix formatting
          nixpkgs-fmt =
            pkgs.runCommand "check-nixpkgs-fmt"
              {
                nativeBuildInputs = [ pkgs.nixpkgs-fmt ];
              }
              ''
                echo "checking nix formatting"
                nixpkgs-fmt --check ${sources.nix}
                touch $out
              '';
        };

        devShells.default = import ./shell.nix { inherit system nixpkgs; };
      }
    );
}
