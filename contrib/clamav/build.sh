#!/bin/bash

# Copyright (c) 2020 Kevin R Croft <krcroft@gmail.com>
# SPDX-License-Identifier: GPL-2.0-or-later

# A simple serialized script that builds the latest release version of
# ClamAV.  The package is installed inside this repository's ./local
# directory.  A static build is used to ensure the binaries work
# regardless of their relative path and without needing LD_* variables
# or ldconfig registration.

# Enable bash safe-mode; quit immediately on any error
set -euo pipefail

# Use the official ClamAV repository
CLAM_REPO="https://github.com/Cisco-Talos/clamav-devel.git"

# Determine our local script and repository directories
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
pushd "$SCRIPT_DIR"
REPO_ROOT="$(git rev-parse --show-toplevel)"

# Clone the ClamAV repository
if [[ ! -d clamav-devel ]]; then
	git clone "$CLAM_REPO"
fi

# Enter and refresh the repository
pushd clamav-devel
git clean -fdx
git fetch origin
git reset --hard origin/master
git checkout master
git pull

# Checkout the latest release tag
release="$(git for-each-ref --sort=-committerdate refs/remotes/origin/rel | head -1 | cut -f2)"
if [[ -z "$release" ]]; then
	echo "Coulnd't find the latest release tag, quitting"
	exit 1
fi
git checkout "$release"

# Configure
prefix="$REPO_ROOT/local"
flags="-DNDEBUG -O3 -mtune=native -pipe -s"
if ! ./configure CFLAGS="$flags" CXXFLAGS="$flags" --with-systemdsystemunitdir=no \
     --disable-unrar --enable-static --disable-shared --prefix="$prefix"; then
	cat config.log
	exit 1
fi

# Build and install
make -j $(nproc || echo 4) install
make distclean > /dev/null

# Fetch the latest AV signatures
pushd "$REPO_ROOT"
sed 's/.*Example.*//g' local/etc/clamd.conf.sample > local/etc/clamd.conf
sed 's/.*Example.*//g' local/etc/freshclam.conf.sample > local/etc/freshclam.conf
mkdir -p local/share/clamav
./local/bin/freshclam

# Done!
echo "You make now perform scans using:"
echo "    $PWD/local/bin/clamscan --heuristic-scan-precedence=yes \\"
echo "    --recursive --infected /path/to/scan"
