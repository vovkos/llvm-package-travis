#!/bin/bash
set -e

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

case "$BUILD_PROJECT" in
"llvm")
	# download and unpack LLVM sources

	wget $LLVM_SRC_URL
	mkdir -p llvm
	tar --strip-components=1 -xf $LLVM_SRC_TAR -C llvm

	# on Debug builds patch llvm-config/CMakeLists.txt to always build and install llvm-config

	if [ $BUILD_CONFIGURATION == "Debug" ]; then
		echo "set_target_properties(llvm-config PROPERTIES EXCLUDE_FROM_ALL FALSE)" >> llvm/tools/llvm-config/CMakeLists.txt
		echo "install(TARGETS llvm-config RUNTIME DESTINATION bin)" >> llvm/tools/llvm-config/CMakeLists.txt
	fi

	# patch YAMLTraits.h in llvm-3.5.0 .. llvm-3.9.1 as to avoid
	# 'undefined reference' with Debug builds on Clang-7

	if [[ $TRAVIS_DIST == "xenial" && $CC == "clang" && \
		  $LLVM_VERSION > "3.4.9" && $LLVM_VERSION < "4.0.0" ]]; then
		perl yaml-patch.pl llvm/include/llvm/Support/YAMLTraits.h
	fi
	;;

"clang")
	# download and unpack Clang sources

	wget $CLANG_SRC_URL
	mkdir -p clang
	tar --strip-components=1 -xf $CLANG_SRC_TAR -C clang

	# download and unpack LLVM release package from llvm-package-travis

	wget $LLVM_RELEASE_URL
	tar -xf $LLVM_RELEASE_TAR
	;;
esac

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

# multilib for x86 (Linux only)

if [[ $TARGET_CPU == "x86" ]]; then
	sudo dpkg --add-architecture i386
	sudo apt-get -qq update
	sudo apt-get install -y g++-multilib
fi

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

# if it's not the prehistoric 14.04 Trusty Tahr, we are done with install

if [[ $TRAVIS_OS_NAME != "linux" || $TRAVIS_DIST != "trusty" ]]; then
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

wget $CMAKE_URL
mkdir -p $CMAKE_DIR
tar --strip-components=1 -xzf $CMAKE_TAR -C $CMAKE_DIR
export PATH=$CMAKE_DIR/bin:$PATH

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
