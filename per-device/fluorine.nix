{ config, pkgs, ... }:

{
  networking.hostName = "fluorine";

  # Full-disk encryption + boot from external USB
  boot.initrd.luks.devices.sda1_crypt.device = "/dev/sda1";
  boot.loader.grub.device = "nodev";

  fileSystems."/home/matthew/owncloud" =
    { device = "/dev/vgfluorine/owncloud";
      fsType = "ext4";
    };

  fileSystems."/media/determination" =
    { device = "/dev/vgfluorine/determination";
      fsType = "ext4";
    };

  fileSystems."/media/stretch" =
    { device = "/dev/vgfluorine/jessie";
      fsType = "ext4";
    };

  # Enable hardware video rendering
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];

  # Needed for Steam
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;
}
