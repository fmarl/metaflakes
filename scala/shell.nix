{ system, nixpkgs }:
let
  pkgs = import nixpkgs { inherit system; };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    nixfmt
    nil
    bt
    metals
    openjdk17
    coursier
  ];
}
