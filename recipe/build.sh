#!/usr/bin/env bash

chmod +x configure

# This is set to reduce the number of random tests run so that CIs can run
# tests to completion without timeouts.
export ARB_TEST_MULTIPLIER=0.1;

# CFLAGS are not appended
export CFLAGS="$CFLAGS -funroll-loops -g"

./configure --prefix=$PREFIX --with-gmp=$PREFIX --with-mpfr=$PREFIX --with-flint=$PREFIX
make -j${CPU_COUNT}
make install

if [[ "$target_platform" == "osx-64" ]]l then
  make check AT= QUIET_CC= QUIET_CXX= QUIET_AR=
else
  make check
fi
