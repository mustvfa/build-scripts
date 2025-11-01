#!/bin/bash

# ROM source init
repo init -u https://github.com/Evolution-X/manifest -b bka --git-lfs

# Local manifests
git clone https://github.com/mustvfa/local_manifests -b slsi .repo/local_manifests

# Repo sync
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
repo sync -c -j4 --force-sync --no-clone-bundle --no-tags

#errors fixs
rm -rf hardware/samsung/hidl/touch
rm -rf hardware/samsung_slsi-linaro/openmax
git clone -b lineage-22.2 https://github.com/mustvfa/android_hardware_samsung_slsi-linaro_openmax hardware/samsung_slsi-linaro/openmax
rm -rf hardware/samsung/hidl/fastcharge
rm -rf hardware/samsung/hidl/livedisplay

# Clone device/vendor/kernel trees
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b lineage-23.0
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-23.0
git clone https://github.com/mustvfa/android_device_samsung_a21s-common device/samsung/a21s-common -b evox
git clone https://github.com/mustvfa/android_device_samsung_a21s device/samsung/a21s -b evox
git clone https://github.com/mustvfa/android_kernel_samsung_exynos850 kernel/samsung/exynos850 -b lineage-23.0

git clone https://github.com/Evolution-X/vendor_evolution-priv_keys-template vendor/evolution-priv/keys && cd vendor/evolution-priv/keys && ./keys.sh
cd ../../..

# Build
source build/envsetup.sh && lunch lineage_a21s-bp2a-userdebug && m evolution
