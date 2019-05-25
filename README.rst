LLVM packages for Travis CI
===========================

.. image:: https://travis-ci.org/vovkos/llvm-package-travis.svg
	:target: https://travis-ci.org/vovkos/llvm-package-travis
.. image:: https://img.shields.io/badge/donate-@jancy.org-blue.svg
	:align: right
	:target: http://jancy.org/donate.html?donate=llvm-package

Releases
--------

.. list-table::
	:header-rows: 1

	*	- LLVM Date
		- LLVM Version
		- Clang Version
		- Remarks

	*	-	2019-Mar-20

		-	+ `llvm-8.0.0-linux-xenial <https://github.com/vovkos/llvm-package-travis/releases/llvm-8.0.0-linux-xenial>`__
			+ `llvm-8.0.0-linux-trusty <https://github.com/vovkos/llvm-package-travis/releases/llvm-8.0.0-linux-trusty>`__
			+ `llvm-8.0.0-osx <https://github.com/vovkos/llvm-package-travis/releases/llvm-8.0.0-osx>`__

		-	+ `clang-8.0.0-linux-xenial <https://github.com/vovkos/llvm-package-travis/releases/clang-8.0.0-linux-xenial>`__
			+ `clang-8.0.0-linux-trusty <https://github.com/vovkos/llvm-package-travis/releases/clang-8.0.0-linux-trusty>`__
			+ `clang-8.0.0-osx <https://github.com/vovkos/llvm-package-travis/releases/clang-8.0.0-osx>`__

		- The latest and greatest LLVM

	*	-	2019-Apr-17

		-	+ `llvm-7.1.0-linux-xenial <https://github.com/vovkos/llvm-package-travis/releases/llvm-7.1.0-linux-xenial>`__
			+ `llvm-7.1.0-linux-trusty <https://github.com/vovkos/llvm-package-travis/releases/llvm-7.1.0-linux-trusty>`__
			+ `llvm-7.1.0-osx <https://github.com/vovkos/llvm-package-travis/releases/llvm-7.1.0-osx>`__

		-	+ `clang-7.1.0-linux-xenial <https://github.com/vovkos/llvm-package-travis/releases/clang-7.1.0-linux-xenial>`__
			+ `clang-7.1.0-linux-trusty <https://github.com/vovkos/llvm-package-travis/releases/clang-7.1.0-linux-trusty>`__
			+ `clang-7.1.0-osx <https://github.com/vovkos/llvm-package-travis/releases/clang-7.1.0-osx>`__

		- The ABI compatibility with GCC fix for LLVM 7

	*	-	2016-Dec-23

		-	+ `llvm-3.9.1-linux-xenial <https://github.com/vovkos/llvm-package-travis/releases/llvm-3.9.1-linux-xenial>`__
			+ `llvm-3.9.1-linux-trusty <https://github.com/vovkos/llvm-package-travis/releases/llvm-3.9.1-linux-trusty>`__
			+ `llvm-3.9.1-osx <https://github.com/vovkos/llvm-package-travis/releases/llvm-3.9.1-osx>`__

		-	+ `clang-3.9.1-linux-xenial <https://github.com/vovkos/llvm-package-travis/releases/clang-3.9.1-linux-xenial>`__
			+ `clang-3.9.1-linux-trusty <https://github.com/vovkos/llvm-package-travis/releases/clang-3.9.1-linux-trusty>`__
			+ `clang-3.9.1-osx <https://github.com/vovkos/llvm-package-travis/releases/clang-3.9.1-osx>`__

		- The latest LLVM which still can be compiled with MSVC 2013

	*	- 	2014-Jun-19

		-	+ `llvm-3.4.2-linux-xenial <https://github.com/vovkos/llvm-package-travis/releases/llvm-3.4.2-linux-xenial>`__
			+ `llvm-3.4.2-linux-trusty <https://github.com/vovkos/llvm-package-travis/releases/llvm-3.4.2-linux-trusty>`__
			+ `llvm-3.4.2-osx <https://github.com/vovkos/llvm-package-travis/releases/llvm-3.4.2-osx>`__

		-	+ `clang-3.4.2-linux-xenial <https://github.com/vovkos/llvm-package-travis/releases/clang-3.4.2-linux-xenial>`__
			+ `clang-3.4.2-linux-trusty <https://github.com/vovkos/llvm-package-travis/releases/clang-3.4.2-linux-trusty>`__
			+ `clang-3.4.2-osx <https://github.com/vovkos/llvm-package-travis/releases/clang-3.4.2-osx>`__

		- The latest LLVM which still can be compiled with MSVC 2010

	*	-
		- LLVM x.x.x
		- Clang x.x.x
		- Create a `new issue <https://github.com/vovkos/llvm-package-travis/issues/new>`__ to request a particular LLVM version

Abstract
--------

LLVM is huge, and it's getting bigger with each and every release. Building it together with a project which depends on it (e.g., an LLVM-targeting programming language) during a CI build is **not an option** -- building *LLVM itself* eats most (earlier LLVM releases), and all (recent LLVM releases) of the allotted CI build time.

So why not use pre-built packages from the official `LLVM download page <http://releases.llvm.org>`__? Unfortunately, the official binaries cover just a *tiny fraction* of possible configurations; what's even worse, there's no consistency in the build matrix from release to release. There are no Debug libraries or 32-bit binaries for Ubuntu, sometimes Ubuntu build is missing, sometimes there's no Mac OS X, etc.

The ``llvm-package-travis`` project builds all important versions of both LLVM and LibClang on Travis CI (so there's a guarantee of binary compatibility) and for a consistent and much more complete build matrix:

* OS:
	- Linux Ubuntu 16.04 (Xenial Xerus)
	- Linux Ubuntu 14.04 (Trusty Tahr)
	- Mac OS X

* Compiler:
	- GCC (Linux only)
	- Clang

* Configuration:
	- Debug (libraries only, no tools)
	- Release

* Target CPU:
	- IA32 (a.k.a. x86; Linux only)
	- AMD64 (a.k.a. x86_64)

The resulting LLVM binary packages are made publicly available as GitHub release artifacts. Compiler developers can now fully test their LLVM-dependent projects on Travis CI by downloading and unpacking a corresponding LLVM binary archive during the CI installation phase.

	Big thanks to the Travis CI team for increasing the allotted build time for ``llvm-package-travis``!

Sample
------

* `Jancy <https://github.com/vovkos/jancy>`__ uses ``llvm-package-windows`` for CI testing on a range of configurations and LLVM versions. See `build logs <https://travis-ci.org/vovkos/jancy>`__ for more details.
