#!/bin/bash
set -e
umask 022
export LANG="C.UTF-8"
export UNAME="${UNAME:-0:0}"

if [ "$1" = 'gitit' ]; then
	if [ ! -f /data/gitit.conf ]; then
		gosu $UNAME bash -c 'gitit --print-default-config > /data/gitit.conf'
		gosu $UNAME gitit -f /data/gitit.conf -p 80 2>/dev/null || true
	fi
	exec gosu $UNAME "$@"
fi

exec "$@"

