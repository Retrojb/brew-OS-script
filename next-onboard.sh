cat << _EOF_

_EOF_


echo "Set zsh as default shell (y/n) >"
read res1
if [ "$res1" == "y"]; then
    sudo sh -c "echo $(which zsh) >> /etc/shells" && chsh -s $(which zsh)
    echo zsh is now default
fi
echo

cat << _EOF_

_EOF_

echo "Start installing NPM dependecies"
npm i -g  react react-scripts npm express redux
echo
npm ls -g --depth=0
echo
echo "Next download your personal zshrc? >"
