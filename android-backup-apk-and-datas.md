# Backup android app, data included, no root needed, with adb

`adb` is the Android CLI tool with which you can interact with your android device, from your PC

You must enable developer mode (tap 7 times on the build version in parameters) and install adb on your PC.

## Fetch application APK

To get the list of your installed applications:

```
adb shell pm list packages -f -3
```

If you want to fetch all apk of your installed apps:

```
for APP in $(adb shell pm list packages -3 -f)
do
  adb pull $( echo ${APP} | sed "s/^package://" | sed "s/base.apk=/base.apk /").apk
done
```

To fetch only one application, based of listed packages results:

```
adb pull /data/app/org.fedorahosted.freeotp-Rbf2NWw6F-SqSKD7fZ_voQ==/base.apk freeotp.apk
```

## Backup applications datas

To backup one application, with its apk:

```
adb backup -f freeotp.adb -apk org.fedorahosted.freeotp
```

To backup all datas at once:

```
adb backup -f all -all -apk -nosystem
```

To backup all datas in separated files:

```
for APP in $(adb shell pm list packages -3)
do
  APP=$( echo ${APP} | sed "s/^package://")
  adb backup -f ${APP}.backup ${APP}
done
```

## Restore Applications

First, you have to install the saved apk with adb:

```
adb install application.apk
```

Then restore the datas:

```
adb restore application.backup
```

## Extract content of adb backup file


You will need the `zlib-flate` binary. You will able to use it by installing the `qpdf` package.

```
apt install qpdf
```

Then, to extract your application backup:

```
dd if=freeotp.adb bs=24 skip=1 | zlib-flate -uncompress | tar xf -
```

## Miscellaneous: remove non-wanted applications

Sometimes, you have already installed (but non wanted) apps when you buy an Android Smartphone. And you can't uninstall these apps. So Bad. And some pre-installed app are not present on PlayStore. WTF.

You can remove them with this command, and root is not needed:

```
adb shell pm uninstall --user 0 non.wanted.app
```

You can first disable them, then when you are sure, you can remove them.

To list disabled apps:

```
adb shell pm list packages -d
```

Example:

```
# Google Chrome
adb shell pm uninstall --user 0 com.android.chrome
# Gmail
adb shell pm uninstall --user 0 com.google.android.gm
# Google Play Films et S??ries
adb shell pm uninstall --user 0 com.google.android.videos
# Youtube
adb shell pm uninstall --user 0 com.google.android.youtube
# Google Play Music
adb shell pm uninstall --user 0 com.google.android.music
# Google Hangouts
adb shell pm uninstall --user 0 com.google.android.talk
# Google Keep
adb shell pm uninstall --user 0 com.google.android.keep
# Google Drive
adb shell pm uninstall --user 0 com.google.android.apps.docs
# Google Photos
adb shell pm uninstall --user 0 com.google.android.apps.photos
# Google Cloud Print
adb shell pm uninstall --user 0 com.google.android.apps.cloudprint
# Google Actualit??s et m??t??os
adb shell pm uninstall --user 0 com.google.android.apps.genie.geniewidget
# Application Google
adb shell pm uninstall --user 0 com.google.android.googlequicksearchbox
```

## Resources

https://stackoverflow.com/questions/4032960/how-do-i-get-an-apk-file-from-an-android-device
https://androidquest.wordpress.com/2014/09/18/backup-applications-on-android-phone-with-adb/
https://stackoverflow.com/questions/34482042/adb-backup-does-not-work
https://stackoverflow.com/questions/53634246/android-get-all-installed-packages-using-adb
https://www.dadall.info/article657/nettoyer-android
https://etienne.depar.is/a-ecrit/Desinstaller-des-applications-systemes-d-android/index.html