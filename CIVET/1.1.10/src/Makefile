SHELL=/bin/sh

CVS_HEAD=" $Id: Makefile,v 1.137 2009/07/31 21:04:10 claude Exp $ "

BUILDER_VERSION= $(shell sed -e '/Id/!d'  -e 's/[^0-9.]*\([0-9.]*\).*/\1/'  -e q   Makefile )
version:
	#     +-------------------------------------+
	#     |  QUARANTINE BUILDER VERSION:  ${BUILDER_VERSION}  |
	#     +-------------------------------------+
	@echo 
	@echo "Syntax: make [option]"
	@echo "Useful options are:"
	@echo "  untar      - get packages from web and untar"
	@echo "  utils      - util libs (perl, PMP, etc)"
	@echo "  main       - core codes (pve, clasp, surfreg, etc)"
	@echo "  civet      - CIVET pipeline"
	@echo "  clean      - clean-up (incomplete)"
	@echo 
	@echo "If some modules fail to compile, you may have to install"
	@echo "the following packages on your Linux Debian/Ubuntu system:"
	@echo "  sudo apt-get install build-essential lapack3-dev libnetpbm9-dev"
	@echo "       libx11-dev freeglut3-dev libgmp3-dev libgnome-perl"
	@echo "       gawk zlib1g-dev m4 libgnome2-dev libgnome-dev  xlibs-dev"
	@echo "       refblas3-dev atlas3-base-dev"
	@echo "For verify images, adding the following:"
	@echo "       imagemagick"
	@echo "For surface diffusion, adding the following:"
	@echo "       lapack3-dev refblas3-dev"
	@echo "On Linux Fedora (Red Hat), you may have to install g77 to get libg2c"
	@echo "too if the linker complains about not finding lapack."
	@echo 
	@echo "Copyright Alan C. Evans"
	@echo "Professor of Neurology"
	@echo "McGill University"
	@echo 


.PHONY: clean clean_dist

#     +-------------------------+
#     |  SET SOME DEFAULTS      |
#     +-------------------------+

GTAR=tar
GTAR_FLAGS=-xzf
ABI = 64
DEBUG = 0
UNAME = $(shell uname)-$(shell uname -m | sed 's/ /_/g')
SOURCE_DIR  = $(PWD)/$(UNAME)/SRC
PREFIX_PATH = $(PWD)/$(UNAME)
BUILD_PATH  = $(PREFIX_PATH)
R_LIBS = $(PREFIX_PATH)/R_LIBS

QUARANTINE_FLAG = $(PWD)/$(UNAME)/.quarantine_created

LDFLAGS    += -L$(PREFIX_PATH)/lib
PATH       := $(PREFIX_PATH)/bin:$(PATH)

OPT_OPTIONS :=

#     +-------------------------------------+
#     |  OPTIMIZATION LEVEL (defaut opt)    |
#     +-------------------------------------+
ifeq ($(DEBUG),1)
  OPT_OPTIONS += -g
else
  ifneq ($(findstring IRIX,$(shell uname)),)
    OPT_OPTIONS += -g -O2
  else
    ifneq ($(findstring Linux,$(shell uname)),)
      ifneq ($(findstring ia64,$(shell uname -m)),)
        OPT_OPTIONS += -g -O1
      else
        OPT_OPTIONS += -g -O2
      endif
    else
      OPT_OPTIONS += -g -O2
    endif
  endif
endif
CFLAGS=${OPT_OPTIONS}
CPPFLAGS=${OPT_OPTIONS}
CXXFLAGS=${OPT_OPTIONS}

#     +----------------------------------+
#     |  SET ARCH and OS specific bits   |
#     +----------------------------------+

#     +---------- IRIX64 ----------------+
ifneq ($(findstring IRIX,$(shell uname)),)
  JAMARCH=bin.irixmips
  BICPL_BUILD_SWITCH=--with-image-sgi
  CPPFLAGS+=-I$(PREFIX_PATH)/include -I$(PREFIX_PATH)/include/volume_io -I/usr/include/gl
  
  # THESE ARE BIC SPECIFIC THINGS
  PERL=$(shell which /usr/local/perl5.8/bin/perl5.8.5)
  GTAR:=gtar
else
  PERL=$(shell which perl)
endif

#     +----------  Linux  ----------------+
ifneq ($(findstring Linux,$(shell uname)),)
  ifneq ($(findstring libppm.a,$(shell locate libppm.a)),)
    BICPL_BUILD_SWITCH=--with-image-ppm
  else
    BICPL_BUILD_SWITCH=--with-image-netpbm
  endif
  ifneq ($(findstring x86_64,$(shell uname -m)),)
    JAMARCH=bin.linux
    # needed on Linux 64 bits
    CFLAGS+=-fpic
    CPPFLAGS+=-fpic
    CXXFLAGS+=-fpic
  else
    JAMARCH=bin.linuxx86
  endif
  ifneq ($(findstring ia64,$(shell uname -m)),)
    JAMARCH=bin.linuxia64
  endif
endif

#     +-----------  Darwin ----------------+
ifneq ($(findstring Darwin,$(shell uname)),)
  BICPL_BUILD_SWITCH=--with-image-netpbm
  ifneq ($(findstring i386,$(shell uname -m)),)
    JAMARCH=bin.macosxx86
  else
    JAMARCH=bin.macosxppc
  endif
  BUILD_PATH := $(BUILD_PATH)/:/sw
  DYLD_LIBRARY_PATH=(PREFIX_PATH)/lib
  VIEWER_OPTS='--with-apple-opengl-framework'
  ## add dylib for MAC to avoid recycle
  VIEWER_LDFLAGS=${LDFLAGS} -L/Applications/MNI/Darwin-i386//lib -dylib_file \
                 /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib:\
                 /System/Library/Frameworks/OpenGL.framework/Versions/A/Libraries/libGL.dylib
else
  VIEWER_OPTS='--with-x'
  VIEWER_LDFLAGS=
endif

CFG_COMP_FLAGS=CFLAGS='${CFLAGS}' CPPFLAGS='${CPPFLAGS}' CXXFLAGS='${CXXFLAGS}'

#     +-------------------------------------------------+
#     |        DETECT SYSTEM FOR GRID (SGE, PBS)        |
#     +-------------------------------------------------+

CIVET_JOB_SCHEDULER="DEFAULT"
ifneq ($(findstring vamana,$(shell domainname)),)
  CIVET_JOB_SCHEDULER="MNIBIC"
endif
ifneq ($(findstring krylov.clumeq.mcgill.ca,$(shell uname -n)),)
  CIVET_JOB_SCHEDULER="CLUMEQ"
endif
ifneq ($(findstring cyclops,$(shell uname -n)),)
  CIVET_JOB_SCHEDULER="COLOSSE"
endif
ifneq ($(findstring ip03,$(shell uname -n)),)
  CIVET_JOB_SCHEDULER="RQCHP"
endif
ifneq ($(findstring biowulf.nih.gov,$(shell uname -n)),)
  CIVET_JOB_SCHEDULER="NIH"
