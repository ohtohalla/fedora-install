#! /bin/bash

clear
read -p "Which Nerdfont would you like to install?" FONTNAME # Lisää tähän title case handling

# POSSIBLE OS
FEDORA=`cat /etc/*elease | grep "Fedora" | wc -l`
CENTOS=`cat /etc/*elease | grep "CentOS" | wc -l`

echo "Updating the system"

dnf update --refresh -y

if [ $CENTOS -gt 0 ]
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

sudo dnf install git neovim rust cargo npm gcc g++ R gnome-tweaks gnome-extensions-app kitty ulauncher zsh zathura zathura-pdf-mupdf texlive-scheme-full util-linux-user julia python3-pip

# echo "Installing extesions" sevlitä ja tee joskus

echo "Installing Miniconda"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda

eval "$(/Users/jsmith/miniconda/bin/conda shell.bash hook)"
conda init

echo "Downloading fonts"
#cd ~/Downloads/
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/$FONTNAME.zip

echo "Installing the font" # Ja tästä pitäisi saada robustimpi
unzip ${FONTNAME}.zip -d $FONTNAME
[ -d $HOME/.fonts ] || mkdir $HOME/.fonts
mv $FONTNAME $HOME/.fonts
fc-cache

# Tähän sitten vielä fonttien asennus joskus

echo "Setting Gnome settings"
dconf write /org/gnome/desktop/peripherals/touchpad/natural-scroll "false"
dconf write /org/gnome/desktop/peripherals/touchpad/tap-to-click "true"
dconf write /org/gnome/desktop/peripherals/touchpad/tap-to-click "true"
dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:ctrl_modifier']"
dconf write /org/gnome/desktop/wm/preferences/button-layout "'close,minimize,maximize:appmenu'"


echo "Installing Oh-My-Zsh"

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Fetching dotfiles"
alias config='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'
echo ".dots" >> .gitignore
git clone --bare <git-repo-url> $HOME/.dots
alias config='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'
config checkout

echo "Installing VimPlug"

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
       
echo "Installing plugins"
nvim '+PlugInstall | qa'
nvim '+PlugUpdate | qa'

echo "Set zsh as default"

chsh -s $(which zsh)
