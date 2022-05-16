{
  description = "ESP32 development tools";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    esp32-toolchain.url = "github:almini/nix-esp32-toolchain";
    esp32-toolchain.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, esp32-toolchain }: {
    overlay = final: prev: {
      gcc-xtensa-esp32-elf-bin = esp32-toolchain.defaultPackage.${prev.system};
      openocd-esp32-bin = prev.callPackage ./pkgs/openocd-esp32-bin.nix { };
      esp-idf-src = prev.callPackage ./pkgs/esp-idf-src { };
    };
  } // flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs { 
        inherit system; 
        overlays = [ 
          self.overlay 
        ]; 
      };
    in
    {
      packages = {
        inherit (pkgs)
          gcc-xtensa-esp32-elf-bin
          openocd-esp32-bin
          esp-idf-src;
      };

      devShell = import ./shells/esp32-idf.nix { inherit pkgs; };
    });
}
