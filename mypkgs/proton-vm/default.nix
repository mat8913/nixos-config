{ coreutils
, qemu
, socat
}:

{
  service = rec {
    path = [ coreutils qemu socat ];

    script = ''
      mkdir /tmp/proton-vm
      chmod 700 /tmp/proton-vm

      exec qemu-system-x86_64 \
        -display none \
        -boot order=d \
        -accel kvm \
        -sandbox on \
        -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
        -smp 4 \
        -rtc base=localtime \
        -vga qxl \
        -m 16G \
        -usb -device usb-tablet \
        -device virtio-serial-pci \
        -nic user,model=virtio-net-pci,hostfwd=tcp:127.0.0.1:8445-:445,hostfwd=tcp:127.0.0.1:8389-:3389 \
        -drive index=0,file="$STATE_DIRECTORY"/root.qcow2,media=disk,if=virtio,discard=unmap,detect-zeroes=unmap \
        -drive index=1,file="$STATE_DIRECTORY"/storage.qcow2,media=disk,if=virtio,discard=unmap,detect-zeroes=unmap \
        -monitor unix:/tmp/proton-vm/monitor-socket,server,nowait
    '';

    preStop = ''
      echo "stopping $MAINPID"

      if [ x"$MAINPID" = x ]; then
        echo already stopped
        exit 0
      fi

      while [ -S /tmp/proton-vm/monitor-socket ]; do
        echo asking for shutdown
        echo "system_powerdown" | socat STDIN unix-connect:/tmp/proton-vm/monitor-socket
        sleep 1
      done

      exit 0
    '';

    restartIfChanged = false;

    confinement.enable = true;

    confinement.packages = path;

    serviceConfig = {
      PrivateDevices = false;
      BindPaths = [ "/dev" ];
      StateDirectory = "proton-vm";
      SupplementaryGroups = "kvm";

      DynamicUser = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      CapabilityBoundingSet = "";
      TemporaryFileSystem = [ "/dev/shm:mode=1777" ];
      DevicePolicy = "closed";
      DeviceAllow = "/dev/kvm rw";
      SystemCallFilter = [ "~@clock" "~@cpu-emulation" "~@debug" "~@module" "~@mount" "~@obsolete" "~@privileged" "~@raw-io" "~@reboot" "~@resources" ];
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      SystemCallArchitectures = "native";
      UMask = "0066";
      RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
      ProtectClock = true;
      ProtectKernelLogs = true;
      ProtectHostname = true;
    };
  };
}
