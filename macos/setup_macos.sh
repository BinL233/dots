# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Update Homebrew
brew update

# wget
brew install wget

# neovim
brew install neovim

# Oh-my-zsh
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# zsh auto completion
brew install zsh-autocomplete

# p10k
brew install powerlevel10k

# Scroll Reverser
wget https://pilotmoon.com/downloads/ScrollReverser-1.9.zip

# yazi
brew install yazi ffmpeg-full sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick-full font-symbols-only-nerd-font
brew link ffmpeg-full imagemagick-full -f --overwrite

# k8s
brew install kubectl
brew install kubectx
brew install kubecolor

# zoxide
brew install zoxide
