LLVM_VERSION=8.0.0
LLVM_SRC_TAR=llvm-$LLVM_VERSION.src.tar.xz
LLVM_SRC_URL=http://releases.llvm.org/$LLVM_VERSION/$LLVM_SRC_TAR
CLANG_SRC_TAR=cfe-$LLVM_VERSION.src.tar.xz
CLANG_SRC_URL=http://releases.llvm.org/$LLVM_VERSION/$CLANG_SRC_TAR

if [ $TRAVIS_OS_NAME == "osx" ]; then
	CPU_COUNT=$(sysctl -n hw.ncpu)
	CPU_SUFFIX=
	CC_SUFFIX=
else
	CPU_COUNT=$(nproc)
	CPU_SUFFIX=-$TARGET_CPU
	CC_SUFFIX=-$CC
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

LLVM_RELEASE_NAME=llvm-$LLVM_VERSION-$TRAVIS_OS_NAME$CPU_SUFFIX$CC_SUFFIX$DEBUG_SUFFIX
LLVM_RELEASE_DIR=$THIS_DIR/$LLVM_RELEASE_NAME
LLVM_RELEASE_FILE=$LLVM_RELEASE_NAME.tar.xz

LLVM_CMAKE_FLAGS=(
	-DCMAKE_INSTALL_PREFIX=$LLVM_RELEASE_DIR
	-DCMAKE_BUILD_TYPE=$BUILD_CONFIGURATION
	-DLLVM_BUILD_32_BITS=$LLVM_BUILD_32_BITS
	-DLLVM_TARGETS_TO_BUILD=X86
	-DLLVM_ENABLE_LIBXML2=OFF
	-DLLVM_ENABLE_TERMINFO=OFF
	-DLLVM_ENABLE_ZLIB=OFF
	-DLLVM_INCLUDE_BENCHMARKS=OFF
	-DLLVM_INCLUDE_DOCS=OFF
	-DLLVM_INCLUDE_EXAMPLES=OFF
	-DLLVM_INCLUDE_GO_TESTS=OFF
	-DLLVM_INCLUDE_RUNTIMES=OFF
	-DLLVM_INCLUDE_TESTS=OFF
	-DLLVM_INCLUDE_UTILS=OFF
	-DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=ON
	)

CLANG_RELEASE_NAME=clang-$LLVM_VERSION-$TRAVIS_OS_NAME$CPU_SUFFIX$CC_SUFFIX$DEBUG_SUFFIX
CLANG_RELEASE_DIR=$THIS_DIR/$CLANG_RELEASE_NAME
CLANG_RELEASE_FILE=$CLANG_RELEASE_NAME.tar.xz

CLANG_CMAKE_FLAGS=(
	-DCMAKE_INSTALL_PREFIX=$CLANG_RELEASE_DIR
	-DCMAKE_BUILD_TYPE=$BUILD_CONFIGURATION
	-DLLVM_BUILD_32_BITS=$LLVM_BUILD_32_BITS
	-DLLVM_DIR=$THIS_DIR/llvm/build/lib/cmake/llvm
	-DLLVM_TABLEGEN_EXE=$THIS_DIR/llvm/build/bin/llvm-tblgen
	-DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=ON
	-DCLANG_INCLUDE_DOCS=OFF
	-DCLANG_INCLUDE_TESTS=OFF
	)

# don't try to build Debug tools -- executables will be huge and not really
# essential (whoever needs tools, can just download a Release build)
# also, the linker is OOM-killed sometimes thus failing the whole build.

if [ $BUILD_CONFIGURATION == "Debug" ]; then
	LLVM_CMAKE_FLAGS+=(-DLLVM_INCLUDE_TOOLS=OFF)
	CLANG_CMAKE_FLAGS+=(-DCLANG_BUILD_TOOLS=OFF)
fi

LLVM_CMAKE_FLAGS=${LLVM_CMAKE_FLAGS[*]}
CLANG_CMAKE_FLAGS=${CLANG_CMAKE_FLAGS[*]}
