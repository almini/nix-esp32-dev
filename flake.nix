{
  description = "ESP32 development tools";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: {
    overlay = import ./overlay.nix;
  } // flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
    let
      pkgs = import nixpkgs { inherit system; overlays = [ self.overlay ]; };
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
