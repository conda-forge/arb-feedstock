#!/usr/bin/env bash

chmod +x configure

# This is set to reduce the number of random tests run so that CIs can run
# tests to completion without timeouts.
export ARB_TEST_MULTIPLIER=0.1;

# CFLAGS are not appended
export CFLAGS="$CFLAGS -funroll-loops -g"

sed -i.bak 's/$(LIBS)/$(LDFLAGS) $(LIBS)/g' Makefile.subdirs

if [[ "$target_platform" == *-64 ]]; then
  export ARCH="x86_64"
fi
if [[ "$target_platform" == linux-* ]]; then
  export FLINT_BUILD="$ARCH-Linux"
elif [[ "$target_platform" == osx-* ]]; then
  export FLINT_BUILD="$ARCH-Darwin"
fi

./configure \
  --prefix=$PREFIX \
  --with-gmp=$PREFIX \
  --with-mpfr=$PREFIX \
  --with-flint=$PREFIX \
  --disable-static \
  --build=$FLINT_BUILD
make -j${CPU_COUNT}
make install

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make check
fi
