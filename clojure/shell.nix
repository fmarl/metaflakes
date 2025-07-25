{
  system,
  nixpkgs,
  edinix,
}:

let
  pkgs = import nixpkgs { inherit system; };
  code = edinix.packages.${system}.code {
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
