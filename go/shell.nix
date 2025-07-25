{
  system,
  nixpkgs,
  edinix,
}:
let
  pkgs = import nixpkgs { inherit system; };
  code = edinix.packages.${system}.code {
    profiles.nix.enable = true;
    profiles.go.enable = true;
  };
in
pkgs.mkShell {
  CGO_ENABLED = 0;

  buildInputs = with pkgs; [
    nixfmt
    nil
    code.editor
    code.tooling
  ];
}
