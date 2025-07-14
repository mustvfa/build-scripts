#!/bin/bash
#!/bin/bash

echo "====================== BUILD STARTED ======================"

# ROM source init
repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault
echo "==============================================================="
echo "---------------------- Repo Init Success ----------------------"
echo "==============================================================="

# Local manifests
git clone https://github.com/samsungexynos850/local_manifests -b aosp .repo/local_manifests

# Clean clang before sync
rm -rf prebuilts/clang/host/linux-x86

# Repo sync
/opt/crave/resync.sh
echo "======================= Repo Sync Done =========================="

# Clone device/vendor/kernel trees
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common vendor/samsung/a21s-common -b lineage-22.2
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-22.2
git clone https://github.com/tryinsmth/android_device_samsung_a21s-common device/samsung/a21s-common -b lineage-22.2
git clonehttps://github.com/tryinsmth/android_device_samsung_a21s device/samsung/a21s -b lineage-22.2
git clone https://github.com/samsungexynos850/upstream_exynos850 kernel/samsung/exynos850 -b lineage-23.0

echo "==============================================================="
echo "----------- All Repositories Cloned Successfully -------------"
echo "==============================================================="

# Export build info
export BUILD_USERNAME=Mustafa
export BUILD_HOSTNAME=crave

#build signing
git clone https://github.com/ProjectInfinity-X/vendor_infinity-priv_keys-template vendor/infinity-priv/keys && cd vendor/infinity-priv/keys && ./keys.sh
cd ../../..

#build
source build/envsetup.sh && lunch infinity_a21s-userdebug && m bacon
