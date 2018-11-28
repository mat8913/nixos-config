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

  environment.systemPackages = with pkgs; [
    # Workaround for no Wayland support in GDM yet
    gnome3.gnome-session

    # For gsettings binary
    glib.dev

    vimHugeX
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

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
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;
  services.xserver.desktopManager.xterm.enable = false;

  # Enable Flatpak
  services.flatpak.enable = true;

  # Workaround for #40878
  environment.interactiveShellInit = ''
    if [[ "$VTE_VERSION" > 3405 ]]; then
      source "${pkgs.gnome3.vte}/etc/profile.d/vte.sh"
    fi
  '';

  # Workaround for bluetooth audio
  systemd.services.fix-gdm-pulse = {
    enable = true;
    wantedBy = [ "display-manager.service" ];
    before = [ "display-manager.service" ];
    script = ''
      mkdir -p /run/gdm/.config/pulse
      cat <<EOF > /run/gdm/.config/pulse/default.pa
      # load system wide configuration
      .include /etc/pulse/default.pa
      ### unload driver modules for Bluetooth hardware
      .ifexists module-bluetooth-policy.so
        unload-module module-bluetooth-policy
      .endif
      .ifexists module-bluetooth-discover.so
        unload-module module-bluetooth-discover
      .endif
      EOF
      chown gdm:gdm /run/gdm/.config
      chown gdm:gdm /run/gdm/.config/pulse
    '';
    serviceConfig.Type = "oneshot";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?
}
