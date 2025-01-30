# ez-android
Android emulator based on official SDK.

### Requirements

* docker (and/or docker-compose)
* X server running on your host (with DISPLAY variable)
* `xhost +local:docker` before running container

### Optional

* adb (android-35 version)
* custom docker-compose.yaml to add other services

### Details

* Use the x86_64 architecture for emulator
* Use android 35
* Use openjdk java 17
* Download android SDK from https://dl.google.com
* AVD directory in docker: /root/.android/avd/default.avd
* Emulator properties: qemu with 4Gb RAM in verbose mode

### How to use ?

1. Custom DEVICE, ARCH and ABI in docker-compose.yaml

```
args:
  DEVICE: pixel_7
  ARCH: x86_64
  VARIANT: google_apis
```
**DEVICE** : _automotive_1024p_landscape, desktop_large, desktop_medium, desktop_size, medium_phone, medium_tablet, pixel, pixel_2, pixel_3, pixel_4, pixel_5, pixel_6, pixel_7, pixel_c, pixel_tablet, pixel_xl, resizable, small_phone, tv_1080p, tv_4k, tv_720p, wearos_large_round, wearos_rect, wearos_small_round, wearos_square_ \
**ARCH** : _x86, x86_64, arm64-v8a_ \
**VARIANT** : _default, google_apis, google_apis_play_store, google_atd, aosp_atd, android_wear_

2. Build docker image

```
docker compose build
```

3. Running

###### Service emulator run (persistant data in android-emulator-data docker volume)
```
docker compose up
```

###### One-time emulator run
```
docker run \
    --rm \
    --privileged \
    --network host \
    -e DISPLAY=$DISPLAY \
    ez-android-emulator
```
