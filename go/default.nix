{ system, nixpkgs }:
let
  pkgs = import nixpkgs { inherit system; };
in
pkgs.mkShell {
  name = "go-dev-shell";
  buildInputs = [ pkgs.go pkgs.gopls pkgs.git ];
  shellHook = ''
    echo "Willkommen in der Go Entwicklungsumgebung!"
  '';
}