REM This is set to reduce the number of random tests run so that CIs can run
REM tests to completion without timeouts

set ARB_TEST_MULTIPLIER=0.1

cp %SRC_DIR%/CMakeLists.txt CMakeLists.txt

mkdir build
cd build

cmake ^
  -G "Ninja" ^
  -DBUILD_TESTING=ON ^
  -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DBUILD_SHARED_LIBS=ON ^
  ..

ninja -j%CPU_COUNT%
ninja install

ctest -j%CPU_COUNT% --output-on-failure -E "dump_file"
