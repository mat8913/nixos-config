{ config, pkgs, lib, ... }:

let
  upowerconfig = pkgs.writeTextFile {
    name = "UPower.conf";
    destination = "/etc/UPower/UPower.conf";
    text = ''
      # Only the system vendor should modify this file, ordinary users
      # should not have to change anything.

      [UPower]

      # Enable the Watts Up Pro device.
      #
      # The Watts Up Pro contains a generic FTDI USB device without a specific
      # vendor and product ID. When we probe for WUP devices, we can cause
      # the user to get a perplexing "Device or resource busy" error when
      # attempting to use their non-WUP device.
      #
      # The generic FTDI device is known to also be used on:
      #
      # - Sparkfun FT232 breakout board
      # - Parallax Propeller
      #
      # default=false
      EnableWattsUpPro=false

      # Don't poll the kernel for battery level changes.
      #
      # Some hardware will send us battery level changes through
      # events, rather than us having to poll for it. This option
      # allows disabling polling for hardware that sends out events.
      #
      # default=false
      NoPollBatteries=false

      # Do we ignore the lid state
      #
      # Some laptops are broken. The lid state is either inverted, or stuck
      # on or off. We can't do much to fix these problems, but this is a way
      # for users to make the laptop panel vanish, a state that might be used
      # by a couple of user-space daemons. On Linux systems, see also
      # logind.conf(5).
      #
      # default=false
      IgnoreLid=false

      # Policy for warnings and action based on battery levels
      #
      # Whether battery percentage based policy should be used. The default
      # is to use the time left, change to true to use the percentage, which
      # should work around broken firmwares. It is also more reliable than
      # the time left (frantically saving all your files is going to use more
      # battery than letting it rest for example).
      # default=true
      UsePercentageForPolicy=true

      # When UsePercentageForPolicy is true, the levels at which UPower will
      # consider the battery low, critical, or take action for the critical
      # battery level.
      #
      # This will also be used for batteries which don't have time information
      # such as that of peripherals.
      #
      # If any value is invalid, or not in descending order, the defaults
      # will be used.
      #
      # Defaults:
      # PercentageLow=10
      # PercentageCritical=3
      # PercentageAction=2
      PercentageLow=35
      PercentageCritical=30
      PercentageAction=25

      # When UsePercentageForPolicy is false, the time remaining at which UPower
      # will consider the battery low, critical, or take action for the critical
      # battery level.
      #
      # If any value is invalid, or not in descending order, the defaults
      # will be used.
      #
      # Defaults:
      # TimeLow=1200
      # TimeCritical=300
      # TimeAction=120
      TimeLow=1200
      TimeCritical=300
      TimeAction=120

      # The action to take when "TimeAction" or "PercentageAction" above has been
      # reached for the batteries (UPS or laptop batteries) supplying the computer
      #
      # Possible values are:
      # PowerOff
      # Hibernate
      # HybridSleep
      #
      # If HybridSleep isn't available, Hibernate will be used
      # If Hibernate isn't available, PowerOff will be used
      CriticalPowerAction=HybridSleep
    '';
  };

  upowerservice = pkgs.writeTextFile {
    name = "upower.service";
    destination = "/etc/systemd/system/upower.service";
    text = ''
      [Unit]
      Description=Daemon for power management
      Documentation=man:upowerd(8)

      [Service]
      Environment="UPOWER_CONF_FILE_NAME=${upowerconfig}/etc/UPower/UPower.conf"
      Type=dbus
      BusName=org.freedesktop.UPower
      ExecStart=/nix/store/qxd06igfzj6qyvp5f1jylp2vsij5li2i-upower-0.99.11/libexec/upowerd
      Restart=on-failure

      # Filesystem lockdown
      ProtectSystem=strict
      # Needed by keyboard backlight support
      ProtectKernelTunables=false
      ProtectControlGroups=true
      ReadWritePaths=/var/lib/upower
      StateDirectory=upower
      ProtectHome=true
      PrivateTmp=true

      # Network
      # PrivateNetwork=true would block udev's netlink socket
      IPAddressDeny=any
      RestrictAddressFamilies=AF_UNIX AF_NETLINK

      # Execute Mappings
      MemoryDenyWriteExecute=true

      # Modules
      ProtectKernelModules=true

      # Real-time
      RestrictRealtime=true

      # Privilege escalation
      NoNewPrivileges=true

      # Capabilities
      CapabilityBoundingSet=

      # System call interfaces
      LockPersonality=yes
      SystemCallArchitectures=native
      SystemCallFilter=@system-service
      SystemCallFilter=ioprio_get

      # Namespaces
      PrivateUsers=yes
      RestrictNamespaces=yes

      # Locked memory
      LimitMEMLOCK=0

      [Install]
      WantedBy=graphical.target
    '';
  };

in

{
  networking.hostName = "gallium";

  hardware.cpu.amd.updateMicrocode = true;

  hardware.opengl.extraPackages = [ pkgs.mesa_noglu.drivers ];

  environment.systemPackages = with pkgs; [
    acpi
  ];

  # Full-disk encryption + boot from external USB
  boot.loader.grub.device = "nodev";

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

  # Suspend on low battery
  services.upower.package = pkgs.symlinkJoin {
    name = "upower";
    paths = [ upowerservice upowerconfig pkgs.upower ];
  };
  
  # Disable hibernate (it doesn't work)
  environment.etc."systemd/sleep.conf".text = lib.mkAfter ''
    HibernateMode=suspend platform shutdown
    HibernateState=mem
    HybridSleepMode=suspend platform shutdown
    HybridSleepState=mem
  '';
}
