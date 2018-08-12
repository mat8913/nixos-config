{ stdenv, fetchFromGitHub, meson, pkgconfig, gdk_pixbuf, gtk3, xkeyboard_config,
  libxkbfile, libpulseaudio, gettext, gobjectIntrospection, ninja, intltool }:

stdenv.mkDerivation rec {
  name = "cinnamon-desktop-${version}";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-desktop";
    rev = version;
    sha256 = "0pqgwc37g3nrr9gj67rbkggxyffpghm2ssmgmkmgwsyaz9rm4qs7";
  };

  nativeBuildInputs = [ meson pkgconfig gettext gobjectIntrospection ninja intltool ];
  buildInputs = [ gdk_pixbuf gtk3 xkeyboard_config libxkbfile libpulseaudio ];

  postPatch = ''
    chmod +x install-scripts/meson_install_schemas.py
    patchShebangs install-scripts/meson_install_schemas.py
  '';
}

