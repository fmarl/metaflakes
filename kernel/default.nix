{ system, nixpkgs }:
let
  pkgs = import nixpkgs { inherit system; };
  lib = nixpkgs.lib;
  clangVersion = lib.versions.major pkgs.llvmPackages.libclang.version;
  cc = pkgs.llvmPackages.stdenv.cc.override {
    bintools = pkgs.llvmPackages.bintools;
    extraBuildCommands = ''
      substituteInPlace "$out/nix-support/cc-cflags" --replace " -nostdlibinc" ""
      echo " -resource-dir=${pkgs.llvmPackages.libclang.lib}/lib/clang/${clangVersion}" >> $out/nix-support/cc-cflags
    '';
  };
in
pkgs.mkShell {
  name = "kernel-dev-shell";
  hardeningDisable = [ "all" ];
  LLVM = 1;

  buildInputs = with pkgs; [
    git
    (python3.withPackages (ps: with ps; [
      GitPython
      ply
    ]))

    gdb
    qemu
    pahole
    flex
    bison
    bc
    pkg-config
    elfutils
    openssl.dev
    perl

    # LLVM=1
    cc.cc
    llvmPackages.bintools-unwrapped
    llvmPackages.lld

    clang-tools
    # static analysis
    codespell
    flawfinder
    cppcheck
    sparse
    valgrind
    aflplusplus
  ];
}