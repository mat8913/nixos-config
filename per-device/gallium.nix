{ config, pkgs, ... }:

{
  networking.hostName = "gallium";

  hardware.cpu.amd.updateMicrocode = true;

  hardware.opengl.extraPackages = [ pkgs.mesa_noglu.drivers ];

  environment.systemPackages = with pkgs; [
    acpi
  ];

  # Full-disk encryption + boot from external USB
  boot.loader.grub.device = "nodev";

  # Need this kernel stuff for new AMD APU
  boot.kernelPackages = pkgs.linuxPackages_4_19;
  boot.initrd.kernelModules = [ "amdgpu" ];

  boot.kernelPatches = [{
    name = "my-config";
    patch = null;
    extraConfig = ''
      X86_AMD_PLATFORM_DEVICE y
      PREEMPT_VOLUNTARY n
      PREEMPT y
    '';
  }];

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
}
