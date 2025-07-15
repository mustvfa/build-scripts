#!/bin/bash
rm -rf out/

#build signing
git clone https://github.com/Evolution-X/vendor_evolution-priv_keys-template vendor/evolution-priv/keys && cd vendor/evolution-priv/keys && ./keys.sh
cd ../../..

# Build
source build/envsetup.sh && lunch lineage_a21s-bp2a-userdebug && m evolution
