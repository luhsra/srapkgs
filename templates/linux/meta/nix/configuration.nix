{ pkgs, config, modulesPath, ... }:
{
  imports = [
    # The qemu-vm NixOS module gives us the `vm` attribute that we will later
    # use, and other VM-related settings
    "${modulesPath}/virtualisation/qemu-vm.nix"
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.registry = {
    nixpkgs.to = {
      type = "path";
      path = pkgs.path;
    };
  };

  environment.systemPackages = with pkgs; [
    htop
    usbutils
    lm_sensors
  ];

  boot.kernel.sysctl."kernel.printk" = "7 7 7 7";

  virtualisation.graphics = false;
  boot.kernel.sysctl."kernel.sysrq" = 1;

  # virtualisation.qemu.options = [ ];
  # boot.kernelParams = [ ];

  virtualisation = {
    memorySize = 8096;
    diskSize = 128 * 1024;
    cores = 8;

    useNixStoreImage = true;
    writableStore = true;
    writableStoreUseTmpfs = false;
  };

  # Root user without password and enabled SSH
  networking.firewall.enable = false;

  services.openssh.enable = true;
  services.openssh.settings = {
    PermitRootLogin = "yes";
    PermitEmptyPasswords = "yes";
  };
  security.pam.services.sshd.allowNullPassword = true;
  security.pam.services.sudo.allowNullPassword = true;

  users.users = {
    root = {
      password = "";
      openssh.authorizedKeys.keys = pkgs.lib.strings.splitString "\n" (builtins.readFile ./authorized_keys);
    };

    eval = {
      isNormalUser = true;
      password = "";
      openssh.authorizedKeys.keys = config.users.extraUsers.root.openssh.authorizedKeys.keys;
      extraGroups = [ "wheel" ];
    };
  };

  system.stateVersion = "24.11";
}
