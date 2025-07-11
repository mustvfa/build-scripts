#!/bin/bash
# Fresh manifest cleanup
rm -rf .repo/local_manifests .repo/manifests .repo/manifest.xml
# Initialize repo 
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 15 -g default,-mips,-darwin,-notdefault
git clone https://github.com/samsungexynos850/local_manifests -b aosp .repo/local_manifests
# Sync
/opt/crave/resync.sh
# Clone device/vendor/kernel repositories
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common  vendor/samsung/a21s-common -b lineage-22.2
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-22.2
git clone https://github.com/tryinsmth/android_device_samsung_a21s-common device/samsung/a21s-common -b lineage-22.2
git clone https://github.com/tryinsmth/android_device_samsung_a21s device/samsung/a21s -b lineage-22.2
git clone https://github.com/mustafa-dgaf/upstream_exynos850 kernel/samsung/exynos850 -b lineage-23.0
#
source build/envsetup.sh
# 🍽️ Lunch time
lunch infinity_a21s-userdebug && mka bacon
