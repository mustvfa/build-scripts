#!/bin/bash

# ROM source init 
repo init -u https://github.com/AxionAOSP/android.git -b lineage-23.1 --git-lfs

#local manifests
git clone https://github.com/mustvfa/local_manifests- -b slsi .repo/local_manifests

# Repo sync
repo sync
repo sync -j4
echo "======================= Repo Sync Done =========================="

#errors fixs
rm -rf device/samsung_slsi/sepolicy/common/vendor/hal_lineage_fastcharge_default.te
sed -i '/fastcharge/d' device/samsung_slsi/sepolicy/common/vendor/file_contexts

#dt
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b lineage-23.1
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-23.1
git clone https://github.com/mustvfa/android_device_samsung_a21s-common device/samsung/a21s-common -b los-23.0
git clone https://github.com/mustvfa/android_device_samsung_a21s device/samsung/a21s -b axion
git clone https://github.com/LineageOS/android_kernel_samsung_exynos850 kernel/samsung/exynos850 -b lineage-23.1

echo "==============================================================="
echo "----------- All Repositories Cloned Successfully -------------"
echo "==============================================================="
#build
source build/envsetup.sh && axionSync
axion a21s && ax -br

rm -rf out/target/product/a21s/lineage_a21s-ota.zip
echo "==============================================================="
echo "-----------The Build Is Done Succefully Build Mafia------------"
