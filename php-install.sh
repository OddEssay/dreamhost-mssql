# Updated by Paul Freeman / OddEssay@github
#ssript updated 2011-12-01 by David (deceifermedia.com) for latest package versioins, updated download links,
#	   and for the MySQLi and PDO extensions to use mysqlnd instead of libmysql (highly recommended)
# Script updated 2010-07-03 by Andres (andrew67.com) for latest php, curl and openssl versions and enabling perl/pecl
# Script updated 2009-12-27 by Steven Rosato to fix PHP 5.3 Compile Error: Undefined References in dns.c
# Script updated 2009-09-24 by Christopher (heavymark.com) for latest source versions and incorrect url and addition of proper enabling of xmlrpc.
# Script updated 2009-08-05 by Andy (andy.hwang.tw) to correct typo on m4 extract command.
# Script updated 2009-07-28 by samutz (samutz.com) to include ZIP, XMLRPC,
#          and GNU M4 (previous version of script failed without it)
# Script updated 2009-07-24 by ercoppa (ercoppa.org) to convert this script for PHP 5.3 (with all features of dreamhost,
#          except kerberos) with Xdebug and APC
# Script updated 2009-05-24 by ksmoe to correct copying of correct PHP cgi file (php-cgi instead of php)
# Script updated 2009-04-25 by Daniel (whathuhstudios.com) for latest source versions
# Script updated 2007-11-24 by Andrew (ajmconsulting.net) to allow 3rd wget line to pass 
#          LIBMCRYPT version information (was set as static download file name previously.)
# Script updated 2006-12-25 by Carl McDade (hiveminds.co.uk) to allow memory limit and freetype
#
#
# Save the code to a file as *.sh
# Don't forget to chmod a+x it!
# Abort on any errors
#
set -e

# The domain in which to install the PHP CGI script.
export DOMAIN="protocol80.info"

# Where do you want all this stuff built? I'd recommend picking a local
# filesystem.
# ***Don't pick a directory that already exists!***  We clean up after
# ourselves at the end!
SRCDIR=${HOME}/phpsource

# And where should it be installed?
INSTALLDIR=${HOME}/php5

# Set DISTDIR to somewhere persistent, if you plan to muck around with this
# script and run it several times!
DISTDIR=${HOME}/dist

# Pre-download clean up!!!!
rm -rf $SRCDIR

# Update version information here.
PHP5="php-5.3.8" #MUST BE THE CURRENT VERSION
CURL="curl-7.23.1"
XDEBUG="xdebug-2.1.2"
M4="m4-1.4.16"
AUTOCONF="autoconf-2.68"
CCLIENT="imap-2007f" #MUST BE THE CURRENT VERSION
CCLIENT_DIR="imap-2007f"
OPENSSL="openssl-1.0.0e"   
OPENSSL_DIR="openssl-1.0.0e"
LIBMCRYPT="2.5.8"
LIBTOOL="libtool-2.4.2"
APC="APC-3.1.9"
FREETDS="freetds-0.82" # Older version as latest has a bug that prevents PHP compiling.

# What PHP features do you want enabled?
PHPFEATURES="--prefix=${INSTALLDIR} \
			 --with-config-file-path=${INSTALLDIR}/etc/php5/${DOMAIN} \
			 --with-config-file-scan-dir=${INSTALLDIR}/etc/php5/${DOMAIN} \
			 --enable-fastcgi \
			 --bindir=$INSTALLDIR/bin \
			 --enable-force-cgi-redirect \
			 --enable-zip \
			 --enable-xmlrpc \
			 --with-xmlrpc \
			 --with-xml \
			 --with-freetype-dir=/usr \
			 --with-mhash=/usr \
			 --with-zlib-dir=/usr \
			 --with-jpeg-dir=/usr \
			 --with-png-dir=/usr \
			 --with-curl=${INSTALLDIR} \
			 --with-gd \
			 --enable-gd-native-ttf \
			 --enable-memory-limit \
			 --enable-ftp \
			 --enable-exif \
			 --enable-sockets \
			 --enable-wddx \
			 --enable-sqlite-utf8 \
			 --enable-calendar \
			 --enable-mbstring \
			 --enable-mbregex \
			 --enable-bcmath \
			 --with-mysql=/usr \
			 --with-mysqli=mysqlnd \
			 --with-pear \
			 --with-gettext \
			 --with-pdo-mysql=mysqlnd \
			 --with-openssl=${INSTALLDIR} \
			 --with-xsl \
			 --with-ttf=/usr \
			 --with-xslt \
			 --with-xslt-sablot=/usr \ 
			 --with-dom-xslt=/usr \
							 --with-mcrypt=${INSTALLDIR} \
			--with-mssql=${INSTALLDIR} \
							 "

