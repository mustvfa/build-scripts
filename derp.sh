#!/bin/bash
echo "====================== BUILD STARTED ======================"

# ROM source init
repo init -u https://github.com/DerpFest-AOSP/manifest.git -b 13
echo "==============================================================="
echo "---------------------- Repo Init Success ----------------------"
echo "==============================================================="

# Local manifests
git clone https://github.com/mustafa-dgaf/local_manifests- -b lineage-20 .repo/local_manifests

# Clean clang before sync
rm -rf prebuilts/clang/host/linux-x86

# Repo sync
/opt/crave/resync.sh
repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j4
echo "======================= Repo Sync Done =========================="

# Clone device/vendor/kernel trees
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b lineage-22.2
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-22.2
git clonehttps://github.com/mustafa-dgaf/a21s-common-archive device/samsung/a21s-common -b lineage-20
git clone https://github.com/mustafa-dgaf/android_device_samsung_a21s device/samsung/a21s -b lineage-23.0
git clone https://github.com/samsungexynos850/upstream_exynos850 kernel/samsung/exynos850 -b lineage-23.0

# kernel
cd kernel/samsung/exynos850
git reset --hard 39b0138abf46e230ed9d0fd6b9d01c606aa0379a
cd ../../..

#device
cd device/samsung/a21s
git checkout 07e85d0e5c0fc3453424045fb2233d5aee5cd296
cd ../../..

echo "==============================================================="
echo "----------- All Repositories Cloned Successfully -------------"
echo "==============================================================="

# Build
source build/envsetup.sh && lunch lineage_a21s-userdebug && mka derp
