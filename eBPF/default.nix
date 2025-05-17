{ system, nixpkgs }:
let
  pkgs = import nixpkgs { inherit system; };
in
pkgs.mkShell {
  devShell = pkgs.mkShell {
    name = "ebpf-dev-shell";
    buildInputs = with pkgs; [
      clang
      llvm
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
  };
}
