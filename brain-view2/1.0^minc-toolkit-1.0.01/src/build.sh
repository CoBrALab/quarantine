#!/bin/bash

# --- configure the following --- 
BUILDDIR=/opt/quarantine/brain-view2/1.0^minc-toolkit-1.0.01/build
MINCTOOLDIR=/opt/quarantine/minc-toolkit/1.0.01/build

# use libcoin60-dev on cic compute node
sudo apt-get install qt4-qmake libqt4-dev-bin libqt4-dev \
libcoin80-dev libboost-dev libnetcdf-dev \
libpcre++-dev libpcre++0    # for oobicpl
# --- 

set -e

mkdir -p $BUILDDIR
module load minc-toolkit/1.0.01

echo building quarter
mkdir -p $BUILDDIR/designer   # QT plugin path 
if [[ ! -e Coin3D-quarter-3dc3433032c9 ]]; then
  wget --continue https://bitbucket.org/Coin3D/quarter/get/3dc3433032c915c19946a8c4e2a4ccfa6036ce49.zip
  unzip 3dc3433032c915c19946a8c4e2a4ccfa6036ce49.zip
  patch --forward -p0 -i Coin3d-quarter--3dc3433032c9.patch || true
fi

( 
cd Coin3D-quarter-3dc3433032c9
./configure --prefix=$BUILDDIR \
            --with-qt-designer-plugin-path=$BUILDDIR/designer
make && make install
)

echo building bicinventor
if [[ ! -e bicInventor-0.3.1 ]]; then
  wget --continue http://packages.bic.mni.mcgill.ca/tgz/bicInventor-0.3.1.tar.gz
  tar xzf bicInventor-0.3.1.tar.gz
  patch --forward -p0 -i bicInventor.patch || true
fi

( cd bicInventor-0.3.1
CPPFLAGS="-I$MINCTOOLDIR/include -I$BUILDDIR/include" \
 LDFLAGS="-L$MINCTOOLDIR/lib -L$BUILDDIR/lib" \
 ./configure --prefix=$BUILDDIR --with-minc2
make && make install
)


echo building brain-view2
[[ ! -e brain-view2 ]] && git clone https://github.com/sghanavati/brain-view2
( cd brain-view2
qmake \
  MINCDIR=$MINCTOOLDIR \
  INVENTORDIR=$MINCTOOLDIR \
  QUARTERDIR=$BUILDDIR \
  HDF5DIR=$BUILDDIR \
  brain-view2.pro
make
cp brain-view2 $BUILDDIR/bin
)

echo On compute node: 
echo cp /usr/lib/libCoin.so.60 build/lib
echo cp /usr/lib/libnetcdf.so.6 ../build/lib/
