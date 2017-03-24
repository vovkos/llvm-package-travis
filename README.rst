LLVM-package
============

Building LLVM as part of your project is no longer an option on Travis CI. Recent versions of LLVM take around 40 minitues to build, which in combination with the hard 50 minitues job time out in Travis CI makes it impossible to build your own project successfully.

LLVM-package project will build all major releases of LLVM and upload them as releases. Other projects can then download archives and unpack LLVM binaries -- instead of wasting those precious 50 minutes.
