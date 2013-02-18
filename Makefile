TGT=noip2
CC=gcc
PKG=noip-2.1.tgz

PREFIX=/usr
CONFDIR=${PREFIX}/etc
BINDIR=${PREFIX}/sbin

# these defines are for Linux
LIBS=
ARCH=linux

# for Mac OS X and BSD systems that have getifaddr(), uncomment the next line
#ARCH=bsd_with_getifaddrs

# for early BSD systems without getifaddrs(), uncomment the next line
#ARCH=bsd


# for solaris, uncomment the next two lines
# LIBS=-lsocket -lnsl
# ARCH=sun

${TGT}: Makefile ${TGT}.c 
	${CC} -Wall -g -D${ARCH} -DPREFIX=\"${PREFIX}\" ${TGT}.c -o ${TGT} ${LIBS}

install: ${TGT} 
	if [ ! -d $(DESTDIR)${BINDIR} ]; then mkdir -p $(DESTDIR)${BINDIR};fi
	if [ ! -d $(DESTDIR)${CONFDIR} ]; then mkdir -p $(DESTDIR)${CONFDIR};fi
	cp ${TGT} $(DESTDIR)${BINDIR}/${TGT}
#	${BINDIR}/${TGT} -C -c /tmp/no-ip2.conf
#	mv /tmp/no-ip2.conf ${CONFDIR}/no-ip2.conf

package: ${TGT}
	rm  -f *.bak
	mv ${TGT} binaries/${TGT}-`uname -m`
	scp a-k:/local/bin/noip2 binaries/noip2-`ssh a-k uname -m`
	cd ..; tar zcvf /tmp/${PKG} noip-2.0/*
	scp /tmp/${PKG} a-k:/opt/www/${PKG}
	rm /tmp/${PKG}

clean: 
	rm -f *o
	rm -f binaries/*
	rm -f ${TGT}

all: ${TGT}
