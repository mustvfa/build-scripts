#!/bin/bash
echo "====================== BUILD STARTED ======================"

# ROM source init 
repo init -u https://github.com/Project-Mist-OS/manifest.git -b 16 --git-lfs
echo "==============================================================="
echo "---------------------- Repo Init Success ----------------------"
echo "==============================================================="

#manifest
git clone https://github.com/mustafa-dgaf/local_manifests- -b slsi .repo/local_manifests

# Repo sync
repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)
repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j4
echo "======================= Repo Sync Done =========================="


#dt
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b lineage-23.0
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-23.0
git clone https://github.com/tryinsmth/android_device_samsung_a21s-common device/samsung/a21s-common -b mist
git clone https://github.com/tryinsmth/android_device_samsung_a21s device/samsung/a21s -b mist
git clone https://github.com/mustafa-dgaf/upstream_exynos850 kernel/samsung/exynos850 -b lineage-23.0

# fixs
cd kernel/samsung/exynos850
git reset --hard 39b0138abf46e230ed9d0fd6b9d01c606aa0379a
cd ../../..
chmod +r vendor/mist/config/common_full_phone.mk

echo "==============================================================="
echo "----------- All Repositories Cloned Successfully -------------"
echo "==============================================================="

#build
source build/envsetup.sh && mistify a21s userdebug && mist b

echo "==============================================================="
echo "-----------The Build Is Done Succefully Build Mafia------------"
echo "==============================================================="
