{
  system,
  nixpkgs,
  edinix,
}:
let
  pkgs = import nixpkgs { inherit system; };
  helix = edinix.helix.${system} {
    profiles.python.enable = true;
  };
  
  code = edinix.code.${system} {
    profiles.nix.enable = true;
    profiles.python.enable = true;
  };
in
pkgs.mkShell {
  buildInputs = [
    helix.editor
    code.editor
    code.tooling
  ];
}
