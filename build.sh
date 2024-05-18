#!/bin/sh

build()
{
    if [ $# -lt 1 ]; then
        return
    fi

    DIR=build/$1
    DEST_DIR=../../unity/Library/$1/
    BUILD_ARGS="-DOPUS_BUILD_SHARED_LIBRARY=ON"
    FILE_LIST="Release/opus.dll libopus.so"

    if [ "$2" != "" ]; then
	BUILD_ARGS="${BUILD_ARGS} -A $2"
    fi

    mkdir -p $DIR
    cd $DIR
    cmake ../../libopus $BUILD_ARGS
    cmake --build . --config Release

    for file in $FILE_LIST; do
        test -f "$file" && cp "$file" $DEST_DIR
    done
    cd ../../
}

build_android()
{
    if [ "$ANDROID_SDK_ROOT" = "" ]; then
        echo "Android SDK is not found, skip android build."
        return
    fi

    FILE_NAME="libopus/build/outputs/aar/libopus-release.aar"

    cd android
    if [ -x "$(command -v gradle)" ]; then
        gradle build
    else
        ./gradlew build
    fi
    test -f $FILE_NAME && cp $FILE_NAME ../unity/Library/android/
}

OS=`uname -o`
echo "OS: $OS"

if [ "$OS" = "GNU/Linux" ]; then
    build linux
fi

if [ "$OS" = "Msys" ]; then
    build win-x86 Win32
    build win-x64 x64
fi

build_android

