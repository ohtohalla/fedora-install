#! /bin/bash

clear

# POSSIBLE OS
FEDORA=`cat /etc/*elease | grep "Fedora" | wc -l`
CENTOS=`cat /etc/*elease | grep "CentOS" | wc -l`

echo "Updating the system"

dnf update --refresh -y

if [CENTOS -gt 0]
then
  echo "Enabling EPEL Repositories"
  dnf config-manager --set-enabled crb
  dnf install \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
    https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm
    
  echo "Enabling RPM Fusion for CentOS"
  dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm
  dnf install --nogpgcheck https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm
fi


echo "Installing packages"

sudo dnf install git neovim rust cargo npm gcc g++ R rstudio gnome-tweaks kitty ulauncher zsh zathura zathura-pdf-mupdf texlive-scheme-full util-linux-user julia python3-pip

# echo "Installing extesions" sevlitä ja tee joskus

echo "Downloading fonts"
cd ~/Downloads/
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Iosevka.zip
unzip Iosevka.zip
cd
# Tähän sitten vielä fonttien asennus joskus

echo "Setting tap to click and reversing scroll direction"
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll false

echo "Installing Oh-My-Zsh"

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Getting own zsh config"

cd 
cd .config
rm .zshrc
wget https://raw.githubusercontent.com/ohtohalla/dots/main/.zshrc

echo "Set zsh as default"

chsh -s $(which zsh)

# Tähän joskus kitty-konffan haku kun on valmis

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
nvim '+PlugUpdate | qa'
