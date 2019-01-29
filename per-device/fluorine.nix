{ config, pkgs, ... }:

{
  networking.hostName = "fluorine";

  # Full-disk encryption + boot from external USB
  boot.loader.grub.device = "nodev";

  # Suspend on low battery
  services.udev.extraRules = builtins.concatStringsSep ", " [
    ''SUBSYSTEM=="power_supply"''
    ''ATTR{status}=="Discharging"''
    ''ATTR{capacity}=="[0-9]"''
    ''RUN+="${pkgs.systemd}/bin/systemctl suspend"
    ''
  ];

  # Enable hardware video rendering
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];
}
