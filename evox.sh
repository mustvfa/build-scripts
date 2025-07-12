#!/bin/bash
# Remove local manifests
rm -rf .repo/local_manifests
# Initialize repo for Evolution-X
repo init -u https://github.com/Evolution-X/manifest -b bka --git-lfs
git clone https://github.com/samsungexynos850/local_manifests -b slsi .repo/local_manifests
#####
rm -rf prebuilts/clang/host/linux-x86
# Sync
/opt/crave/resync.sh
######
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common  vendor/samsung/a21s-common -b lineage-22.2
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-22.2
git clone https://github.com/mustafa-dgaf/android_device_samsung_a21s-common device/samsung/a21s-common -b lineage-23.0
git clone https://github.com/mustafa-dgaf/android_device_samsung_a21s device/samsung/a21s -b lineage-23.0
git clone https://github.com/samsungexynos850/upstream_exynos850 kernel/samsung/exynos850 -b lineage-23.0
# Build
source build/envsetup.sh && lunch lineage_a21s-bp2a-userdebug && m evolution
