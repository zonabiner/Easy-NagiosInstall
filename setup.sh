# Created by : Akhid Yanuar A.F
# Github : github.com/yanuarakhid

# Nagios 4 Instalation Setup

# Updating Repository
echo "Updating Repository"
apt update
# Instalation Dependencies
echo "Installing Dependencies"
apt install -y apache2 figlet apache2-utils php build-essential autoconf gcc libc6 make wget unzip make libssl-dev wget bc gawk dc snmp libnet-snmp-perl gettext
echo "Creating Nagios User and Group"
useradd nagios && groupadd nagcmd
usermod -a -G nagcmd nagios && usermod -a -G nagcmd www-data
echo "Begin Install and Build Nagios"
mkdir /opt/nagios
cp nagioscore.tar.gz /opt/nagios
cp nagios-plugins.tar.gz /opt/nagios
cd /opt/nagios
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
echo "Create Nagios Admin Password"
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
systemctl restart apache2.service
cd ..
tar zxf nagios-plugins.tar.gz
cd nagios-plugins-release-2.3.3/
./tools/setup
./configure
make
make install
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
systemctl enable nagios
systemctl reload nagios
systemctl start nagios
figlet "Installation Completed !"
echo "you can access the nagios web interface by accessing http://ip-address/nagios"
echo "Login with username=nagiosadmin and passwor=[you made before]"