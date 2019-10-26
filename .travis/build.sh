#!/bin/bash

function build_linux()
{
    ./autogen.sh
    ./configure ${HOST+--host=$HOST} ${CONFIGURE_OPTIONS}
    make
    make dist
    make check RUNTESTFLAGS="-a $RUNTESTFLAGS"
    EXITCODE=$?

    gzip -c -9 */testsuite/libffi.log > libffi.log.gz
    echo ================================================================
    echo The logs are too long for travis to handle, so we compress and
    echo uuencode them.  Download, decode and uncompress if you need to
    echo read them.  For example, if you select and save this text
    echo as libffi.uu, run: 'cat libffi.uu | uudecode | gzip -d | less'.
    echo ================================================================
    uuencode libffi.log.gz -
    echo ================================================================
    echo ================================================================

    exit $EXITCODE
}

function build_foreign_linux()
{
    docker run --rm -t -i -v `pwd`:/opt --rm -ti -e LIBFFI_TEST_OPTIMIZATION="${LIBFFI_TEST_OPTIMIZATION}" $2 bash -c /opt/.travis/build-in-container.sh
    exit $?
}

function build_ios()
{
    which python
# export PYTHON_BIN=/usr/local/bin/python
    ./generate-darwin-source-and-headers.py
    xcodebuild -showsdks
    xcodebuild -project libffi.xcodeproj -target "libffi-iOS" -configuration Release -sdk iphoneos11.4
    exit $?
}

./autogen.sh
case "$HOST" in
    arm-apple-darwin*)
	build_ios
	;;
    arm32v7-linux-gnu)
        build_foreign_linux arm moxielogic/arm32v7-ci-build-container:latest 
	;;
    aarch64-linux-gnu)
        build_foreign_linux aarch64 moxielogic/aarch64-ci-build-container:latest 
	;;
    ppc64le-linux-gnu)
        build_foreign_linux ppc64le moxielogic/ppc64le-ci-build-container:latest 
	;;
    s390x-linux-gnu)
	build_foreign_linux s390x s390x/ubuntu
	;;
    *)
	build_linux
	;;
esac