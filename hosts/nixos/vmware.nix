{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "vmware";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  virtualisation.vmware.guest.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/Sao_Paulo";

  users.users.nicolas = {
    isNormalUser = true;
    description = "Nicolas Rezende";
    extraGroups = [
      "networkmanager"
      "wheel"
      "acme"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBVxFt9oc+P31mvJmLE2gdEVVIzCIdVEI4MZbuSKswZp"
    ];
  };

  services.openssh = {
    enable = true;
    knownHosts = {
      github = {
        hostNames = ["github.com"];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
    };
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    code-server
  ];

  systemd.services.code-server = {
    wantedBy = ["multi-user.target"];
    after = ["nginx.service"];
    description = "Start a code-server instance";
    serviceConfig = {
      Type = "simple";
      User = "nicolas";
      ExecStart = "${pkgs.code-server}/bin/code-server --bind-addr 0.0.0.0:443 --auth none --cert /var/lib/acme/dev.nicolasrezende.com/cert.pem --cert-key /var/lib/acme/dev.nicolasrezende.com/key.pem";
      Restart = "always";
      AmbientCapabilities = "cap_net_bind_service";
      CapabilityBoundingSet = "cap_net_bind_service";
    };
  };

  security.acme = {
    acceptTerms = true;
    preliminarySelfsigned = false;
    defaults.email = "cloudflare@nicolasrezende.com";
    certs."dev.nicolasrezende.com" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      credentialsFile = ../../secrets/cloudflare-credentials;
      dnsPropagationCheck = true;
      domain = "dev.nicolasrezende.com";
      extraDomainNames = ["*.dev.nicolasrezende.com"];
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "alt-intl";
  };

  system.stateVersion = "24.11";
}
