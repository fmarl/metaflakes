{
  system,
  nixpkgs,
  code-nix,
}:

let
  pkgs = import nixpkgs { inherit system; };
  code = code-nix.packages.${system}.default {
    profiles.nix.enable = true;
    profiles.clojure.enable = true;
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    babashka
    code.editor
    code.tooling
  ];
}
