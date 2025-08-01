{
  system,
  nixpkgs,
  ghc ? "ghc984",
  libDeps ? [ ],
  edinix,
}:
let
  pkgs = import nixpkgs { inherit system; };
  hpkgs = pkgs.haskell.packages."${ghc}";

  stack-wrapped = pkgs.symlinkJoin {
    name = "stack";
    paths = [ pkgs.stack ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/stack \
        --add-flags "\
          --no-nix \
          --system-ghc \
          --no-install-ghc \
        "
    '';
  };

  code = edinix.packages.${system}.code {
    profiles.nix.enable = true;
    profiles.haskell.enable = true;
  };
in
pkgs.mkShell {
  buildInputs = [
    pkgs.nixfmt
    pkgs.nil
    pkgs.pkg-config

    stack-wrapped

    (hpkgs.ghcWithPackages (hgpkgs: [ hgpkgs.pretty-simple ]))
    hpkgs.ormolu
    hpkgs.hlint
    hpkgs.hoogle
    hpkgs.haskell-language-server
    hpkgs.ghcid
    hpkgs.implicit-hie
    hpkgs.retrie

    code.editor
    code.tooling
  ]
  ++ libDeps;

  # Make external Nix C libraries like zlib known to GHC, like pkgs.haskell.lib.buildStackProject does
  # https://github.com/NixOS/nixpkgs/blob/d64780ea0e22b5f61cd6012a456869c702a72f20/pkgs/development/haskell-modules/generic-stack-builder.nix#L38
  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath libDeps;
}
