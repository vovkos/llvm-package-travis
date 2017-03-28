LLVM packages for Travis CI
===========================

.. image:: https://travis-ci.org/vovkos/llvm-travis-package.svg?branch=llvm-3.8.x
	:target: https://travis-ci.org/vovkos/llvm-travis-package

Abstract
--------

Building LLVM on Travis CI as part of your project is no longer an option. Recent versions of LLVM take around 40 minitues to build, which in combination with the hard 50 minitues job timeout of Travis CI makes it nearly impossible to complete the build of your own project successfully.

**llvm-travis-package** project builds all major versions of LLVM and makes resulting LLVM binary packages available as GitHub release attached resource files. Other projects can then download LLVM package archives and unpack LLVM binaries -- instead of building LLVM and wasting those precious 40 minutes of allotted job time.

Releases
--------

* `LLVM 3.4.2 <https://github.com/vovkos/llvm-package/releases/llvm-3.4.2>`_
* `LLVM 3.5.2 <https://github.com/vovkos/llvm-package/releases/llvm-3.5.2>`_
* `LLVM 3.6.2 <https://github.com/vovkos/llvm-package/releases/llvm-3.6.2>`_
* `LLVM 3.7.1 <https://github.com/vovkos/llvm-package/releases/llvm-3.7.1>`_
* `LLVM 3.8.1 <https://github.com/vovkos/llvm-package/releases/llvm-3.8.1>`_
