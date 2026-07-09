#!/usr/bin/env bash
#
# mayhem/build.sh — build logswan twice:
#   1) the FUZZ build (cmake, ASan+UBSan via $SANITIZER_FLAGS + DWARF<4 via $DEBUG_FLAGS)
#      → /mayhem/logswan-fuzz  (the Mayhem target; logswan is a file-input binary, no
#      libFuzzer harness — the whole program is the harness, as in the original integration)
#   2) the TEST build (normal flags, plus optional $COVERAGE_FLAGS)
#      → build-tests/logswan, which mayhem/test.sh runs as the functional oracle.
#
# Dependencies (libjansson-dev, libmaxminddb-dev) are apt-installed in the Dockerfile, so an
# offline re-run of this script resolves everything from the image — no network fetches here.
set -euo pipefail

[ -n "${SOURCE_DATE_EPOCH:-}" ] || unset SOURCE_DATE_EPOCH

: "${SANITIZER_FLAGS=-fsanitize=address,undefined -fno-sanitize-recover=all -fno-omit-frame-pointer}"
: "${DEBUG_FLAGS:=-g -gdwarf-3}"
: "${CC:=clang}" ; : "${CXX:=clang++}"
: "${MAYHEM_JOBS:=$(nproc)}"
: "${COVERAGE_FLAGS=}"
export SANITIZER_FLAGS DEBUG_FLAGS CC CXX MAYHEM_JOBS COVERAGE_FLAGS

cd "$SRC"

# 1) Sanitized fuzz build. detect_leaks=0 is baked into the binary via a weak
#    __asan_default_options (Mayhem owns the runtime ASAN_OPTIONS; end-of-process allocations
#    logswan never frees are not the defects we fuzz for). Kept additive: the extra object is
#    injected through CMAKE_C_STANDARD_LIBRARIES, no upstream file is touched.
ASAN_OPTS_OBJ=/tmp/mayhem_asan_default_options.o
if [ -n "$SANITIZER_FLAGS" ]; then
  $CC -c "$SRC/mayhem/asan_default_options.c" -o "$ASAN_OPTS_OBJ"
  EXTRA_LIBS="$ASAN_OPTS_OBJ"
else
  EXTRA_LIBS=""
fi
cmake -B build \
      -DCMAKE_C_COMPILER="$CC" \
      -DCMAKE_C_FLAGS="$SANITIZER_FLAGS $DEBUG_FLAGS" \
      -DCMAKE_C_STANDARD_LIBRARIES="$EXTRA_LIBS" \
      -DCMAKE_BUILD_TYPE=None
cmake --build build -j"$MAYHEM_JOBS"
cp build/logswan /mayhem/logswan-fuzz

# 2) Test/oracle build with the project's NORMAL flags (independent of the sanitized build).
cmake -B build-tests \
      -DCMAKE_C_COMPILER="$CC" \
      -DCMAKE_C_FLAGS="$COVERAGE_FLAGS" \
      -DCMAKE_BUILD_TYPE=Release
cmake --build build-tests -j"$MAYHEM_JOBS"
