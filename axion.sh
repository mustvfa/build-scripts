#!/bin/bash
echo "====================== BUILD STARTED ======================"

# ROM source init 
repo init -u https://github.com/AxionAOSP/android.git -b lineage-22.2 --git-lfs
echo "==============================================================="
echo "---------------------- Repo Init Success ----------------------"
echo "==============================================================="

#
git clone https://github.com/mustafa-dgaf/local_manifests- -b slsi .repo/local_manifests

# Repo sync
repo sync -j24
repo sync -j4
echo "======================= Repo Sync Done =========================="

#dt
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b lineage-22.2
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-22.2
git clone https://github.com/mustafa-dgaf/android_device_samsung_a21s-common device/samsung/a21s-common -b lineage-22.2
git clone https://github.com/mustafa-dgaf/android_device_samsung_a21s device/samsung/a21s -b lineage-22.2
git clone https://github.com/mustafa-dgaf/upstream_exynos850 kernel/samsung/exynos850 -b lineage-23.0

# fixs
cd kernel/samsung/exynos850
git reset --hard 39b0138abf46e230ed9d0fd6b9d01c606aa0379a
cd ../../..

echo "==============================================================="
echo "----------- All Repositories Cloned Successfully -------------"
echo "==============================================================="

#build signing
gk -s

echo "==============================================================="
echo "-------------------- The Build Got Signed----------------------"
echo "==============================================================="

#build
source build/envsetup.sh && axion a21s userdebug va && axionSync &&ax -br -j24

echo "==============================================================="
echo "-----------The Build Is Done Succefully Build Mafia------------"
echo "==============================================================="
