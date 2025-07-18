{ system, nixpkgs, fenix, rust-overlay, code-nix }:
let
  pkgs = import nixpkgs {
    inherit system;
    overlays = [ (import rust-overlay) ];
  };

  fenix-channel = fenix.packages.${system}.latest;

  fenix-toolchain = (fenix-channel.withComponents [
    "rustc"
    "cargo"
    "clippy"
    "rust-analysis"
    "rust-src"
    "rustfmt"
    "llvm-tools-preview"
  ]);

  code = code-nix.packages.${system}.default {
    profiles.nix.enable = true;
    profiles.clojure.enable = true;
  };
in pkgs.mkShell {
  buildInputs = with pkgs; [
    code.editor
    code.tooling
    fenix-toolchain
    rust-analyzer
  ];
}
