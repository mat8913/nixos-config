{ config, pkgs, lib, ... }:

{
  networking.hostName = "gallium";

  hardware.cpu.amd.updateMicrocode = true;

  hardware.opengl.extraPackages = [ pkgs.mesa_noglu.drivers ];

  environment.systemPackages = with pkgs; [
    acpi
  ];

  # Full-disk encryption + boot from external USB
  boot.loader.grub.device = "nodev";

  boot.kernelPackages = pkgs.linuxPackages_5_4;

  networking.wireguard.enable = true;

  networking.firewall.extraCommands = ''
    ${pkgs.iproute}/bin/ip netns add physical || true
    ${pkgs.iproute}/bin/ip link set dev enp2s0f1 netns physical || true
    ${pkgs.iw}/bin/iw phy phy0 set netns name physical || ${pkgs.iproute}/bin/ip netns exec physical ${pkgs.iw}/bin/iw phy phy0 info > /dev/null
    ${pkgs.iproute}/bin/ip -n physical link set dev lo up
  '';

  services.upower.percentageLow = 35;
  services.upower.percentageCritical = 30;
  services.upower.percentageAction = 25;

  systemd.services.iwd.serviceConfig = {
    ExecStart = [
      ""
      "${pkgs.iproute}/bin/ip netns exec physical ${pkgs.iwd}/libexec/iwd"
    ];
    CapabilityBoundingSet = "CAP_SYS_ADMIN";
  };

  # Disable hibernate (it doesn't work)
  environment.etc."systemd/sleep.conf".text = lib.mkAfter ''
    HibernateMode=suspend platform shutdown
    HibernateState=mem
    HybridSleepMode=suspend platform shutdown
    HybridSleepState=mem
  '';
}
