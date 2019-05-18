#!/bin/bash

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

case $BUILD_PROJECT in
"llvm")
	echo LLVM_CMAKE_FLAGS=$LLVM_CMAKE_FLAGS
	echo LLVM_CPU_COUNT=$LLVM_CPU_COUNT

	mkdir llvm/build
	pushd llvm/build
	cmake .. $LLVM_CMAKE_FLAGS
	make -j $LLVM_CPU_COUNT
	make install
	popd

	travis_wait tar --${TAR_COMPRESSION} -cvf $LLVM_RELEASE_TAR $LLVM_RELEASE_NAME
	;;

"clang")
	echo CLANG_CMAKE_FLAGS=$CLANG_CMAKE_FLAGS
	echo CLANG_CPU_COUNT=$CLANG_CPU_COUNT

	mkdir clang/build
	pushd clang/build
	cmake .. $CLANG_CMAKE_FLAGS
	make -j $CLANG_CPU_COUNT
	make install
	popd

	travis_wait tar --${TAR_COMPRESSION} -cvf $CLANG_RELEASE_TAR $CLANG_RELEASE_NAME
	;;
esac

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
