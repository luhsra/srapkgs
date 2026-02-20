{ pkgs }:
let
  # This module describes the part of the system that only makes sense in our
  # test VM scenario, like empty root password and port forward rules.
  debugVm =
    { config, modulesPath, ... }:
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
      # virtualisation.qemu.options = [ "-s" "-serial tcp::5555,server,nowait" ];
      # boot.kernelParams = [ "console=ttyS0" "console=ttyS1" "kgdboc=ttyS1" ];

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

      users.extraUsers.root = {
        password = "";
        openssh.authorizedKeys.keys = pkgs.lib.strings.splitString "\n" (builtins.readFile ./authorized_keys);
      };

      users.extraUsers.eval = {
        isNormalUser = true;
        password = "";
        openssh.authorizedKeys.keys = config.users.extraUsers.root.openssh.authorizedKeys.keys;
      };

      system.stateVersion = "24.11";
    };

  nixosEvaluation = pkgs.nixos [
    debugVm
  ];
in

nixosEvaluation.config.system.build.vm
