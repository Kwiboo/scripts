## scripts and snippets

### labgrid

```
LABGRID_PATH=/home/labgrid
sudo mkdir -p $LABGRID_PATH
sudo chown $USER: $LABGRID_PATH
pushd $LABGRID_PATH
python3 -m venv .
bin/pip install git+https://github.com/Kwiboo/labgrid.git@rockchip --upgrade --upgrade-strategy eager
popd
```

### .bash_aliases

```
PATH="$PATH:~/scripts"
```

### bash-completion

```
mkdir -p ~/.local/share/bash-completion/completions
pushd ~/.local/share/bash-completion/completions
ln -s ~/scripts/bash-completion/labgrid.sh
ln -s ~/scripts/bash-completion/u-boot.sh
popd
```

### packages

```
sudo apt install confget mtools
```

### u-boot

```
pushd board/rockchip
ln -s ~/scripts/u-boot/board/rockchip/rockchip-pxeboot.config
ln -s ~/scripts/u-boot/board/rockchip/rockchip-usbpxeboot.config
popd
```
