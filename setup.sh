#!/usr/bin/env bash

BUILD_ROOT="$PWD"
QSSI_ROOT="${BUILD_ROOT}/LA.QSSI.14.0"
VENDOR_ROOT="${BUILD_ROOT}/LA.UM.9.14.r1"
LE_ROOT="${BUILD_ROOT}/LE.UM.4.3.1.r1"

function sync_repo {
    mkdir -p "$1" && cd "$1"
    echo "[+] Changed directory to $1."

    if repo init --depth=1 -q -u https://github.com/QRD-Development/SM8350_BSP_Sync.git -b LA.UM.9.14.r1 -m "$2"; then
        echo "[+] Repo initialized successfully."
    else
        echo "[-] Error: Failed to initialize repo."
        exit 1
    fi

    echo "[+] Starting repo sync..."
    if schedtool -B -e ionice -n 0 repo sync -q -c --force-sync --optimized-fetch --no-tags --retry-fetches=5 -j"$(nproc --all)"; then
        echo "[+] Repo synced successfully."
    else
        echo "[-] Error: Failed to sync repo."
        exit 1
    fi
}

sync_repo "$QSSI_ROOT" "qssi.xml"
sync_repo "$VENDOR_ROOT" "target.xml"
sync_repo "$LE_ROOT" "le.xml"

cd "$BUILD_ROOT"
echo "[+] Successfully returned to the build root."
