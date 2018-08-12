let
  nixpkgs = import <nixpkgs> {};

  mySteamWorkaround = rec {
    repo = nixpkgs.fetchFromGitHub {
      owner = "mat8913";
      repo = "nixpkgs";
      rev = "d65e58a20fe7b4cc2c20b673afd9ff6997eeefa7";
      sha256 = "161xsjgp7qvsk1h729lv90xyz9md4jdy0y1b0xqkw84zfhgmjh4l";
    };

    steamPackages = nixpkgs.callPackage (repo + /pkgs/games/steam) {};

    steam = steamPackages.steam-chrootenv;
  };

  ffmpeg_3_2 = with nixpkgs; callPackage ./ffmpeg_3_2.nix {
     inherit (darwin.apple_sdk.frameworks) Cocoa CoreMedia;
   };

  x-terminal-emulator = nixpkgs.runCommandNoCC "x-terminal-emulator"
    { preferLocalBuild = true;
      allowSubstitutes = false;
    }
    ''
      mkdir -p "$out/bin"
      ln -s "${nixpkgs.xfce.terminal}/bin/xfce4-terminal" "$out/bin/x-terminal-emulator"
    '';

in

with nixpkgs;

[
  acpi
  gnome3.defaultIconTheme
  anki
  binutils
  cabal2nix
  chromium
  gnome3.dconf
  feh
  file
  firefox-esr-60
  gimp
  git
  gitAndTools.git-annex
  gitAndTools.gitRemoteGcrypt
  gmrun
  gnupg
  hicolor-icon-theme
  mailutils
  mkvtoolnix
  mpv
  myanimelist-export
  gnome3.nautilus
  networkmanagerapplet
  passman-cli
  pavucontrol
  powerline-fonts
  redshift
  steam-run
  sudo
  taskwarrior
  transmission-gtk
  trayer
  unison
  unzip
  vimHugeX
  weechat
  wget
  xbindkeys
  xfce.terminal
  x-terminal-emulator
  haskellPackages.xmobar
  xscreensaver
  youtube-dl
  xmonad-exe
  mySteamWorkaround.steam
  ffmpeg_3_2
  evince
]
