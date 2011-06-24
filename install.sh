#/bin/sh

CURRENT=`pwd`

ZSH=~/.zsh
ZSHRC=~/.zshrc

if [ -d $ZSH ]; then
  echo "Directory $ZSH already exists, backing up to $ZSH.bak..."
  if [ -d $ZSH.bak ]; then
    echo "$ZSH.bak already exists, aborting installation..."
    exit 1
  fi
  mv  $ZSH $ZSH.bak
fi

if [ -f $ZSHRC ]; then
  echo "Directory $ZSHRC already exists, backing up to $ZSHRC.bak..."
  if [ -f $ZSHRC.bak ]; then
    echo "$ZSHRC.bak already exists, aborting installation..."
    exit 1
  fi
  mv  $ZSHRC $ZSHRC.bak
fi

ln -s $CURRENT/zsh ~/.zsh
ln -s $CURRENT/zshrc ~/.zshrc

echo "zsh config successfully installed."

