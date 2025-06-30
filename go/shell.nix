{ system, nixpkgs }:
let pkgs = import nixpkgs { inherit system; };
in pkgs.mkShell {
  name = "go-dev-shell";

  buildInputs = with pkgs; [ pkgs.go pkgs.gopls pkgs.golangci-lint ];

  shellHook = ''
    echo "Let's GO!"
  '';
}
