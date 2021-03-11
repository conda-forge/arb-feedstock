#!/usr/bin/env bash

chmod +x configure

# This is set to reduce the number of random tests run so that CIs can run
# tests to completion without timeouts.
export ARB_TEST_MULTIPLIER=0.1;

# CFLAGS are not appended
export CFLAGS="$CFLAGS -funroll-loops -g"

sed -i.bak 's/$(LIBS)/$(LDFLAGS) $(LIBS)/g' Makefile.subdirs

./configure --prefix=$PREFIX --with-gmp=$PREFIX --with-mpfr=$PREFIX --with-flint=$PREFIX --disable-static
make -j${CPU_COUNT}
make install

if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
make check
fi
