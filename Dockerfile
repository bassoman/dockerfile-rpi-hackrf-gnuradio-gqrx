# Designed for use in Docker running on a RaspberryPi
#
# Installs HackRF tools. I.E. hackrf_info
# https://github.com/mossmann/hackrf/wiki/libHackRF-API
#
# Installs GNURadio and GNURadio-dev libraries
#
# Installs GQRX ( SDR Application )
#
# Run GQRX with the command: ./gqrx
#
# Run container with the command: docker run -it --privileged --name hackrf -v /dev/bus/usb:/dev/bus/usb barrymarkgee/rpi-hackrf-gnuradio-gqrx

FROM armhf/ubuntu

MAINTAINER Barry Gee

ENTRYPOINT exec /bin/bash

RUN apt-get update && apt-get install -y \
                                      git \
                                      build-essential \
                                      cmake \
                                      libusb-1.0-0-dev \
                                      liblog4cpp5-dev \
                                      libboost-dev \
                                      libboost-system-dev \
                                      libboost-thread-dev \
                                      libboost-program-options-dev \
                                      swig \
                                      pkg-config

# Install HackRF tools
RUN apt-get install -y \
                    hackrf \
                    libhackrf-dev \
                    libhackrf0



# Install GNURadio
RUN apt-get install -y \
                    gnuradio \
                    gnuradio-dev


# Install OsmoSDR lib
RUN mkdir ~/sdr && \
          cd ~/sdr && \
          git clone git://git.osmocom.org/gr-osmosdr && \
          cd gr-osmosdr && \
          mkdir build && \
          cd build && \
          cmake ../ && \
          make && \
          make install && \
          ldconfig


# Install RTL-SDR tools
RUN cd ~/sdr && \
       git clone git://git.osmocom.org/rtl-sdr.git && \
       cd rtl-sdr && \
       mkdir build && \
       cd build && \
       cmake ../ &&\
       make && \
       make install && \
       ldconfig && \
       cmake ../ -DINSTALL_UDEV_RULES=ON


# Install GQRX
RUN apt-get install -y \
                    qt5-default \
                    qttools5-dev-tools

RUN cd ~/sdr && \
       git clone https://github.com/csete/gqrx.git && \
       cd gqrx && \
       mkdir build && \
       cd build && \
       qmake ../ && \
       make && \
       ldconfig
