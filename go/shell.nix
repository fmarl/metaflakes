{ system, nixpkgs }:
let pkgs = import nixpkgs { inherit system; };
in pkgs.mkShell {
  CGO_ENABLED = 0;
  name = "go-dev-shell";

  buildInputs = with pkgs; [
    pkgs.nixfmt
    pkgs.go
    pkgs.gopls
    pkgs.golangci-lint
    pkgs.delve
  ];

  shellHook = ''
    echo "Let's GO!"
  '';
}
