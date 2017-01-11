#!/bin/bash

set -e

RB_EXE="$1"
ABSOLUTE_LIB_PREFIX="$2"  # used only on OSX

if [[ ! -x "$RB_EXE" ]]; then
  echo "missing RB_EXE at: $RB_EXE"
  exit 1
fi

"$RB_EXE" setup.rb

if [[ "$(uname)" == "Darwin" ]]; then
  SITE_RB_DIR=`$RB_EXE -e 'puts RbConfig::CONFIG["sitearchdir"]'`
  EM_EXT_PATH="$SITE_RB_DIR/rubyeventmachine.bundle"
  chmod u+w "$EM_EXT_PATH"
  install_name_tool -change "$ABSOLUTE_LIB_PREFIX/libssl.1.0.0.dylib" "@rpath/libssl.1.0.0.dylib" "$EM_EXT_PATH"
  install_name_tool -change "$ABSOLUTE_LIB_PREFIX/libcrypto.1.0.0.dylib" "@rpath/libcrypto.1.0.0.dylib" "$EM_EXT_PATH"
  chmod u-w "$EM_EXT_PATH"
fi
