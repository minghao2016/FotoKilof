#!/bin/sh
# Variables:
# common
CWD=`pwd`
DIST=dist
NAME="fotokilof"
VER="3.1" 
OS=`echo $0 | sed 's/^..//g'`
OSVER="x86_64"

# pyinstaller
UPX="--upx-dir=upx"
UPX="--noupx"
ONEFILE="--onefile"
ONEFILE=""

# zipping
ZIPFILE=$NAME-$VER-$OS-$OSVER.zip
EXCLUDE="-x $FILES/locale/*/*/*.po -x $FILES/locale/fotokilof.pot -x $FILES/doc/*/*md"


echo "= PyInstaller ===================="
cd ..
echo "UPX: " $UPX
echo "ONEFILE: " $ONEFILE

echo "= Remove working directories ===================="
for DIR in "__pycache__" "build" $DIST/$NAME; do
    if [ -d $DIR ]; then
	echo "remove: $DIR"
	rm -rf $DIR
    fi
done

pyinstaller --clean $ONEFILE $UPX src/fotokilof.py
rm -rf build
cd $CWD

cd ../$DIST
if [ -d $NAME ]; then
    echo "= Packing ===================="
    echo "ZIPFILE: " $ZIPFILE
    echo "Exclude: " $EXCLUDE
    
    cd $NAME
    ln -s ../../src/locale locale
    ln -s ../../doc doc
    ln -s ../../LICENSE LICENSE
    cd ..
    
    if [ -e $ZIPFILE ]; then
	echo "Remove old zip file"
	rm $ZIPFILE
    fi
    
    zip -r $ZIPFILE $NAME $EXCLUDE
    echo "= Done: = $ZIPFILE ===================="
else
    echo "= Something went wrong... ===================="
fi

# remove spec file
if [ -e ../$NAME.spec ]; then
    rm ../$NAME.spec
fi
cd $CWD

# EOF