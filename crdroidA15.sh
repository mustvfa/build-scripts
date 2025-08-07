#!/bin/bash

# Initialize repo
repo init -u https://github.com/crdroidandroid/android.git -b 15.0 --git-lfs
git clone https://github.com/mustvfa/local_manifests -b slsi .repo/local_manifests

#fixing sync issue
rm -rf prebuilts/clang/host/linux-x86

# Repo sync
/opt/crave/resync.sh

# Clone device/vendor/kernel repositories
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common  vendor/samsung/a21s-common -b lineage-22.2
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-22.2
git clone https://github.com/mustvfa/android_device_samsung_a21s-common device/samsung/a21s-common -b lineage-23.0
git clone https://github.com/mustvfa/android_device_samsung_a21s device/samsung/a21s -b lineage-23.0
git clone https://github.com/mustvfa/upstream_exynos850 kernel/samsung/exynos850 -b lineage-23.0
# Build
source build/envsetup.sh && lunch lineage_a21s-userdebug && mka bacon
