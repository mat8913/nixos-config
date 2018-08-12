{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage <nixpkgs/pkgs/development/libraries/ffmpeg/generic.nix> (args // rec {
  version = "${branch}";
  branch = "3.2.12";
  sha256 = "1n2b9zg3zyjysshan3hdwk8wbn1pyc86yj3w1f9b107cswhwzqs5";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
