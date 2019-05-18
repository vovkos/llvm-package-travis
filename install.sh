#!/bin/bash

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

case "$BUILD_PROJECT" in
"llvm")
	# download and unpack LLVM sources

	wget --quiet $LLVM_SRC_URL
	mkdir -p llvm
	tar --strip-components=1 -xf $LLVM_SRC_TAR -C llvm

	# on Debug builds patch llvm-config/CMakeLists.txt to always build and install llvm-config

	if [ $BUILD_CONFIGURATION == "Debug" ]; then
		echo "set_target_properties(llvm-config PROPERTIES EXCLUDE_FROM_ALL FALSE)" >> llvm/tools/llvm-config/CMakeLists.txt
		echo "install(TARGETS llvm-config RUNTIME DESTINATION bin)" >> llvm/tools/llvm-config/CMakeLists.txt
	fi
	;;

"clang")
	# download and unpack Clang sources

	wget --quiet $CLANG_SRC_URL
	mkdir -p clang
	tar --strip-components=1 -xf $CLANG_SRC_TAR -C clang

	# download and unpack LLVM release package from llvm-package-travis

	wget --quiet $LLVM_RELEASE_URL
	mkdir -p llvm
	tar -xf $LLVM_RELEASE_TAR -C llvm
	;;

*)
	echo "Invalid project $BUILD_PROJECT (must be 'llvm' or 'clang')"
	exit -1
esac

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

# if it's not the prehistoric ubuntu, we are done with install

if [ $TRAVIS_OS_NAME != "linux" ]; then
	return
fi

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

# manually install CMake -- we need at least CMake 3.4.3

CMAKE_VERSION=3.4.3
CMAKE_VERSION_DIR=v3.4
CMAKE_OS=Linux-x86_64
CMAKE_TAR=cmake-$CMAKE_VERSION-$CMAKE_OS.tar.gz
CMAKE_URL=http://www.cmake.org/files/$CMAKE_VERSION_DIR/$CMAKE_TAR
CMAKE_DIR=$(pwd)/cmake-$CMAKE_VERSION

wget --quiet $CMAKE_URL
mkdir -p $CMAKE_DIR
tar --strip-components=1 -xzf $CMAKE_TAR -C $CMAKE_DIR
export PATH=$CMAKE_DIR/bin:$PATH

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

# now to official APT packages

if [ "$TARGET_CPU" == "x86" ]; then
	sudo dpkg --add-architecture i386
	sudo apt-get -qq update
	sudo apt-get install -y g++-multilib
fi
