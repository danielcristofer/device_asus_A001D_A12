# LineageOS 19.1 — Asus Zenfone Max Shot (A001D)

> ⚠️ **Unofficial/Experimental Build.** Distributed for community testing purposes. Use at your own risk and back up your data before installing.

## About this build

| | |

|---|---|

| **Device** | Asus Zenfone Max Shot (A001D) |

| **Base** | LineageOS 19.1 (Android 12) |

| **Kernel** | Prebuilt 3.18 (legacy, not recompiled) |

| **SELinux** | **Enforcing** ✅ |

| **Variant** | `userdebug` (test-keys) |

| **Partitions** | Static/physical (system, vendor, product, and system_ext folded inside `/system`) |

This build underwent an extensive sepolicy correction process, originally inherited from a tree with several inconsistencies (corrupted rules, partition scheme incompatible with the actual hardware, remnants of ports from other Android versions). The device **currently runs in enforcing mode**, with the customized sepolicy revised and tested over multiple denial capture cycles.

## How to help test

This ROM is being distributed precisely to expand test coverage. If you encounter a problem not listed below, please open an issue with:
- Steps to reproduce
- Relevant log, if possible (`adb logcat`, or `adb logcat -d | grep "avc: denied"` in case of suspected permission blocking)
- If the problem also occurs using an alternative app (e.g., camera, browser) to help isolate the cause

## Known Issues

### 📷 Camera — Dark Photos with Flash
When taking photos with the flash enabled using the default camera app (Snap), the result comes out dark even with the flash visibly firing. This already occurred in previous builds based on Android 11 on this device; it is not a regression of this version.

- **Probable cause:** The flash LED kernel driver (`msm_flash.c`) is limiting (*clamping*) the requested current to a very low value. The fix would require recompiling the kernel — it is not adjustable via device tree/HAL.

- **Workaround:** Use the **Open Camera** app (available on F-Droid/Play Store), which does not present this problem.

### 👆 Biometrics — First fingerprint registered in the system is not recognized
When configuring the fingerprint **for the first time** in a clean installation, the fingerprint is successfully registered but is not recognized in subsequent unlock attempts. Registering a second fingerprint (or re-registering) solves the problem — from then on, everything works normally, indefinitely.

- **Probable cause:** The kernel does not have complete support for cgroup v2 (missing `CONFIG_MEMCG`, `CONFIG_CGROUP_PIDS`, `CONFIG_CGROUP_BPF`), which prevents the correct assembly of the unified cgroup hierarchy. This seems to interfere with the Keystore/Gatekeeper initialization specifically during the system's first sensitive biometric operation.

- **Workaround:** After setting up the first fingerprint, register a second one (it can be the same finger in a slightly different position) before relying on biometric unlocking.

### 📻 FM Radio — Recording does not generate a valid audio file
When recording audio using the FM Radio app, the process appears to occur normally (interface shows recording in progress), but the final file is not generated correctly.

- **Cause:** The `FmService` service experiences a native crash (`SIGABRT`) upon termination (`FmService.powerDown`), inconsistently interrupting the recorder session.

- **Status:** No known workaround at this time; requires further investigation (possible incompatibility between the radio app binary and the tuner driver in this kernel).

### 🌐 Default browser (Jelly) — Fullscreen notification freezes on first playback
When playing a fullscreen video for the first time in the Jelly browser (LineageOS default), the fullscreen notification (with the "Got it" button) keeps appearing and disappearing repeatedly, preventing you from tapping the button to close it.

**Workaround:** Use another browser (e.g., Chrome), where the behavior occurs normally.

## What already works well

- Calls, SMS, mobile data, and network signal
- Wi-Fi and Bluetooth
- Camera (photos without flash) and gallery
- Biometrics (after initial double registration, see above)
- GApps (Google Play Services, Chrome, GSA) and third-party apps in general
- SELinux enforcing with no known remaining denials

## Technical notes for developers

- The prebuilt kernel (3.18) could not be recompiled in the current build environment (Ubuntu 20.04 + Clang); this kernel requires an old GCC toolchain (e.g., `aarch64-linux-android-4.9`), incompatible with modern AOSP tools without additional porting work.

- The camera/flash and cgroup2 (biometrics) problems are rooted in the kernel and will only be resolved with a successful recompilation, planned as future work in a separate branch.

The device does not natively support dynamic partitions—the original partition table does not include a `super` partition. The device tree has been corrected to use static partitions.
