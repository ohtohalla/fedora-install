# Fedora/CentOS Workstation initial setup

* First create a SSH-keypair with [these instructions](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

After setting SSH keys, run:

```
curl https://raw.githubusercontent.com/ohtohalla/fedora-install/main/install.sh --output install.sh
chmod +x install.sh
./install.sh
```

You can then manage your dotfiles with the ```config``` command (and it works like git)


After the initial setup you need to:

* Theme the install (optional)
* Install Iosevka fonts manually after the initial setup (optional)
