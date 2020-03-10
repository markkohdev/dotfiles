!#/bin/bash

SCRIPT_DIR="$(dirname $(realpath $0))"

if [ ! -z $(which brew) ]; then
  brew bundle --file $SCRIPT_DIR/Brewfile
else
  echo "Brew installation not found.  Skipping Brewfile installation."
  echo "To install brew, see https://brew.sh/"
fi

if [ ! -z $(which pip) ]; then
  pip install -r $SCRIPT_DIR/requirements.txt
else
    echo "Pip installation not found.  Skipping pip installation."
fi
