#!/usr/bin/env bash
# Setup script for setting up a new macos machine

echo "*********************************************************************"
echo "Starting Automated MAC Setup v1.1"
echo 'You should be and up and running in a few minutes.'
echo "*********************************************************************"
echo "Before starting & if you are migrating from a previous Laptop"
echo "Make sure you have a backup of your config files from previous Laptop"
echo "To do so run the following command on previous laptop"
echo "> brew install mackup"
echo "> mackup backup"
read -p "Have you done the backup & wish to continue?(yes)"
if [ "$REPLY" != "yes" ]; then
   exit
fi
echo "Current shell: $SHELL."
echo "macOS version:"
sw_vers
echo "Mac model:"
sysctl hw.model
echo "*********************************************************************"
echo "Please enter your Mac Password to proceed with Setup"
# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# install xcode CLI
#xcode-select —-install

###############################################################################
# Homebrew                                                                    #
###############################################################################

# Check for Homebrew to be present, install if it's missing
if test ! $(which brew); then
    echo "*********************************************************************"
    echo "Installing homebrew..."
    echo "*********************************************************************"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
echo "Verifying the Homebrew installation..."
if brew doctor; then
  echo "Your Homebrew installation is good to go."
else
  echo "Your Homebrew installation reported some errors or warnings."
  echo "Review the Homebrew messages to see if any action is needed."
fi
echo "*********************************************************************"
echo "Update Homebrew Packages/Recipes"
echo "*********************************************************************"
# Update homebrew recipes
brew update

PACKAGES=(
    git
    tmux
    bat
#    macvim
    mysql
    fzf
    ctags
    atool
    autoconf
    automake
    bind
    bluetoothconnector
    cairo
#    cmake
    coreutils
    docbook
    docbook-xsl
#    doxygen
    fontconfig
    freetype
    gdbm
    geoip
    gettext
    ghostscript
    glib
    gmp
    gnu-getopt
    gnutls
    icu4c
    ilmbase
    imagemagick
    jansson
    jpeg
    jq
    json-c
    libde265
    libevent
    libffi
    libgcrypt
    libgpg-error
    libheif
    libidn2
    liblqr
    libomp
    libpng
    libtasn1
    libtiff
    libtool
    libunistring
    libuv
    libxml2
    libxmlsec1
    libyaml
    little-cms2
    lnav
    luarocks
    lzo
    mackup
#    macprefs
    mtr
    ncurses
    nettle
    nikto
    nmap
    node
    nspr
    nss
    oath-toolkit
    openexr
    openjpeg
    openssl@1.1
    p11-kit
    pcre
    pixman
    pnpm
    poppler
    python
    python@3.8
    qt
    readline
    shared-mime-info
    speedtest-cli
    sqlite
    sslscan
    theharvester
    unbound
    webp
    wget
    x265
    xmlto
    xz
    youtube-dl
    zsh
    zsh-completions
)
echo "Installing packages..."
brew install ${PACKAGES[@]}

# any additional steps you want to add here

# install amass https://danielmiessler.com/study/amass/

brew tap caffix/amass
brew install amass
amass enum –list

# link readline
brew link --force readline

echo "Cleaning up..."
brew cleanup

###############################################################################
# Ruby                                                                        #
###############################################################################

# ruby install
ruby-install ruby 2.5.5
echo "*********************************************************************"
echo "Installing Ruby gems"
echo "*********************************************************************"
RUBY_GEMS=(
    bundler
    bigdecimal
    bundler
    CFPropertyList
    cmath
    csv
    date
    dbm
    did_you_mean
    e2mmap
    etc
    fcntl
    fiddle
    fileutils
    forwardable
    io-console
    ipaddr
    irb
    json
    libxml-ruby
    logger
    matrix
    mini_portile2
    minitest
    mutex_m
    net-telnet
    nokogiri
    ostruct
    power_assert
    prime
    psych
    rake
    rdoc
    rexml
    rss
    scanf
    sdbm
    shell
    sqlite3
    stringio
    strscan
    sync
    test-unit
    thwait
    tracer
    webrick
    xmlrpc
    zlib
    )
    sudo gem install ${RUBY_GEMS[@]}

    gem install openssl -- --with-openssl-dir=/opt/openssl

    ###############################################################################
    # Brew Casks                                                                  #
    ###############################################################################

    echo "*********************************************************************"
    echo "Installing Brew Cask..."
    echo "*********************************************************************"
