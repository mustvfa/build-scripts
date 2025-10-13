#!/bin/bash

echo "====================== BUILD STARTED ======================"

# ROM source init 
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault
echo "==============================================================="
echo "---------------------- Repo Init bomb Success ----------------------"
echo "==============================================================="

#clone manifests
git clone https://github.com/mustvfa/local_manifests -b slsi .repo/local_manifests

#repo sync
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j4
echo "======================= Repo Sync Done =========================="

# errors fixs
rm -rf hardware/samsung
git clone https://github.com/LineageOS/android_hardware_samsung hardware/samsung -b lineage-23.0
rm -rf hardware/samsung/hidl/fastcharge/
rm -rf hardware/samsung/hidl/livedisplay/
rm -rf vendor/infinity
git clone -b 16 https://github.com/ProjectInfinity-X/vendor_infinity vendor/infinity

# a16 fix
rm -rf  hardware/samsung_slsi-linaro/openmax
git clone -b lineage-22.2 https://github.com/mustvfa/android_hardware_samsung_slsi-linaro_openmax hardware/samsung_slsi-linaro/openmax

#some errors fixs
git clone https://github.com/ProjectInfinity-X/device_infinity_sepolicy device/infinity/sepolicy -b 16
git clone https://github.com/ProjectInfinity-X/hardware_samsung_nfc hardware/samsung/nfc

#dt
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b lineage-23.0
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-23.0
git clone https://github.com/mustvfa/android_device_samsung_a21s-common device/samsung/a21s-common -b infx
git clone https://github.com/mustvfa/android_device_samsung_a21s device/samsung/a21s -b infinityx
git clone https://github.com/mustvfa/upstream_exynos850 kernel/samsung/exynos850 -b master-stable

echo "==============================================================="
echo "----------- All Repositories Cloned Successfully -------------"
echo "==============================================================="

#errors fixs
rm -rf device/samsung_slsi/sepolicy/common/vendor/hal_lineage_fastcharge_default.te
sed -i '/fastcharge/d' device/samsung_slsi/sepolicy/common/vendor/file_contexts

#build signing
git clone https://github.com/ProjectInfinity-X/vendor_infinity-priv_keys-template vendor/infinity-priv/keys && cd vendor/infinity-priv/keys && ./keys.sh
cd ../../..

#build
source build/envsetup.sh && lunch infinity_a21s-userdebug && m bacon