# ---- end of user-editable bits. Hopefully! ----

# Push the install dir's bin directory into the path
							 export PATH=${INSTALLDIR}/bin:$PATH

#fix for PHP 5.3 Compile Error: Undefined References in dns.c
							 export EXTRA_LIBS="-lresolv"

# set up directories
							 mkdir -p ${SRCDIR}
							 mkdir -p ${INSTALLDIR}
							 if [ ! -f ${DISTDIR} ] 
							 then
							 mkdir -p ${DISTDIR}
							 fi

							 cd ${DISTDIR}

# Get all the required packages
							 if [ ! -f ${DISTDIR}/${PHP5}.tar.gz ] 
							 then
							 wget -c http://us.php.net/get/${PHP5}.tar.gz/from/this/mirror/ 
							 mv index.html ${PHP5}.tar.gz
							 fi

							 if [ ! -f ${DISTDIR}/${CURL}.tar.gz ] 
							 then
							 wget -c http://curl.haxx.se/download/${CURL}.tar.gz
							 fi

							 if [ ! -f ${DISTDIR}/${M4}.tar.gz ] 
							 then
							 wget -c http://ftp.gnu.org/gnu/m4/${M4}.tar.gz
							 fi

							 if [ ! -f ${DISTDIR}/${AUTOCONF}.tar.gz ] 
							 then
							 wget -c http://ftp.gnu.org/gnu/autoconf/${AUTOCONF}.tar.gz
							 fi

							 if [ ! -f ${DISTDIR}/${XDEBUG}.tgz ] 
							 then
							 wget -c http://xdebug.org/files/${XDEBUG}.tgz
							 fi

							 if [ ! -f ${DISTDIR}/${CCLIENT}.tar.Z ] 
							 then
							 wget -c ftp://ftp.cac.washington.edu/imap/${CCLIENT}.tar.Z
							 fi

							 if [ ! -f ${DISTDIR}/${OPENSSL}.tar.gz ] 
							 then
							 wget -c http://www.openssl.org/source/${OPENSSL}.tar.gz
							 fi

							 if [ ! -f ${DISTDIR}/${LIBMCRYPT}.tar.gz ] 
							 then
							 wget -c http://ignum.dl.sourceforge.net/project/mcrypt/Libmcrypt/${LIBMCRYPT}/libmcrypt-${LIBMCRYPT}.tar.gz
							 fi

							 if [ ! -f ${DISTDIR}/${LIBTOOL}.tar.gz ] 
							 then
							 wget -c http://ftp.gnu.org/gnu/libtool/${LIBTOOL}.tar.gz
							 fi

							 if [ ! -f ${DISTDIR}/${APC}.tgz ] 
							 then
							 wget -c http://pecl.php.net/get/${APC}.tgz
							 fi

							 if [ ! -f ${DISTDIR}/${FREETDS}.tar.gz ] 
							 then
							 wget -c ftp://ftp.ibiblio.org/pub/Linux/ALPHA/freetds/old/0.82/${FREETDS}.tar.gz
							 fi

							 echo ---------- Unpacking downloaded archives. This process may take several minutes! ----------

							 cd ${SRCDIR}

