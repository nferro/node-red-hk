FROM nodered/node-red-docker:rpi-v8
USER root

# e.g. install here gosu via https://github.com/tianon/gosu/blob/master/INSTALL.md
# ...
# fix non-root usage
#RUN chown root:node-red /usr/local/bin/gosu && chmod +s /usr/local/bin/gosu

RUN apt-get update -y
RUN apt-get install -y apt-utils build-essential python make g++ avahi-daemon avahi-discover libnss-mdns libavahi-compat-libdnssd-dev iputils-ping

# please replace diskstation with your server name
RUN sed -i "s/#enable-dbus=yes/enable-dbus=yes/g" /etc/avahi/avahi-daemon.conf && sed -i "s/.*host-name.*/host-name=pi3/" /etc/avahi/avahi-daemon.conf
RUN mkdir -p /var/run/dbus && mkdir -p /var/run/avahi-daemon
RUN chown messagebus:messagebus /var/run/dbus && chown avahi:avahi /var/run/avahi-daemon && dbus-uuidgen --ensure

RUN apt-get install sudo
RUN echo "node-red ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/00_node-red

USER node-red
RUN npm install node-red-contrib-homekit-bridged

# arp stuff, to move upper
RUN sudo apt-get install net-tools
RUN npm install node-red-contrib-arp

# LGTV
RUN npm install node-red-contrib-lgtv
RUN npm install node-red-node-wol

# Yeelight
RUN npm install node-red-contrib-yeelight
RUN npm install node-red-contrib-mi-devices

# Broadlink
RUN npm install node-red-contrib-broadlink-control

# dashboard
RUN npm i node-red-dashboard

# meobox
RUN npm i node-red-contrib-meobox

RUN npm i node-red-node-darksky

RUN npm i node-red-contrib-persist

COPY entrypoint.sh /usr/src/node-red
RUN sudo chmod 755 /usr/src/node-red/entrypoint.sh
ENTRYPOINT /usr/src/node-red/entrypoint.sh
