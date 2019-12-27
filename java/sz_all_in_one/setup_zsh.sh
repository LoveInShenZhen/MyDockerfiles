#!/bin/sh

apk update && apk upgrade && apk add git zsh

sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sed -ri 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="bira"/' $HOME/.zshrc

sed -i 's/\/bin\/ash/\/bin\/zsh/g' /etc/passwd

rm -rf /var/cache/apk/* /tmp/*