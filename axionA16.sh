#!/bin/bash

# init
repo init -u https://github.com/AxionAOSP/android.git -b lineage-23.1 --git-lfs

# local manifests
git clone https://github.com/mustvfa/local_manifests- -b slsi .repo/local_manifests

# Repo sync
curl https://raw.githubusercontent.com/accupara/docker-images/refs/heads/master/aosp/common/resync.sh | bash
repo sync -j4
echo "======================= Repo Sync Done =========================="

#dt
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b lineage-23.1
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-23.1
git clone https://github.com/mustvfa/android_device_samsung_a21s-common device/samsung/a21s-common -b axion
git clone https://github.com/mustvfa/android_device_samsung_a21s device/samsung/a21s -b axion
git clone https://github.com/LineageOS/android_kernel_samsung_exynos850 kernel/samsung/exynos850 -b lineage-23.2

echo "==============================================================="
echo "----------- All Repositories Cloned Successfully -------------"
echo "==============================================================="
#build
source build/envsetup.sh && axionSync
axion a21s gms core && gk -s
ax -br

echo "==============================================================="
echo "-----------------The Build Is Done Succefully------------------"
echo "==============================================================="
