#!/bin/bash
echo "====================== BUILD STARTED ======================"

# ROM source init
repo init -u https://github.com/DerpFest-AOSP/manifest.git -b 13
echo "==============================================================="
echo "---------------------- Repo Init Success ----------------------"
echo "==============================================================="

# Local manifests
git clone https://github.com/mustafa-dgaf/local_manifests- -b slsi .repo/local_manifests

# Repo sync
repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)
repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j4
echo "======================= Repo Sync Done =========================="

# Clone device/vendor/kernel trees
git clone https://github.com/mustafa-dgaf/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b lineage-20
git clone https://github.com/mustafa-dgaf/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-20
git clone https://github.com/tyypeshi1/android_device_samsung-common_a21s device/samsung/a21s-common -b lineage-20
git clone https://github.com/tyypeshi1/android_device_samsung_a21s device/samsung/a21s -b lineage-20
git clone https://github.com/samsungexynos850/upstream_exynos850 kernel/samsung/exynos850 -b lineage-23.0

# kernel
cd kernel/samsung/exynos850
git reset --hard 39b0138abf46e230ed9d0fd6b9d01c606aa0379a
cd ../../..

echo "==============================================================="
echo "----------- All Repositories Cloned Successfully -------------"
echo "==============================================================="

# Build
source build/envsetup.sh && lunch lineage_a21s-userdebug && mka derp
