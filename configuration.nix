# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, inputs, ... }:

let

  # This is needed because usbipd for windows fails to create these 
  # directories and mount them with it's inbuilt commands
  usbipd-mount-sh = ''
    mkdir -m 0000 "/var/run/usbipd-win"
    mount -t drvfs -o "ro,umask=222" "C:\Program Files\usbipd-win\WSL" "/var/run/usbipd-win"
  '';
in
{
  #imports = [
  #  # include NixOS-WSL modules
  #  <nixos-wsl/modules>
  #];

  wsl = {
    enable = true;
    defaultUser = "nixos";
    nativeSystemd = true;
    usbip.enable = true;
  };

 # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users = {
    nixos = {
      name = "nixos";
      group = "users";
      extraGroups = [
        "dialout" "lp" # these are for /dev/tty* access
      ];
    };
  };


  system.activationScripts.usbipdMount = {
    text = usbipd-mount-sh;
  };

  environment.systemPackages = with pkgs; [
    # Flakes clones its dependencies through the git command,
    # so git must be installed first
    git
    vim
    nano
    wget
    curl
    busybox
  ];

  #i'm pretty sure all the nix-ld stuff is for vscode access. But i can't quite remember
  programs.nix-ld = {
    enable = true;
    package = inputs.nix-ld-rs.packages."${pkgs.system}".nix-ld-rs;
  };  

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
