#!/bin/bash
set -e
if ! which swift
then
    SWIFT=~/.swiftenv/shims/swift
else
    SWIFT=swift
fi

test 6 -eq $($SWIFT test 2>/dev/null | grep queuedPrint | wc -l)
test 8 -eq $($SWIFT test 2>&1 | grep queuedPrint | wc -l)
