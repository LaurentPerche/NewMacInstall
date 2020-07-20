#!/usr/bin/env bash
# Setup script for setting up a new macos machine

echo "Starting setup"

# install xcode CLI
#xcode-select —-install

# Check for Homebrew to be present, install if it's missing
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

PACKAGES=(
    git
    tmux
    bat
    macvim
    mysql
    fzf
    ctags
    atool
    autoconf
    automake
    bind
    bluetoothconnector
    cairo
    cmake
    coreutils
    docbook
    docbook-xsl
    doxygen
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
    macprefs
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

# ruby install
ruby-install ruby 2.5.5
echo "Installing Ruby gems"
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

    echo "Installing cask..."
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
    blue-jeans
    boom-3d
    box-drive
    charles
    cleanmymac
    dropbox
    droplr
    firefox
    gas-mask
    google-backup-and-sync
    google-chrome
    chrome-devtools
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
    station
    the-unarchiver
    transmit
    vlc
    istat-menus
    iterm2
    zoom
    webex-meetings
)
echo "Installing cask apps..."
brew cask install ${CASKS[@]}

echo "Configuring OS..."

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

#echo "Configuring oh-my-zsh plugins..."
#
#cd ~/.oh-my-zsh/custom/plugins
#git clone https://github.com/zsh-users/zsh-autosuggestions
#git clone https://github.com/zsh-users/zsh-autosuggestions


echo "Macbook setup completed!"
