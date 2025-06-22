{
  lib,
  python3Packages,
  networkmanager,
  wrapGAppsHook3,
  gobject-introspection,
}:

python3Packages.buildPythonApplication rec {
  pname = "nmwgrefresh";
  version = "1";
  pyproject = true;

  src = ./src;

  nativeBuildInputs = [
    wrapGAppsHook3
    gobject-introspection
  ];

  buildInputs = [
    networkmanager
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    pygobject3
  ];

  dontWrapGapps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
}