endif

#     +-----------------------------------------------+
#     |        SET MINC BASE VERSION (MUST BE 2)      |
#     +-----------------------------------------------+

MINC_BASE=2
MINC_COMPRESS=4
MINC_FORCE_V2=1
MINC_EXTRA   = --enable-shared=no --enable-static=yes --enable-acr-nema --enable-minc2
MINC_FLAG    = --with-minc2

#     +------------------------------------+
#     |        SET VERSION NUMBERS         |
#     +------------------------------------+

ARGS_VERS=-0.2.1
AUTOREG_VERS=-0.99.3
BET_VERS=-1.3.2
BOOST_VERS=_1_33_1
BPL_VERS=-1.4.5
CAREA_VERS=-1.2.0
CDF_VERS=-3.6.1
CGAL_VERS=-3.2.1
CIVET_VERS=-1.1.10
CLASP_VERS=-2.4.0
CLASSIFY_VERS=-1.0.08
CONGLOMERATE_VERS=-1.6.6
CSURFACE_VERS=-1.2.0
DIFFUSE_VERS=-1.4.0
EBTKS_VERS=-1.6.1
GETOPT_VERS=-0.3
GSL_VERS=-1.8
HDF_VERS=5-1.6.6
HDF_VERS_LATEST=5-1.8.0
ICBM152_VERS=-1.1
ICBM152NL_VERS=-1.0
ICBMTEMP_VERS=-1.0
ILT_VERS=-1.2.2
INORM_VERS=-1.0.2
LAPLACE_VERS=-1.2.0
M4_VERS=-1.0
MINC_VERS=-2.0.18
MMORPH_VERS=-1.4
N3_VERS=-1.10.1
OOBPL_VERS=-0.4.4
PCREPP_VERS=-0.9.5
PCRE_VERS=-7.8
PERLLIB_VERS=-0.08
PMP_VERS=-0.7.9
PVE_VERS=-1.2.0
RAY_TRACE_VERS=-1.0.3
SURFREG_VERS=-0.6.0

#     +---------------------+
#     |  NAMES OF PACKAGES  |
#     +---------------------+

ARGS_PACKAGE=arguments${ARGS_VERS}
AUTOREG_PACKAGE=mni_autoreg${AUTOREG_VERS}
BET_PACKAGE=mincbet${BET_VERS}
BOOST_PACKAGE=boost${BOOST_VERS}
BPL_PACKAGE=bicpl${BPL_VERS}
CAREA_PACKAGE=cortex_area${CAREA_VERS}
CDF_PACKAGE=netcdf${CDF_VERS}
CGAL_PACKAGE=CGAL${CGAL_VERS}
CIVET_PACKAGE=civet${CIVET_VERS}
ifeq ($(CLASP_VERS),-2.1)
  CLASP_PACKAGE=CLASP${CLASP_VERS}
else
  CLASP_PACKAGE=surface-extraction${CLASP_VERS}
endif
CLASSIFY_PACKAGE=classify${CLASSIFY_VERS}
CONGLOMERATE_PACKAGE=conglomerate${CONGLOMERATE_VERS}
CSURFACE_PACKAGE=cortical_surface${CSURFACE_VERS}
DIFFUSE_PACKAGE=diffuse${DIFFUSE_VERS}
ifeq ($(EBTKS_VERS),-1.4)
  EBTKS_PACKAGE=EBTKS${EBTKS_VERS}
else
  EBTKS_PACKAGE=ebtks${EBTKS_VERS}
endif
GETOPT_PACKAGE=Getopt-Tabular${GETOPT_VERS}
GSL_PACKAGE=gsl${GSL_VERS}
HDF_PACKAGE=hdf${HDF_VERS}
ICBM152_PACKAGE=mni-models_icbm152-lin${ICBM152_VERS}
ICBM152NL_PACKAGE=mni-models_icbm152-nl${ICBM152NL_VERS}
ICBMTEMP_PACKAGE=mni-templates${ICBMTEMP_VERS}
ILT_PACKAGE=ILT${ILT_VERS}
INORM_PACKAGE=inormalize${INORM_VERS}
LAPLACE_PACKAGE=laplacian_thickness${LAPLACE_VERS}
M4_PACKAGE=mni_m4${M4_VERS}
MINC_PACKAGE=minc${MINC_VERS}
MMORPH_PACKAGE=mincmorph${MMORPH_VERS}
N3_PACKAGE=N3${N3_VERS}
OOBPL_PACKAGE=oobicpl${OOBPL_VERS}
PCREPP_PACKAGE=pcre++${PCREPP_VERS}
PCRE_PACKAGE=pcre${PCRE_VERS}
PERLLIB_PACKAGE=mni_perllib${PERLLIB_VERS}
PMP_PACKAGE=PMP${PMP_VERS}
PVE_PACKAGE=pve${PVE_VERS}
RAY_TRACE_PACKAGE=ray_trace${RAY_TRACE_VERS}
ifeq ($(SURFREG_VERS),-0.4)
  SURFREG_PACKAGE=mni-surfreg${SURFREG_VERS}
else
  SURFREG_PACKAGE=mni_surfreg${SURFREG_VERS}
endif

TGZ_FLAG=${PWD}/TGZ/.tgz_created
TGZ_DIR=${PWD}/TGZ

#     +---------------+
#     |  BOOST STUFF  |
#     +---------------+

JAMPATH := ${SOURCE_DIR}/${BOOST_PACKAGE}/boost-jam-3.1.10/
BJAM := ${SOURCE_DIR}/${BOOST_PACKAGE}/tools/build/jam_src/${JAMARCH}
BOOSTTMP := /tmp

#     +------------------------+
#     |  SOURCE FILE TARGETS   |
#     +------------------------+
 
