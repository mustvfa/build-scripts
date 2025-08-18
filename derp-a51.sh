repo init -u https://github.com/DerpFest-LOS/android_manifest.git -b 15.2 --git-lfs 
git clone https://github.com/mustafa-dgaf/local_manifests- -b slsi .repo/local_manifests
rm -rf prebuilts/clang/host/linux-x86
/opt/crave/resync.sh
repo sync
git clone https://github.com/Exynos9611Development/android_device_samsung_a51 device/samsung/a51
git clone https://github.com/Exynos9611Development/android_vendor_samsung_a51 vendor/samsung/a51
git clone https://github.com/Exynos9611Development/android_kernel_samsung_universal9611 kernel/samsung/universal9611
git clone https://github.com/Exynos9611Development/android_vendor_samsung_universal9611-common vendor/samsung/universal9611-common
git clone https://github.com/Exynos9611Development/android_device_samsung_universal9611-common device/samsung/universal9611-common
source build/envsetup.sh
lunch lineage_a51-bp1a-userdebug && mka derp
