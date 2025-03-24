{ config, pkgs, lib, ... }:

let
  script = pkgs.writeShellScript "hack" (builtins.readFile ./hack.sh);
in
{
  systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = ["" "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${script} --autologin root --noclear --keep-baud %I 115200,38400,9600 $TERM"];
  };
}
