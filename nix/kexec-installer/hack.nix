{ config, pkgs, lib, ... }:

let
  extracted = pkgs.stdenv.mkDerivation {
    src = /home/maciej/nixos-images/images.tar.gz;
    name = "extracted";
    dontBuild = true;
setSourceRoot = "sourceRoot=$PWD";
    installPhase = ''
      mkdir -p $out
      mv -v root_part efi_part $out
    '';
  };

  script = pkgs.writeShellScript "hack" ''
    export PATH="${lib.makeBinPath (with pkgs; [ coreutils-full systemd ])}"
    extracted=${extracted}
    dd if=$extracted/efi_part oflag=direct of=/dev/vda2
    dd if=$extracted/root_part oflag=direct of=/dev/vda1
    shutdown -h now
  '';
in
{
  /* systemd.services."getty@tty1" = {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = ["" "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${script} --autologin root --noclear --keep-baud %I 115200,38400,9600 $TERM"];
  }; */
  systemd.services.install = {
    serviceConfig = {
       ExecStart = script;
    };
    wantedBy = [ "multi-user.target" ]; 
  };

  boot.kernelParams = [
    "systemd.journald.forward_to_console"
    "loglevel=3"
    "console=tty1"
    "console=ttyS0"
  ];
}
