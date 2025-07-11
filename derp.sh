#!/bin/bash
# Fresh manifest cleanup
rm -rf .repo/local_manifests
# Initialize repo 
repo init -u https://github.com/DerpFest-AOSP/android_manifest.git -b 16 --git-lfs
git clone https://github.com/samsungexynos850/local_manifests -b aosp .repo/local_manifests
#repo sync fix
rm -rf prebuilts/clang/host/linux-x86
# Sync
/opt/crave/resync.sh
# Clone device/vendor/kernel repositories
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common  vendor/samsung/a21s-common -b lineage-22.2
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-22.2
git clone https://github.com/mustafa-dgaf/android_device_samsung_a21s-common device/samsung/a21s-common -b lineage-23.0
git clone https://github.com/mustafa-dgaf/android_device_samsung_a21s device/samsung/a21s -b lineage-23.0
git clone https://github.com/mustafa-dgaf/upstream_exynos850 kernel/samsung/exynos850 -b lineage-23.0
# 🍽️ Lunch time
source build/envsetup.sh && lunch lineage_a21s-bp1a-userdebug && mka derp
