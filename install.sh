#! /bin/bash

clear

echo "requesting access rights"

sudo su

echo "Updating the system"

sudo dnf update -y

echo "installing GNOME"

sudo dnf groupinstall gnome

echo "Installing packages"

sudo dnf install neovim rust cargo npm gcc g++ R rstudio gnome-tweaks kitty ulauncher zsh zathura zathura-pdf-mupdf texlive-scheme-full util-linux-user julia

# echo "Installing extesions" sevlitä ja tee joskus

echo "Downloading fonts"
cd ~/Downloads/
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Iosevka.zip
unzip Iosevka.zip
cd
# Tähän sitten vielä fonttien asennus joskus

echo "Setting tap to click and reversing scroll direction"
sudo gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

# Set ZSH as default in ZSH

zsh

clear

echo "Installing Oh-My-Zsh"

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Setting zsh as default"

chsh -s $(which zsh)

echo "Getting own zsh config"

cd 
cd .config
rm .zshrc
wget https://raw.githubusercontent.com/ohtohalla/dots/main/.zshrc

echo "Get Neovim config"

cd

echo "Getting the congig files"
mkdir -p ~/.config/nvim
git clone https://github.com/ohtohalla/nvim-lsp-config/ ~/.config/nvim

echo "Installing VimPlug"

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
       
echo "Installing plugins"
nvim '+PlugInstall | qa'
