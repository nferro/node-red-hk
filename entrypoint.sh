#!/bin/bash
[[ -e /var/run/dbus.pid ]] && sudo rm -f /var/run/dbus.pid
[[ -e /var/run/avahi-daemon/pid ]] && sudo rm -f /var/run/avahi-daemon/pid
[[ -e /var/run/dbus/system_bus_socket ]] && sudo rm -f /var/run/dbus/system_bus_socket
sudo service dbus restart
sudo service avahi-daemon restart
npm start -- --userDir /data
