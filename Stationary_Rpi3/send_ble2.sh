#!/bin/bash
# ref: http://www.theregister.co.uk/Print/2013/11/29/feature_diy_apple_ibeacons/
set -x
# inquiry local bluetooth device
#hcitool dev
export BLUETOOTH_DEVICE=hci0
#sudo hcitool -i hcix cmd <OGF> <OCF> <No. Significant Data Octets> <iBeacon Prefix> <UUID> <Major> <Minor> <Tx Power> <Pla

#OGF = Operation Group Field = Bluetooth Command Group = 0x08
#OCF = Operation Command Field = HCI_LE_Set_Advertising_Data = 0x0008
#No. Significant Data Octets (Max of 31) = 1E (Decimal 30)
#iBeacon Prefix (Always Fixed) = 02 01 1A 1A FF 4C 00 02 15

export OGF="0x08"
export OCF="0x0008"
export IBEACONPROFIX="1E 02 01 1A 1A FF 4C 00 02 15"

#uuidgen  could gerenate uuid
# original: export UUID="4a 4e ce 60 7e b0 11 e4 b4 a9 08 00 20 0c 9a 66"
export UUID="B9 40 7F 30 F5 F8 46 6E AF F9 25 55 6B 57 FE 6D"
#export UUID="76 E8 B4 E0 7E B5 11 E4 B4 A9 08 00 20 0C 9A 66"


while :

do

# run script to get value from sensor in hex

# set to static: sudo bash /home/pi/my_scripts/sensor2hex-file.sh

# export MAJOR="00 01"


# read sensor reding from file as string

major_val=`cat /home/pi/my_scripts/beacon_content.ibc`

# convert reading into integer

# check max values

# convert reading into hex



# set reading as major val in ibeacon
export MAJOR="$major_val"
export MINOR="00 00"

export POWER="C5 00"


# initialize device
sudo hciconfig $BLUETOOTH_DEVICE up
# disable advertising
sudo hciconfig $BLUETOOTH_DEVICE noleadv
# stop the dongle looking for other Bluetooth devices
sudo hciconfig $BLUETOOTH_DEVICE noscan

sudo hciconfig $BLUETOOTH_DEVICE pscan


sudo hciconfig $BLUETOOTH_DEVICE leadv

# advertise
sudo hcitool -i $BLUETOOTH_DEVICE cmd 0x08 0x0008 $IBEACONPROFIX $UUID $MAJOR $MINOR $POWER
sudo hcitool -i $BLUETOOTH_DEVICE cmd 0x08 0x0006 A0 00 A0 00 00 00 00 00 00 00 00 00 00 07 00
sudo hcitool -i $BLUETOOTH_DEVICE cmd 0x08 0x000a 01


now_file="/home/pi/my_scripts/logfiles/"$(date +"%Y%m%d")"_BT-sent.log"
echo "$(date);$BLUETOOTH_DEVICE;$IBEACONPROFIX;$UUID;$MAJOR;$MINOR;$POWER" >> $now_file

echo "$i"
echo "complete"

sleep 3

done

