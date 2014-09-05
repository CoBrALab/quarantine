#!/bin/sh

#
# If compiling at the BIC in /data/aces/aces1/, do "newgrp aces"
# before this script so that files are accounted for in the aces
# group quota.
#
umask 077
INSTALL_DIR=/opt/quarantine/CIVET/1.1.12/build
mkdir -p ${PWD}/bin

if [[ "`uname -n`" =~ "scarus" ]] ; then
  echo 'Using gcc 4.2 on scarus...'
  ln -sf /usr/bin/gcc-4.2 ${PWD}/bin/gcc
  ln -sf /usr/bin/g++-4.2 ${PWD}/bin/g++
  ln -sf /usr/bin/cpp-4.2 ${PWD}/bin/cpp
  export PATH=${PWD}/bin:${PATH}
fi
if [[ "`uname -n`" =~ "zealous" ]] ; then
  echo 'Using default compiler on zealous'
fi
if [[ "`uname -n`" =~ "ip03" ]] ; then
  echo 'Using default compiler on RQCHP ms'
fi
if [[ "`uname -n`" =~ "lg-1r14" ]] ; then
  echo 'Using default compiler on CLUMEQ guillimin'
fi
if [[ "`uname -n`" =~ "colosse" ]] ; then
  echo 'Using default compiler on CLUMEQ colosse'
fi
if [[ "`uname -n`" =~ "judge" ]] ; then
  echo 'Using gcc 4.2 on judge...'
  module add g++/4.2.4-64bit
fi

gcc --version
g++ --version
cpp --version

make PREFIX_PATH=$INSTALL_DIR netpbm && 
make PREFIX_PATH=$INSTALL_DIR main && 
make PREFIX_PATH=$INSTALL_DIR civet 
#make PREFIX_PATH=$INSTALL_DIR imagemagick
#make PREFIX_PATH=$INSTALL_DIR visual

# Save Makefile and other files to rebuild later (not readable by others).

echo "Saving compiling scripts..."
mkdir -p $INSTALL_DIR/building/
cp -p $PWD/mk_environment.pl $INSTALL_DIR/building/
cp -p $PWD/Makefile $INSTALL_DIR/building/
cp -p $PWD/rqchp_install.sh $INSTALL_DIR/building/

# Set file permissions to all.

echo "Setting file permissions..."
chmod og+rX `uname`-`uname -m`
chmod -R og+rX $INSTALL_DIR
chmod og-rx $INSTALL_DIR/building/

echo "#!/bin/csh -f" > job_test
echo "source $INSTALL_DIR/init.csh" >> job_test
echo "$INSTALL_DIR/CIVET-1.1.12/CIVET_Processing_Pipeline -prefix mni_icbm -sourcedir `pwd`/Test -targetdir `pwd`/Test -N3-distance 200 -lsq12 -resample-surfaces -thickness tlink 30 -VBM -combine-surface -spawn -run 00100" >> job_test
chmod u+x job_test

echo "Submit file job_test to run the test case"

