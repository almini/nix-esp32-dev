final: prev: 
{
  # gcc-xtensa-esp32-elf-bin = prev.callPackage ./pkgs/esp32-toolchain-bin.nix { };
  openocd-esp32-bin = prev.callPackage ./pkgs/openocd-esp32-bin.nix { };
  esp-idf-src = prev.callPackage ./pkgs/esp-idf-src { };
}
