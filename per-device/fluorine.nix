{ config, pkgs, ... }:

{
  networking.hostName = "fluorine";

  # Full-disk encryption + boot from external USB
  boot.initrd.luks.devices.sda1_crypt.device = "/dev/sda1";
  boot.loader.grub.device = "nodev";

  fileSystems."/home/matthew/owncloud" =
    { device = "/dev/vgfluorine/owncloud";
      fsType = "ext4";
      options = [ "ro" ];
    };

  fileSystems."/media/determination" =
    { device = "/dev/vgfluorine/determination";
      fsType = "ext4";
    };
}
