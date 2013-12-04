#!/usr/bin/env bash -e

cd "$(dirname $0)"
SCRIPT_PATH="$(pwd)"

export CC=cc
export CXX=c++

if [ ! -d "$SCRIPT_PATH/mruby" ] ; then
    git clone --depth 1 "https://github.com/mruby/mruby.git"
fi

export LIBUV_VERSION=0.10.19

if [ ! -d "$SCRIPT_PATH/libuv-v$LIBUV_VERSION" ] ; then
    wget --continue http://libuv.org/dist/v0.10.19/libuv-v$LIBUV_VERSION.tar.gz
    tar xf libuv-v$LIBUV_VERSION.tar.gz
    cd libuv-v$LIBUV_VERSION
    make libuv.a
    cd $SCRIPT_PATH
fi

export LDFLAGS="-L$SCRIPT_PATH/libuv-v$LIBUV_VERSION"
if [ `uname` == "Darwin" ] ; then
    export LDFLAGS="$LDFLAGS -framework CoreFoundation -framework CoreServices"
fi

CFLAGS="-I$SCRIPT_PATH/libuv-v$LIBUV_VERSION/include" \
    MRUBY_CONFIG="$SCRIPT_PATH/build_config.rb" \
    make -C "$SCRIPT_PATH/mruby" $@

"$SCRIPT_PATH/mruby/bin/mruby" "$SCRIPT_PATH/server.rb"
