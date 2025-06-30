{ system, nixpkgs }:
let pkgs = import nixpkgs { inherit system; };
in pkgs.mkShell {
  name = "ebpf-dev-shell";
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

  shellHook = ''
    echo ""
    echo "Development shell for eBPF ready."
    echo ""
  '';
}
