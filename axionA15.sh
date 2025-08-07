#!/bin/bash
echo "====================== BUILD STARTED ======================"

# ROM source init 
repo init -u https://github.com/AxionAOSP/android.git -b lineage-22.2 --git-lfs
echo "==============================================================="
echo "---------------------- Repo Init Success ----------------------"
echo "==============================================================="

#local manifests
git clone https://github.com/mustvfa/local_manifests- -b slsi .repo/local_manifests

# Crave specific error
rm -rf prebuilts/clang/host/linux-x86

# Repo sync
curl https://raw.githubusercontent.com/accupara/docker-images/refs/heads/master/aosp/common/resync.sh | bash
repo sync -j4
echo "======================= Repo Sync Done =========================="

#errors fixs
rm -rf vendor/gapps/arm/Android.bp
rm -rf vendor/gapps/arm64/Android.bp
rm -rf build/envsetup.sh
git clone https://github.com/mustvfa/android_build bruh/
cp bruh/envsetup.sh build/
rm -rf bruh/
#dt
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b lineage-23.0
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-23.0
git clone https://github.com/mustvfa/android_device_samsung_a21s-common device/samsung/a21s-common -b lineage-23.0
git clone https://github.com/mustvfa/android_device_samsung_a21s device/samsung/a21s -b axion
git clone https://github.com/mustvfa/upstream_exynos850 kernel/samsung/exynos850 -b lineage-23.0

# fixs
cd kernel/samsung/exynos850
git reset --hard 39b0138abf46e230ed9d0fd6b9d01c606aa0379a
cd ../../..

echo "==============================================================="
echo "----------- All Repositories Cloned Successfully -------------"
echo "==============================================================="
#build
source build/envsetup.sh && axionSync
axion a21s va && ax -br -j24

rm -rf out/target/product/a21s/lineage_a21s-ota.zip
echo "==============================================================="
echo "-----------The Build Is Done Succefully Build Mafia------------"
echo "==============================================================="
