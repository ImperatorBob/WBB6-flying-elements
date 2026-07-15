#!/bin/sh
# Builds the installable WoltLab package archive.
# The result (de.imperatorbob.flyingelements.tar) is uploaded via the ACP:
#   Configuration -> Packages -> Install Package
#
# No files.tar is needed because the CSS is delivered inline via the
# template listener (fewer moving parts, nothing to copy into the install).
set -e

cd "$(dirname "$0")"

PACKAGE="de.imperatorbob.flyingelements.tar"

tar cf "$PACKAGE" \
	package.xml \
	userOption.xml \
	templateListener.xml \
	language/de.xml \
	language/en.xml

echo "Built $PACKAGE"
