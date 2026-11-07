brew "colima"
brew "coreutils"
brew "curl"
brew "docker"
brew "docker-buildx"
brew "docker-compose"
brew "emacs"
brew "exiftool"
brew "git"
brew "grep"
brew "imagemagick"
brew "pkgconf"
brew "webp"

cask "1password-cli"
cask "ghostty"

local_brewfile = File.expand_path("~/.Brewfile.local")
instance_eval(File.read(local_brewfile), local_brewfile) if File.exist?(local_brewfile)
