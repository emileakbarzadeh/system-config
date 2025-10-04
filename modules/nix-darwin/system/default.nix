{ inputs, ... }:
{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.em.system;
in
{
  imports = [ ];

  options = {
    em.system = {
      enable = mkEnableOption "Emile MacOS system config";
    };
  };

  config = mkIf cfg.enable {
    # programs.nix-index.enable = true;

    environment.systemPackages = with pkgs; [
      nixos-rebuild
    ];
    environment.shells = [
      pkgs.zsh
    ];

    security.pam.services.sudo_local.touchIdAuth = true;

    system = {
      # keyboard settings is not very useful on macOS
      # the most important thing is to remap option key to alt key globally,
      # but it's not supported by macOS yet.
      keyboard = {
        # enableKeyMapping = true;  # enable key mapping so that we can use `option` as `control`

        # NOTE: do NOT support remap capslock to both control and escape at the same time
        #remapCapsLockToControl = false;  # remap caps lock to control, useful for emac users
        #remapCapsLockToEscape  = true;   # remap caps lock to escape, useful for vim users

        # swap left command and left alt
        # so it matches common keyboard layout: `ctrl | command | alt`
        #
        # disabled, caused only problems!
        #swapLeftCommandAndLeftAlt = false;
        # enableKeyMapping = true; # Allows for skhd
        # userKeyMapping = [
        #   # { HIDKeyboardModifierMappingSrc = 30064771172; HIDKeyboardModifierMappingDst = 30064771125; }
        #   # { HIDKeyboardModifierMappingSrc = 30064771125; HIDKeyboardModifierMappingDst = 30064771172; }
        # ];
      };

      defaults = {

        # customize settings that not supported by nix-darwin directly
        # Incomplete list of macOS `defaults` commands :
        #   https://github.com/yannbertrand/macos-defaults
        NSGlobalDomain = {
          # `defaults read NSGlobalDomain "xxx"`
          "com.apple.swipescrolldirection" = true; # enable natural scrolling(default to true)
          "com.apple.sound.beep.feedback" = 0; # disable beep sound when pressing volume up/down key
          #AppleInterfaceStyle = "Dark";  # dark mode
          AppleKeyboardUIMode = 3; # Mode 3 enables full keyboard control.
          #ApplePressAndHoldEnabled = true;  # enable press and hold

          # If you press and hold certain keyboard keys when in a text area, the key’s character begins to repeat.
          # This is very useful for vim users, they use `hjkl` to move cursor.
          # sets how long it takes before it starts repeating.
          #InitialKeyRepeat = 15;  # normal minimum is 15 (225 ms), maximum is 120 (1800 ms)
          # sets how fast it repeats once it starts.
          #KeyRepeat = 3;  # normal minimum is 2 (30 ms), maximum is 120 (1800 ms)

          NSAutomaticCapitalizationEnabled = false; # disable auto capitalization(自动大写)
          NSAutomaticDashSubstitutionEnabled = false; # disable auto dash substitution(智能破折号替换)
          NSAutomaticPeriodSubstitutionEnabled = false; # disable auto period substitution(智能句号替换)
          NSAutomaticQuoteSubstitutionEnabled = false; # disable auto quote substitution(智能引号替换)
          #NSAutomaticSpellingCorrectionEnabled = false;  # disable auto spelling correction(自动拼写检查)
          NSNavPanelExpandedStateForSaveMode = true; # expand save panel by default(保存文件时的路径选择/文件名输入页)
          NSNavPanelExpandedStateForSaveMode2 = true;

          # Save to local disk by default, not iCloud
          NSDocumentSaveNewDocumentsToCloud = false;

          # Expand print panel by default
          PMPrintingExpandedStateForPrint = true;

          # # Automatically show and hide the menu bar
          # _HIHideMenuBar = true;

          # # Replace press-and-hold with key repeat
          # ApplePressAndHoldEnabled = false;
          # # Set a fast key repeat rate
          # KeyRepeat = 5;
          # # Shorten delay before key repeat begins
          # InitialKeyRepeat = 12;

          # # Disable autocorrect spellcheck
          # NSAutomaticSpellingCorrectionEnabled = false;
          # # Set resize animation time
          # NSWindowResizeTime = 0.1;
          # # Disable scrollbar animations
          # NSScrollAnimationEnabled = false;
          # # Disable automatic window animations
          # NSAutomaticWindowAnimationsEnabled = false;

        };

        dock = {
          autohide = true;
          # Add translucency in dock for hidden applications
          showhidden = true;
          # Enable spring loading on all dock items
          enable-spring-load-actions-on-all-items = true;
          # Highlight hover effect in dock stack grid view
          # mouse-over-hilite-stack = true;
          # mineffect = "genie";
          # orientation = "bottom";
          # show-recents = false;
          # tilesize = 44;

          persistent-apps = [
            "/System/Applications/Launchpad.app"
            "/Applications/Safari.app"
            "/Applications/Google Chrome.app"
            "/Applications/Ghostty.app"
            "${pkgs.vscode}/Applications/Visual Studio Code.app"
            "/System/Applications/Messages.app"
            "/System/Applications/Music.app"
            "/System/Applications/Photos.app"
            "/System/Applications/Calendar.app"
            "/System/Applications/Notes.app"
            "/System/Applications/App Store.app"
            "/System/Applications/System Settings.app"
            "/Applications/Slack.app"
            "/System/Applications/Passwords.app"

          ];
          # persistent-others = [ "/Users/${config.system.primaryUser}/Downloads" ];

          mru-spaces = false; # disable spaces rearranging themselves
        };

        finder = {
          # # Default Finder window set to column view
          # FXPreferredViewStyle = "clmv";
          # Finder search in current folder by default
          FXDefaultSearchScope = "SCcf";

          #_FXShowPosixPathInTitle = true;  # show full path in finder title
          AppleShowAllExtensions = true; # show all file extensions
          FXEnableExtensionChangeWarning = false; # disable warning when changing file extension
          QuitMenuItem = true; # enable quit menu item
          ShowPathbar = true; # show path bar
          ShowStatusBar = false; # show status bar
        };

        # customize trackpad
        trackpad = {
          # tap - 轻触触摸板, click - 点击触摸板
          Clicking = true; # enable tap to click(轻触触摸板相当于点击)
          TrackpadRightClick = true; # enable two finger right click
          TrackpadThreeFingerDrag = false; # enable three finger drag
        };

        # Disable "Are you sure you want to open" dialog
        LaunchServices.LSQuarantine = false;
        # # Disable trackpad tap to click
        # trackpad.Clicking = false;

        # universalaccess = {
        #   # Zoom in with Control + Scroll Wheel
        #   closeViewScrollWheelToggle = true;
        #   closeViewZoomFollowsFocus = true;
        # };

        # Customize settings that not supported by nix-darwin directly
        # see the source code of this project to get more undocumented options:
        #    https://github.com/rgcr/m-cli
        #
        # All custom entries can be found by running `defaults read` command.
        # or `defaults read xxx` to read a specific domain.
        CustomUserPreferences = {
          ".GlobalPreferences" = {
            # automatically switch to a new space when switching to the application
            AppleSpacesSwitchOnActivate = true;
          };
          NSGlobalDomain = {
            # Add a context menu item for showing the Web Inspector in web views
            WebKitDeveloperExtras = true;
          };
          "com.apple.dock" = {
            "showAppExposeGestureEnabled" = true; # enable app expose gesture
          };
          "com.apple.finder" = {
            ShowExternalHardDrivesOnDesktop = true;
            ShowHardDrivesOnDesktop = true;
            ShowMountedServersOnDesktop = true;
            ShowRemovableMediaOnDesktop = true;
            #_FXSortFoldersFirst = true;
          };
          "com.apple.desktopservices" = {
            # Avoid creating .DS_Store files on network or USB volumes
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };
          "com.apple.spaces" = {
            "spans-displays" = 0; # Display have seperate spaces
          };
          "com.apple.WindowManager" = {
            EnableStandardClickToShowDesktop = 0; # Click wallpaper to reveal desktop
            StandardHideDesktopIcons = 0; # Show items on desktop
            HideDesktop = 0; # Do not hide items on desktop & stage manager
            StageManagerHideWidgets = 0;
            StandardHideWidgets = 0;
          };
          "com.apple.screensaver" = {
            # Require password immediately after sleep or screen saver begins
            #askForPassword = 1;
            #askForPasswordDelay = 0;
          };
          "com.apple.screencapture" = {
            location = "~/Desktop";
            type = "png";
          };
          "com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
          };
          # Prevent Photos from opening automatically when devices are plugged in
          "com.apple.ImageCapture".disableHotPlug = true;
        };

        loginwindow = {
          GuestEnabled = false; # disable guest user
          SHOWFULLNAME = true; # show full name in login window
        };

      };

      activationScripts = {
        reloadSettings = {
          text = ''
            # activateSettings -u will reload the settings from the database and apply them to the current session,
            # so we do not need to logout and login again to make the changes take effect.
            /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
          '';
        };
      };

      # # Settings that don't have an option in nix-darwin
      # activationScripts.postActivation.text = ''
      #   echo "Disable disk image verification"
      #   defaults write com.apple.frameworks.diskimages skip-verify -bool true
      #   defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
      #   defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

      #   echo "Disable the warning before emptying the Trash"
      #   defaults write com.apple.finder WarnOnEmptyTrash -bool false

      #   echo "Require password immediately after sleep or screen saver begins"
      #   defaults write com.apple.screensaver askForPassword -int 1
      #   defaults write com.apple.screensaver askForPasswordDelay -int 0

      #   echo "Allow apps from anywhere"
      #   SPCTL="$(spctl --status)"
      #   if ! [ "''${SPCTL}" = "assessments disabled" ]; then
      #       sudo spctl --master-disable
      #   fi

      #   ${
      #     inputs.mac-app-util.packages.${pkgs.stdenv.system}.default
      #   }/bin/mac-app-util sync-trampolines "/Applications/Nix Apps" "/Applications/Nix Trampolines"
      # '';

      # User-level settings
      # activationScripts.postUserActivation.text = ''
      #   echo "Show the ~/Library folder"
      #   chflags nohidden ~/Library

      #   echo "Enable dock magnification"
      #   defaults write com.apple.dock magnification -bool true

      #   echo "Set dock magnification size"
      #   defaults write com.apple.dock largesize -int 48

      #   echo "Set dock autohide delays (0)"
      #   defaults write com.apple.dock autohide-time-modifier -float 0
      #   defaults write com.apple.dock autohide-delay -float 0
      #   defaults write com.apple.dock expose-animation-duration -float 0
      #   defaults write com.apple.dock springboard-show-duration -float 0
      #   defaults write com.apple.dock springboard-hide-duration -float 0
      #   defaults write com.apple.dock springboard-page-duration -float 0

      #   echo "Disable Hot Corners"
      #   ## wvous-**-corner
      #   ## 0 - Nothing
      #   ## 1 - Disabled
      #   ## 2 - Mission Control
      #   ## 3 - Notifications
      #   ## 4 - Show the desktop
      #   ## 5 - Start screen saver
      #   ##
      #   ## wvous-**-modifier
      #   ## 0 - _
      #   ## 131072 - Shift+_
      #   ## 1048576 - Command+_
      #   ## 524288 - Option+_
      #   ## 262144 - Control+_
      #   ##
      #   # Top Left
      #   defaults write com.apple.dock wvous-tl-corner -int 0
      #   # Top Right
      #   defaults write com.apple.dock wvous-tr-corner -int 0
      #   # Bottom Left
      #   defaults write com.apple.dock wvous-bl-corner -int 0
      #   # Bottom Right
      #   defaults write com.apple.dock wvous-br-corner -int 0

      #   echo "Disable Finder animations"
      #   defaults write com.apple.finder DisableAllAnimations -bool true

      #   echo "Disable Mail animations"
      #   defaults write com.apple.Mail DisableSendAnimations -bool true
      #   defaults write com.apple.Mail DisableReplyAnimations -bool true

      #   # echo "Disable \"Save in Keychain\" for pinentry-mac"
      #   # defaults write org.gpgtools.common DisableKeychain -bool yes

      #   echo "Disable bezels (volume/brightness popups)"
      #   launchctl unload -wF /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist

      #   echo "Define dock icon function"
      #   __dock_item() {
      #       echo "${
      #         lib.pipe
      #           ''
      #             <dict>
      #               <key>
      #                 tile-data
      #               </key>
      #               <dict>
      #                 <key>
      #                   file-data
      #                 </key>
      #                 <dict>
      #                   <key>
      #                     _CFURLString
      #                   </key>
      #                   <string>
      #                     ''${1}
      #                   </string>
      #                   <key>
      #                     _CFURLStringType
      #                   </key>
      #                   <integer>
      #                     0
      #                   </integer>
      #                 </dict>
      #               </dict>
      #             </dict>
      #           ''
      #           [
      #             (lib.splitString "\n")
      #             (map
      #               (lib.flip lib.pipe
      #                 [
      #                   (builtins.match "[[:space:]]*(.*)")
      #                   head
      #                 ]))
      #             lib.concatStrings
      #           ]
      #       }"
      #   }

      #   echo "Choose and order dock icons"
      #   defaults write com.apple.dock persistent-apps -array \
      #       "$(__dock_item "/System/Applications/System Settings.app")"
      # '';
      # defaults write com.apple.dock persistent-apps -array \
      #     "$(__dock_item /Applications/1Password.app)" \
      #     "$(__dock_item ${pkgs.slack}/Applications/Slack.app)" \
      #     "$(__dock_item /System/Applications/Calendar.app)" \
      #     "$(__dock_item ${pkgs.firefox-bin}/Applications/Firefox.app)" \
      #     "$(__dock_item /System/Applications/Messages.app)" \
      #     "$(__dock_item /System/Applications/Mail.app)" \
      #     "$(__dock_item /Applications/Mimestream.app)" \
      #     "$(__dock_item /Applications/zoom.us.app)" \
      #     "$(__dock_item ${pkgs.discord}/Applications/Discord.app)" \
      #     "$(__dock_item /Applications/Obsidian.app)" \
      #     "$(__dock_item ${pkgs.kitty}/Applications/kitty.app)" \
      #     "$(__dock_item /System/Applications/System\ Settings.app)"
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ emile ];
  };
}
