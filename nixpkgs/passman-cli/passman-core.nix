{ mkDerivation, aeson, async, base, bcrypt, bytestring, conduit
, conduit-extra, containers, cryptohash-md5, csv-conduit
, data-ordlist, directory, filepath, int-cast, memory, QuickCheck
, quickcheck-unicode, resourcet, stdenv, template-haskell
, temporary, text, unix-compat, yaml
}:
mkDerivation {
  pname = "passman-core";
  version = "0.2.0.0";
  sha256 = "a73ee6fcff29666037a49e04746790f4b46fd5fcaa497c005bbd4990911d840e";
  revision = "1";
  editedCabalFile = "1840hm9wiym9jlgij1b2d8fa90pdscg2rqhzhvrl7qawd3jjxq5x";
  libraryHaskellDepends = [
    aeson base bcrypt bytestring conduit conduit-extra containers
    cryptohash-md5 csv-conduit data-ordlist directory filepath int-cast
    memory resourcet text unix-compat yaml
  ];
  testHaskellDepends = [
    async base conduit filepath QuickCheck quickcheck-unicode
    template-haskell temporary text yaml
  ];
  doHaddock = false;
  homepage = "https://github.com/PasswordManager/passman-core#readme";
  description = "Deterministic password generator core";
  license = stdenv.lib.licenses.gpl3;
}
