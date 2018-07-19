FROM ubuntu:16.04

# Install minimal requirements
RUN apt-get update && apt-get install -y \
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
    openjdk-8-jdk

# Install 32 bits dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 && \
    apt-get clean

# Setup environment
ENV ANDROID_HOME /opt/android-sdk-linux
ENV ANDROID_VERSION android-25
ENV ANDROID_ABI google_apis
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Install Android SDK
RUN curl -Lso android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && \
    mkdir -p /opt/android-sdk-linux && \
    unzip android-sdk.zip -d /opt/android-sdk-linux && \
    rm -f android-sdk.zip

RUN mkdir ~/.android && touch ~/.android/repositories.cfg

# Selecting sdk version licenses
RUN yes | sdkmanager --licenses
RUN sdkmanager "build-tools;27.0.1"
RUN sdkmanager "platform-tools" "tools"
RUN sdkmanager "platforms;$ANDROID_VERSION"
RUN sdkmanager "emulator" "extras;google;simulators"
RUN sdkmanager "system-images;$ANDROID_VERSION;$ANDROID_ABI;x86"
RUN yes | sdkmanager --licenses

ENV LD_LIBRARY_PATH="/opt/android-sdk-linux/emulator/lib64/qt/lib/:$LD_LIBRARY_PATH"

RUN ${ANDROID_HOME}/tools/bin/avdmanager create avd \
    --device pixel \
    --name EMU01 \
    --abi ${ANDROID_ABI}/x86 \
    --package "system-images;$ANDROID_VERSION;$ANDROID_ABI;x86"

RUN echo "hw.keyboard=yes" >> /root/.android/avd/EMU01.avd/config.ini

ENTRYPOINT ${ANDROID_HOME}/tools/emulator \
    -verbose \
    -debug init \
    -avd EMU01 \
    -engine qemu2 \
    -screen 'touch' \
    -gpu on \
    -memory 2048 \
    -netspeed full \
    -partition-size 1024 \
    -qemu
