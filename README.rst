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

	*	- `LLVM 3.4.2 <https://github.com/vovkos/llvm-package-travis/releases/llvm-3.4.2-b>`_
		- `Clang 3.4.2 <https://github.com/vovkos/llvm-package-travis/releases/clang-3.4.2>`_

Abstract
--------

LLVM is huge, and it's getting bigger with each and every release. Building it together with a project which depends on it (e.g. an LLVM-targeting programming language) during a CI build is **not an option** -- building *LLVM itself* eats most (earlier LLVM releases) and all (recent LLVM releases) of the allotted CI build time.

So why not using pre-built packages from the official `LLVM download page <http://releases.llvm.org>`_? Unfortunately, the official binaries cover just a *tiny fraction* of possible configurations; what's even worse, there's no consistency in the build matrix from release to release. There are no Debug libraries or 32-bit binaries for Ubuntu, sometimes Ubuntu build is missing, sometimes there's no Mac OS X, etc.

The ``llvm-package-travis`` project builds all major versions of both LLVM and LibClang on Travis CI (so there's a guarantee of binary compatibility) and for a consistent and much more complete build matrix:

* OS:
	- Linux Ubuntu 14.04 (Trusty Tahr)
	- Mac OS X

* Compiler:
	- gcc++ (Linux only)
	- clang++

* Configuration:
	- Debug (libraries only, no tools)
	- Release

* Target CPU:
	- IA32 (a.k.a. x86; Linux only)
	- AMD64 (a.k.a. x86_64)

The resulting LLVM binary packages are made publicly available as GitHub release artifacts. Compiler developers can now fully test their LLVM-dependent projects on Travis CI by downloading and unpacking a corresponding LLVM binary archive during the CI installation phase.

	Big thanks to the Travis CI team for increasing the allotted build time for ``llvm-package-travis``!
