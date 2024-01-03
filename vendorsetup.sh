echo "Cloning Max Shot Device Tree and stuff"
git clone https://github.com/danielcristofer/kernel_asus_A001D -b 11 kernel/asus/A001D --depth=1
git clone https://github.com/danielcristofer/vendor_asus_A001D -b lineage-18.1 vendor/asus/A001D
git clone https://github.com/danielcristofer/external_ant-wireless_antradio-library external/ant-wireless/antradio-library

echo "Cloning HALS"
rm -rf hardware/qcom-caf/msm8996/audio
git clone https://github.com/AospExtended/platform_hardware_qcom_audio -b 12.x-caf-msm8996 hardware/qcom-caf/msm8996/audio
rm -rf hardware/qcom-caf/msm8996/media
git clone https://github.com/AospExtended/platform_hardware_qcom_media -b 12.x-caf-msm8996 hardware/qcom-caf/msm8996/media
rm -rf hardware/qcom-caf/msm8996/display
git clone https://github.com/AospExtended/platform_hardware_qcom_display -b 12.x-caf-msm8996 hardware/qcom-caf/msm8996/display

echo "Applying patchs for 3.18"
cd frameworks/native
git fetch https://github.com/phhusson/platform_frameworks_native android-12.0.0_r16-phh
git cherry-pick 11160ca79ca44375af895f70af14bb2af909aa77
git cherry-pick --abort
git cherry-pick 40b43f648327b3fc13a18f0f28da54b34db11c79
git cherry-pick --abort
cd ../..
cd system/netd
git fetch https://github.com/phhusson/platform_system_netd android-12.0.0_r15-phh
git cherry-pick 5f6bfe7390eafc659b36996398deb670436fc9df
git cherry-pick --abort
cd ..
cd bpf
git fetch https://github.com/phhusson/platform_system_bpf android-12.0.0_r15-phh
git cherry-pick 2f0ac4a3596fc20c94828a01534fd77d12ec20dd
git cherry-pick --abort
cd ../..
cd external/selinux
git fetch https://github.com/phhusson/platform_external_selinux android-12.0.0_r16-phh android-12.0.0_r26-phh android-12.0.0_r28-phh
git cherry-pick 010b772593639c9fdb4392ac976d5f3da4ea5e57
git cherry-pick --abort
cd ../..
echo "If cherry-pick fails use https://gerrit.aicp-rom.com/q/topic:twelve-ultralegacy-devices"
echo "Done"
