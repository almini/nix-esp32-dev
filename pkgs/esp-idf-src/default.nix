# When updating to a newer version, check if the version of `esp32-toolchain-bin.nix` also needs to be updated.
{ rev ? "a82e6e63d98bb051d4c59cb3d440c537ab9f74b0"
, sha256 ? "sha256-qw3PFu5iaLqoiKnbttZFcTDJ16CLCICMTAd5WbMvqRc="
, stdenv
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "esp-idf-src";
  version = rev;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esp-idf";
    rev = rev;
    sha256 = sha256;
    fetchSubmodules = true;
  };

  # This is so that downstream derivations will have IDF_PATH set.
  setupHook = ./setup-hook.sh;

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
  '';
}
