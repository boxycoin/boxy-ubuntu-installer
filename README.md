# boxy-ubuntu-installer
Install Script for BOXY Wallet on Ubuntu 16.04.

## Script Features
* Verify Ubuntu 16.04 befor install.
* Update SSH to stay alive.
* Install Swap File (Default set to 3GB, "SWAPSIZE" variable in script.
* Install neccesary dependencies
* Apply latest bootstrap
* Copy pre-made boxy.conf file and edit with nano.

## How to run the installation script
* Start with a new install of Ubuntu 16.04. A 1CPU/1GB RAM VPS from your favorite VPS provider will work fine.
* Log into your VPS's command-line
* Type the following commands
   ```
   git clone https://github.com/boxycoin/boxy-ubuntu-installer.git
   cd boxy-ubuntu-installer/
   chmod +x install.sh
   ./install.sh
   ```
* The install script will launch validating that you are using Ubuntu 16.04.  Type "y" and hit Enter to begin the installation.
* The wallet will take around 20 minutes to compile.  After it is complete, boxy.conf will be opened in nano for you to make any changes you wish.
* Close nano by typing "control + x", saving the file by typing "y" and hitting enter.
* The wallet is now installed and running and the "boxyd getinfo" command is displayed to the screen. An example of the output is below.
   ```
      root@boxywallet:~# boxyd getinfo
   {
       "version" : "v3.1.0.0-60010",
       "protocolversion" : 60010,
       "walletversion" : 60000,
       "balance" : 44568.94308266,
       "darksend_balance" : 0.00000000,
       "newmint" : 0.00000000,
       "stake" : 151.16000000,
       "blocks" : 236770,
       "timeoffset" : -1,
       "moneysupply" : 907848.40000000,
       "connections" : 4,
       "proxy" : "",
       "ip" : "159.89.159.45",
       "difficulty" : 68324.87686923,
       "testnet" : false,
       "keypoololdest" : 1545349539,
       "keypoolsize" : 101,
       "paytxfee" : 0.00000000,
       "mininput" : 0.00000000,
       "errors" : ""
   }

## Problems or Errors:
Reports problems and errors in this github repo using the "Issues" tab.
