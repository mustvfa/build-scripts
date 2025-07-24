rm -rf hardware/samsung/doze
rm -rf hardware/samsung/AdvancedDisplay
rm -rf hardware/samsung/hidl/fastcharge
rm -rf hardware/samsung/hidl/touch
chmod +r vendor/infinity/config/common_full_phone.mk
#build
source build/envsetup.sh && lunch infinity_a21s-userdebug && m bacon
