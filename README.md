# ez-android
Android emulator based on official SDK.

### Requirements

There are two ways to have a working adb on your host:
* Remove your local version of adb and replace it by the sdk adb version
* Change your PATH variable into `PATH=<android_sdk_path>/platform-tools/:$PATH`

### Details

* Use the x86 architecture for emulator
* Use openjdk java 8
* Download android SDK from https://dl.google.com
* AVD directory in docker: /root/.android/avd/EMU01.avd
* Emulator properties: qemu with 2Gb RAM in verbose mode

### Build command
`docker build -t android-emulator:nougat .`

### Examples of running

* Requirements
`xhost +local:docker`

* Normal run (without session saving)
```
docker run \
    --rm \
    --detach \
    --privileged \
    --network host \
    -e DISPLAY=unix$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    android-emulator:nougat
```

* Session saving run
```
docker run \
    --privileged \
    --network host \
    -e DISPLAY=unix$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /home/user/EMU01.avd:/root/.android/avd/EMU01.avd \
    android-emulator:nougat
```
