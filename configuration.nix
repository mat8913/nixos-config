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

  # Enable GNOME3 desktop environment
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.desktopManager.xterm.enable = false;

  # Workaround for no Wayland support in GDM yet
  environment.systemPackages = [ pkgs.gnome3.gnome-session ];

  # Enable Flatpak
  services.flatpak.enable = true;

  # Workaround for #40878
  environment.etc = {
    "profile.d/vte.sh" = {
      source = "${pkgs.gnome3.vte}/etc/profile.d/vte.sh";
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?
}
