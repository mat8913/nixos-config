# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./per-device/default.nix  # Symbolic link to current device
    ];

  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_AU.UTF-8";
  time.timeZone = "Australia/Sydney";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;

  # So that file managers can mount external drives
  services.gnome3.gvfs.enable = true;
  environment.variables.GIO_EXTRA_MODULES = [ "${pkgs.gnome3.gvfs}/lib/gio/modules" ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable SSH server
  services.openssh.enable = true;
  services.openssh.forwardX11 = true;
  services.openssh.permitRootLogin = "no";
  services.openssh.passwordAuthentication = false;
  services.openssh.challengeResponseAuthentication = false;
  services.openssh.hostKeys = [ {
    type = "ed25519";
    path = "/etc/ssh/ssh_host_ed25519_key";
  } ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";

  services.xserver.displayManager.lightdm.enable = true;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.horizontalScrolling = false;
  services.xserver.libinput.tapping = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?
}