ARGS_TAR=${TGZ_DIR}/${ARGS_PACKAGE}.tar.gz
AUTOREG_TAR=${TGZ_DIR}/${AUTOREG_PACKAGE}.tar.gz
BET_TAR=${TGZ_DIR}/${BET_PACKAGE}.tar.gz
BOOST_TAR=${TGZ_DIR}/${BOOST_PACKAGE}.tar.gz
BPL_TAR=${TGZ_DIR}/${BPL_PACKAGE}.tar.gz
CAREA_TAR=${TGZ_DIR}/${CAREA_PACKAGE}.tar.gz
CDF_TAR=${TGZ_DIR}/${CDF_PACKAGE}.tar.gz
CGAL_TAR=${TGZ_DIR}/${CGAL_PACKAGE}.tar.gz
CIVET_TAR=${TGZ_DIR}/${CIVET_PACKAGE}.tar.gz
CLASP_TAR=${TGZ_DIR}/${CLASP_PACKAGE}.tar.gz
CLASSIFY_TAR=${TGZ_DIR}/${CLASSIFY_PACKAGE}.tar.gz
CONGLOMERATE_TAR=${TGZ_DIR}/${CONGLOMERATE_PACKAGE}.tar.gz
CSURFACE_TAR=${TGZ_DIR}/${CSURFACE_PACKAGE}.tar.gz
DIFFUSE_TAR=${TGZ_DIR}/${DIFFUSE_PACKAGE}.tar.gz
EBTKS_TAR=${TGZ_DIR}/${EBTKS_PACKAGE}.tar.gz
GETOPT_TAR=${TGZ_DIR}/${GETOPT_PACKAGE}.tar.gz
GSL_TAR=${TGZ_DIR}/${GSL_PACKAGE}.tar.gz
HDF_TAR=${TGZ_DIR}/${HDF_PACKAGE}.tar.gz
ICBM152_TAR=${TGZ_DIR}/${ICBM152_PACKAGE}.tar.gz
ICBM152NL_TAR=${TGZ_DIR}/${ICBM152NL_PACKAGE}.tar.gz
ICBMTEMP_TAR=${TGZ_DIR}/${ICBMTEMP_PACKAGE}.tar.gz
ILT_TAR=${TGZ_DIR}/${ILT_PACKAGE}.tar.gz
INORM_TAR=${TGZ_DIR}/${INORM_PACKAGE}.tar.gz
LAPLACE_TAR=${TGZ_DIR}/${LAPLACE_PACKAGE}.tar.gz
M4_TAR=${TGZ_DIR}/${M4_PACKAGE}.tar.gz
MINC_TAR=${TGZ_DIR}/${MINC_PACKAGE}.tar.gz
MMORPH_TAR=${TGZ_DIR}/${MMORPH_PACKAGE}.tar.gz
N3_TAR=${TGZ_DIR}/${N3_PACKAGE}.tar.gz
OOBPL_TAR=${TGZ_DIR}/${OOBPL_PACKAGE}.tar.gz
PCREPP_TAR=${TGZ_DIR}/${PCREPP_PACKAGE}.tar.gz
PCRE_TAR=${TGZ_DIR}/${PCRE_PACKAGE}.tar.gz
PERLLIB_TAR=${TGZ_DIR}/${PERLLIB_PACKAGE}.tar.gz
PMP_TAR=${TGZ_DIR}/${PMP_PACKAGE}.tar.gz
PVE_TAR=${TGZ_DIR}/${PVE_PACKAGE}.tar.gz
RAY_TRACE_TAR=${TGZ_DIR}/${RAY_TRACE_PACKAGE}.tar.gz
SURFREG_TAR=${TGZ_DIR}/${SURFREG_PACKAGE}.tar.gz

# +------------------------------+
# |  THE FAMOUS UNTAR DIRECTORY  |
# +------------------------------+

ARGS_UNTAR=${SOURCE_DIR}/${ARGS_PACKAGE}
AUTOREG_UNTAR=${SOURCE_DIR}/${AUTOREG_PACKAGE}
BET_UNTAR=${SOURCE_DIR}/${BET_PACKAGE}
BOOST_UNTAR=${SOURCE_DIR}/${BOOST_PACKAGE}
BPL_UNTAR=${SOURCE_DIR}/${BPL_PACKAGE}
CAREA_UNTAR=${SOURCE_DIR}/${CAREA_PACKAGE}
CDF_UNTAR=${SOURCE_DIR}/${CDF_PACKAGE}/src/
CGAL_UNTAR=${SOURCE_DIR}/${CGAL_PACKAGE}
CIVET_UNTAR=${SOURCE_DIR}/${CIVET_PACKAGE}
CLASP_UNTAR=${SOURCE_DIR}/${CLASP_PACKAGE}
CLASSIFY_UNTAR=${SOURCE_DIR}/${CLASSIFY_PACKAGE}
CONGLOMERATE_UNTAR=${SOURCE_DIR}/${CONGLOMERATE_PACKAGE}
CSURFACE_UNTAR=${SOURCE_DIR}/${CSURFACE_PACKAGE}
DIFFUSE_UNTAR=${SOURCE_DIR}/${DIFFUSE_PACKAGE}
EBTKS_UNTAR=${SOURCE_DIR}/${EBTKS_PACKAGE}
GETOPT_UNTAR=${SOURCE_DIR}/${GETOPT_PACKAGE}
GSL_UNTAR=${SOURCE_DIR}/${GSL_PACKAGE}
HDF_UNTAR=${SOURCE_DIR}/${HDF_PACKAGE}
ICBM152_UNTAR=${SOURCE_DIR}/${ICBM152_PACKAGE}
ICBM152NL_UNTAR=${SOURCE_DIR}/${ICBM152NL_PACKAGE}
ICBMTEMP_UNTAR=${SOURCE_DIR}/${ICBMTEMP_PACKAGE}
INORM_UNTAR=${SOURCE_DIR}/${INORM_PACKAGE}
ILT_UNTAR=${SOURCE_DIR}/${ILT_PACKAGE}
LAPLACE_UNTAR=${SOURCE_DIR}/${LAPLACE_PACKAGE}
M4_UNTAR=${SOURCE_DIR}/m4
MINC_UNTAR=${SOURCE_DIR}/${MINC_PACKAGE}
MMORPH_UNTAR=${SOURCE_DIR}/${MMORPH_PACKAGE}
N3_UNTAR=${SOURCE_DIR}/${N3_PACKAGE}
OOBPL_UNTAR=${SOURCE_DIR}/${OOBPL_PACKAGE}
PCREPP_UNTAR=${SOURCE_DIR}/${PCREPP_PACKAGE}
PCRE_UNTAR=${SOURCE_DIR}/${PCRE_PACKAGE}
PERLLIB_UNTAR=${SOURCE_DIR}/${PERLLIB_PACKAGE}
PMP_UNTAR=${SOURCE_DIR}/${PMP_PACKAGE}
PVE_UNTAR=${SOURCE_DIR}/${PVE_PACKAGE}
RAY_TRACE_UNTAR=${SOURCE_DIR}/${RAY_TRACE_PACKAGE}
SURFREG_UNTAR=${SOURCE_DIR}/${SURFREG_PACKAGE}

####################################################################################

#     +---------------+
#     |  MAKE TGZ DIR |
#     +---------------+

${TGZ_FLAG}:
	mkdir -p ${TGZ_DIR}
	@if [ ! -f $@ ] ;  then \
	  echo 1 > $@ ; \
	fi

#     +-----------------------+
#     |  MAKE QUARANTINE DIRS |
#     +-----------------------+

${QUARANTINE_FLAG}:
	mkdir -p ${SOURCE_DIR}
	mkdir -p $(PREFIX_PATH)/lib $(PREFIX_PATH)/man/man1 $(PREFIX_PATH)/man/man2 $(PREFIX_PATH)/man/man3  $(PREFIX_PATH)/man/man4  $(PREFIX_PATH)/man/man5  $(PREFIX_PATH)/man/man6  $(PREFIX_PATH)/man/man7  $(PREFIX_PATH)/man/man8  $(PREFIX_PATH)/man/man9 $(PREFIX_PATH)/perl
	@if [ ! -f $@ ] ;  then \
	  echo 1 > $@ ; \
	fi
	@echo "#  +-------------------------------------------------+" 
	@echo "#  |    SRC      = ${SOURCE_PATH}" 
	@echo "#  |    PREFIX   = ${PREFIX_PATH}" 
	@echo "#  |    CFLAGS   = $(CFLAGS)" 
	@echo "#  |    CPPFLAGS = $(CPPFLAGS)" 
	@echo "#  |    CXXFLAGS = $(CXXFLAGS)" 
	@echo "#  |    LDFLAGS  = $(LDFLAGS)" 
	@echo "#  +-------------------------------------------------+"

