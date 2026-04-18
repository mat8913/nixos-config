{ config, lib, pkgs, ... }:

{
  systemd.services.wifi_recon = {
    path = [ pkgs.iputils pkgs.networkmanager pkgs.systemd ];

    script = ''
      # shellcheck source=/dev/null
      . /etc/wifi_recon.conf

      if [ -z "$GATEWAY" ]; then
        echo "GATEWAY not set"
        exit 1
      fi

      if [ -z "$SSID" ]; then
        echo "SSID not set"
        exit 1
      fi

      if ping -c 1 -W 5 "$GATEWAY"; then
        echo "ping succeeded. no action."
        exit 0
      else
        echo "ping failed. reconnecting."
        systemctl stop wpa_supplicant.service
        sleep 5
        nmcli connection up "$SSID"
      fi
    '';

    enableStrictShellChecks = true;

    serviceConfig = {
      Type = "oneshot";
      TimeoutStartSec = "1min";
      TimeoutStopSec = "1min";
      Restart = "no";
    };
  };

  systemd.timers.wifi_recon = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnActiveSec = "5min";
      OnUnitActiveSec = "5min";
    };
  };
}
