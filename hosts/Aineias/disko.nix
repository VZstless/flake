{
  # Let disko own `fileSystems` / `swapDevices` instead of
  # hardware-configuration.nix.
  disko.enableConfig = true;

  disko.devices.disk.main = {
    device = "/dev/disk/by-id/nvme-UMIS_RPJYJ1T24MML1AWQ_SS1D71533X1LC55R0X61";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          label = "EFI";
          uuid = "dc07af2a-0c71-4306-9071-0cd2ef796faa";
          type = "EF00";
          start = "4096";
          end = "2101247"; # 2097152 sectors
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [
              "fmask=0077"
              "dmask=0077"
            ];
            extraArgs = [
              "-F"
              "32"
            ];
          };
        };
        root = {
          label = "root";
          uuid = "3526be61-9018-45ea-860c-f056443bd08c";
          type = "8300";
          start = "2101248";
          end = "1981942730"; # 1979841483 sectors
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
        swap = {
          label = "swap";
          uuid = "9f2f6e48-2ceb-47fa-ad3c-3817dff57acc";
          type = "8200";
          start = "1981942731";
          end = "2000397668"; # 18454938 sectors
          content = {
            type = "swap";
            resumeDevice = true;
          };
        };
      };
    };
  };
}
