#/bin/bash
NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
MAX=9

COINNAME=BOXY
COINGITHUB=https://github.com/boxycoin/boxycoinv3.1.git
COINGITFOLDER=boxycoinv3.1
COINPORT=121523
COINRPCPORT=121528
COINDAEMON=boxyd
COINCORE=.boxy
COINCONFIG=boxy.conf
COINCONFIGSRC="https://bootstrap.boxyco.in/boxy.conf"
BOOTSTRAP="https://bootstrap.boxyco.in/bootstrap.dat"
SWAPSIZE=3000
UBUNTUVERSION=16.04

checkForUbuntuVersion() {
   echo "[1/${MAX}] Checking Ubuntu version..."
   sleep 3
    if [[ `cat /etc/issue.net`  == *$UBUNTUVERSION* ]]; then
        echo -e "${GREEN}* You are running `cat /etc/issue.net` . Setup will continue.${NONE}";
    else
        echo -e "${RED}* You are not running Ubuntu 16.04.X. You are running `cat /etc/issue.net` ${NONE}";
        echo && echo "Installation cancelled" && echo;
        exit;
    fi
}

changeSsh() {
    echo
    echo "[2/${MAX}] Setting SSH session to stay alive. Please wait..."
    sleep 3
    echo >> /etc/ssh/sshd_config
    echo "#Keep SSH Alive" >> /etc/ssh/sshd_config
    echo "ClientAliveInterval 600" >> /etc/ssh/sshd_config
    echo "TCPKeepAlive yes" >> /etc/ssh/sshd_config
    echo "ClientAliveCountMax 10" >> /etc/ssh/sshd_config
    service ssh restart > /dev/nul 2>&1
    echo -e "${GREEN}* Done${NONE}";
}

updateAndUpgrade() {
    echo
    echo "[3/${MAX}] Running update and upgrade. Please wait..."
    sleep 3
    sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq -y > /dev/null 2>&1
    sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq > /dev/null 2>&1
    echo -e "${GREEN}* Done${NONE}";
}

