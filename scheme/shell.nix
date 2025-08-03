{
  system,
  nixpkgs,
  edinix,
}:

let
  pkgs = import nixpkgs { inherit system; };
  emacs = edinix.emacs.${system} {
    profiles.nix.enable = true;
    profiles.scheme.enable = true;
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    chicken  
    emacs.editor
    emacs.tooling
  ];
}
