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
in pkgs.mkShell {
  hardeningDisable = [ "all" ];

  buildInputs = with pkgs; [
    nixfmt
    nil
    
    git
    (python3.withPackages (ps: with ps; [ GitPython ply ]))

    gdb
    gcc
    qemu
    ncurses
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
    llvmPackages.bintools
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
  shellHook = ''
    echo ""
    echo "Happy kernel hacking!"
    echo ""

    export CC=${cc.cc}/bin/clang
    export LD=${pkgs.llvmPackages.lld}/bin/ld.lld
    export AR=${pkgs.llvmPackages.bintools}/bin/llvm-ar
    export STRIP=${pkgs.llvmPackages.bintools}/bin/llvm-strip
    export OBJCOPY=${pkgs.llvmPackages.bintools}/bin/llvm-objcopy
    export OBJDUMP=${pkgs.llvmPackages.bintools}/bin/llvm-objdump
    export READELF=${pkgs.llvmPackages.bintools}/bin/llvm-readelf

    export HOSTCC=${cc.cc}/bin/clang
    export HOSTCXX=${cc.cc}/bin/clang++
    export HOSTLD=${pkgs.llvmPackages.lld}/bin/ld.lld
  '';
}