#     +--------------------+
#     |  UNTAR THE FILES   |
#     +--------------------+

${ARGS_UNTAR}:     ${QUARANTINE_FLAG}    ${ARGS_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}    ${ARGS_TAR}  ;  \
	fi
${AUTOREG_UNTAR}:     ${QUARANTINE_FLAG}    ${AUTOREG_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}    ${AUTOREG_TAR}  ;  \
	fi
${BET_UNTAR}:     ${QUARANTINE_FLAG}      ${BET_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${BET_TAR}   ;  \
	fi
${BOOST_UNTAR}:     ${QUARANTINE_FLAG}      ${BOOST_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${BOOST_TAR}   ;  \
	fi
${BPL_UNTAR}:     ${QUARANTINE_FLAG}        ${BPL_TAR}   
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${BPL_TAR} ;  \
	fi
${CAREA_UNTAR}:     ${QUARANTINE_FLAG}      ${CAREA_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${CAREA_TAR}       ;  \
	fi
${CDF_UNTAR}:     ${QUARANTINE_FLAG}        ${CDF_TAR}   
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${CDF_TAR}  ;  \
	fi
${CGAL_UNTAR}:     ${QUARANTINE_FLAG}       ${CGAL_TAR}   
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}  ${CGAL_TAR}        ;  \
	fi
${CIVET_UNTAR}:     ${QUARANTINE_FLAG}      ${CIVET_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}    ${CIVET_TAR}       ; \
	fi
${CLASP_UNTAR}:     ${QUARANTINE_FLAG}      ${CLASP_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}    ${CLASP_TAR}       ; \
	fi
${CLASSIFY_UNTAR}:     ${QUARANTINE_FLAG}   ${CLASSIFY_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}  ${CLASSIFY_TAR}        ;  \
	fi
${CONGLOMERATE_UNTAR}:     ${QUARANTINE_FLAG}       ${CONGLOMERATE_TAR}   
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${CONGLOMERATE_TAR}        ;  \
	fi
${CSURFACE_UNTAR}:     ${QUARANTINE_FLAG}   ${CSURFACE_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${CSURFACE_TAR}    ;  \
	fi
${DIFFUSE_UNTAR}:     ${QUARANTINE_FLAG}    ${DIFFUSE_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}     ${DIFFUSE_TAR}     ;  \
	fi
${EBTKS_UNTAR}:     ${QUARANTINE_FLAG}      ${EBTKS_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${EBTKS_TAR}       ;  \
	fi
${GETOPT_UNTAR}:     ${QUARANTINE_FLAG}     ${GETOPT_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${GETOPT_TAR}      ;  \
	fi
${GSL_UNTAR}:     ${QUARANTINE_FLAG}        ${GSL_TAR}   
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${GSL_TAR}         ;  \
	fi
${HDF_UNTAR}:     ${QUARANTINE_FLAG}        ${HDF_TAR}   
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}  ${HDF_TAR}         ;  \
	fi
${ICBM152_UNTAR}:     ${QUARANTINE_FLAG}      ${ICBM152_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${ICBM152_TAR}       ;  \
	fi
${ICBM152NL_UNTAR}:     ${QUARANTINE_FLAG}      ${ICBM152NL_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${ICBM152NL_TAR}       ;  \
	fi
${ICBMTEMP_UNTAR}:     ${QUARANTINE_FLAG}      ${ICBMTEMP_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${ICBMTEMP_TAR}       ;  \
	fi
${INORM_UNTAR}:     ${QUARANTINE_FLAG}      ${INORM_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}    ${INORM_TAR}       ;  \
	fi
${ILT_UNTAR}:     ${QUARANTINE_FLAG}        ${ILT_TAR}  
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${ILT_TAR}         ;  \
	fi
${LAPLACE_UNTAR}:     ${QUARANTINE_FLAG}     ${LAPLACE_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${LAPLACE_TAR}      ;  \
	fi
${M4_UNTAR}:     ${QUARANTINE_FLAG}      ${M4_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}    ${M4_TAR} ;  \
	fi
${MINC_UNTAR}:     ${QUARANTINE_FLAG}      ${MINC_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${MINC_TAR}       ;  \
	fi
${MMORPH_UNTAR}:     ${QUARANTINE_FLAG}     ${MMORPH_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${MMORPH_TAR}      ;  \
	fi
${N3_UNTAR}:     ${QUARANTINE_FLAG}         ${N3_TAR}   
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}  ${N3_TAR}  ;  \
	fi
${OOBPL_UNTAR}:     ${QUARANTINE_FLAG}      ${OOBPL_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${OOBPL_TAR}       ;  \
	fi
${PCREPP_UNTAR}:     ${QUARANTINE_FLAG}     ${PCREPP_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}  ${PCREPP_TAR}         ;       \
	fi
${PCRE_UNTAR}:     ${QUARANTINE_FLAG}       ${PCRE_TAR}  
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}  ${PCRE_TAR}       ;       \
	fi
${PERLLIB_UNTAR}:     ${QUARANTINE_FLAG}     ${PERLLIB_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${PERLLIB_TAR}      ;  \
	fi
${PMP_UNTAR}:     ${QUARANTINE_FLAG}        ${PMP_TAR}  
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${PMP_TAR}  ;  \
	fi
${PVE_UNTAR}:     ${QUARANTINE_FLAG}        ${PVE_TAR}  
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${PVE_TAR} ;  \
	fi
${RAY_TRACE_UNTAR}:     ${QUARANTINE_FLAG}  ${RAY_TRACE_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${RAY_TRACE_TAR}    ; \
	fi
${SURFREG_UNTAR}:     ${QUARANTINE_FLAG}    ${SURFREG_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}  ${SURFREG_TAR}     ; \
	fi

#     +------------------------------------+
#     |  MAIN LIBRARIES AND CORE PROGRAMS  |
#     +------------------------------------+

LIBARGS      = $(PREFIX_PATH)/lib/libarguments.a
AVG305VBM    = $(PREFIX_PATH)/share/mni-models/avg305/average_305_mask_1mm.mnc
AUTOREG      = $(PREFIX_PATH)/bin/make_model
CAREA        = $(PREFIX_PATH)/bin/cortex_area
CIVET        = $(PREFIX_PATH)/CIVET$(CIVET_VERS)/CIVET_Processing_Pipeline
CLASP        = $(PREFIX_PATH)/bin/expand_from_white
CLASSIFY     = $(PREFIX_PATH)/bin/classify
CONGLOMERATE = $(PREFIX_PATH)/bin/volume_object_evaluate
CORTICAL     = $(PREFIX_PATH)/bin/deform_surface
DIFFUSE      = $(PREFIX_PATH)/bin/diffuse
ICBM152      = $(PREFIX_PATH)/share/mni-models/icbm_avg_152_pd_tal_lin_8_mask.mnc 
ICBM152NL    = $(PREFIX_PATH)/share/mni-models/icbm_avg_152_t1_tal_nlin_symmetric_VI_8_mask.mnc 
ICBMTEMP     = $(PREFIX_PATH)/share/ICBM/icbm_template_1.00mm.mnc
INORM        = $(PREFIX_PATH)/bin/headmask
LAPLACE      = $(PREFIX_PATH)/bin/laplacian_thickness $(PREFIX_PATH)/bin/normal_thickness
LIBBICPL     = $(PREFIX_PATH)/lib/libbicpl.a
LIBEBTKS     = $(PREFIX_PATH)/lib/libEBTKS.a
LIBGSL       = $(PREFIX_PATH)/lib/libgsl.a
LIBHDF       = $(PREFIX_PATH)/lib/libhdf5.a
LIBMINC      = $(PREFIX_PATH)/lib/libminc2.a
LIBNETCDF    = $(PREFIX_PATH)/lib/libnetcdf.a
LIBOOBPL     = $(PREFIX_PATH)/lib/liboobicpl.a
LIBPCRE      = $(PREFIX_PATH)/lib/libpcre.a
LIBPCREPP    = $(PREFIX_PATH)/lib/libpcre++.a
M4 	     = ${SOURCE_DIR}/m4
MINCBET      = $(PREFIX_PATH)/bin/mincbet
MMORPH       = $(PREFIX_PATH)/bin/mincmorph
N3           = $(PREFIX_PATH)/bin/nu_correct      
PVE          = $(PREFIX_PATH)/bin/pve
RAY_TRACE    = $(PREFIX_PATH)/bin/ray_trace
SURFREG      = $(PREFIX_PATH)/bin/surftracc $(PREFIX_PATH)/bin/surface-stats 

LIBBOOST     = $(PREFIX_PATH)/lib/libboost_serialization-gcc-s-1_33_1.a
LIBCGAL      = ${PREFIX_PATH}/lib/libCGAL.a
ENV_FILES    = ${PREFIX_PATH}/init.sh      ${PREFIX_PATH}/init.csh 

PERL_PRIV    = $(PREFIX_PATH)/perl
PL_LIB       = $(PERL_PRIV)/MNI/TagSet.pm
PMP          = $(PERL_PRIV)/PMP/sge.pod
GETOPT       = $(PERL_PRIV)/Getopt/Tabular.pm
ILT          = $(PERL_PRIV)/ILT/SceneObject/VolumeObject.pm

#     +-------------------------+
#     | Execution begins here.  |
#     +-------------------------+

$(LIBARGS):      $(ARGS_UNTAR)   $(M4_UNTAR)
	cd ${SOURCE_DIR}/${ARGS_PACKAGE} ;\
	if [ ! -d m4 ] ; then ln -fs ../m4 ./m4 ;fi ; \
	if [ ! -e Makefile ] ; then \
	 ./configure --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

# patch for VBM
$(AVG305VBM):	$(ICBM152NL)
	mkdir -p $(PREFIX_PATH)/share/avg305/ ;\
	ln -sf $(PREFIX_PATH)/share/mni-models/icbm_avg_152_t1_tal_nlin_symmetric_VI_mask.mnc $(PREFIX_PATH)/share/avg305/average_305_mask_1mm.mnc

$(AUTOREG):      $(AUTOREG_UNTAR)   $(M4_UNTAR)  $(LIBMINC)
	cd ${SOURCE_DIR}/${AUTOREG_PACKAGE} ;\
	if [ ! -d m4 ] ; then ln -fs ../m4 ./m4 ;fi ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) PERL=${PERL} ${CFG_COMP_FLAGS} ; \
	fi ; \
        MINC_COMPRESS=${MINC_COMPRESS} ; export MINC_COMPRESS ; \
        MINC_FORCE_V2=${MINC_FORCE_V2} ; export MINC_FORCE_V2 ; \
	${MAKE}; ${MAKE} install

$(CAREA):        $(CAREA_UNTAR)    $(M4_UNTAR)    $(LIBBICPL)
	cd ${SOURCE_DIR}/${CAREA_PACKAGE}/ ; \
	if [ ! -d m4 ] ; then ln -fs ../m4 ./m4 ;fi ; \
	if [ ! -e Makefile ] ; then \
	   ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(CIVET):        $(CIVET_UNTAR)    $(GETOPT)    $(PMP)
	cd ${SOURCE_DIR}/${CIVET_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) PERL=${PERL}; \
	fi ; \
	${MAKE}; ${MAKE} install

$(CLASP):        $(CLASP_UNTAR)    $(LIBBICPL)   $(GETOPT)
	cd ${SOURCE_DIR}/${CLASP_PACKAGE}/ ; \
	if [ ! -d m4 ] ; then ln -fs ../m4 ./m4 ;fi ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) PERL=${PERL} ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(CLASSIFY):     $(CLASSIFY_UNTAR) $(LIBMINC) $(LIBEBTKS)       
	cd ${SOURCE_DIR}/${CLASSIFY_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) LDFLAGS=${LDFLAGS} PERL=${PERL} ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(CONGLOMERATE): $(CONGLOMERATE_UNTAR) $(M4_UNTAR) $(LIBBICPL)
	cd ${SOURCE_DIR}/${CONGLOMERATE_PACKAGE}/; \
	rm -rf m4 ; \
	if [ ! -d m4 ] ; then ln -fs ../m4 ./m4 ;fi ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) PERL=${PERL} ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(CORTICAL):     $(CSURFACE_UNTAR) $(LIBBICPL)
	cd ${SOURCE_DIR}/${CSURFACE_PACKAGE}/; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) PERL=${PERL} ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(DIFFUSE):      $(DIFFUSE_UNTAR)  $(M4_UNTAR)  $(LIBBICPL)
	if [ "`uname -n`"m == "paris"m ] ; then \
	  ln -sf /usr/lib/gcc/x86_64-linux-gnu/4.3/libgfortran.a $(PREFIX_PATH)/lib/libgfortran.a ; \
	fi
	if [ "`uname -n`"m == "ip03"m ] ; then \
	  ln -sf /usr/lib64/libblas.so.3 $(PREFIX_PATH)/lib/libblas.so ; \
	  ln -sf /usr/lib64/libg2c.so.0 $(PREFIX_PATH)/lib/libg2c.so ; \
	  ln -sf /usr/lib64/liblapack.so.3 $(PREFIX_PATH)/lib/liblapack.so ; \
	fi ; \
	if [ "`uname -n`"m == "krylov.clumeq.mcgill.ca"m ] ; then \
	  ln -sf /usr/lib64/libg2c.so.0 $(PREFIX_PATH)/lib/libg2c.so ; \
	fi ; \
	cd ${SOURCE_DIR}/${DIFFUSE_PACKAGE}/ ; \
	if [ ! -d m4 ] ; then ln -fs ../m4 ./m4 ;fi ; \
	if [ ! -e Makefile ] ; then \
	  ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(ICBM152):       $(ICBM152_UNTAR) $(AUTOREG) $(GETOPT)
	cd ${SOURCE_DIR}/${ICBM152_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	PERL5LIB=${PERL_PRIV} ; export PERL5LIB  ; \
        MINC_COMPRESS=${MINC_COMPRESS} ; export MINC_COMPRESS ; \
        MINC_FORCE_V2=${MINC_FORCE_V2} ; export MINC_FORCE_V2 ; \
	${MAKE}; ${MAKE} install

$(ICBM152NL):       $(ICBM152NL_UNTAR) $(AUTOREG) $(GETOPT)
	cd ${SOURCE_DIR}/${ICBM152NL_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	PERL5LIB=${PERL_PRIV} ; export PERL5LIB  ; \
        MINC_COMPRESS=${MINC_COMPRESS} ; export MINC_COMPRESS ; \
        MINC_FORCE_V2=${MINC_FORCE_V2} ; export MINC_FORCE_V2 ; \
	${MAKE}; ${MAKE} install

$(ICBMTEMP):       $(ICBMTEMP_UNTAR)
	cd ${SOURCE_DIR}/${ICBMTEMP_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	PERL5LIB=${PERL_PRIV} ; export PERL5LIB  ; \
        MINC_COMPRESS=${MINC_COMPRESS} ; export MINC_COMPRESS ; \
        MINC_FORCE_V2=${MINC_FORCE_V2} ; export MINC_FORCE_V2 ; \
	${MAKE}; ${MAKE} install

$(INORM):        ${INORM_UNTAR}    ${LIBMINC}  ${LIBEBTKS}
	cd ${SOURCE_DIR}/${INORM_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) PERL=${PERL} ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(LAPLACE):      $(LAPLACE_UNTAR)   $(LIBOOBPL)   $(GETOPT)
	cd ${SOURCE_DIR}/${LAPLACE_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) PERL=${PERL} ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(LIBBICPL):     $(BPL_UNTAR)      $(LIBMINC)
	cd ${SOURCE_DIR}/${BPL_PACKAGE}/ ; \
	if [ ! -d m4 ] ; then ln -fs ../m4 ./m4 ;fi ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH):$(PREFIX_PATH)  ${BICPL_BUILD_SWITCH} ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(LIBEBTKS):     $(EBTKS_UNTAR)    $(M4_UNTAR)   $(PL_LIB)       $(LIBNETCDF)
	cd ${SOURCE_DIR}/${EBTKS_PACKAGE}/ ; \
	if [ ! -d m4 ] ; then ln -fs ../m4 ./m4 ;fi ; \
	if [ ! -e Makefile ] ; then \
	 ./configure --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS}; \
	fi ; \
	${MAKE}; ${MAKE} install

$(LIBHDF):       $(HDF_UNTAR)
	cd ${SOURCE_DIR}/${HDF_PACKAGE} ; \
	if [ ! -e config.cache ] ; then \
	  ./configure --disable-shared --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(LIBMINC):      $(MINC_UNTAR) $(LIBNETCDF) $(LIBHDF)
	cd ${SOURCE_DIR}/${MINC_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) $(MINC_EXTRA) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) PERL=${PERL} ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(LIBOOBPL):     $(OOBPL_UNTAR)    $(LIBBICPL)   $(LIBPCREPP)   $(LIBARGS)
	cd ${SOURCE_DIR}/${OOBPL_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(LIBPCRE):      $(PCRE_UNTAR)
	cd ${SOURCE_DIR}/${PCRE_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure --enable-shared=no --enable-static=yes --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS}; \
	fi ; \
	${MAKE}; ${MAKE} install

$(LIBPCREPP):    $(PCREPP_UNTAR)   $(LIBPCRE)
	cd ${SOURCE_DIR}/${PCREPP_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure --disable-shared --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) --with-pcre-lib=$(PREFIX_PATH)/lib --with-pcre-include=$(PREFIX_PATH)/include ${CFG_COMP_FLAGS}; \
	fi ; \
	${MAKE}; ${MAKE} install

$(MINCBET):   $(BET_UNTAR)    $(M4_UNTAR)    $(LIBBICPL)
	cd ${SOURCE_DIR}/${BET_PACKAGE}/ ; \
	if [ ! -d m4 ] ; then ln -fs ../m4 ./m4 ;fi ; \
	if [ ! -e Makefile ] ; then \
	   ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(MMORPH):       $(MMORPH_UNTAR)   $(LIBMINC)
	cd ${SOURCE_DIR}/${MMORPH_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(N3):           ${N3_UNTAR}       $(LIBMINC)         $(LIBEBTKS)
	cd ${SOURCE_DIR}/${N3_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) PERL=${PERL} ${CFG_COMP_FLAGS}; \
	fi ; \
	${MAKE}; ${MAKE} install

$(PVE):          $(PVE_UNTAR)      $(LIBMINC)   $(GETOPT)
	cd ${SOURCE_DIR}/${PVE_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) PERL=${PERL} ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(RAY_TRACE):    ${RAY_TRACE_UNTAR} $(LIBBICPL)  
	cd ${SOURCE_DIR}/${RAY_TRACE_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) LDFLAGS='${VIEWER_LDFLAGS}' ${VIEWER_OPTS} ${CFG_COMP_FLAGS}; \
	fi ; \
	${MAKE}; ${MAKE} install

$(SURFREG):     $(SURFREG_UNTAR)  $(LIBBICPL)   $(LIBGSL)  $(LIBCGAL) $(LIBBOOST)
	cd ${SOURCE_DIR}/${SURFREG_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	  [ "`uname`"m == "IRIX64"m ] && [ "`domainname`"m == "bic"m ] && [ -f /usr/local/gnu/bin/ar ] && export PATH=/usr/local/gnu/bin:${PATH} ; \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) --with-cgal-makefile=${SOURCE_DIR}/${CGAL_PACKAGE}/make/makefile_$(shell ${SOURCE_DIR}/${CGAL_PACKAGE}/install_cgal -os g++) PERL=${PERL} ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

#   +---------------+
#   |   PERL LIBS   |
#   +---------------+

$(PL_LIB):       $(PERLLIB_UNTAR)
	@if [ ! -e $(PL_LIB) ] ; then \
	  cd ${SOURCE_DIR}/${PERLLIB_PACKAGE}/ ; \
	  echo $(PREFIX_PATH)>yes  ; \
	  ${PERL} ./Makefile.PL PREFIX=$(PREFIX_PATH) INSTALLDIRS=site INSTALLSITELIB=$(PERL_PRIV) INSTALLSITEARCH=$(PERL_PRIV) INSTALLMAN1DIR=$(PREFIX_PATH) INSTALLMAN3DIR=$(PREFIX_PATH) < yes ; \
	  ${MAKE}; ${MAKE} install; \
	  touch $(PL_LIB) ; \
	fi

$(GETOPT):       $(GETOPT_UNTAR)
	@if [ ! -e $(GETOPT) ] ; then \
	  cd ${SOURCE_DIR}/${GETOPT_PACKAGE}/ ; \
	  ${PERL} ./Makefile.PL PREFIX=$(PREFIX_PATH) INSTALLDIRS=site INSTALLSITELIB=$(PERL_PRIV) INSTALLSITEARCH=$(PERL_PRIV) INSTALLMAN1DIR=$(PREFIX_PATH) INSTALLMAN3DIR=$(PREFIX_PATH) ; \
	  ${MAKE}; ${MAKE} install; \
	  touch $(GETOPT) ; \
	fi

$(PMP):          ${PMP_UNTAR}      ${PL_LIB}
	@if [ ! -e $(PMP) ] ; then \
	  cd ${SOURCE_DIR}/${PMP_PACKAGE}/ ; \
	  echo $(PREFIX_PATH)>yes  ; \
	  ${PERL} ./Makefile.PL PREFIX=$(PREFIX_PATH) INSTALLDIRS=site INSTALLSITELIB=$(PERL_PRIV) INSTALLSITEARCH=$(PERL_PRIV) INSTALLMAN1DIR=$(PREFIX_PATH) INSTALLMAN3DIR=$(PREFIX_PATH) < yes ; \
	  ${MAKE}; ${MAKE} install; \
	  touch $(PMP) ; \
	fi

$(ILT):          ${ILT_UNTAR}
	@if [ ! -e $(ILT) ] ; then \
	  cd ${SOURCE_DIR}/${ILT_PACKAGE}/ ; \
	  echo $(PREFIX_PATH)>yes  ; \
	  ${PERL} ./Makefile.PL PREFIX=$(PREFIX_PATH) INSTALLDIRS=site INSTALLSITELIB=$(PERL_PRIV) INSTALLSITEARCH=$(PERL_PRIV) INSTALLMAN1DIR=$(PREFIX_PATH) INSTALLMAN3DIR=$(PREFIX_PATH) < yes ; \
	  ${MAKE}; ${MAKE} install; \
	  touch $(ILT) ; \
	fi

#   +-----------------------------------------+
#   |   SPECIAL CASE BUILDS OF EXTERNAL LIBS  |
#   |   Make external libs static             |
#   +-----------------------------------------+

$(LIBBOOST):     $(BOOST_UNTAR)
	cd ${SOURCE_DIR}/${BOOST_PACKAGE} ; \
	if [ ! -d ${BJAM} ] ; then \
	    cd ./tools/build/jam_src ; \
	   ./build.sh gcc && cd ../../.. ; \
	fi ;\
	PATH=${JAMPATH}:${PATH} ; export PATH ; \
	${BJAM}/bjam "-sBUILD=release <runtime-link>static <threading>single" "-sTOOLS=gcc" --prefix=$(PREFIX_PATH) --builddir=$(BOOSTTMP) install ; \
	echo If compilation aborts in BOOST, simply restart make. This is normal. ; \
	if [ -f ${LIBBOOST} ] ; then \
	  touch ${LIBBOOST} ; \
	fi ;

$(LIBCGAL):      $(CGAL_UNTAR) $(LIBBOOST)
	cd ${SOURCE_DIR}/${CGAL_PACKAGE} ; \
	./install_cgal --non-interactive --CXX g++ --disable-shared --without-autofind --with-BOOST --BOOST_INCL_DIR ${SOURCE_DIR}/${BOOST_PACKAGE}; \
	cp -f ${SOURCE_DIR}/${CGAL_PACKAGE}/lib/$(shell ${SOURCE_DIR}/${CGAL_PACKAGE}/install_cgal -os g++)/libCGAL.a ${PREFIX_PATH}/lib/libCGAL.a ; \
	if [ -f  ${SOURCE_DIR}/${CGAL_PACKAGE}/lib/$(shell ${SOURCE_DIR}/${CGAL_PACKAGE}/install_cgal -os g++)/libCGAL.so ] ; then \
	  cp -f ${SOURCE_DIR}/${CGAL_PACKAGE}/lib/$(shell ${SOURCE_DIR}/${CGAL_PACKAGE}/install_cgal -os g++)/libCGAL.so ${PREFIX_PATH}/lib/libCGAL.so ;\
	fi ;\
	if [ -f  ${SOURCE_DIR}/${CGAL_PACKAGE}/lib/$(shell ${SOURCE_DIR}/${CGAL_PACKAGE}/install_cgal -os g++)/libCGAL.dylib ] ; then \
	  cp -f ${SOURCE_DIR}/${CGAL_PACKAGE}/lib/$(shell ${SOURCE_DIR}/${CGAL_PACKAGE}/install_cgal -os g++)/libCGAL.dylib ${PREFIX_PATH}/lib/libCGAL.dylib ;\
	fi

# For <= 3.6.1
# cd ${SOURCE_DIR}/${CDF_PACKAGE}/src ; \
# ./configure --prefix=$(PREFIX_PATH) --without-F90 ${CFG_COMP_FLAGS} F90=false FC=false CXX=false CC=gcc; \
#
# For 3.6.2-beta6
# cd ${SOURCE_DIR}/${CDF_PACKAGE} ; \
# ./configure --prefix=$(PREFIX_PATH) --disable-f77 --disable-cxx --disable-examples --disable-utilities ${CFG_COMP_FLAGS} CC=gcc; \
#

$(LIBNETCDF): ${CDF_UNTAR}
	cd ${SOURCE_DIR}/${CDF_PACKAGE}/src ; \
	if  [ ! -e config.log ] ; then \
	 ./configure --prefix=$(PREFIX_PATH) --without-F90 ${CFG_COMP_FLAGS} F90=false FC=false CXX=false CC=gcc; \
	fi ; \
	${MAKE}; ${MAKE} install

$(LIBGSL):       ${GSL_UNTAR}
	cd ${SOURCE_DIR}/${GSL_PACKAGE} ; \
	if [ ! -e Makefile ] ; then \
	 ./configure --enable-shared=no --enable-static=yes --enable-maintainer-mode --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE} ; ${MAKE} install

#   +-----------------------------------------+
#   |	make the required environment file   |
#   +----------------------------------------+

${ENV_FILES}:
	@./mk_environment.pl ${PREFIX_PATH}
	@echo making ${PREFIX_PATH}/init.sh
	@echo making ${PREFIX_PATH}/init.csh

#     +-------------+
#     |  SHORTCUTS  |
#     +-------------+
ILT           :  $(ILT)
ilt           :  $(ILT)
N3            :  $(N3)
n3            :  $(N3)
PMP           :  $(PMP)
pmp           :  $(PMP)
arguments     :  $(LIBARGS)
autoreg       :  $(AUTOREG)
bicpl         :  $(LIBBICPL)
boost         :  $(LIBBOOST)
cgal          :  $(LIBCGAL)
civet         :  $(CIVET) 
clasp         :  $(CLASP) 
classify      :  $(CLASSIFY)
conglomerate  :  $(CONGLOMERATE)
cortex_area   :  $(CAREA)
cortical      :  $(CORTICAL)
diffuse       :  $(DIFFUSE)
ebtks         :  $(LIBEBTKS)
getopt        :  $(GETOPT)
gsl           :  $(LIBGSL)
hdf           :  $(LIBHDF)
icbm152       :  $(ICBM152)
icbm152nl     :  $(ICBM152NL)
icbmtemplate  :  $(ICBMTEMP)
inormalize    :  $(INORM)
laplace       :  $(LAPLACE)
m4            :  $(M4_UNTAR)
minc          :  $(LIBMINC)
mincbet       :  $(MINCBET)
mincmorph     :  $(MMORPH)
perllib       :  ${PL_LIB}
netcdf        :  $(LIBNETCDF)
oobicpl       :  $(LIBOOBPL)
pcre          :  $(LIBPCRE)
pcrepp        :  $(LIBPCREPP)
pve           :  $(PVE)
raytrace      :  $(RAY_TRACE)
surfreg       :  $(SURFREG)

inits         :  ${ENV_FILES}

utils         :  perllib getopt PMP ILT m4
models        :  icbm152 icbm152nl
avg305vbm     :  ${AVG305VBM}

main          :  utils N3 autoreg clasp classify conglomerate \
                 cortex_area cortical diffuse inormalize laplace \
                 mincbet mincmorph pve raytrace surfreg models \
                 icbmtemplate avg305vbm inits

untar:   ${ARGS_UNTAR} \
         ${AUTOREG_UNTAR} \
         ${BET_UNTAR} \
         ${BOOST_UNTAR} \
         ${BPL_UNTAR} \
         ${CAREA_UNTAR} \
         ${CDF_UNTAR} \
         ${CGAL_UNTAR} \
         ${CIVET_UNTAR} \
         ${CLASP_UNTAR} \
         ${CLASSIFY_UNTAR} \
         ${CONGLOMERATE_UNTAR} \
         ${CSURFACE_UNTAR} \
         ${DIFFUSE_UNTAR} \
         ${EBTKS_UNTAR} \
         ${GETOPT_UNTAR} \
         ${GSL_UNTAR} \
         ${HDF_UNTAR} \
         ${ICBM152_UNTAR} \
         ${ICBM152NL_UNTAR} \
         ${ICBMTEMP_UNTAR} \
         ${ILT_UNTAR} \
         ${INORM_UNTAR} \
         ${LAPLACE_UNTAR} \
         ${M4_UNTAR} \
         ${MINC_UNTAR} \
         ${MMORPH_UNTAR} \
         ${N3_UNTAR} \
         ${OOBPL_UNTAR} \
         ${PCRE_UNTAR} \
         ${PCREPP_UNTAR} \
         ${PERLLIB_UNTAR} \
         ${PMP_UNTAR} \
         ${PVE_UNTAR} \
         ${RAY_TRACE_UNTAR} \
         ${SURFREG_UNTAR}

#     +-----------------------------------------------------+
#     |  DELETION OF THE OBJECTS FILES OF THE MAIN PROGRAM  |
#     +-----------------------------------------------------+
#
remove_target:
	rm -f $(AUTOREG) \
	rm -f $(CAREA) \
	rm -f $(CIVET) \
	rm -f $(CLASP) \
	rm -f $(CLASSIFY) \
	rm -f $(CONGLOMERATE) \
	rm -f $(CORTICAL) \
	rm -f $(DIFFUSE) \
	rm -f $(GETOPT) \
	rm -f $(ICBM152) \
	rm -f $(ICBM152NL) \
	rm -f $(ICBMTEMP) \
	rm -f $(ILT) \
	rm -f $(INORM) \
	rm -f $(LAPLACE) \
	rm -f $(LIBARGS) \
	rm -f $(LIBBICPL) \
	rm -f $(LIBBOOST) \
	rm -f $(LIBCGAL) \
	rm -f $(LIBEBTKS) \
	rm -f $(LIBGSL) \
	rm -f $(LIBHDF) \
	rm -f $(LIBMINC) \
	rm -f $(LIBNETCDF) \
	rm -f $(LIBOOBPL) \
	rm -f $(LIBPCRE) \
	rm -f $(LIBPCREPP) \
	rm -f $(M4_UNTAR) \
	rm -f $(MINCBET) \
	rm -f $(MMORPH) \
	rm -f $(N3) \
	rm -f ${PL_LIB} \
	rm -f $(PMP) \
	rm -f $(PVE) \
	rm -f $(RAY_TRACE) \
	rm -f $(SURFREG)

flush: clean remove_target

clean:
	cd ${SOURCE_DIR}/${ARGS_PACKAGE}   		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${AUTOREG_PACKAGE}   		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${BET_PACKAGE}/           	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${BOOST_PACKAGE}               ; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${BPL_PACKAGE}/           	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${CAREA_PACKAGE}/         	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${CDF_PACKAGE}/src       	; ${MAKE} clean ; rm -f macros.make  ;\
	cd ${SOURCE_DIR}/${CGAL_PACKAGE}		; ${MAKE} clean ; rm -f config.log  ;\
	cd ${SOURCE_DIR}/${CIVET_PACKAGE}/         	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${CLASP_PACKAGE}/         	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${CLASSIFY_PACKAGE}/          	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${CONGLOMERATE_PACKAGE}/  	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${CSURFACE_PACKAGE}/    	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${DIFFUSE_PACKAGE}/          	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${EBTKS_PACKAGE}   		; ${MAKE} clean ; rm -f config.cache  ;\
	cd ${SOURCE_DIR}/${GETOPT_PACKAGE}/ 	 	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${GSL_PACKAGE}                 ; ${MAKE} clean ; rm -f config.cache  ;\
	cd ${SOURCE_DIR}/${HDF_PACKAGE}              	; ${MAKE} clean ; rm -f config.cache  ;\
	cd ${SOURCE_DIR}/${ILT_PACKAGE}/              	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${INORM_PACKAGE}/          	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${LAPLACE_PACKAGE}/ 		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${MINC_PACKAGE}/           	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${MMORPH_PACKAGE}/          	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${N3_PACKAGE}/          	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${ICBM152_PACKAGE}/		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${ICBM152NL_PACKAGE}/		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${ICBMTEMP_PACKAGE}/		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${PERLLIB_PACKAGE}/     	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${SURFREG_PACKAGE}/   		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${OOBPL_PACKAGE}/          	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${PCRE_PACKAGE}             	; ${MAKE} clean ; rm -f config.cache  ;\
	cd ${SOURCE_DIR}/${PCREPP_PACKAGE}         	; ${MAKE} clean ; rm -f config.cache ;\
	cd ${SOURCE_DIR}/${PMP_PACKAGE}/               	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${PVE_PACKAGE}/                ; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${RAY_TRACE_PACKAGE}/    	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\

