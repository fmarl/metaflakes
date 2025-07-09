{ system, nixpkgs }:
let pkgs = import nixpkgs { inherit system; };
in pkgs.mkShell {
  buildInputs = with pkgs; [
    clojure
    clojure-lsp
    clj-kondo
    cljstyle
    babashka
    leiningen
    rlwrap
    openjdk
  ];
}
