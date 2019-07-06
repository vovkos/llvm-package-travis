#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

LLVM_CMAKELISTS_URL=https://raw.githubusercontent.com/llvm-mirror/llvm/master/CMakeLists.txt

if [[ $BUILD_MASTER == "true" ]]; then
	wget $LLVM_CMAKELISTS_URL
	LLVM_VERSION=$(perl print-llvm-version.pl CMakeLists.txt)
	LLVM_RELEASE_TAG=llvm-master-$TRAVIS_OS_NAME$DIST_SUFFIX
else
	LLVM_RELEASE_TAG=llvm-$LLVM_VERSION-$TRAVIS_OS_NAME$DIST_SUFFIX
fi

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

if [[ $LLVM_VERSION < "3.5.0" ]]; then
	TAR_SUFFIX=.tar.gz
else
	TAR_SUFFIX=.tar.xz
fi

LLVM_SRC_TAR=llvm-$LLVM_VERSION.src$TAR_SUFFIX
LLVM_SRC_URL=http://releases.llvm.org/$LLVM_VERSION/$LLVM_SRC_TAR
CLANG_SRC_TAR=cfe-$LLVM_VERSION.src$TAR_SUFFIX
CLANG_SRC_URL=http://releases.llvm.org/$LLVM_VERSION/$CLANG_SRC_TAR

if [ $TRAVIS_OS_NAME == "osx" ]; then
	CPU_COUNT=$(sysctl -n hw.ncpu)
	CPU_SUFFIX=
	DIST_SUFFIX=
	CC_SUFFIX=
else
	CPU_COUNT=$(nproc)
	CPU_SUFFIX=-$TARGET_CPU
	DIST_SUFFIX=-$TRAVIS_DIST
	CC_SUFFIX=-$CC
fi

if [ $TARGET_CPU == "x86" ]; then
	LLVM_BUILD_32_BITS=ON
else
	LLVM_BUILD_32_BITS=OFF
fi

DEBUG_SUFFIX=

if [ $BUILD_CONFIGURATION == "Debug" ]; then
	DEBUG_SUFFIX=-dbg
	LLVM_TARGETS=X86
else
	LLVM_TARGETS=X86;NVPTX;AMDGPU
fi

THIS_DIR=`pwd`

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

LLVM_MASTER_URL=https://github.com/llvm-mirror/llvm
LLVM_RELEASE_NAME=llvm-$LLVM_VERSION-$TRAVIS_OS_NAME$DIST_SUFFIX$CPU_SUFFIX$CC_SUFFIX$DEBUG_SUFFIX
LLVM_RELEASE_DIR=$THIS_DIR/$LLVM_RELEASE_NAME
LLVM_RELEASE_TAR=$LLVM_RELEASE_NAME.tar.xz
LLVM_RELEASE_URL=https://github.com/vovkos/llvm-package-travis/releases/download/$LLVM_RELEASE_TAG/$LLVM_RELEASE_TAR
LLVM_CPU_COUNT=$CPU_COUNT

