#!/bin/sh
# Usage: ./easy-remove.sh [-f]

[ "$1" = "-f" ] && REMOVE=1

IFS='
'

for testfile in `/usr/syno/pgsql/bin/psql mediaserver admin -tA -c "SELECT path FROM video WHERE NOT ((path LIKE '/volume1/video/Series/%' OR path LIKE '/volume1/video/Humour/%' OR path LIKE '/volume1/video/Animes/%' OR path LIKE '/volume1/video/Docs/%' OR path LIKE '/volume1/video/Films/%' OR path LIKE '/volume1/video/Pr0n/%' ))"`; do
    if [ ! -f "$testfile" ]; then
	echo "MISSING: $testfile"
	[ -n "$REMOVE" ] && synoindex -d "$testfile"
    fi
done

for testdir in `/usr/syno/pgsql/bin/psql mediaserver admin -tA -c "SELECT path FROM directory WHERE ((path LIKE '/volume1/video/%' ))"`; do
    if [ ! -d "$testdir" ]; then
        echo "MISSING DIRECTORY: $testdir"
        [ -n "$REMOVE" ] && synoindex -D "$testdir"
    fi
done
