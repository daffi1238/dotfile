# Installation

```bash
pushd
cd /tmp
git clone https://github.com/daffi1238/dotfile
cd dotfile
cp .zshrc_hack ~
echo "source ~/.zshrc_hack" >> ~/.zshrc
source ~/.zshrc
popd
```

# Update
```bash
pushd
cd /tmp
git clone git@github.com:daffi1238/dotfile.git
cd dotfile
./update_repo.sh
git add
git commit -m "auto-update"
git push
popd
```
