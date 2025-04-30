{ system, nixpkgs }:
let
  pkgs = import nixpkgs { inherit system; };
in
pkgs.mkShell {
  name = "kernel-dev-shell";
  buildInputs = with pkgs; [
    git
    gdb
    qemu
    pahole
    flex
    bison
    bc
    pkg-config
    elfutils
    openssl.dev
    llvmPackages.clang
    (python3.withPackages (ps: with ps; [
      GitPython
      ply
    ]))
    codespell
    perl

    # static analysis
    flawfinder
    cppcheck
    sparse
  ];
}