{ system, nixpkgs }:
let
  pkgs = import nixpkgs { inherit system; };
in
pkgs.mkShell {
  name = "python-dev-shell";
  buildInputs = [ pkgs.python3Full pkgs.pyright ];
}
