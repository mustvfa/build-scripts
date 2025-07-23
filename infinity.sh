#!/bin/bash

echo "====================== BUILD STARTED ======================"

# ROM source init 
repo init --depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault
echo "==============================================================="
echo "---------------------- Repo Init Success ----------------------"
echo "==============================================================="

# Crave specific error
rm -rf prebuilts/clang/host/linux-x86

# Repo sync
curl https://raw.githubusercontent.com/accupara/docker-images/refs/heads/master/aosp/common/resync.sh | bash
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j4
echo "======================= Repo Sync Done =========================="

# errors fixs
rm -rf hardware/samsung/doze
rm -rf hardware/samsung/AdvancedDisplay

#alt to manifest
git clone -b lineage-22.2 https://github.com/LineageOS/android_device_samsung_slsi_sepolicy device/samsung_slsi/sepolicy
git clone -b lineage-22.2 https://github.com/LineageOS/android_hardware_samsung hardware/samsung
git clone -b lineage-22.2 https://github.com/LineageOS/android_hardware_samsung_slsi_libbt hardware/samsung_slsi/libbt
git clone -b lineage-22.2 https://github.com/LineageOS/android_hardware_samsung_slsi_scsc_wifibt_wifi_hal hardware/samsung_slsi/scsc_wifibt/wifi_hal
git clone -b lineage-22.2 https://github.com/LineageOS/android_hardware_samsung_slsi_scsc_wifibt_wpa_supplicant_lib hardware/samsung_slsi/scsc_wifibt/wpa_supplicant_lib
git clone -b lineage-22.2 https://github.com/LineageOS/android_hardware_samsung_slsi-linaro_config hardware/samsung_slsi-linaro/config
git clone -b lineage-22.2 https://github.com/LineageOS/android_hardware_samsung_slsi-linaro_exynos hardware/samsung_slsi-linaro/exynos
git clone -b lineage-22.2 https://github.com/LineageOS/android_hardware_samsung_slsi-linaro_exynos5 hardware/samsung_slsi-linaro/exynos5
git clone -b lineage-22.2 https://github.com/LineageOS/android_hardware_samsung_slsi-linaro_graphics hardware/samsung_slsi-linaro/graphics
git clone -b lineage-22.2 https://github.com/LineageOS/android_hardware_samsung_slsi-linaro_interfaces hardware/samsung_slsi-linaro/interfaces
git clone -b lineage-22.2 https://github.com/mustafa-dgaf/android_hardware_samsung_slsi-linaro_openmax hardware/samsung_slsi-linaro/openmax

#dt
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b lineage-22.2
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-22.2
git clone https://github.com/tryinsmth/android_device_samsung_a21s-common device/samsung/a21s-common -b lineage-22.2
git clone https://github.com/tryinsmth/android_device_samsung_a21s device/samsung/a21s -b lineage-22.2
git clone https://github.com/mustafa-dgaf/upstream_exynos850 kernel/samsung/exynos850 -b lineage-23.0

# fixs
cd kernel/samsung/exynos850
git reset --hard 39b0138abf46e230ed9d0fd6b9d01c606aa0379a
cd ../../..
chmod +r vendor/infinity/config/common_full_phone.mk

echo "==============================================================="
echo "----------- All Repositories Cloned Successfully -------------"
echo "==============================================================="

#build signing
git clone https://github.com/ProjectInfinity-X/vendor_infinity-priv_keys-template vendor/infinity-priv/keys && cd vendor/infinity-priv/keys && ./keys.sh
cd ../../..

#build
source build/envsetup.sh && lunch infinity_a21s-userdebug && m bacon
