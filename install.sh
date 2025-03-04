#!/bin/bash

sudo apt-get install ninja-build gettext cmake curl build-essential

cd /tmp
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
make
make install
