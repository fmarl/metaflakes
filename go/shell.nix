{ system, nixpkgs, code-nix }:
let
  pkgs = import nixpkgs { inherit system; };
  code = code-nix.packages.${system}.default {
    profiles.nix.enable = true;
    profiles.go.enable = true;
  };
in pkgs.mkShell {
  CGO_ENABLED = 0;

  buildInputs = with pkgs; [
    nixfmt
    nil
    code.editor
    code.tooling
  ];
}
