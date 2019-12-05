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

  networking.wireguard.enable = true;

  networking.firewall.extraCommands = ''
    iptables -w -P OUTPUT DROP
    iptables -w -A OUTPUT -o tun_proton -j ACCEPT
    iptables -w -A OUTPUT -o lo -j ACCEPT
    iptables -w -A OUTPUT -d 192.168.122.0/24 -o virbr0 -j ACCEPT
    iptables -w -A OUTPUT -d 10.14.61.82 -j ACCEPT

    iptables -w -A OUTPUT -p udp -d 79.142.76.71 -j ACCEPT
    iptables -w -A OUTPUT -p udp -d 79.142.76.72 -j ACCEPT
    iptables -w -A OUTPUT -p udp -d 185.159.156.3 -j ACCEPT
    iptables -w -A OUTPUT -p udp -d 185.159.156.4 -j ACCEPT
    iptables -w -A OUTPUT -p udp -d 185.159.156.17 -j ACCEPT
    iptables -w -A OUTPUT -p udp -d 185.159.156.18 -j ACCEPT

    iptables -A OUTPUT -p udp -d 116.203.36.234 --destination-port 1194 -j ACCEPT
    iptables -A OUTPUT -p tcp -d 116.203.36.234 --destination-port 443 -j ACCEPT
    iptables -A OUTPUT -p tcp -d 116.203.36.234 --destination-port 22 -j ACCEPT
    iptables -w -A OUTPUT -d 10.8.0.0/24 -o tun_mb -j ACCEPT
  '';

  services.upower.percentageLow = 35;
  services.upower.percentageCritical = 30;
  services.upower.percentageAction = 25;

  # Disable hibernate (it doesn't work)
  environment.etc."systemd/sleep.conf".text = lib.mkAfter ''
    HibernateMode=suspend platform shutdown
    HibernateState=mem
    HybridSleepMode=suspend platform shutdown
    HybridSleepState=mem
  '';
}
