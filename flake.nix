{
  description = "ESP32 development tools";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    esp32-toolchain.url = "github:almini/nix-esp32-toolchain";
    esp32-toolchain.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, esp32-toolchain }: {
    overlay = import ./overlay.nix;
  } // flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs { 
        inherit system; 
        overlays = [ 
          self.overlay 
          (final: prev: {
            gcc-xtensa-esp32-elf-bin = esp32-toolchain.defaultPackage.${system};
          })
        ]; 
      };
    in
    {
      packages = builtins.trace esp32-toolchain.defaultPackage.${system} {
        inherit (pkgs)
          gcc-xtensa-esp32-elf-bin
          openocd-esp32-bin
          esp-idf-src;
      };

      devShell = import ./shells/esp32-idf.nix { inherit pkgs; };
    });
}
