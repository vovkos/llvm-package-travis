LLVM packages for Travis CI
===========================

.. image:: https://travis-ci.org/vovkos/llvm-package-travis.svg?branch=llvm-3.8.x
	:target: https://travis-ci.org/vovkos/llvm-package-travis

Abstract
--------

Unfortunately, pre-built packages on the official `LLVM download page <http://releases.llvm.org>`_ cover but a tiny fraction of the possible build configurations on Travis CI.

Even worse, building LLVM on Travis CI as part of your project is no longer an option. Recent versions of LLVM take around 40-50 minitues to build, which in combination with the hard 50 minitues job timeout of Travis CI makes it nearly impossible to complete the build of your own project successfully.

**llvm-travis-package** project builds all major versions of LLVM for a more complete build matrix:

* OS:
	- Linux Ubuntu 14.04 Trusty Tahr
	- Mac OS X 10.11.6

* Compiler:
	- gcc++ 4.8.4
	- clang++ 3.5.0

* Configuration:
	- Debug
	- Release

* Target CPU:
	- IA32 (a.k.a. x86)
	- AMD64 (a.k.a. x86_64)

The resulting LLVM binary packages are then made publicly available as GitHub release artifacts. Other projects can then download LLVM package archives and unpack LLVM binaries, instead of building LLVM locally.

Releases
--------

* `LLVM 3.4.2 <https://github.com/vovkos/llvm-package-travis/releases/llvm-3.4.2>`_
* `LLVM 3.5.2 <https://github.com/vovkos/llvm-package-travis/releases/llvm-3.5.2>`_
* `LLVM 3.6.2 <https://github.com/vovkos/llvm-package-travis/releases/llvm-3.6.2>`_
* `LLVM 3.7.1 <https://github.com/vovkos/llvm-package-travis/releases/llvm-3.7.1>`_
* `LLVM 3.8.1 <https://github.com/vovkos/llvm-package-travis/releases/llvm-3.8.1>`_
