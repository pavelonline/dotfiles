{ config, pkgs, ... }:
{
  systemd.mounts = [
    {
      enable = true;
      after = [ "remote-fs-pre.target" "network.target" "network-online.target" ];
      before = [ "remote-fs.target" "umount.target" ];
      wants = [ "network-online.target" ];
      conflicts = [ "umount.target" ];
      wantedBy = [ "remote-fs.target" ];
      options = "gid=100,file_mode=0664,dir_mode=2775";
      type = "davfs";
      what = "https://cloud01.opsdata.ch/remote.php/webdav/";
      where = "/mnt/cloud";
      unitConfig = {
        DefaultDependencies = false;
      };
      mountConfig = {
        TimeoutSec = 15;
      };
    }
  ];

  users.groups.davfs2 = {};

  users.users.davfs2 = {
    isNormalUser = false;
    isSystemUser = true;
    group = "davfs2";
  };

  environment.systemPackages = [ pkgs.davfs2 ];
}
