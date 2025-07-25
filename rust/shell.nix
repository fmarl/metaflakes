{
  system,
  nixpkgs,
  fenix,
  rust-overlay,
  edinix,
}:
let
  pkgs = import nixpkgs {
    inherit system;
    overlays = [ (import rust-overlay) ];
  };

  fenix-channel = fenix.packages.${system}.latest;

  fenix-toolchain = (
    fenix-channel.withComponents [
      "rustc"
      "cargo"
      "clippy"
      "rust-analysis"
      "rust-src"
      "rustfmt"
      "llvm-tools-preview"
    ]
  );

  code = edinix.packages.${system}.code {
    profiles.nix.enable = true;
    profiles.rust.enable = true;
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    code.editor
    code.tooling
    fenix-toolchain
    rust-analyzer
  ];
}