LLVM_CMAKE_FLAGS=(
	-DCMAKE_INSTALL_PREFIX=$LLVM_RELEASE_DIR
	-DCMAKE_BUILD_TYPE=$BUILD_CONFIGURATION
	-DCMAKE_DISABLE_FIND_PACKAGE_LibXml2=TRUE
	-DLLVM_BUILD_32_BITS=$LLVM_BUILD_32_BITS
	-DLLVM_TARGETS_TO_BUILD=$LLVM_TARGETS
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

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

CLANG_MASTER_URL=https://github.com/llvm-mirror/clang
CLANG_RELEASE_NAME=clang-$LLVM_VERSION-$TRAVIS_OS_NAME$DIST_SUFFIX$CPU_SUFFIX$CC_SUFFIX$DEBUG_SUFFIX
CLANG_RELEASE_DIR=$THIS_DIR/$CLANG_RELEASE_NAME
CLANG_RELEASE_TAR=$CLANG_RELEASE_NAME.tar.xz
CLANG_CPU_COUNT=$CPU_COUNT

CLANG_CMAKE_FLAGS=(
	-DCMAKE_INSTALL_PREFIX=$CLANG_RELEASE_DIR
	-DCMAKE_BUILD_TYPE=$BUILD_CONFIGURATION
	-DCMAKE_DISABLE_FIND_PACKAGE_LibXml2=TRUE
	-DLLVM_BUILD_32_BITS=$LLVM_BUILD_32_BITS
	-DLLVM_INCLUDE_TESTS=OFF
	-DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=ON
	-DCLANG_INCLUDE_DOCS=OFF
	-DCLANG_INCLUDE_TESTS=OFF
	-DLIBCLANG_BUILD_STATIC=ON
	)

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

# add version specific settings

if [[ $LLVM_VERSION < "3.5.0" ]]; then
	LLVM_CMAKE_FLAGS+=(-DHAVE_SANITIZER_MSAN_INTERFACE_H=0)

	CLANG_CMAKE_FLAGS+=(
		-DCLANG_PATH_TO_LLVM_BUILD=$LLVM_RELEASE_DIR
		-DLLVM_MAIN_SRC_DIR=$LLVM_RELEASE_DIR
		)
elif [[ $LLVM_VERSION < "8.0.0" ]]; then
	CLANG_CMAKE_FLAGS+=(-DLLVM_CONFIG=$LLVM_RELEASE_DIR/bin/llvm-config)
else
	CLANG_CMAKE_FLAGS+=(-DLLVM_DIR=$LLVM_RELEASE_DIR/lib/cmake/llvm)
fi

# don't build Debug tools -- executables will be huge and not really
# essential (whoever needs tools, can just download a Release build);
# linking multiple shared Debug libs in parallel gets linker OOM-killed

if [ $BUILD_CONFIGURATION == "Debug" ]; then
	LLVM_CMAKE_FLAGS+=(
		-DLLVM_BUILD_TOOLS=OFF
		-DLLVM_OPTIMIZED_TABLEGEN=ON
		)

	CLANG_CMAKE_FLAGS+=(
		-DCLANG_BUILD_TOOLS=OFF
		-DCLANG_ENABLE_ARCMT=OFF
		-DCLANG_ENABLE_STATIC_ANALYZER=OFF
		-DCLANG_ANALYZER_ENABLE_Z3_SOLVER=OFF
		)

	LLVM_CPU_COUNT=1
	CLANG_CPU_COUNT=1
fi

LLVM_CMAKE_FLAGS=${LLVM_CMAKE_FLAGS[*]}
CLANG_CMAKE_FLAGS=${CLANG_CMAKE_FLAGS[*]}

#. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

case "$BUILD_PROJECT" in
"llvm")
	DEPLOY_TAR=$LLVM_RELEASE_TAR
	;;

"clang")
	DEPLOY_TAR=$CLANG_RELEASE_TAR
	;;

*)
	echo "Invalid project $BUILD_PROJECT (must be 'llvm' or 'clang')"
	exit -1
esac

echo ---------------------------------------------------------------------------
echo LLVM_VERSION:     $LLVM_VERSION
echo LLVM_MASTER_URL:  $LLVM_MASTER_URL
echo LLVM_SRC_URL:     $LLVM_SRC_URL
echo LLVM_RELEASE_TAR: $LLVM_RELEASE_TAR
echo LLVM_RELEASE_URL: $LLVM_RELEASE_URL
echo LLVM_CMAKE_FLAGS: $LLVM_CMAKE_FLAGS
echo ---------------------------------------------------------------------------
echo CLANG_SRC_URL:     $CLANG_SRC_URL
echo CLANG_MASTER_URL:  $CLANG_MASTER_URL
echo CLANG_RELEASE_TAR: $CLANG_RELEASE_TAR
echo CLANG_CMAKE_FLAGS: $CLANG_CMAKE_FLAGS
echo ---------------------------------------------------------------------------
echo DEPLOY_TAR: $DEPLOY_TAR
echo ---------------------------------------------------------------------------

env | sort
