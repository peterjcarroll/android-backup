#!/bin/sh

# Backup apps
for APP in $(adb shell pm list packages -3 -f)
do
  APK_PULL=$( echo ${APP} | sed "s/^package://" | sed "s/base.apk=/base.apk /")
  # echo $APK_PULL
  # APK_BACKUP=$( echo $APK_PULL | cut -f 2 -d " ")
  # echo $APK_BACKUP
  adb pull ${APK_PULL}.apk
  # adb backup -f ${APK_BACKUP}.backup ${APP}
done

# Backup all data
adb backup -f all -all -apk -nosystem

# Backup files
# This is the /sdcard folder which is really internal storage
adb exec-out "cd /sdcard && tar c * -" > sdcard.tar
# This is the /storage/0000-0000 folder which is the actual sdcard on my phone
adb exec-out "cd /storage/0000-0000 && tar c * -" > storage_0000-0000.tar
