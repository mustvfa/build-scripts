#!/bin/bash

# ROM source init
repo init -u https://github.com/Evolution-X/manifest -b bq1 --git-lfs
# Local manifests
git clone https://github.com/samsungexynos850/local_manifests -b lineage-23.1 .repo/local_manifests

# Repo sync
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
repo sync -c -j4 --force-sync --no-clone-bundle --no-tags

#errors fixs
rm -rf hardware/samsung/hidl/touch
rm -rf hardware/samsung/hidl/fastcharge
rm -rf hardware/samsung/hidl/livedisplay

# Clone device/vendor/kernel trees
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b lineage-23.1
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-23.1
git clone https://github.com/LineageOS/android_device_samsung_a21s-common device/samsung/a21s-common -b lineage-23.1
git clone https://github.com/LineageOS/android_device_samsung_a21s device/samsung/a21s -b lineage-23.1
git clone https://github.com/LineageOS/android_kernel_samsung_exynos850 kernel/samsung/exynos850 -b lineage-23.1

git clone https://github.com/Evolution-X/vendor_evolution-priv_keys-template vendor/evolution-priv/keys && cd vendor/evolution-priv/keys && ./keys.sh
cd ../../..

# Build
source build/envsetup.sh && lunch lineage_a21s-bp3a-userdebug && m evolution
