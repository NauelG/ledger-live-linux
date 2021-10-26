#!/bin/bash

echo ""
echo "=== Wellcome to Ledger Live Linux Installer ==="
echo ""

TEMP_FOLDER=/tmp/
HOME_FOLDER=/home/$USER
LEDGER_APP_NAME=ledger-live.AppImage
LEDGER_LIVE_LINK=https://download-live.ledger.com/releases/latest/download/linux
EXEC_FOLDER=$HOME_FOLDER/.local/bin
ICONS_FOLDER=$HOME_FOLDER/.local/share/icons
ICONS_LINK=https://coinzodiac.com/wp-content/uploads/2018/10/ledger-live-icon.png
APPLICATION_FILE=$HOME_FOLDER/.local/share/applications/ledger-live.desktop
APPLICATION_TEXT="[Desktop Entry]
Type=Application
Name=Ledger Live
Comment=Ledger Live
Icon=$ICONS_FOLDER/ledger-live-icon.png
Exec=$EXEC_FOLDER/$LEDGER_APP_NAME --no-sandbox
Terminal=false
Categories=crypto;wallet"


function install {
    echo "= Download Ledger Live"
    wget -q --show-progress -O $TEMP_FOLDER$LEDGER_APP_NAME $LEDGER_LIVE_LINK
    echo "... done"

    echo ""
    echo "= Making Ledger Live executable"
    chmod +x $TEMP_FOLDER$LEDGER_APP_NAME
    echo "... done"

    echo ""
    echo "= Moving Ledger Live to final destination"
    mkdir -p $EXEC_FOLDER && mv $TEMP_FOLDER$LEDGER_APP_NAME $EXEC_FOLDER/
    echo "... done"

    echo ""
    echo "= Download ledger live icon"
    wget -q --show-progress -P $ICONS_FOLDER/ $ICONS_LINK
    echo "... done"

    echo ""
    echo "= Creating launcher"
    echo "$APPLICATION_TEXT" > $APPLICATION_FILE
    echo "... done"
}

function usb {
    echo ""
    echo "= Download UDEV Rules"
    wget -q -O - https://raw.githubusercontent.com/LedgerHQ/udev-rules/master/add_udev_rules.sh | sudo bash
    install
}

while true; do
    read -p "= Do you wish to add udev rules (require sudo)? [y/n/c]  " yn
    case $yn in
        [Yy]* ) usb; break;;
        [Nn]* ) install; break;;
        [Cc]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
