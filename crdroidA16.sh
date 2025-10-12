#!/bin/bash
echo "====================== BUILD STARTED ======================"

# ROM source init 
repo init -u https://github.com/crdroidandroid/android.git -b 16.0 --git-lfs --no-clone-bundle
echo "==============================================================="
echo "---------------------- Repo Init Success ----------------------"
echo "==============================================================="

#clean
rm -rf device/samsung/a21s-common
rm -rf device/samsung/a21s
rm -rf vendor/samsung/a21s-common
rm -rf vendor/samsung/a21s
rm -rf kernel/samsung/exynos850
rm -rf .repo/local_manifests

#manifest
git clone https://github.com/mustvfa/local_manifests -b slsi .repo/local_manifests

# Repo sync
repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)
repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j4
echo "======================= Repo Sync Done =========================="

# a16 fix
rm -rf  hardware/samsung_slsi-linaro/openmax
git clone -b lineage-22.2 https://github.com/mustvfa/android_hardware_samsung_slsi-linaro_openmax hardware/samsung_slsi-linaro/openmax

#dt
git clone https://github.com/crdroidandroid/android_device_samsung_a21s-common device/samsung/a21s-common -b 16.0
git clone https://github.com/crdroidandroid/android_device_samsung_a21s device/samsung/a21s -b 16.0
git clone https://github.com/crdroidandroid/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b 16.0
git clone https://github.com/crdroidandroid/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b 16.0
git clone https://github.com/crdroidandroid/android_kernel_samsung_exynos850 kernel/samsung/exynos850 -b 16.0

echo "==============================================================="
echo "----------- All Repositories Cloned Successfully -------------"
echo "==============================================================="

#build
source build/envsetup.sh && brunch a21s userdebug

echo "==============================================================="
echo "-----------The Build Is Done Succefully Build Mafia------------"
echo "==============================================================="
