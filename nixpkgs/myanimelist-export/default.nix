pkgs:
(pkgs.haskellPackages.override {
  overrides = self: super: {
    myanimelist-export = self.callPackage ./myanimelist-export.nix { };
  };
}).myanimelist-export
