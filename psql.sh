#!/bin/bash
#Variable Creation
echo "Creating variables for use throughout the PSQL installation process"
packages=('git' 'gcc' 'tar' 'gzip' 'libreadline5' 'make' 'zlib1g' 'zlib1g-dev' 'flex' 'bison' 'perl' 'python3' 'tcl' 'gettext' 'odbc-postgre>dfolder='/postgres/data'
gitloc='git://git.postgresql.org/git/postgresql.git'
sysuser='postgres'
helloscript='/home/vagrant/Ansible/hello.sql'
Logfile='psqlinstall-log'

#package installation
echo "Updating server..."
sudo apt-get update -y >> $logfile
#pull up packages from the package Array and install them
echo "Installing PostgreSQL dependencies"
sudo apt-get install ${packages[@]} -y >> $logfile
#Create required directories
echo "Creating folders $dfolder..."
sudo mkdir -p $dfolder >> $logfile
#Create System User
echo "Creating system user '$sysuser'"
sudo adduser --system $sysuser >> $logfile
#pull down psql using git
echo "Pulling down PostgreSQL from $gitloc"
git clone $gitloc >> $logfile
#Configuring Postgresql to be installed at /postgres with a data root of /postgres/data
echo "Configuring PostgreSQL"
~/postgresql/configure --prefix=$rfolder --datarootdir=$dfolder >> $logfile

echo "Making PostgreSQL"
make >> $logfile
echo "installing PostgreSQL"
sudo make install >> $logfile
echo "Giving system user '$sysuser' control over the $dfolder folder"
sudo chown postgres $dfolder >> $logfile1

# InitDB is used to create the location of the database cluster,and it will be placed in the $dfolder under /db.
echo "Running initdb"
sudo -u postgres $rfolder/bin/initdb -D $dfolder/db >> $logfile

# Start psql
echo "Starting PostgreSQL"
sudo -u postgres $rfolder/bin/pg_ctl -D $dfolder/db -l $dfolder/logfilePSQL start >> $logfile

#  Add PostgreSQL to /etc/rc.local and add environment variables to /etc/profile
echo "Set PostgreSQL to launch on startup"
sudo sed -i '$isudo -u postgres /postgres/bin/pg_ctl -D /postgres/data/db -l /postgres/data/logfilePSQL start' /etc/rc.local >> $logfile    >

echo "Writing PostgreSQL environment variables to /etc/profile"
cat << EOL | sudo tee -a /etc/profile

#PostgreSQL Environmental variable
LD_LIBRARY_PATH=/postgres/lib
export LD_LIBRARY_PATH
PATH=/postgres/bin:$PATH
export PATH
EOL

echo "Wait for PostgreSQL to finish starting up..."
sleep 5

echo "Running script"
$rfolder/bin/psql -U postgres -f $helloscript

echo "Querying the newly created table in the newly created database."
/postgres/bin/psql -c 'select * from hello;' -U psqluser hello_postgres;
