FROM nodered/node-red:1.1.3
USER root

# e.g. install here gosu via https://github.com/tianon/gosu/blob/master/INSTALL.md
# ...
# fix non-root usage
#RUN chown root:node-red /usr/local/bin/gosu && chmod +s /usr/local/bin/gosu

RUN apk update
#RUN apk install -y apt-utils build-essential python make g++ avahi-daemon avahi-discover libnss-mdns libavahi-compat-libdnssd-dev iputils-ping
RUN apk add avahi avahi-compat-libdns_sd avahi-dev dbus

# please replace diskstation with your server name
RUN sed -i "s/#enable-dbus=yes/enable-dbus=yes/g" /etc/avahi/avahi-daemon.conf && sed -i "s/.*host-name.*/host-name=pi3/" /etc/avahi/avahi-daemon.conf
RUN mkdir -p /var/run/dbus && mkdir -p /var/run/avahi-daemon
RUN chown messagebus:messagebus /var/run/dbus && chown avahi:avahi /var/run/avahi-daemon && dbus-uuidgen --ensure

RUN apk add sudo
RUN echo "node-red ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/00_node-red

COPY entrypoint.sh /usr/src/node-red
RUN chmod 755 /usr/src/node-red/entrypoint.sh

USER node-red
RUN npm install node-red-contrib-homekit-bridged \
                node-red-contrib-lgtv \
                node-red-contrib-yeelight \
                node-red-contrib-mi-devices \
                node-red-contrib-broadlink-control \
                node-red-contrib-meobox \
                node-red-dashboard \
                node-red-node-ui-list \
                node-red-contrib-persist
                

# arp stuff, to move upper
#RUN sudo apt-get install net-tools
#RUN npm install node-red-contrib-arp

ENTRYPOINT /usr/src/node-red/entrypoint.sh
