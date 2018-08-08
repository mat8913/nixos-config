pkgs:
(pkgs.haskellPackages.override {
  overrides = self: super: {
    passman-core = self.callPackage ./passman-core.nix { };
    passman-cli = self.callPackage ./passman-cli.nix { };
    QuickCheck = self.callPackage ./QuickCheck-2.9.2.nix { };
    quickcheck-instances = self.callPackage ./quickcheck-instances-0.3.14.nix { };
    aeson = self.callPackage ./aeson-1.2.2.0.nix { };
    generic-deriving = self.callPackage ./generic-deriving-1.11.2.nix { };
  };
}).passman-cli
