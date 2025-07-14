{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.em.brew;
in
{
  imports = [ ];

  options = {
    em.brew = {
      enable = mkEnableOption "Emile's brew config";
    };
  };

  config = mkIf cfg.enable {
    # # Requires Homebrew to be installed
    # system.activationScripts.preUserActivation.text = ''
    #   if ! xcode-select --version 2>/dev/null; then
    #     $DRY_RUN_CMD xcode-select --install
    #   fi
    #   if ! ${config.homebrew.brewPrefix}/brew --version 2>/dev/null; then
    #     $DRY_RUN_CMD /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    #   fi
    # '';

    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = true;
        upgrade = true;
        # cleanup = "zap"; # Uninstall all programs not declared, only run this on initial activation
      };
      global = {
        brewfile = true; # Run brew bundle from anywhere
        lockfiles = false; # Don't save lockfile (since running from anywhere)
      };
      taps = [
        "homebrew/services"
        "leoafarias/fvm"
        "probe-rs/probe-rs"
      ];
      brews = [
        # "libusb"
        # "openssl"
        # "switchaudio-osx"
        "wget" # download tool
        "curl" # no not install curl via nixpkgs, it's not working well on macOS!
        "aria2" # download tool
        "httpie" # http client
        "ruby" # More up to date version of ruby
        "fvm"

        "probe-rs"
      ];
      casks = [
        # "android-platform-tools"
        # "docker"
        # "eloston-chromium"
        # "firefox"
        # "flameshot"
        # "font-fira-code-nerd-font"
        # "karabiner-elements"
        # "notion"
        # # "osxfuse"
        # "prismlauncher"
        # "scroll-reverser"
        # "sf-symbols"
        # "slack"
        # "spotify"
        # "xquartz"

        # The following are removed because it caused too many install issues
        # Feel free to uncomment for first time installation
        # "foxglove-studio"
        # "wireshark"
        # "syncthing"

        "google-chrome"

        "winbox" # MikroTik Winbox
        "gitkraken" # git client
        "ltspice"
        "aldente"

        "daisydisk"

        "arduino-ide"
        "orcaslicer"
        "blender"
        "rider"

        "microsoft-office"
        "adobe-creative-cloud"

        "xcodes"
        "sf-symbols"

        "stats" # beautiful system monitor

        # Development
        "insomnia" # REST client
      ];
      extraConfig = ''
        # brew "xorpse/formulae/brew", args: ["HEAD"]
        cask_args appdir: "~/Applications"
      '';
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ emile ];
  };
}
