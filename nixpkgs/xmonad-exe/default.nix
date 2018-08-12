pkgs:
(pkgs.haskellPackages.override {
  overrides = self: super: {
    xmonad-exe = self.callPackage ./xmonad-exe.nix { };
  };
}).xmonad-exe
