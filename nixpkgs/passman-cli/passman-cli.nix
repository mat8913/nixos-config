{ mkDerivation, base, conduit, contravariant, haskeline
, optparse-applicative, passman-core, resourcet, stdenv, text, X11
, yaml
}:
mkDerivation {
  pname = "passman-cli";
  version = "0.2.0.0";
  sha256 = "a8c9737bc596d5eae5a7b3cff6d8b3d55e96c20b9d085592d7bd89f72c5c0c50";
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base conduit contravariant haskeline optparse-applicative
    passman-core resourcet text X11 yaml
  ];
  homepage = "https://github.com/PasswordManager/passman-cli#readme";
  description = "Deterministic password generator command line interface";
  license = stdenv.lib.licenses.gpl3;
}
