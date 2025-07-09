{ system, nixpkgs }:
let
  pkgs = import nixpkgs { inherit system; };
  opkgs = pkgs.ocamlPackages;
in pkgs.mkShell {
  packages = [
    pkgs.nixfmt
    pkgs.nil
    pkgs.ocamlformat
    pkgs.fswatch
    opkgs.odoc
    opkgs.ocaml-lsp
    opkgs.ocamlformat-rpc-lib
    opkgs.utop
  ];
}