# Unpack them all
							 echo Extracting ${PHP5}...
							 tar xzf ${DISTDIR}/${PHP5}.tar.gz
							 echo Done.

							 echo Extracting ${CURL}...
							 tar xzf ${DISTDIR}/${CURL}.tar.gz
							 echo Done.

							 echo Extracting ${M4}...
							 tar xzf ${DISTDIR}/${M4}.tar.gz
							 echo Done.

							 echo Extracting ${XDEBUG}...
							 tar xzf ${DISTDIR}/${XDEBUG}.tgz
							 echo Done.

							 echo Extracting ${AUTOCONF}...
							 tar xzf ${DISTDIR}/${AUTOCONF}.tar.gz
							 echo Done.

							 echo Extracting ${CCLIENT}...
							 uncompress -cd ${DISTDIR}/${CCLIENT}.tar.Z |tar x
							 echo Done.

							 echo Extracting ${OPENSSL}...
							 uncompress -cd ${DISTDIR}/${OPENSSL}.tar.gz |tar x
							 echo Done.

							 echo Extracting ${LIBMCRYPT}...
							 tar xzf ${DISTDIR}/libmcrypt-${LIBMCRYPT}.tar.gz
							 echo Done.

							 echo Extracting ${LIBTOOL}...
							 tar xzf ${DISTDIR}/${LIBTOOL}.tar.gz
							 echo Done.

							 echo Extracting ${APC}...
							 tar xzf ${DISTDIR}/${APC}.tgz
							 echo Done.

							 echo Extracting ${FREETDS}...
							 tar xzf ${DISTDIR}/${FREETDS}.tar.gz
							 echo Done.

# Build them in the required order to satisfy dependencies

#cURL
							 echo ###################
							 echo Compile CURL
							 echo ###################
							 cd ${SRCDIR}/${CURL}
							 ./configure --enable-ipv6 --enable-cookies \
									 --enable-crypto-auth --prefix=${INSTALLDIR}
 make clean
									 make
									 make install

#M4
									 echo ###################
									 echo Compile M4
									 echo ###################
									 cd ${SRCDIR}/${M4}
									 ./configure --prefix=${INSTALLDIR}
 make clean
									 make
									 make install

#CCLIENT
									 echo ###################
									 echo Compile CCLIENT
									 echo ###################
									 cd ${SRCDIR}/${CCLIENT_DIR}
									 make ldb
