#!/bin/bash

# Created by : Akhid Yanuar A.F
# Github : github.com/yanuarakhid
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Nagios 4 Instalation Setup


# Updating Repository
echo -e "\e[32mUpdating Repository\e[39m"
apt update
# Instalation Dependencies
echo -e "\e[32mInstalling Dependencies\e[39m"
apt install -y apache2 figlet apache2-utils php build-essential autoconf gcc libc6 make wget unzip make libssl-dev wget bc gawk dc snmp libnet-snmp-perl gettext
echo -e "\e[32mCreating Nagios User and Group\e[39m"
useradd nagios && groupadd nagcmd
usermod -a -G nagcmd nagios && usermod -a -G nagcmd www-data
echo -e "\e[32mBegin Install and Build Nagios\e[39m"
cp nagioscore.tar.gz /tmp
cp nagios-plugins.tar.gz /tmp
cd /tmp
tar xzf nagioscore.tar.gz
cd nagioscore-nagios-4.4.6/
./configure --with-nagios-group=nagios --with-command-group=nagcmd --with-httpd_conf=/etc/apache2/sites-enabled/
make all
make install
make install-init
make install-commandmode
make install-config
make install-webconf
a2enmod rewrite && a2enmod cgi
echo -e "\e[32mCreate Nagios Admin Password\e[39m"
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
cd ..
tar zxf nagios-plugins.tar.gz
cd nagios-plugins-release-2.3.3/
./tools/setup
./configure
make
make install
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
systemctl enable nagios
systemctl start nagios
systemctl restart apache2
cd ~
figlet "Installation Completed !"
echo -e "\e[32mYou can access the nagios web interface by accessing http://ip-address/nagios"
echo -e "Login with username=nagiosadmin and password=[you made before]\e[39m"
