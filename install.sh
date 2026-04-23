SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
sudo mkdir /opt/robohead-cli
sudo touch /opt/robohead-cli/robohead
sudo cp $SCRIPT_DIR/source/robohead /opt/robohead-cli/robohead
sudo chmod +x /opt/robohead-cli/robohead

sudo ln -s /opt/robohead-cli/robohead /usr/local/bin/robohead