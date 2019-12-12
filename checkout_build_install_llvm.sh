#!/bin/bash -eux
# Copyright 2016 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

LLVM_DEP_PACKAGES="build-essential make cmake ninja-build git python2.7 g++-multilib"
apt-get install -y $LLVM_DEP_PACKAGES

# Checkout
CHECKOUT_RETRIES=10
function clone_with_retries {
  REPOSITORY=$1
  LOCAL_PATH=$2
  CHECKOUT_RETURN_CODE=1

  # Disable exit on error since we might encounter some failures while retrying.
  set +e
  for i in $(seq 1 $CHECKOUT_RETRIES); do
    rm -rf $LOCAL_PATH
    git clone $REPOSITORY $LOCAL_PATH
    CHECKOUT_RETURN_CODE=$?
    if [ $CHECKOUT_RETURN_CODE -eq 0 ]; then
      break
    fi
  done

  # Re-enable exit on error. If checkout failed, script will exit.
  set -e
  return $CHECKOUT_RETURN_CODE
}

# Use chromium's clang revision
mkdir $SRC/chromium_tools
cd $SRC/chromium_tools
git clone https://chromium.googlesource.com/chromium/src/tools/clang
cd clang

LLVM_SRC=$SRC/llvm-project
clone_with_retries https://github.com/llvm/llvm-project.git $LLVM_SRC

mkdir -p $WORK/build
cd $WORK/build

TARGET_TO_BUILD="host;WebAssembly"

PROJECTS_TO_BUILD="compiler-rt;clang;lld"
cmake -G "Ninja" \
      -DLIBCXX_ENABLE_SHARED=OFF -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY=ON -DLIBCXXABI_ENABLE_SHARED=OFF \
      -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="$TARGET_TO_BUILD" \
      -DLLVM_ENABLE_PROJECTS=$PROJECTS_TO_BUILD \
      $LLVM_SRC/llvm
ninja install

# rm -rf $LLVM_SRC
# rm -rf $SRC/chromium_tools
# apt-get remove --purge -y $LLVM_DEP_PACKAGES
# apt-get autoremove -y
