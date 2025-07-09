{ system, nixpkgs, fenix, rust-overlay }:
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
in pkgs.mkShell {
  buildInputs = with pkgs; [ nixfmt nil fenix-toolchain rust-analyzer ];
}
