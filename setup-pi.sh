#!/bin/bash

echo "Installing dependencies on pi..."
ssh pi@raspberrypi "sudo apt-get install graphicsmagick-imagemagick-compat darkice icecast2 screen libmp3lame-dev libasound2-dev && mkdir raspbaby"
ssh pi@raspberrypi "sudo apt-get build-dep darkice"
echo "Copying code to pi..."
scp -rd upstart/ darkice/ mjpg-streamer/ darkice-conf/ stream-audio.sh stream-video.sh rc.local pi@raspberrypi:raspbaby/ 
echo "Compiling mjpg-streamer..."
ssh pi@raspberrypi "cd raspbaby/mjpg-streamer && make"
echo "Compling darkice..."
ssh pi@raspberrypi "cd raspbaby/darkice && ./configure --prefix=/usr --sysconfdir=/usr/share/doc/darkice/examples --with-vorbis-prefix=/usr/lib/arm-linux-gnueabihf/ --with-jack-prefix=/usr/lib/arm-linux-gnueabihf/ --with-alsa-prefix=/usr/lib/arm-linux-gnueabihf/ --with-faac-prefix=/usr/lib/arm-linux-gnueabihf/ --with-aacplus-prefix=/usr/lib/arm-linux-gnueabihf/ --with-samplerate-prefix=/usr/lib/arm-linux-gnueabihf/ --with-lame-prefix=/usr/lib/arm-linux-gnueabihf/ CFLAGS='-march=armv6 -mfpu=vfp -mfloat-abi=hard' && make && sudo make install"
echo "Setting up icecast2..."
ssh pi@raspberrypi "cd raspbaby && sudo cp darkice-conf/icecast-default /etc/default/icecast2 && sudo cp darkice-conf/icecast.xml /etc/icecast2/icecast.xml && sudo /etc/init.d/icecast2 restart"
echo "Bumping capture volume up..."
ssh pi@raspberrypi "amixer -c 1 set Mic 10%"
echo "Updating rc.local..."
ssh pi@raspberrypi "sudo cp raspbaby/rc.local /etc/rc.local"
echo "Rebooting pi..."
ssh pi@raspberrypi "sudo reboot"
