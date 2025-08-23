#!/bin/bash

# Cleanup old local manifests
rm -rf .repo/local_manifests

# Initialize RisingOS repo
repo init -u https://github.com/RisingOS-Revived/android -b sixteen --git-lfs

# Clone local manifests
git clone https://github.com/mustvfa/local_manifests- -b slsi .repo/local_manifests

repo sync -c --no-clone-bundle --optimized-fetch --prune --force-sync -j$(nproc --all)
repo sync -c --no-clone-bundle --optimized-fetch --prune --force-sync -j4

#errors fixs
rm -rf vendor/rising
git clone https://github.com/mustvfa/android_vendor_rising vendor/rising
rm -rf hardware/samsung_slsi-linaro/openmax
git clone https://github.com/mustvfa/android_hardware_samsung_slsi-linaro_openmax hardware/samsung_slsi-linaro/openmax
rm -rf hardware/samsung
git clone https://github.com/mustvfa/android_hardware_samsung hardware/samsung

# Clone device/vendor/kernel trees
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b lineage-23.0
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-23.0
git clone https://github.com/mustvfa/android_device_samsung_a21s-common device/samsung/a21s-common -b lineage-23.0
git clone https://github.com/mustvfa/android_device_samsung_a21s device/samsung/a21s -b rise
git clone https://github.com/mustvfa/upstream_exynos850 kernel/samsung/exynos850 -b lineage-23.0

# Setup and build
source build/envsetup.sh
riseup a21s && gk -f && rise sb

