#!/bin/bash

if [[ $TRAVIS_OS_NAME == "osx"  ]]; then
	set +e # for some reason, pushd on macos halts the script with set -e
fi

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

case "$BUILD_PROJECT" in
"llvm")
	mkdir llvm/build
	pushd llvm/build
	cmake .. $LLVM_CMAKE_FLAGS
	make -j $LLVM_CPU_COUNT
	make install
	popd

	time travis_wait 60 tar -cvJf $LLVM_RELEASE_TAR $LLVM_RELEASE_NAME
	ls -l
	xz --version
	;;

"clang")
	mkdir clang/build
	pushd clang/build
	cmake .. $CLANG_CMAKE_FLAGS
	make -j $CLANG_CPU_COUNT
	make install
	popd

	time travis_wait 90 tar -cvJf $CLANG_RELEASE_TAR $CLANG_RELEASE_NAME
	ls -l
	xz --version
	;;
esac

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
