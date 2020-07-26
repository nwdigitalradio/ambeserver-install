# ambeserver-install
Files, scripts and documentation for installing AMBEserver

From the command line in a terminal:

apt-get install git

cd

git clone https://github.com/nwdigitalradio/ambeserver-install.git

cd ambeserver-install

sudo chmod +x install.sh

sudo ./install.sh

# If your AMBEserver doesn't start, try removing and replacing the ThumbDV™, check for /dev/ThumbDV and then do a
# sudo systemctl restart ambeserver@ThumbDV
