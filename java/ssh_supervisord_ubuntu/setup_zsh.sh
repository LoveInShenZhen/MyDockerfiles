#!/usr/bin/env bash

apt-get update
apt-get install -y git zsh vim

sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

sed -ri 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="amuse"/' $HOME/.zshrc