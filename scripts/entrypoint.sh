#!/bin/bash
PLATFORMS=$1
LEVEL=$2
SRCDIR=$3
VERSION=$4

IFS=';' read -ra PLATFORMARRAY <<< "$PLATFORMS"

for platform in "${PLATFORMARRAY[@]}"; do
  /scripts/build_jnilib.sh ${platform} ${LEVEL} ${SRCDIR}
done

/scripts/hash_libs.sh "$PLATFORMS" "$VERSION" "${SRCDIR}"
