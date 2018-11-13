{ config, pkgs, ... }:

{
  networking.hostName = "gallium";

  hardware.opengl.extraPackages = [ pkgs.mesa_noglu.drivers ];

  environment.systemPackages = with pkgs; [
    acpi
  ];

  # Full-disk encryption + boot from external USB
  boot.loader.grub.device = "nodev";

  # Need this kernel stuff for new AMD APU
  boot.kernelPackages = pkgs.linuxPackages_4_18;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [ "rcu_nocbs=0-15" ];

  boot.kernelPatches = [{
    name = "my-config";
    patch = null;
    extraConfig = ''
      X86_AMD_PLATFORM_DEVICE y
      DRM_AMD_DC_DCN1_0 y
      PREEMPT y
      PREEMPT_RCU y
      RCU_EXPERT y
      RCU_STALL_COMMON y
      RCU_NEED_SEGCBLIST y
      RCU_FANOUT 32
      RCU_FANOUT_LEAF 16
      RCU_BOOST y
      RCU_BOOST_DELAY 300
      RCU_NOCB_CPU y
      RCU_CPU_STALL_TIMEOUT 60
    '';
  }];
}
