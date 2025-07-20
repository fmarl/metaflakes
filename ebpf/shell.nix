{ system, nixpkgs }:
let
  pkgs = import nixpkgs { inherit system; };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    clang-tools
    llvmPackages.clang
    gcc
    gnumake
    pkg-config
    bpftools
    bpftrace
    libbpf
    libelf
    elfutils
    pahole
  ];
}
