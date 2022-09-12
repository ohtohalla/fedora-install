# Fedora clean install

Run first 
```
sudo dnf install git git-credential-libsecret
git config --global credential.helper /usr/libexec/git-core/git-credential-libsecret
```
Then 
```git clone https://github.com/ohtohalla/fedora-install.git```

And finally make the install.sh executable and run it

Afterwards you need to:

* Theme the install
* Install Iosevka fonts
* Install Nvidia drivers if needed
* Install Anaconda
* Install flathub and flatpak apps

