#!/bin/sh

tempfile=tempfile-$(hostname -s)
count=512

stop() { rm -f $tempfile; }

trap "stop" 2

echo "Working directory: $(pwd)"
echo "Free space: $(df -h . | tail -1)"

echo 'Write to file:'
if ! dd if=/dev/zero of=$tempfile bs=1M count=$count; then
    echo "ERROR: dd write failed (quota or no space?)"
    rm -f $tempfile
    exit 1
fi
sync

sleep 5
echo

echo 'Read from file:'
dd if=$tempfile of=/dev/null bs=1M count=$count

rm $tempfile

#stop

