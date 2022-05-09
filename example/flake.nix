{
  inputs = {
    esp32-dev.url = "github:almini/nix-esp32-dev";
  };

  outputs = { self, esp32-dev }: let 
    flake-utils = esp32-dev.inputs.flake-utils;
  in flake-utils.lib.eachDefaultSystem (system: 
    let 
      pkgs = (import esp32-dev.inputs.nixpkgs { 
        inherit system; 
        overlays = [ 
          esp32-dev.overlay
          (final: prev: {
            esp-idf-src = prev.esp-idf-src.override {
              rev = "7e1b3f401fe148b52bee9df070cc3bc883c8583a";
              sha256 = "sha256-lBR3wOkCsN7JL6A9JP5LYJ9l3oF9GiF+A/sUQnr0NFE=";
            };
          })
        ]; 
      });
    in {
      devShell = import "${esp32-dev.outPath}/shells/esp32-idf.nix" { inherit pkgs; };
    });
}
