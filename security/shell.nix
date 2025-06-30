{ system, nixpkgs }:
let pkgs = import nixpkgs { inherit system; };
in pkgs.mkShell {
  name = "kernel-dev-shell";
  buildInputs = with pkgs; [
    openvpn
    nmap
    dnsrecon
    binwalk
    sqlmap
    aflplusplus

    (python3.withPackages (ps: with ps; [ scapy ]))
  ];
}
