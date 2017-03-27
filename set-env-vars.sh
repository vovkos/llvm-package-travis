LLVM_VERSION=3.7.1
LLVM_TAR=llvm-$LLVM_VERSION.src.tar.xz
LLVM_URL=http://releases.llvm.org/$LLVM_VERSION/$LLVM_TAR

if [ $TRAVIS_OS_NAME == "osx" ]; then
	CPU_SUFFIX=
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

LLVM_RELEASE_NAME=llvm-$LLVM_VERSION-$TRAVIS_OS_NAME$CPU_SUFFIX-$CC$DEBUG_SUFFIX
LLVM_RELEASE_DIR=$LLVM_RELEASE_NAME
LLVM_RELEASE_FILE=$LLVM_RELEASE_NAME.tar.xz
