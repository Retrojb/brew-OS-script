#!/usr/bin/env bash

brew_pkg="
nvm
watchman
wget
"

brew_casks="
firefox
spotify
"

npm_global="
yarn::yarn
typescript::typescript
"

# Colors
# https://dev.to/ifenna__/adding-colors-to-bash-scripts-48g4
# \033 -> escape
# \033[0 -> 0 is font width
# \033[0;32 -> 32 foreground color
# \033[0;32;40m; -> 40m background color

reset="\033[0m"
highlight="\033[41m\033[97m"
dot="\033[31m $reset"
dim="\033[2m"
blue="\e[34m"
green="\e[32m"
yellow="\e[33m"
green_tag="\e[30;46m"
blue_tag="\e[38;5;33m"
bold=$(tput bold)
normal=$(tput sgr0)
underline="\e[37;4m"
indent="    "

print_red() {
  _print_in_color "$1" 1
}

print_green() {
  _print_in_color "$1" 2
}

print_yellow() {
  _print_in_color "$1" 3
}

print_blue() {
  _print_in_color "$1" 4
}

print_purple() {
  _print_in_color "$1" 5
}

print_white() {
  _print_in_color "$1" 6
}

print_success() {
  print_green"${indent} $1\n"
}

print_error() {
  print_red"${indent} [X] $1 $2\n"
}

print_question() {
  print_yellow" [?] $1\n"
}
print_result() {
  if [ "$1" -eq 0]; then
    print_success "$2"
  else
    print_error "$2"
  fi

  return "$1"
}

# Utils
# Printf https://linuxize.com/post/bash-printf-command/
_print_in_color() {
  printf "%b" \
    "$(tput setaf "$2" 2> /dev/null)" \
    "$1" \
    "$(tput sgr0 2> /dev/null)"
}

_print_stream_error_log() {
  while read -r line; do
    print_red "ERROR: $line\n"
  done
}

kill_subprocess() {
  local index=""

  for index in $(jobs -p); do
    kill "$index"
    wait "$index" &> /dev/null
  done
}

set_trap() {
  trap -p "$1" | grep "$2" &> /dev/null \
  || trap '$2' "$1"
}

_link_files() {
  local src=$1 dst=$2
  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then
    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then
      local currentSrc="$(readlink "$dst")"
      if [ "$currentSrc" == "$src" ]
      then
        skip=true;
      else
        printf "\r ${yellow}!${reset} File already exists: $dst ($(basename "$src")), what do you want to do?
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all? "
        read -n 1 action
        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all;;
          * )
            ;;
        esac
      fi
    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true"]
    then
      rm -rf "$dst"
      print_green "\n ${indent} deleted $dst"
    fi
    if [ "$backup" == "true"]
        then
          mv "$dst" "${dst}.backup"
          print_green "\n ${indent} moved $dst to ${dst}.backup"
    fi
    if [ "$skip" == "true"]
        then
          print_green "\n ${indent} $src already linked. Skipped.${reset}"
    fi
  fi

  if [ "$skip" != "true"]
  then
    ln -s "$1" "$2"
    print_green "\n    linked $1 to $2"
  fi
}

# OS Setup
uname_machine="$(uname -m)"
uname_arm="arm64"

get_os() {
    local os=""
    local kernelName=""

    kernelName="$(uname -s)"

    if [ "$kernelName" == "Darwin" ]; then
        os="macOS"
    elif [ "$kernalName" == "Linux" ]; then
        os="ubuntu"
    else
        os="$kernalName"
    fi

    printf "%s" "$os"
}

get_os_version() {
    local os=""
    local version=""

    os="$(get_os)"

    if [ "$os" == "macOS" ]; then
        version="$(sw_vers -productVersion)"
    elif [ "$os" == "ubuntu" ]; then
        version="$(lsb_release -d | cut -f2 | cut -d' ' -f2)"
    fi

    printf "%s" "$version"
}

check_internet_connection() {
    if [ ping -q -wl -c1 google.com &>/dev/null ]; then
        print "Check internet connection"
        exit 0
    else
        print "Internet GOOD"
    fi
}

cli_is_installed() {
    local return_=1
    type $1 >/dev/null 2>&1 || { local return_=0 }
    echo "$return_"
}

install_home_brew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

set_home_brew() {
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/$USER/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
}

install_brew() {
    if [[ ! $(brew list | grep $brew) ]]; then
        brew install $brew >/dev/null
        print "Installed Brew"
    else
        print "Brew already installed"
    fi
}

install_brew_apps() {
    if [[ ! $(brew list | grep $cask) ]]; then
        brew install --cask $brew_casks --appdir=/Applications >/dev/null
    else
        print "$cask already installed"
    fi
}

install_npm_deps() {
    if [[ $(cli_is_installed $2) == 0 ]]; then
        echo "Installing $1"
        npm install $1 -g --silent
    else
        print "$1 already installed"
    fi
}

get_github_version() {
    echo $1 | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/'
}


set_nvm() {
    local version=""
    version=18.17.1

    nvm install $version
    # Set nvm to default version
    nvm alias default $version
}