installFirewall() {
    echo
    echo -e "[4/${MAX}] Installing UFW. Please wait..."
    sleep 3
    sudo apt-get -y install ufw > /dev/null 2>&1
    sudo ufw default deny incoming > /dev/null 2>&1
    sudo ufw default allow outgoing > /dev/null 2>&1
    sudo ufw allow ssh > /dev/null 2>&1
    sudo ufw limit ssh/tcp > /dev/null 2>&1
    sudo ufw allow $COINPORT/tcp > /dev/null 2>&1
    sudo ufw allow $COINRPCPORT/tcp > /dev/null 2>&1
    sudo ufw logging on > /dev/null 2>&1
    echo "y" | sudo ufw enable > /dev/null 2>&1
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

installSwap() {
    echo
    echo -e "[5/${MAX}] Installing SwapFile. Please wait..."
    sleep 3
    sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=$SWAPSIZE > /dev/null 2>&1
    sudo mkswap /var/swap.img > /dev/null 2>&1
    sudo swapon /var/swap.img > /dev/null 2>&1
    sudo chmod 0600 /var/swap.img > /dev/null 2>&1
    sudo chown root:root /var/swap.img > /dev/null 2>&1
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

installDependencies() {
    echo
    echo -e "[6/${MAX}] Installing dependencies. Please wait..."
    sleep 3
    sudo apt-get install -y build-essential libtool autotools-dev pkg-config libssl-dev libboost-all-dev autoconf automake -qq -y > /dev/null 2>&1
    sudo apt-get install libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev -qq -y > /dev/null 2>&1
    sudo apt-get install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev -qq -y > /dev/null 2>&1
    sudo apt-get install libboost-all-dev -qq -y > /dev/null 2>&1
    sudo apt-get install libgmp-dev -qq -y > /dev/null 2>&1
    sudo apt-get install openssl -qq -y > /dev/null 2>&1
    sudo apt-get install software-properties-common -qq -y > /dev/null 2>&1
    sudo add-apt-repository ppa:bitcoin/bitcoin -y > /dev/null 2>&1
    sudo apt-get update -qq -y > /dev/null 2>&1
    sudo apt-get install libdb4.8-dev libdb4.8++-dev -qq -y > /dev/null 2>&1
    sudo apt-get install libgmp3-dev -y > /dev/null 2>&1
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

installWallet() {
    echo
    echo -e "[7/${MAX}] Installing wallet. Please wait, you can take your dog for a walk, this may take 20-30 min"
    sleep 3
    git clone $COINGITHUB > /dev/null 2>&1
    cd ~/$COINGITFOLDER/src/leveldb > /dev/null 2>&1
    wget https://github.com/google/leveldb/archive/v1.18.tar.gz > /dev/null 2>&1
    tar xfv v1.18.tar.gz > /dev/null 2>&1
    cp leveldb-1.18/Makefile ~/$COINGITFOLDER/src/leveldb/ > /dev/null 2>&1
    chmod +x build_detect_platform > /dev/null 2>&1
    cd > /dev/null 2>&1
    cd ~/$COINGITFOLDER/src > /dev/null 2>&1
    sudo make -f makefile.unix USE_UPNP=- > /dev/null 2>&1
    chmod 755 $COINDAEMON > /dev/null 2>&1
    strip $COINDAEMON > /dev/null 2>&1
    sudo mv /usr/bin/$COINDAEMON /usr/bin/backup_$COINDAEMON > /dev/null 2>&1
    sudo mv $COINDAEMON /usr/bin > /dev/null 2>&1
    cd > /dev/null 2>&1
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

startWallet() {
    echo
    echo -e "[8/${MAX}] Starting wallet daemon..."
    sleep 3
    sudo mkdir ~/$COINCORE > /dev/null 2>&1
    cd ~/$COINCORE > /dev/null 2>&1
    sudo rm governance.dat > /dev/null 2>&1
    sudo rm netfulfilled.dat > /dev/null 2>&1
    sudo rm peers.dat > /dev/null 2>&1
    sudo rm -r blocks > /dev/null 2>&1
    sudo rm mncache.dat > /dev/null 2>&1
    sudo rm -r chainstate > /dev/null 2>&1
    sudo rm fee_estimates.dat > /dev/null 2>&1
    sudo rm mnpayments.dat > /dev/null 2>&1
    sudo rm banlist.dat > /dev/null 2>&1
    sudo mv $COINCONFIG backup_$COINCONFIG > /dev/null 2>&1
    wget $COINCONFIGSRC > /dev/null 2>&1
    wget $BOOTSTRAP > /dev/null 2>&1
    echo -e "${NONE}${GREEN}* Add your RPC Username and Password and save. Press "control x" after "y" and "enter". Wait a few seconds, now the editor will open. ${NONE}";
    sleep 5 
    nano $COINCONFIG
    cd > /dev/null 2>&1
    $COINDAEMON -daemon > /dev/null 2>&1
    cd ~ > /dev/null 2>&1
    echo -e "${GREEN}* Done${NONE}";
}

syncWallet() {
    echo
    echo "[9/${MAX}] Waiting for wallet to sync.";
    sleep 3
    echo -e "${GREEN}* Displaying command "boxyd getinfo"${NONE}";
    $COINDAEMON getinfo
}

clear
cd

echo
echo -e "-----------------------------------------------------------------------------"
echo -e "|                                                                           |"
echo -e "|           ${BOLD}----- $COINNAME Ubuntu Install script -----${NONE}                          |"
echo -e "|                                                                           |"
echo -e "|           ${CYAN} __________ ________  ____  ________.___.${NONE}                       |"
echo -e "|           ${CYAN} \______   \|_____  \ \   \/  /\__  |   |${NONE}                       |"                   
echo -e "|           ${CYAN}  |    |  _/ /   |   \ \     /  /   |   |${NONE}                       |"
echo -e "|           ${CYAN}  |    |   \/    |    \/     \  \____   |${NONE}                       |"
echo -e "|           ${CYAN}  |______  /\_______  /___/\  \ / ______|${NONE}                       |"
echo -e "|           ${CYAN}         \/         \/      \_/ \/       ${NONE}                       |"
echo -e "|                                                                           |"
echo -e "-----------------------------------------------------------------------------"

echo -e "${BOLD}"
read -p "This script will setup your$COINNAME Ubuntu $UBUNTUVERSION Wallet (CommandLine Only). Do you wish to continue? (y/n)? " response
echo -e "${NONE}"

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    checkForUbuntuVersion
    changeSsh
    updateAndUpgrade
    installFirewall
    installSwap
    installDependencies
    installWallet
    startWallet
    syncWallet

    echo
    echo -e "${BOLD}Your BOXY Coin Wallet is Installed${NONE}".
    echo -e "${BOLD}Happy STAKING!!!${NONE}".
    echo 
    echo -e "${CYAN}Script By SoyBtc - Modified by github.com/boyroywax${NONE}".
    echo
    else
    echo && echo "Installation cancelled" && echo
fi
