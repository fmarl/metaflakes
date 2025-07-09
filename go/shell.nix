{ system, nixpkgs }:
let pkgs = import nixpkgs { inherit system; };
in pkgs.mkShell {
  CGO_ENABLED = 0;

  buildInputs = with pkgs; [
    nixfmt
    nil
    go
    gopls
    gotools
    go-tools
    gopkgs
    golangci-lint
    delve
    gotests
  ];
}
