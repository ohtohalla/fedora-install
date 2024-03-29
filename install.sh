#! /bin/bash

clear
#read -p "Which Nerdfont would you like to install? The default is Iosevka. " FONTNAME # Lisää tähän title case handling

# Variables
## Possible OS
FEDORA=`cat /etc/*elease | grep "Fedora" | wc -l`
CENTOS=`cat /etc/*elease | grep "CentOS" | wc -l`

# Availibility of Nvidia card
NVIDIA=`sudo lspci | grep NVIDIA | wc -l`

# Fontname to be installed
if [ -z "$FONTNAME" ]
then
  FONTNAME="Iosevka"
fi

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

echo "Enabling COPR Repositories"
sudo dnf copr enable dani/qgis

echo "Installing packages from packages.list"

dnf install $(cat ./package.list) --skip-broken

echo "Installing Flatpaks"

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.slack.Slack
flatpak install flathub md.obsidian.Obsidian
flatpak install flathub com.bitwarden.desktop
flatpak install flathub com.google.Chrome
flatpak install flathub org.chromium.Chromium
flatpak install flathub com.github.micahflee.torbrowser-launcher
flatpak install flathub com.getpostman.Postman
flatpak install flathub org.signal.Signal
flatpak install flathub io.gitlab.librewolf-community
flatpak install flathub org.octave.Octave
flatpak install flathub us.zoom.Zoom

echo "Installing plugins for playing movies and music"
sudo dnf install \
    gstreamer1-plugins-{bad-\*,good-\*,base} \
    gstreamer1-plugin-openh264 gstreamer1-libav \
    --exclude=gstreamer1-plugins-bad-free-devel

sudo dnf install lame\* --exclude=lame-devel

sudo dnf group upgrade --with-optional Multimedia

echo "Installing Sublime Text"
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
sudo dnf install sublime-text

# echo "Installing extesions" sevlitä ja tee joskus

echo "Installing Miniconda"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash ~/Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/.miniconda

eval "$($HOME/.miniconda/bin/conda shell.zsh hook)"
conda init

echo "Downloading fonts"
#cd ~/Downloads/
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Iosevka.zip

echo "Installing the font" # Ja tästä pitäisi saada robustimpi
unzip $FONTNAME.zip -d $FONTNAME
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

# Shortcuts:
for i in {1..6}
do
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Super><Shift>$i']"
    gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"
done

echo "Setting keybinds for AltGr + HJKL"
xmodmap -e "keycode 92 = Mode_switch" # setting AltGr as the "Mode_switch"
xmodmap -e "keycode 43 = h H h H Left Left" # h
xmodmap -e "keycode 44 = j J j J Down Down" # j
xmodmap -e "keycode 45 = k K k K Up Up" # k
xmodmap -e "keycode 46 = l L l L Right Right" # l

echo "Installing Oh-My-Zsh"

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "Fetching dotfiles"
alias config='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'
echo ".dots" >> .gitignore
git clone --bare git@github.com:ohtohalla/linux_dots.git $HOME/.dots
alias config='/usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME'
config checkout

echo "Installing VimPlug"

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
echo "Getting Neovim config"
mkdir -p ~/.config/nvim
git clone https://github.com/ohtohalla/nvim-lsp-config/ ~/.config/nvim
       
echo "Installing plugins"
nvim '+PlugInstall | qa'
nvim '+PlugUpdate | qa'

echo "Installing Nvidia drivers"

if [ $NVIDIA -gt 0 ]
then
  dnf upgrade --refresh
  if [ $FEDORA -gt 0 ]
  then
    dnf install akmod-nvidia # rhel/centos users can use kmod-nvidia instead
    dnf install xorg-x11-drv-nvidia-cuda #optional for cuda/nvdec/nvenc support
  elif [ $CENTOS -gt 0 ]
  then
    dnf install kmod-nvidia # rhel/centos users can use kmod-nvidia instead
    dnf install xorg-x11-drv-nvidia-cuda #optional for cuda/nvdec/nvenc support 
  fi
fi

echo "Set zsh as default"

usermod --shell /bin/zsh juhokajava
