#!/usr/bin/env zsh
# Either run the test with the given name, or rerun the most recently run test.
# Intended to be called from within Vim. Check out the vimrc.vim file.

if [[ $2 == 'test-'* ]]
then
  export TEST_NAME=$2
  echo $TEST_NAME > /tmp/last_test_run
elif [[ -e /tmp/last_test_run ]]
then
  FILES=`cat /tmp/last_run_files`
else
  echo "no test found"
  exit 0  # don't open trace
fi

set -e
if [[ $1 == */* ]]
then
  CFLAGS=$CFLAGS ./subx --debug translate [0-9]*.subx  apps/subx-common.subx $1 /tmp/run_one_test.subx -o /tmp/a.elf
else
  # don't mention files twice
  CFLAGS=$CFLAGS ./subx --debug translate [0-9]*.subx apps/subx-common.subx    /tmp/run_one_test.subx -o /tmp/a.elf
fi

./subx --debug --trace run /tmp/a.elf
