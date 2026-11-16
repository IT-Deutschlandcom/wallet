#!/bin/sh
# Baut ivy-wallet.apk (Tools: aapt, dx, apksigner, android.jar)
set -e
cd "$(dirname "$0")"
JAR=/usr/lib/android-sdk/platforms/android-23/android.jar
rm -rf build && mkdir -p build/classes
aapt package -f -M app/AndroidManifest.xml -S app/res -A app/assets -I $JAR -F build/base.apk
javac --release 8 -cp $JAR -d build/classes app/src/de/ivy/wallet/*.java
dalvik-exchange --dex --output=build/classes.dex build/classes
(cd build && aapt add base.apk classes.dex >/dev/null)
zipalign -f 4 build/base.apk build/aligned.apk
[ -f ivy.keystore ] || keytool -genkeypair -keystore ivy.keystore -alias ivy -keyalg RSA -keysize 2048 -validity 10000 -storepass ivypass -keypass ivypass -dname "CN=Ivy Wallet"
apksigner sign --ks ivy.keystore --ks-pass pass:ivypass --out ivy-wallet.apk build/aligned.apk
apksigner verify ivy-wallet.apk && echo OK
