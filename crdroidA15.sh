#!/bin/bash
echo "====================== BUILD STARTED ======================"

# ROM source init 
repo init -u https://github.com/crdroidandroid/android.git -b 15.0 --git-lfs
echo "==============================================================="
echo "---------------------- Repo Init Success ----------------------"
echo "==============================================================="

#manifest
git clone https://github.com/mustvfa/local_manifests -b 22.2 .repo/local_manifests

# Repo sync
repo sync -j$(nproc --all)
repo sync -j4
echo "======================= Repo Sync Done =========================="

#dt
git clone https://github.com/crdroidandroid/android_device_samsung_a21s-common device/samsung/a21s-common -b 15.0
git clone https://github.com/crdroidandroid/android_device_samsung_a21s device/samsung/a21s -b 15.0
git clone https://github.com/crdroidandroid/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b 15.0
git clone https://github.com/crdroidandroid/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b 15.0
git clone https://github.com/crdroidandroid/android_kernel_samsung_exynos850 kernel/samsung/exynos850 -b 15.0

echo "==============================================================="
echo "----------- All Repositories Cloned Successfully -------------"
echo "==============================================================="

#build
source build/envsetup.sh && brunch a21s userdebug

echo "==============================================================="
echo "-----------The Build Is Done Succefully Build Mafia------------"
echo "==============================================================="
