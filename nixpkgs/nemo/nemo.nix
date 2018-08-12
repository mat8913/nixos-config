{ stdenv, fetchFromGitHub, meson, pkgconfig, gtk3, gobjectIntrospection, libnotify }:

stdenv.mkDerivation rec {
  name = "nemo-${version}";
  version = "3.8.5";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "nemo";
    rev = version;
    sha256 = "13a2qylag3zxpz6c1mnm59m829m4dy84jp9l7yn47q2ba4g1h48v";
  };

  nativeBuildInputs = [ meson pkgconfig ];
  buildInputs = [ gtk3 gobjectIntrospection libnotify ];
}

