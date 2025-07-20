{ system, nixpkgs }:
let
  pkgs = import nixpkgs { inherit system; };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    nixfmt
    nil
    python3Full
    pyright
  ];
}
