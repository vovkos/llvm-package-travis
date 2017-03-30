LLVM_VERSION=3.5.2
LLVM_TAR=llvm-$LLVM_VERSION.src.tar.xz
LLVM_URL=http://releases.llvm.org/$LLVM_VERSION/$LLVM_TAR

CC_SUFFIX=$CC

if [ $TRAVIS_OS_NAME == "osx" ]; then
	CPU_SUFFIX=

   	# the default gcc on osx is just a front-end for LLVM
    if [ $CC == "gcc" ]; then
        CXX=g++-4.8
        CC=gcc-4.8
    fi
else
	CPU_SUFFIX=-$TARGET_CPU
fi

if [ $TARGET_CPU == "x86" ]; then
	LLVM_BUILD_32_BITS=ON
else
	LLVM_BUILD_32_BITS=OFF
fi

if [ $BUILD_CONFIGURATION == "Debug" ]; then
	DEBUG_SUFFIX=-dbg
else
	DEBUG_SUFFIX=
fi

THIS_DIR=`pwd`
LLVM_RELEASE_NAME=llvm-$LLVM_VERSION-$TRAVIS_OS_NAME$CPU_SUFFIX-$CC_SUFFIX$DEBUG_SUFFIX
LLVM_RELEASE_DIR=$THIS_DIR/$LLVM_RELEASE_NAME
LLVM_RELEASE_FILE=$LLVM_RELEASE_NAME.tar.xz

CMAKE_FLAGS=(
	-DCMAKE_INSTALL_PREFIX=$LLVM_RELEASE_DIR
	-DCMAKE_BUILD_TYPE=$BUILD_CONFIGURATION
	-DLLVM_BUILD_32_BITS=$LLVM_BUILD_32_BITS
	-DLLVM_TARGETS_TO_BUILD=X86
	-DLLVM_ENABLE_TERMINFO=OFF
	-DLLVM_ENABLE_ZLIB=OFF
	-DLLVM_INCLUDE_DOCS=OFF
	-DLLVM_INCLUDE_EXAMPLES=OFF
	-DLLVM_INCLUDE_TESTS=OFF
	-DLLVM_INCLUDE_TOOLS=OFF
	-DLLVM_INCLUDE_UTILS=OFF
	)

CMAKE_FLAGS=${CMAKE_FLAGS[*]}

