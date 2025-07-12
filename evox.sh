#!/bin/bash

echo "====================== BUILD STARTED ======================"

# Cleanup old trees
rm -rf .repo/local_manifests
rm -rf device/samsung/a21s
rm -rf device/samsung/a21s-common
rm -rf vendor/samsung/a21s
rm -rf vendor/samsung/a21s-common
rm -rf kernel/samsung/exynos850

# ROM source init
repo init -u https://github.com/Evolution-X/manifest -b bka --git-lfs
echo "==============================================================="
echo "---------------------- Repo Init Success ----------------------"
echo "==============================================================="

# Local manifests
git clone https://github.com/samsungexynos850/local_manifests -b slsi .repo/local_manifests

# Clean clang before sync
rm -rf prebuilts/clang/host/linux-x86

# Repo sync
/opt/crave/resync.sh
echo "======================= Repo Sync Done =========================="

# Clone device/vendor/kernel trees
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b lineage-22.2
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-22.2
git clone https://github.com/mustafa-dgaf/android_device_samsung_a21s-common device/samsung/a21s-common -b lineage-23.0
git clone https://github.com/mustafa-dgaf/android_device_samsung_a21s device/samsung/a21s -b lineage-23.0
git clone https://github.com/samsungexynos850/upstream_exynos850 kernel/samsung/exynos850 -b lineage-23.0

echo "==============================================================="
echo "----------- All Repositories Cloned Successfully -------------"
echo "==============================================================="

# Export build info
export BUILD_USERNAME=Mustafa
export BUILD_HOSTNAME=crave

# Build
source build/envsetup.sh && lunch lineage_a21s-bp2a-userdebug && m evolution