CASKS=(
    1password
    adobe-acrobat-reader
    alfred
    atom
    backblaze
    bartender
    battery-guardian
    bettertouchtool
    bitbar
    bluejeans
#    boom-3d
    box-drive
    charles
    cleanmymac
    dropbox
    droplr
    ferdi
#    firefox
    gas-mask
#    google-backup-and-sync
#    google-chrome
    google-earth-pro
    hand-mirror
    imageoptim
    integrity
    mediainfo
    microsoft-teams
    moom
    muzzle
    oversight
    pdf-expert
    purevpn
    skype
    slack
#    station
    the-unarchiver
    transmit
    vlc
    istat-menus
    iterm2
    zoom
    webex-meetings
)
echo "*********************************************************************"
echo "Installing cask apps..."
echo "*********************************************************************"
brew install --cask ${CASKS[@]}
echo "*********************************************************************"

echo "Configuring OS..."

###############################################################################
# https://github.com/mathiasbynens/dotfiles/blob/master/.macos                                                                    #
###############################################################################

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable the sound effects on boot
#sudo nvram SystemAudioVolume=" "

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Disable “natural” (Lion-style) scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Increase sound quality for Bluetooth headphones/headsets
#defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en" "fr"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Stop iTunes from responding to the keyboard media keys
#launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

###############################################################################
# Energy saving                                                               #
###############################################################################

# Enable lid wakeup
#sudo pmset -a lidwake 1

# Restart automatically on power loss
#sudo pmset -a autorestart 1

# Restart automatically if the computer freezes
#sudo systemsetup -setrestartfreeze on

# Sleep the display after 15 minutes
#sudo pmset -a displaysleep 15

# Disable machine sleep while charging
#sudo pmset -c sleep 0

# Set machine sleep to 5 minutes on battery
#sudo pmset -b sleep 5

# Set standby delay to 24 hours (default is 1 hour)
#sudo pmset -a standbydelay 86400

# Never go into computer sleep mode
#sudo systemsetup -setcomputersleep Off > /dev/null

# Hibernation mode
# 0: Disable hibernation (speeds up entering sleep mode)
# 3: Copy RAM to disk so the system state can still be restored in case of a
#    power failure.
#sudo pmset -a hibernatemode 0

# Remove the sleep image file to save disk space
#sudo rm /private/var/vm/sleepimage
# Create a zero-byte file instead…
#sudo touch /private/var/vm/sleepimage
# …and make sure it can’t be rewritten
#sudo chflags uchg /private/var/vm/sleepimage

###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
#defaults write com.apple.screensaver askForPassword -int 1
#defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the Dowloads Folder
defaults write com.apple.screencapture location -string "${HOME}/Downloads"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Enable subpixel font rendering on non-Apple LCDs
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
#defaults write NSGlobalDomain AppleFontSmoothing -int 1

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Show only open applications in the Dock
#defaults write com.apple.dock static-only -bool true

# Top right screen corner → ScreenSaver
#defaults write com.apple.dock wvous-tr-corner -int 5
#efaults write com.apple.dock wvous-tr-modifier -int 0

###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the WebKit Developer Tools in the Mac App Store
#defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
#defaults write com.apple.appstore ShowDebugMenu -bool true

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Automatically download apps purchased on other Macs
#defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Allow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool true

###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

#echo "Configuring oh-my-zsh plugins..."
#
#cd ~/.oh-my-zsh/custom/plugins
#git clone https://github.com/zsh-users/zsh-autosuggestions
#git clone https://github.com/zsh-users/zsh-autosuggestions

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Google Chrome Canary" \
#	"Google Chrome" \
	"Mail" \
	"Messages" \
	"Opera" \
	"Photos" \
	"Safari" \
	"SizeUp" \
	"Spectacle" \
	"SystemUIServer" \
	"Terminal" \
	"Transmission" \
	"Tweetbot" \
	"Twitter" \
	"iCal"; do
	killall "${app}" &> /dev/null
done

#https://github.com/romkatv/powerlevel10k
echo "*********************************************************************"
echo "Installing Powerlevel10k"
echo "*********************************************************************"
brew install romkatv/powerlevel10k/powerlevel10k
echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
echo "*********************************************************************"
echo "Mackup Restore Config Files..."
mackup restore
echo "*********************************************************************"
echo "Macbook setup completed!"
echo "*********************************************************************"
echo "Manual Install: https://github.com/gabriellorin/touch-bar-emojis"
echo "Manual Install: https://touch-bar-timer.alexzirbel.com/"
echo "Manual Install: https://rockysandstudio.com/"
echo "Manual Install: https://shortmenu.com/mac/"
echo "*********************************************************************"
echo "Note that some of the changes require a logout/restart to take effect."
read -p "Do you want to reboot now?(yes)"
if [ "$REPLY" != "yes" ]; then
   exit
fi
sudo shutdown -r now
