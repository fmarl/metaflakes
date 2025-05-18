{ system, nixpkgs }:
let
  pkgs = import nixpkgs { inherit system; };
in
pkgs.mkShell {
  name = "ebpf-dev-shell";
  buildInputs = with pkgs; [
    llvmPackages.clang
    clang-tools
    gcc
    gnumake
    pkg-config
    bpftools
    libbpf
    libelf
    elfutils
    pahole
  ];

  shellHook = ''
    echo ""
    echo "Development shell for eBPF ready."
    echo ""
  '';
}
