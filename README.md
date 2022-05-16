# nix-esp32-dev
ESP32 packages and development environments for Nix.

This repo contains derivations for:
- Toolchains (compiler, linker, GDB, etc.) for `xtensa-esp32-elf` (ESP32) using the official binaries from Espressif.
- [ESP-IDF](https://github.com/espressif/esp-idf)
- [OpenOCD for ESP32](https://github.com/espressif/openocd-esp32)

The python environment for ESP-IDF tools like `idf.py` is created into a folder `.espressif` inside the project directory. 

Released into the public domain via CC0 (see `COPYING`).

## Getting started
### `nix develop`
The easiest way to get started is to run one of these commands to get a development shell, without even needing to download the repository (requires Nix 2.4 or later):

- `nix --experimental-features 'nix-command flakes' develop github:almini/nix-esp32-dev`: for ESP32 development with [esp-idf](https://github.com/espressif/esp-idf).
    - Includes the ESP32 toolchain, esptool, the OpenOCD fork supporting ESP32, and downloads and sets up ESP-IDF with everything ready to use `idf.py`.

## Overriding ESP-IDF and ESP32 toolchain versions
There are default versions of ESP-IDF and the ESP32 toolchain versions specified in `pkgs/esp32-toolchain-bin.nix` and `pkgs/esp-idf-src/default.nix`. To use a different version of ESP-IDF or to pin the versions, override the derivations with the desired versions and the hashes for them. Note that given versions of ESP-IDF require specific versions of the toolchain, which is why the versions of both are customizable.

See `example/flake.nix` for an example.

## Credits
- [mirrexagon/nixpkgs-esp-dev](https://github.com/mirrexagon/nixpkgs-esp-dev)