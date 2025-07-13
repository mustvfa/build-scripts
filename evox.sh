#!/bin/bash
echo "====================== BUILD STARTED ======================"
croot && git clone https://github.com/Evolution-X/vendor_evolution-priv_keys-template vendor/evolution-priv/keys && cd vendor/evolution-priv/keys && ./keys.sh
cd ../../..
cd bionic && git revert b4ff0ab97d633f532480977b079ff26ba19ecd64 && cd ..
# Build
source build/envsetup.sh && lunch lineage_a21s-bp2a-userdebug && m evolution
