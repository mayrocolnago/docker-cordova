#!/bin/bash

export PROJECTPATH="$(pwd)"

if [ ! -d "$PROJECTPATH/platforms/android" ]; then
echo "Adding android platform... ^ @8"
cordova platform add android@8
fi
if [ ! -d "$PROJECTPATH/platforms/android" ]; then
echo "Buildable android platform not found."
exit 1
fi
echo "Executing cordova release tool..."
echo "Building unsigned apk file..."
cordova build android --release
TEMPBUILDFILE="$PROJECTPATH/platforms/android/app/build/outputs/apk/release"
if [ ! -f "$TEMPBUILDFILE/app-release-unsigned.apk" ]; then
echo " "
echo "Error on build release version"
echo "Please check the errors within the log"
echo " "
echo "Release build process failed."
echo " "
else

KEYALIAS="project"
echo "Searching for keyalias on the repository..."
if test -n "$(find $PROJECTPATH -maxdepth 1 -name '*.keyalias' -print -quit)"; then 
    echo "Keyalias found on the repository."
    find "$PROJECTPATH" -maxdepth 1 -type f -name '*.keyalias' -print0 | xargs -0 -I {} cp -r {} "./temprepkeyalias"
    KEYALIAS=$(<./temprepkeyalias)
    rm -r ./temprepkeyalias > /dev/null 2>/dev/null
else
    echo "Keyalias not found. using default: $KEYALIAS."
fi

echo "Searching for a keystore pair chain..."
if test -n "$(find $PROJECTPATH -maxdepth 1 -name '*.keystore' -print -quit)"; then 
    echo "Keystore found on the repository."
    mkdir -p /resources > /dev/null 2>/dev/null
    rm -r "/resources/$KEYALIAS.keystore" > /dev/null 2>/dev/null
    find "$PROJECTPATH" -maxdepth 1 -type f -name '*.keystore' -print0 | xargs -0 -I {} cp -r {} "/resources/$KEYALIAS.keystore"
    echo "Keystore file has been backuped."
else
    echo "Generating new certification key..."
    keytool -genkey -dname "CN=$KEYALIAS, OU=Internet, O=$KEYALIAS, L=SP, S=SP, C=BR" -v -keystore "/resources/$KEYALIAS.keystore" -alias $KEYALIAS -storepass 111570 -keyalg RSA -keysize 2048 -validity 10000
    echo "Saving new keystore pair..."
    cp -r "/resources/$KEYALIAS.keystore" "./$KEYALIAS.keystore"
fi
echo "Signing apk with jarsigner..."
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -storepass slockz -keystore "/resources/$KEYALIAS.keystore" $TEMPBUILDFILE/app-release-unsigned.apk $KEYALIAS
echo "Deleting old signed files..."
rm $TEMPBUILDFILE/app-release.apk > /dev/null 2>/dev/null
echo "Running zipalign on apk release..."
zipalign -v 4 $TEMPBUILDFILE/app-release-unsigned.apk $TEMPBUILDFILE/app-release.apk
echo " "
echo "Release build completed."
echo " "

if [ -f "$PROJECTPATH/app-release.apk" ]; then
  rm -r "$PROJECTPATH/app-release.apk"
fi
cp -r $TEMPBUILDFILE/app-release.apk $PROJECTPATH/app-release.apk

fi