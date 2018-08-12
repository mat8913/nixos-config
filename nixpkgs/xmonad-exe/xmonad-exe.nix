{ mkDerivation, base, containers, fetchgit, stdenv, xmonad
, xmonad-contrib
}:
mkDerivation {
  pname = "xmonad-exe";
  version = "0.1.0.0";
  src = fetchgit {
    url = "https://github.com/mat8913/xmonad-exe";
    sha256 = "10rx3fzmc7rhg8ixwym3dg5br2z5x5cssg15na3ari7s444qxj76";
    rev = "b7b6c0125a11c61c37fe53b821543c8ee156eb27";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base containers xmonad xmonad-contrib
  ];
  postInstall = ''
    mv $out/bin/xmonad-exe $out/bin/xmonad
  '';
  homepage = "https://github.com/mat8913/xmonad-exe#readme";
  description = "My XMonad config";
  license = stdenv.lib.licenses.bsd3;
}
