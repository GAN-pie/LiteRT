# Toolchain file for cross-compiling to Raspberry Pi 3B (aarch64,
# Raspberry Pi OS 64-bit) from an x86-64 GNU/Linux host.
# Used with the "linux-arm64" configure preset in CMakePresets.json.
# Overrides: -DRPI3_SYSROOT=/path/to/sysroot  -DCROSS_PREFIX=aarch64-linux-gnu-

if(RPI3_TOOLCHAIN_INCLUDED)
  return()
endif()
set(RPI3_TOOLCHAIN_INCLUDED TRUE)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

if(NOT DEFINED RPI3_SYSROOT)
  set(RPI3_SYSROOT "$ENV{HOME}/sysroots/rpi3" CACHE PATH "Raspberry Pi 3 sysroot")
endif()

if(NOT EXISTS "${RPI3_SYSROOT}/usr/include")
  message(FATAL_ERROR "RPI3_SYSROOT '${RPI3_SYSROOT}' has no usr/include - sync the Pi sysroot first with rsync")
endif()

set(CMAKE_SYSROOT "${RPI3_SYSROOT}")

if(NOT DEFINED CROSS_PREFIX)
  set(CROSS_PREFIX "aarch64-linux-gnu-" CACHE STRING "Cross-compiler prefix")
endif()

find_program(RPI3_CC ${CROSS_PREFIX}gcc REQUIRED)
find_program(RPI3_CXX ${CROSS_PREFIX}g++ REQUIRED)

set(CMAKE_C_COMPILER "${RPI3_CC}")
set(CMAKE_CXX_COMPILER "${RPI3_CXX}")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_C_FLAGS_INIT "")
set(CMAKE_CXX_FLAGS_INIT "")
set(CMAKE_EXE_LINKER_FLAGS_INIT "")

set(CMAKE_EXE_LINKER_FLAGS_INIT "-L${RPI3_SYSROOT}/usr/lib/aarch64-linux-gnu")
set(CMAKE_SHARED_LINKER_FLAGS_INIT "-L${RPI3_SYSROOT}/usr/lib/aarch64-linux-gnu")
set(CMAKE_MODULE_LINKER_FLAGS_INIT "-L${RPI3_SYSROOT}/usr/lib/aarch64-linux-gnu")

list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES RPI3_SYSROOT CROSS_PREFIX)
