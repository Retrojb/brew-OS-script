#!/usr/bin/env bash

cd /Users/$USER/Downloads
open "https://idmsa.apple.com/IDMSWebAuth/signin?appIdKey=891bd3417a7776362562d2197f89480a8547b108fd934911bcbea0110d07f757&path=%2Fdownload%2Fmore%2F&rv=1"

echo "Press enter to continue"
read keyPress

cat << _EOF_
  _____   _______    _____   _______ 
 / _ \ \ / /  ___|  / _ \ \ / /  ___|
/ /_\ \ V /| |__   / /_\ \ V /| |__  
|  _  |\ / |  __|  |  _  |\ / |  __| 
| | | || | | |___  | | | || | | |___ 
\_| |_/\_/ \____/  \_| |_/\_/ \____/ 
                                     

____________ _____ _    _ 
| ___ \ ___ \  ___| |  | |
| |_/ / |_/ / |__ | |  | |
| ___ \    /|  __|| |/\| |
| |_/ / |\ \| |___\  /\  /
\____/\_| \_\____/ \/  \/ 
_EOF_


echo "Checking for homebrew..."
if test ! $(which brew); then
    echo "Installing homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    printf 'export PATH="/usr/local/bin:$PATH"\n' >> ~/.bash_profile
    echo "Brew installed"
fi
echo " Verifing lastest version of Home Brew"
brew update
echo
echo "Dr. Brew is in the HOUSE!!!"
echo "Have the Docter give ya physical ;) (y/n)"
read res1

if [ "$res1" == "y"]; then
    echo "Check that Home Brew is good to go"
    brew docter
else echo "Okay"
fi
echo
echo "Hope ya don't get sick!"
echo
echo "Let's go to the Brewery!!!"

PACKAGES=(
    awk
    docker
    helm
    helm@2
    git
    kubernetes-cli
    markdown
    node
    wget
    zsh
    zsh-autosuggestions
    zsh-completions
    zshdb
)

brew install ${PACKAGES[@]}
echo
echo "Set zsh as default shell (y/n) >"
read res1
if [ "$res1" == "y"]; then
    sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)
    printf 'export PATH="/usr/local/bin:$PATH"\n' >> ~/.zshrc
    echo zsh is now default
fi
echo
echo "Installing cask..."
brew install caskroom/cask/brew-cask
echo

CASKS=(
    firefox
    google-chrome
    iterm2
    mongodb-compass
    postman
    slack
)

echo "Installing cask apps..."
brew cask install ${CASKS[@]}

echo "Time for NPM"

DEPENDECIES=(
    react
    npm
    react-scripts
    express
    eslint
    eslint-config-react-app
    eslint-plugin-jsx-a11y
    eslint-plugin-react
    corejs
    bootstrap
    webpack
    zone.js@0.9.1
)

npm i -g ${DEPENDECIES[@]}
echo "NPM dep installed globally"
echo
npm ls -g --depth=0
open -a "iTerm.app"

## END OF FIRST SCRIPT



