SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
sudo mkdir -p /opt/robohead-cli
sudo mkdir -p ~/.config/robohead
sudo cp $SCRIPT_DIR/source/robohead /opt/robohead-cli/robohead
sudo cp $SCRIPT_DIR/source/config.json ~/.config/robohead/config.json
sudo chmod +x /opt/robohead-cli/robohead

sudo ln -sf /opt/robohead-cli/robohead /usr/local/bin/robohead
