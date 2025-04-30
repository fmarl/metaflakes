{
  description = "Linux development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs;
            [
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
        };
    };
}
