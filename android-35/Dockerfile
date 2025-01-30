FROM debian:bookworm

ARG DEVICE
ARG ARCH
ARG VARIANT

# Install minimal requirements
RUN apt update && apt install -y \
    software-properties-common \
    locales \
    ca-certificates \
    sudo \
    zip \
    iproute2 \
    curl \
    libpulse0 \
    libx11-6 \
    libgl1-mesa-glx \
    libxcb-cursor0 \
    openjdk-17-jdk

# Install 32 bits dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y libc6-i386 lib32stdc++6 lib32gcc-s1 lib32ncurses6 lib32z1 && \
    apt-get clean

# Setup environment
ENV ANDROID_SDK_ROOT="/opt/android-sdk-linux"
ENV ANDROID_VERSION="android-35"
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools:${ANDROID_SDK_ROOT}/cmdline-tools/bin:/opt/platform-tools"
ENV JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"

# Install Android SDK
RUN curl -Lso android-sdk.zip https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip && \
    mkdir -p /opt/android-sdk-linux && \
    unzip android-sdk.zip -d /opt/android-sdk-linux && \
    rm -rf android-sdk.zip

RUN mkdir ~/.android && touch ~/.android/repositories.cfg

# Selecting sdk version licenses
RUN yes | sdkmanager --licenses --sdk_root=${ANDROID_SDK_ROOT}
RUN sdkmanager "build-tools;34.0.0" --sdk_root=${ANDROID_SDK_ROOT}
RUN sdkmanager "platform-tools" "tools" --sdk_root=${ANDROID_SDK_ROOT}
RUN sdkmanager "platforms;$ANDROID_VERSION" --sdk_root=${ANDROID_SDK_ROOT}
RUN sdkmanager "emulator" "extras;google;simulators" --sdk_root=${ANDROID_SDK_ROOT}
RUN sdkmanager "system-images;${ANDROID_VERSION};${VARIANT};${ARCH}" --sdk_root=${ANDROID_SDK_ROOT}
RUN yes | sdkmanager --licenses --sdk_root=${ANDROID_SDK_ROOT}

ENV LD_LIBRARY_PATH="/opt/android-sdk-linux/emulator/lib64/qt/lib/:${LD_LIBRARY_PATH}"

RUN ${ANDROID_SDK_ROOT}/cmdline-tools/bin/avdmanager create avd \
    --device ${DEVICE} \
    --name default \
    --package "system-images;${ANDROID_VERSION};${VARIANT};${ARCH}"

RUN sed -i s@android-sdk-linux\/@@g /root/.android/avd/default.avd/config.ini
RUN sed -i s@hw.keyboard=no@hw.keyboard=yes@g /root/.android/avd/default.avd/config.ini

ENTRYPOINT [ \
    "/opt/android-sdk-linux/emulator/emulator", \
    "-verbose", \
    "-debug", "init", \
    "-avd", "default", \
    "-engine", "qemu2", \
    "-screen", "touch", \
    "-gpu", "swiftshader_indirect", \
    "-memory", "4096", \
    "-netspeed", "full", \
    "-partition-size", "1024", \
    "-qemu" \
]
