#!/bin/bash
rm -rf .repo/local_manifests
# Initialize repo for Evolution-X
repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 15 -g default,-mips,-darwin,-notdefault
git clone https://github.com/samsungexynos850/local_manifests -b slsi .repo/local_manifests
# Sync
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync 
# Clone device/vendor/kernel repositories
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common  vendor/samsung/a21s-common -b lineage-22.2
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-22.2
git clone https://github.com/mustafa-dgaf/android_device_samsung_a21s-common device/samsung/a21s-common -b lineage-22.2
git clone https://github.com/mustafa-dgaf/android_device_samsung_a21s device/samsung/a21s -b lineage-22.2
git clone https://github.com/mustafa-dgaf/upstream_exynos850 kernel/samsung/exynos850 -b lineage-23.0
# Build
source build/envsetup.sh 
lunch lineage_a21s-bp2a-userdebug && mka bacon
