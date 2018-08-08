{
  allowUnfree = true;
  unison.enableX11 = false;
  packageOverrides = pkgs: {
    passman-cli = import ./passman-cli pkgs;
    myanimelist-export = import ./myanimelist-export pkgs;
  };
}
