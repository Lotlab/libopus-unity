#!/bin/sh

function build() {
    if [ $# -lt 2 ]; then
        return
    fi

    DIR=build/$1
    pushd .
    mkdir -p $DIR
    cd $DIR
    cmake ../../libopus -A $2 -DOPUS_BUILD_SHARED_LIBRARY=ON
    cmake --build . --config Release
    popd
}

build win32 Win32
build win64 x64