# Install targets are for wusses!
									 cp c-client/c-client.a ${INSTALLDIR}/lib/libc-client.a
									 cp c-client/*.h ${INSTALLDIR}/include

#OPENSSL
echo ###################
echo Compile OPENSSL
echo ###################
# openssl
cd ${SRCDIR}/${OPENSSL_DIR}
./config --prefix=${INSTALLDIR}
make
make install

#MCRYPT
echo ###################
echo Compile MCRYPT
echo ###################
cd ${SRCDIR}/libmcrypt-${LIBMCRYPT}
./configure --disable-posix-threads --prefix=${INSTALLDIR}
# make clean
make
make install

#LIBTOOL
echo ###################
echo Compile LIBTOOL
echo ###################
cd ${SRCDIR}/${LIBTOOL}
./configure --prefix=${INSTALLDIR}
make clean
make
make install

#Free TDS (For MSSQL Support)
echo #################
echo Compile FREETDS
echo #################
cd ${SRCDIR}/${FREETDS}
./configure --enable-msdblib --prefix=${INSTALLDIR}
make
make install
touch ${INSTALLDIR}/include/tds.h
touch ${INSTALLDIR}/lib/libtds.a

#PHP 5
echo ###################
echo Compile PHP
echo ###################
cd ${SRCDIR}/${PHP5}
./configure ${PHPFEATURES}
# make clean
make
make install

# Copy a basic configuration for PHP
mkdir -p ${INSTALLDIR}/etc/php5/${DOMAIN}
cp ${SRCDIR}/${PHP5}/php.ini-production ${INSTALLDIR}/etc/php5/${DOMAIN}/php.ini

#AUTOCONF
echo ###################
echo Compile AUTOCONF
echo ###################
cd ${SRCDIR}/${AUTOCONF}
./configure --prefix=${INSTALLDIR}
# make clean
make
make install

# XDEBUG
echo ###################
echo Compile XDEBUG
echo ###################
cd ${SRCDIR}/${XDEBUG}
export PHP_AUTOHEADER=${INSTALLDIR}/bin/autoheader
export PHP_AUTOCONF=${INSTALLDIR}/bin/autoconf
echo $PHP_AUTOHEADER
echo $PHP_AUTOCONF
${INSTALLDIR}/bin/phpize
./configure --enable-xdebug --with-php-config=${INSTALLDIR}/bin/php-config --prefix=${INSTALLDIR}
# make clean
make
mkdir -p ${INSTALLDIR}/extensions
cp modules/xdebug.so ${INSTALLDIR}/extensions

	echo "zend_extension=${INSTALLDIR}/extensions/xdebug.so" >> ${INSTALLDIR}/etc/php5/${DOMAIN}/xdebug.ini


# APC
									 echo ###################
									 echo Compile APC
									 echo ###################
									 cd ${SRCDIR}/${APC}
									 ${INSTALLDIR}/bin/phpize
									 ./configure --enable-apc --enable-apc-mmap --with-php-config=${INSTALLDIR}/bin/php-config --prefix=${INSTALLDIR}
# make clean
									 make
									 cp modules/apc.so ${INSTALLDIR}/extensions
									 echo "extension=${INSTALLDIR}/extensions/apc.so" >> ${INSTALLDIR}/etc/php5/${DOMAIN}/apc.ini


# Copy PHP CGI
									 mkdir -p ${HOME}/${DOMAIN}/cgi-bin
									 chmod 0755 ${HOME}/${DOMAIN}/cgi-bin
									 cp ${INSTALLDIR}/bin/php-cgi ${HOME}/${DOMAIN}/cgi-bin/php.cgi
									 rm -rf $SRCDIR $DISTDIR

# Create .htaccess
									 if [ -f ${HOME}/${DOMAIN}/.htaccess ] 
									 then
									 echo #
									 echo '#####################################################################'
									 echo ' Your domain already has a .htaccess, it is ranamed .htaccess_old    '
									 echo '               --> PLEASE FIX THIS PROBLEM <--                       '
									 echo '#####################################################################'
									 echo #
									 mv ${HOME}/${DOMAIN}/.htaccess ${HOME}/${DOMAIN}/.htaccess_old
									 fi

									 echo 'Options +ExecCGI' >> ${HOME}/${DOMAIN}/.htaccess
									 echo 'AddHandler php-cgi .php' >> ${HOME}/${DOMAIN}/.htaccess
									 echo 'Action php-cgi /cgi-bin/php.cgi' >> ${HOME}/${DOMAIN}/.htaccess
									 echo '' >> ${HOME}/${DOMAIN}/.htaccess
									 echo '<FilesMatch "^php5?\.(ini|cgi)$">' >> ${HOME}/${DOMAIN}/.htaccess
									 echo 'Order Deny,Allow' >> ${HOME}/${DOMAIN}/.htaccess
									 echo 'Deny from All' >> ${HOME}/${DOMAIN}/.htaccess
									 echo 'Allow from env=REDIRECT_STATUS' >> ${HOME}/${DOMAIN}/.htaccess
									 echo '</FilesMatch>' >> ${HOME}/${DOMAIN}/.htaccess 

									 echo ---------- INSTALL COMPLETE! ----------
									 echo 
									 echo 'Configuration files:'
									 echo "1) General PHP -> ${INSTALLDIR}/etc/php5/${DOMAIN}/php.ini"
									 echo "2) Xdebug conf -> ${INSTALLDIR}/etc/php5/${DOMAIN}/xdebug.ini"
									 echo "3) APC conf -> ${INSTALLDIR}/etc/php5/${DOMAIN}/apc.ini"
									 echo
									 echo 'You have to modify these files in order to enable Xdebug or APC features.'

									 exit 0
