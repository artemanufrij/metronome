# Metronome

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.artemanufrij.metronome)

### A simple metronome designed for [elementary OS](https://elementary.io)
![screenshot](Screenshot.png)

### Building and Installation

You'll need the following dependencies:
* cmake
* cmake-elementary
* debhelper
* libgstreamer1.0-dev
* libgranite-dev
* valac

It's recommended to create a clean build environment

    mkdir build
    cd build/
    
Run `cmake` to configure the build environment and then `make` to build

    cmake -DCMAKE_INSTALL_PREFIX=/usr ..
    make

To install, use `make install`, then execute with `com.github.artemanufrij.metronome`
