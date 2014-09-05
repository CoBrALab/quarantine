
SHELL=/bin/sh

CVS_HEAD=" $Id: Makefile,v 1.141 2013-02-06 22:51:27 claude Exp $ "

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
	@echo "  mnilibs    - internal BIC libs (bicpl, EBTKS, etc)"
	@echo "  main       - core codes (pve, clasp, surfreg, etc)"
	@echo "  civet      - CIVET pipeline"
	@echo "  visual     - BIC viewers (Display, register, brainview)"
	@echo "  clean      - clean-up (incomplete)"
	@echo "  imagemagick - from ftp://ftp.imagemagick.org/pub/"
	@echo 
	@echo "If some modules fail to compile, you may have to install"
	@echo "the following packages on your Linux Debian/Ubuntu system:"
	@echo "  sudo apt-get install build-essential "
	@echo "       libx11-dev freeglut3-dev libgmp3-dev libgnome-perl"
	@echo "       gawk zlib1g-dev m4 libgnome2-dev libgnome-dev xlibs-dev"
	@echo "       r-base r-base-core r-base-dev"
	@echo "For verify images, adding the following:"
	@echo "       imagemagick"
	@echo "or install it from sources at ftp://ftp.imagemagick.org/pub/"
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
MATLAB_ROOT = /usr/local/matlab

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
  BICPL_BUILD_SWITCH=--with-image-netpbm
  ifneq ($(findstring x86_64,$(shell uname -m)),)
    JAMARCH=bin.linuxx86_64
    # some silliness for RMINC-0.4 on Linux 64 bits
    CFLAGS+=-fpic
    CPPFLAGS+=-fpic
    CXXFLAGS+=-fpic
    MEX_EXT=mexa64
  else
    JAMARCH=bin.linuxx86
    MEX_EXT=mexglx
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

ADNI_VERS=-1.0
ARGS_VERS=-0.2.1
AUTOREG_VERS=-0.99.6
AVG305_VERS=-1.1
BET_VERS=-1.3.6
BICINVENTOR_VERS=-0.3.1
BOOST_VERS=_1_48_0
BPL_VERS=-1.4.7
BRAINVIEW_VERS=-0.8.0
CAREA_VERS=-1.3.0
CDF_VERS=-3.6.1
CGAL_VERS=-3.3.1
CIVET_VERS=-1.1.12
CLASP_VERS=-2.4.1
CLASSIFY_VERS=-1.1.1
COLIN27_VERS=-1.1
CONGLOMERATE_VERS=-1.6.7
CSURFACE_VERS=-1.2.2
DISPLAY_VERS=-1.5.0
EBTKS_VERS=-1.6.30
EMMA_VERS=-1.0.0
GETOPT_VERS=-0.3
GGS_VERS=-8.71.1
GLIM_VERS=-1.2
GSL_VERS=-1.8
HDF_VERS=5-1.8.8
ICBM152_VERS=-1.1
ICBM152NL_VERS=-1.1
ICBM152NL09_VERS=-1.0
ICBMTEMP_VERS=-1.0
ILT_VERS=-1.2.3
IMAGEMAGICK_VERS=-6.6.9-10
INORM_VERS=-1.0.2
LOBESEG_VERS=-1.0
LAPLACE_VERS=-1.2.0
M4_VERS=-1.0
MINC_VERS=-2.1.00
MMORPH_VERS=-1.4
N3_VERS=-1.10.1
NETPBM_VERS=-10.35.87
OOBPL_VERS=-0.4.7
PCREPP_VERS=-0.9.5
PCRE_VERS=-7.8
PERLLIB_VERS=-0.08
PMP_VERS=-0.8.0
PVE_VERS=-1.3.0
QVAL_VERS=_1.18.0
RAY_TRACE_VERS=-1.0.4
REGISTER_VERS=-1.4.0
RMINC_VERS=_0.5.1
RSTAT_VERS=-0.9.4
STXSEG_VERS=-1.0
SURFREG_VERS=-0.6.2
TRUEFONT_VERS=-2.0

#     +---------------------+
#     |  NAMES OF PACKAGES  |
#     +---------------------+

ADNI_PACKAGE=mni-models_adni_nl${ADNI_VERS}
ARGS_PACKAGE=arguments${ARGS_VERS}
AUTOREG_PACKAGE=mni_autoreg${AUTOREG_VERS}
AVG305_PACKAGE=mni-models_average305-lin${AVG305_VERS}
BET_PACKAGE=mincbet${BET_VERS}
BICINVENTOR_PACKAGE=bicInventor${BICINVENTOR_VERS}
BOOST_PACKAGE=boost${BOOST_VERS}
BPL_PACKAGE=bicpl${BPL_VERS}
BRAINVIEW_PACKAGE=brain-view${BRAINVIEW_VERS}
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
COLIN27_PACKAGE=mni-models_colin27-lin${COLIN27_VERS}
CONGLOMERATE_PACKAGE=conglomerate${CONGLOMERATE_VERS}
CSURFACE_PACKAGE=cortical_surface${CSURFACE_VERS}
DISPLAY_PACKAGE=Display${DISPLAY_VERS}
ifeq ($(EBTKS_VERS),-1.4)
  EBTKS_PACKAGE=EBTKS${EBTKS_VERS}
else
  EBTKS_PACKAGE=ebtks${EBTKS_VERS}
endif
EMMA_PACKAGE=emma${EMMA_VERS}
GETOPT_PACKAGE=Getopt-Tabular${GETOPT_VERS}
GGS_PACKAGE=gnu-ghostscript${GGS_VERS}
GLIM_PACKAGE=glim_image${GLIM_VERS}
GSL_PACKAGE=gsl${GSL_VERS}
HDF_PACKAGE=hdf${HDF_VERS}
ICBM152_PACKAGE=mni-models_icbm152-lin${ICBM152_VERS}
ICBM152NL_PACKAGE=mni-models_icbm152-nl${ICBM152NL_VERS}
ICBM152NL09_PACKAGE=mni-models_icbm152-nl-2009${ICBM152NL09_VERS}
ICBMTEMP_PACKAGE=mni-templates${ICBMTEMP_VERS}
ILT_PACKAGE=ILT${ILT_VERS}
IMAGEMAGICK_PACKAGE=ImageMagick${IMAGEMAGICK_VERS}
INORM_PACKAGE=inormalize${INORM_VERS}
LOBESEG_PACKAGE=mni_lobe_segment${LOBESEG_VERS}
LAPLACE_PACKAGE=laplacian_thickness${LAPLACE_VERS}
M4_PACKAGE=mni_m4${M4_VERS}
MINC_PACKAGE=minc${MINC_VERS}
MMORPH_PACKAGE=mincmorph${MMORPH_VERS}
N3_PACKAGE=N3${N3_VERS}
NETPBM_PACKAGE=netpbm${NETPBM_VERS}
OOBPL_PACKAGE=oobicpl${OOBPL_VERS}
PCREPP_PACKAGE=pcre++${PCREPP_VERS}
PCRE_PACKAGE=pcre${PCRE_VERS}
PERLLIB_PACKAGE=mni_perllib${PERLLIB_VERS}
PMP_PACKAGE=PMP${PMP_VERS}
PVE_PACKAGE=pve${PVE_VERS}
QVAL_PACKAGE=qvalue${QVAL_VERS}
RAY_TRACE_PACKAGE=ray_trace${RAY_TRACE_VERS}
REGISTER_PACKAGE=Register${REGISTER_VERS}
RMINC_PACKAGE=RMINC${RMINC_VERS}
RSTAT_PACKAGE=mni_cortical_statistics${RSTAT_VERS}
STXSEG_PACKAGE=mni_stx_segment${STXSEG_VERS}
ifeq ($(SURFREG_VERS),-0.4)
  SURFREG_PACKAGE=mni-surfreg${SURFREG_VERS}
else
  SURFREG_PACKAGE=mni_surfreg${SURFREG_VERS}
endif
TRUEFONT_PACKAGE=urw-fonts${TRUEFONT_VERS}

TGZ_FLAG=${PWD}/TGZ/.tgz_created
TGZ_DIR=${PWD}/TGZ

#     +---------------+
#     |  BOOST STUFF  |
#     +---------------+

## JAMPATH := ${SOURCE_DIR}/${BOOST_PACKAGE}/boost-jam-3.1.10/
BJAM := ${SOURCE_DIR}/${BOOST_PACKAGE}/tools/build/v2/engine/${JAMARCH}
BOOSTTMP := /tmp

#     +------------------------+
#     |  SOURCE FILE TARGETS   |
#     +------------------------+
 
ADNI_TAR=${TGZ_DIR}/${ADNI_PACKAGE}.tar.gz
ARGS_TAR=${TGZ_DIR}/${ARGS_PACKAGE}.tar.gz
AUTOREG_TAR=${TGZ_DIR}/${AUTOREG_PACKAGE}.tar.gz
AVG305_TAR=${TGZ_DIR}/${AVG305_PACKAGE}.tar.gz
BET_TAR=${TGZ_DIR}/${BET_PACKAGE}.tar.gz
BICINVENTOR_TAR=${TGZ_DIR}/${BICINVENTOR_PACKAGE}.tar.gz
BOOST_TAR=${TGZ_DIR}/${BOOST_PACKAGE}.tar.gz
BPL_TAR=${TGZ_DIR}/${BPL_PACKAGE}.tar.gz
BRAINVIEW_TAR=${TGZ_DIR}/${BRAINVIEW_PACKAGE}.tar.gz
CAREA_TAR=${TGZ_DIR}/${CAREA_PACKAGE}.tar.gz
CDF_TAR=${TGZ_DIR}/${CDF_PACKAGE}.tar.gz
CGAL_TAR=${TGZ_DIR}/${CGAL_PACKAGE}.tar.gz
CIVET_TAR=${TGZ_DIR}/${CIVET_PACKAGE}.tar.gz
CLASP_TAR=${TGZ_DIR}/${CLASP_PACKAGE}.tar.gz
CLASSIFY_TAR=${TGZ_DIR}/${CLASSIFY_PACKAGE}.tar.gz
COLIN27_TAR=${TGZ_DIR}/${COLIN27_PACKAGE}.tar.gz
CONGLOMERATE_TAR=${TGZ_DIR}/${CONGLOMERATE_PACKAGE}.tar.gz
CSURFACE_TAR=${TGZ_DIR}/${CSURFACE_PACKAGE}.tar.gz
DISPLAY_TAR=${TGZ_DIR}/${DISPLAY_PACKAGE}.tar.gz
EBTKS_TAR=${TGZ_DIR}/${EBTKS_PACKAGE}.tar.gz
EMMA_TAR=${TGZ_DIR}/${EMMA_PACKAGE}.tar.gz
GETOPT_TAR=${TGZ_DIR}/${GETOPT_PACKAGE}.tar.gz
GGS_TAR=${TGZ_DIR}/${GGS_PACKAGE}.tar.bz2
GLIM_TAR=${TGZ_DIR}/${GLIM_PACKAGE}.tar.gz
GSL_TAR=${TGZ_DIR}/${GSL_PACKAGE}.tar.gz
HDF_TAR=${TGZ_DIR}/${HDF_PACKAGE}.tar.gz
ICBM152_TAR=${TGZ_DIR}/${ICBM152_PACKAGE}.tar.gz
ICBM152NL_TAR=${TGZ_DIR}/${ICBM152NL_PACKAGE}.tar.gz
ICBM152NL09_TAR=${TGZ_DIR}/${ICBM152NL09_PACKAGE}.tar.gz
ICBMTEMP_TAR=${TGZ_DIR}/${ICBMTEMP_PACKAGE}.tar.gz
ILT_TAR=${TGZ_DIR}/${ILT_PACKAGE}.tar.gz
IMAGEMAGICK_TAR=${TGZ_DIR}/${IMAGEMAGICK_PACKAGE}.tar.gz
INORM_TAR=${TGZ_DIR}/${INORM_PACKAGE}.tar.gz
LOBESEG_TAR=${TGZ_DIR}/${LOBESEG_PACKAGE}.tar.gz
LAPLACE_TAR=${TGZ_DIR}/${LAPLACE_PACKAGE}.tar.gz
M4_TAR=${TGZ_DIR}/${M4_PACKAGE}.tar.gz
MINC_TAR=${TGZ_DIR}/${MINC_PACKAGE}.tar.gz
MMORPH_TAR=${TGZ_DIR}/${MMORPH_PACKAGE}.tar.gz
N3_TAR=${TGZ_DIR}/${N3_PACKAGE}.tar.gz
NETPBM_TAR=${TGZ_DIR}/${NETPBM_PACKAGE}.tgz
OOBPL_TAR=${TGZ_DIR}/${OOBPL_PACKAGE}.tar.gz
PCREPP_TAR=${TGZ_DIR}/${PCREPP_PACKAGE}.tar.gz
PCRE_TAR=${TGZ_DIR}/${PCRE_PACKAGE}.tar.gz
PERLLIB_TAR=${TGZ_DIR}/${PERLLIB_PACKAGE}.tar.gz
PMP_TAR=${TGZ_DIR}/${PMP_PACKAGE}.tar.gz
PVE_TAR=${TGZ_DIR}/${PVE_PACKAGE}.tar.gz
QVAL_TAR=${TGZ_DIR}/${QVAL_PACKAGE}.tar.gz
RAY_TRACE_TAR=${TGZ_DIR}/${RAY_TRACE_PACKAGE}.tar.gz
REGISTER_TAR=${TGZ_DIR}/${REGISTER_PACKAGE}.tar.gz
RMINC_TAR=${TGZ_DIR}/${RMINC_PACKAGE}.tar.gz
RSTAT_TAR=${TGZ_DIR}/${RSTAT_PACKAGE}.tar.gz
STXSEG_TAR=${TGZ_DIR}/${STXSEG_PACKAGE}.tar.gz
SURFREG_TAR=${TGZ_DIR}/${SURFREG_PACKAGE}.tar.gz
TRUEFONT_TAR=${TGZ_DIR}/${TRUEFONT_PACKAGE}.tar.gz

# +------------------------------+
# |  THE FAMOUS UNTAR DIRECTORY  |
# +------------------------------+

ADNI_UNTAR=${SOURCE_DIR}/${ADNI_PACKAGE}
ARGS_UNTAR=${SOURCE_DIR}/${ARGS_PACKAGE}
AUTOREG_UNTAR=${SOURCE_DIR}/${AUTOREG_PACKAGE}
AVG305_UNTAR=${SOURCE_DIR}/${AVG305_PACKAGE}
BET_UNTAR=${SOURCE_DIR}/${BET_PACKAGE}
BICINVENTOR_UNTAR=${SOURCE_DIR}/${BICINVENTOR_PACKAGE}
BOOST_UNTAR=${SOURCE_DIR}/${BOOST_PACKAGE}
BPL_UNTAR=${SOURCE_DIR}/${BPL_PACKAGE}
BRAINVIEW_UNTAR=${SOURCE_DIR}/${BRAINVIEW_PACKAGE}
CAREA_UNTAR=${SOURCE_DIR}/${CAREA_PACKAGE}
CDF_UNTAR=${SOURCE_DIR}/${CDF_PACKAGE}/src/
CGAL_UNTAR=${SOURCE_DIR}/${CGAL_PACKAGE}
CIVET_UNTAR=${SOURCE_DIR}/${CIVET_PACKAGE}
CLASP_UNTAR=${SOURCE_DIR}/${CLASP_PACKAGE}
CLASSIFY_UNTAR=${SOURCE_DIR}/${CLASSIFY_PACKAGE}
COLIN27_UNTAR=${SOURCE_DIR}/${COLIN27_PACKAGE}
CONGLOMERATE_UNTAR=${SOURCE_DIR}/${CONGLOMERATE_PACKAGE}
CSURFACE_UNTAR=${SOURCE_DIR}/${CSURFACE_PACKAGE}
DISPLAY_UNTAR=${SOURCE_DIR}/${DISPLAY_PACKAGE}
EBTKS_UNTAR=${SOURCE_DIR}/EBTKS-release${EBTKS_VERS}
EMMA_UNTAR=${SOURCE_DIR}/${EMMA_PACKAGE}
GETOPT_UNTAR=${SOURCE_DIR}/${GETOPT_PACKAGE}
GGS_UNTAR=${SOURCE_DIR}/${GGS_PACKAGE}
GLIM_UNTAR=${SOURCE_DIR}/${GLIM_PACKAGE}
GSL_UNTAR=${SOURCE_DIR}/${GSL_PACKAGE}
HDF_UNTAR=${SOURCE_DIR}/${HDF_PACKAGE}
ICBM152_UNTAR=${SOURCE_DIR}/${ICBM152_PACKAGE}
ICBM152NL_UNTAR=${SOURCE_DIR}/${ICBM152NL_PACKAGE}
ICBM152NL09_UNTAR=${SOURCE_DIR}/${ICBM152NL09_PACKAGE}
ICBMTEMP_UNTAR=${SOURCE_DIR}/${ICBMTEMP_PACKAGE}
IMAGEMAGICK_UNTAR=${SOURCE_DIR}/${IMAGEMAGICK_PACKAGE}
INORM_UNTAR=${SOURCE_DIR}/${INORM_PACKAGE}
ILT_UNTAR=${SOURCE_DIR}/${ILT_PACKAGE}
LOBESEG_UNTAR=${SOURCE_DIR}/${LOBESEG_PACKAGE}
LAPLACE_UNTAR=${SOURCE_DIR}/${LAPLACE_PACKAGE}
M4_UNTAR=${SOURCE_DIR}/m4
MINC_UNTAR=${SOURCE_DIR}/${MINC_PACKAGE}
MMORPH_UNTAR=${SOURCE_DIR}/${MMORPH_PACKAGE}
N3_UNTAR=${SOURCE_DIR}/${N3_PACKAGE}
NETPBM_UNTAR=${SOURCE_DIR}/${NETPBM_PACKAGE}
OOBPL_UNTAR=${SOURCE_DIR}/${OOBPL_PACKAGE}
PCREPP_UNTAR=${SOURCE_DIR}/${PCREPP_PACKAGE}
PCRE_UNTAR=${SOURCE_DIR}/${PCRE_PACKAGE}
PERLLIB_UNTAR=${SOURCE_DIR}/${PERLLIB_PACKAGE}
PMP_UNTAR=${SOURCE_DIR}/${PMP_PACKAGE}
PVE_UNTAR=${SOURCE_DIR}/${PVE_PACKAGE}
QVAL_UNTAR=${SOURCE_DIR}/qvalue
RAY_TRACE_UNTAR=${SOURCE_DIR}/${RAY_TRACE_PACKAGE}
REGISTER_UNTAR=${SOURCE_DIR}/${REGISTER_PACKAGE}
RMINC_UNTAR=${SOURCE_DIR}/${RMINC_PACKAGE}
RSTAT_UNTAR=${SOURCE_DIR}/${RSTAT_PACKAGE}
STXSEG_UNTAR=${SOURCE_DIR}/${STXSEG_PACKAGE}
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
	mkdir -p $(PREFIX_PATH)/lib $(PREFIX_PATH)/include $(PREFIX_PATH)/man/man1 $(PREFIX_PATH)/man/man2 $(PREFIX_PATH)/man/man3  $(PREFIX_PATH)/man/man4  $(PREFIX_PATH)/man/man5  $(PREFIX_PATH)/man/man6  $(PREFIX_PATH)/man/man7  $(PREFIX_PATH)/man/man8  $(PREFIX_PATH)/man/man9 $(PREFIX_PATH)/perl
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

${ADNI_UNTAR}:     ${QUARANTINE_FLAG}    ${ADNI_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}    ${ADNI_TAR}  ;  \
	fi
${ARGS_UNTAR}:     ${QUARANTINE_FLAG}    ${ARGS_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}    ${ARGS_TAR}  ;  \
	fi
${AUTOREG_UNTAR}:     ${QUARANTINE_FLAG}    ${AUTOREG_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}    ${AUTOREG_TAR}  ;  \
	fi
${AVG305_UNTAR}:     ${QUARANTINE_FLAG}      ${AVG305_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${AVG305_TAR}       ;  \
	fi
${BET_UNTAR}:     ${QUARANTINE_FLAG}      ${BET_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${BET_TAR}   ;  \
	fi
${BICINVENTOR_UNTAR}:     ${QUARANTINE_FLAG}      ${BICINVENTOR_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${BICINVENTOR_TAR}       ;  \
	fi
${BOOST_UNTAR}:     ${QUARANTINE_FLAG}      ${BOOST_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${BOOST_TAR}   ;  \
	fi
${BPL_UNTAR}:     ${QUARANTINE_FLAG}        ${BPL_TAR}   
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${BPL_TAR} ;  \
	fi
${BRAINVIEW_UNTAR}:     ${QUARANTINE_FLAG}        ${BRAINVIEW_TAR}   
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${BRAINVIEW_TAR} ;  \
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
${COLIN27_UNTAR}:     ${QUARANTINE_FLAG}      ${COLIN27_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${COLIN27_TAR}       ;  \
	fi
${CONGLOMERATE_UNTAR}:     ${QUARANTINE_FLAG}       ${CONGLOMERATE_TAR}   
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${CONGLOMERATE_TAR}        ;  \
	fi
${CSURFACE_UNTAR}:     ${QUARANTINE_FLAG}   ${CSURFACE_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${CSURFACE_TAR}    ;  \
	fi
${DISPLAY_UNTAR}:     ${QUARANTINE_FLAG}    ${DISPLAY_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}     ${DISPLAY_TAR}     ;  \
	fi
${EBTKS_UNTAR}:     ${QUARANTINE_FLAG}      ${EBTKS_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${EBTKS_TAR}       ;  \
	fi
${EMMA_UNTAR}:     ${QUARANTINE_FLAG}      ${EMMA_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${EMMA_TAR}       ;  \
	fi
${GETOPT_UNTAR}:     ${QUARANTINE_FLAG}     ${GETOPT_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${GETOPT_TAR}      ;  \
	fi
${GGS_UNTAR}:     ${QUARANTINE_FLAG}        ${GGS_TAR}   
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} -xvjf  ${GGS_TAR}         ;  \
	fi
${GLIM_UNTAR}:     ${QUARANTINE_FLAG}       ${GLIM_TAR}   
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}     ${GLIM_TAR}        ;  \
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
${ICBM152NL09_UNTAR}:     ${QUARANTINE_FLAG}      ${ICBM152NL09_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${ICBM152NL09_TAR}       ;  \
	fi
${ICBMTEMP_UNTAR}:     ${QUARANTINE_FLAG}      ${ICBMTEMP_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${ICBMTEMP_TAR}       ;  \
	fi
${IMAGEMAGICK_UNTAR}:     ${QUARANTINE_FLAG}  ${IMAGEMAGICK_TAR}
	@if [ ! -d  $@ ] ;  then \
	  cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}    ${IMAGEMAGICK_TAR} ;  \
	fi
${INORM_UNTAR}:     ${QUARANTINE_FLAG}      ${INORM_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}    ${INORM_TAR}       ;  \
	fi
${ILT_UNTAR}:     ${QUARANTINE_FLAG}        ${ILT_TAR}  
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${ILT_TAR}         ;  \
	fi
${LOBESEG_UNTAR}:     ${QUARANTINE_FLAG}      ${LOBESEG_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${LOBESEG_TAR} ;  \
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
${NETPBM_UNTAR}:     ${QUARANTINE_FLAG}         ${NETPBM_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}  ${NETPBM_TAR}  ;  \
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
${QVAL_UNTAR}:     ${QUARANTINE_FLAG}        ${QVAL_TAR}  
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${QVAL_TAR} ;  \
	fi
${REGISTER_UNTAR}:     ${QUARANTINE_FLAG}    ${REGISTER_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}     ${REGISTER_TAR}     ;  \
	fi
${RAY_TRACE_UNTAR}:     ${QUARANTINE_FLAG}  ${RAY_TRACE_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${RAY_TRACE_TAR}    ; \
	fi
${RMINC_UNTAR}:     ${QUARANTINE_FLAG}    ${RMINC_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}  ${RMINC_TAR}     ; \
	fi
${RSTAT_UNTAR}:     ${QUARANTINE_FLAG}    ${RSTAT_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}  ${RSTAT_TAR}     ; \
	fi
${STXSEG_UNTAR}:     ${QUARANTINE_FLAG}      ${STXSEG_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}   ${STXSEG_TAR} ;  \
	fi
${SURFREG_UNTAR}:     ${QUARANTINE_FLAG}    ${SURFREG_TAR}
	@if [ ! -d  $@ ] ;  then \
	      cd ${SOURCE_DIR} ; ${GTAR} ${GTAR_FLAGS}  ${SURFREG_TAR}     ; \
	fi

#     +------------------------------------+
#     |  MAIN LIBRARIES AND CORE PROGRAMS  |
#     +------------------------------------+
ADNI         = $(PREFIX_PATH)/share/mni-models/mni_adni_t1w_tal_nlin_asym.mnc
LIBARGS      = $(PREFIX_PATH)/lib/libarguments.a
AVG305VBM    = $(PREFIX_PATH)/share/mni-models/avg305/average_305_mask_1mm.mnc
AUTOREG      = $(PREFIX_PATH)/bin/make_model
AVG305       = $(PREFIX_PATH)/share/mni-models/average305_t1_tal_lin_8_mask.mnc
BRAINVIEW    = $(PREFIX_PATH)/bin/brain-view
CAREA        = $(PREFIX_PATH)/bin/cortex_area
CIVET        = $(PREFIX_PATH)/CIVET$(CIVET_VERS)/CIVET_Processing_Pipeline
CLASP        = $(PREFIX_PATH)/bin/expand_from_white
CLASSIFY     = $(PREFIX_PATH)/bin/classify
COLIN27      = $(PREFIX_PATH)/share/mni-models/colin27_t1_tal_lin_8_mask.mnc
CONGLOMERATE = $(PREFIX_PATH)/bin/volume_object_evaluate
CORTICAL     = $(PREFIX_PATH)/bin/deform_surface
MNIDISPLAY   = $(PREFIX_PATH)/bin/Display
GGS          = $(PREFIX_PATH)/bin/gs
GLIM         = $(PREFIX_PATH)/bin/glim_image
ICBM152      = $(PREFIX_PATH)/share/mni-models/icbm_avg_152_pd_tal_lin_8_mask.mnc 
ICBM152NL    = $(PREFIX_PATH)/share/mni-models/icbm_avg_152_t1_tal_nlin_symmetric_VI_8_mask.mnc 
ICBM152NL09  = $(PREFIX_PATH)/share/mni-models/mni_icbm152_pd_tal_nlin_asym_09a.mnc 
ICBMTEMP     = $(PREFIX_PATH)/share/ICBM/icbm_template_1.00mm.mnc 
IMAGEMAGICK  = $(PREFIX_PATH)/bin/convert
INORM        = $(PREFIX_PATH)/bin/headmask
LAPLACE      = $(PREFIX_PATH)/bin/laplacian_thickness $(PREFIX_PATH)/bin/normal_thickness
LIBBICINVENTOR = $(PREFIX_PATH)/lib/libbicInventor.a
LIBBICPL     = $(PREFIX_PATH)/lib/libbicpl.a
LIBEBTKS     = $(PREFIX_PATH)/lib/libEBTKS.a
EMMA         = $(PREFIX_PATH)/emma/mireadvar.$(MEX_EXT) $(PREFIX_PATH)/bin/micreateimage
LIBGSL       = $(PREFIX_PATH)/lib/libgsl.a
LIBHDF       = $(PREFIX_PATH)/lib/libhdf5.a
LIBMINC      = $(PREFIX_PATH)/lib/libminc2.a
LIBNETCDF    = $(PREFIX_PATH)/lib/libnetcdf.a
LIBNETPBM    = $(PREFIX_PATH)/lib/libnetpbm.a
LIBOOBPL     = $(PREFIX_PATH)/lib/liboobicpl.a
LIBPCRE      = $(PREFIX_PATH)/lib/libpcre.a
LIBPCREPP    = $(PREFIX_PATH)/lib/libpcre++.a
LOBESEG      = $(PREFIX_PATH)/share/ANIMAL_INSECT/icbm152-lobes-v1.1/atlas_labels.mnc
M4 	     = ${SOURCE_DIR}/m4
MINCBET      = $(PREFIX_PATH)/bin/mincbet
MMORPH       = $(PREFIX_PATH)/bin/mincmorph
N3           = $(PREFIX_PATH)/bin/nu_correct
PVE          = $(PREFIX_PATH)/bin/pve
QVAL         = $(R_LIBS)/qvalue/R/qvalue
RAY_TRACE    = $(PREFIX_PATH)/bin/ray_trace
REGISTER     = $(PREFIX_PATH)/bin/register
RMINC        = $(R_LIBS)/RMINC/libs/RMINC.so
RSTAT        = $(R_LIBS)/mni.cortical.statistics/R/mni.cortical.statistics
STXSEG       = $(PREFIX_PATH)/share/ANIMAL_INSECT/icbm152-symmetric-v1.0/atlas.mnc
SURFREG      = $(PREFIX_PATH)/bin/surftracc

LIBBOOST     = $(PREFIX_PATH)/lib/libboost_serialization.a
LIBCGAL      = ${PREFIX_PATH}/lib/libCGAL.a
ENV_FILES    = ${PREFIX_PATH}/init.sh

PERL_PRIV    = $(PREFIX_PATH)/perl
PL_LIB       = $(PERL_PRIV)/MNI/TagSet.pm
PMP          = $(PERL_PRIV)/PMP/sge.pod
GETOPT       = $(PERL_PRIV)/Getopt/Tabular.pm
ILT          = $(PERL_PRIV)/ILT/SceneObject/VolumeObject.pm

#     +-------------------------+
#     | Execution begins here.  |
#     +-------------------------+

$(ADNI):       $(ADNI_UNTAR) $(AUTOREG) $(GETOPT)
	cd ${SOURCE_DIR}/${ADNI_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	PERL5LIB=${PERL_PRIV} ; export PERL5LIB  ; \
        MINC_COMPRESS=${MINC_COMPRESS} ; export MINC_COMPRESS ; \
        MINC_FORCE_V2=${MINC_FORCE_V2} ; export MINC_FORCE_V2 ; \
	${MAKE}; ${MAKE} install

$(LIBARGS):      $(ARGS_UNTAR)   $(M4_UNTAR)
	cd ${SOURCE_DIR}/${ARGS_PACKAGE} ;\
	if [ ! -d m4 ] ; then ln -fs ../m4 ./m4 ;fi ; \
	if [ ! -e Makefile ] ; then \
	 ./configure --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

# patch for VBM
# ln -sf $(PREFIX_PATH)/share/mni-models/icbm_avg_152_t1_tal_nlin_symmetric_VI_mask.mnc $(PREFIX_PATH)/share/avg305/average_305_mask_1mm.mnc
# make path relative so that quarantine can be relocated without an absolute path.
$(AVG305VBM):	$(ICBM152NL)
	mkdir -p $(PREFIX_PATH)/share/avg305/ ;\
	cd $(PREFIX_PATH)/share/avg305/ ;\
	ln -sf ../mni-models/icbm_avg_152_t1_tal_nlin_symmetric_VI_mask.mnc $(PREFIX_PATH)/share/avg305/average_305_mask_1mm.mnc

$(AUTOREG):      $(AUTOREG_UNTAR)   $(M4_UNTAR)  $(LIBMINC)
	cd ${SOURCE_DIR}/${AUTOREG_PACKAGE} ;\
	if [ ! -d m4 ] ; then ln -fs ../m4 ./m4 ;fi ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) PERL=${PERL} ${CFG_COMP_FLAGS} ; \
	fi ; \
        MINC_COMPRESS=${MINC_COMPRESS} ; export MINC_COMPRESS ; \
        MINC_FORCE_V2=${MINC_FORCE_V2} ; export MINC_FORCE_V2 ; \
	${MAKE}; ${MAKE} install

$(AVG305):       $(AVG305_UNTAR) $(AUTOREG) $(GETOPT)
	cd ${SOURCE_DIR}/${AVG305_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	PERL5LIB=${PERL_PRIV} ; export PERL5LIB  ; \
        MINC_COMPRESS=${MINC_COMPRESS} ; export MINC_COMPRESS ; \
        MINC_FORCE_V2=${MINC_FORCE_V2} ; export MINC_FORCE_V2 ; \
	${MAKE}; ${MAKE} install

# 
# Use this for the new brain-view-0.7.0 with Qt3.
#   	./configure $(MINC_FLAG) --disable-shared --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS}; \
#
# Use this for the new brain-view-0.8.0 with Qt4.
#
#	   ./configure $(MINC_FLAG) --disable-shared --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) CFLAGS='${CFLAGS} -DQT3_SUPPORT' CPPFLAGS='${CPPFLAGS} -DQT3_SUPPORT' CXXFLAGS='${CXXFLAGS} -DQT3_SUPPORT' LDFLAGS='${LDFLAGS} -lQt3Support'; \
#

$(BRAINVIEW):	$(BRAINVIEW_UNTAR)	$(M4_UNTAR) $(LIBBICINVENTOR)
	cd ${SOURCE_DIR}/${BRAINVIEW_PACKAGE}/ ; \
	if [ ! -d m4 ] ; then ln -fs ../m4 ./m4 ;fi ; \
	if [ ! -e Makefile ] ; then \
	   rm -rf textures/brain-view-config ; \
	   rm -rf src/brainEnvironment.cc ; \
	   ./configure $(MINC_FLAG) --disable-shared --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) CFLAGS='${CFLAGS} -DQT3_SUPPORT' CPPFLAGS='${CPPFLAGS} -DQT3_SUPPORT' CXXFLAGS='${CXXFLAGS} -DQT3_SUPPORT' LDFLAGS='${LDFLAGS} -lQt3Support'; \
	fi ; \
	${MAKE}; ${MAKE} install

$(CAREA):        $(CAREA_UNTAR)    $(M4_UNTAR)    $(LIBBICPL)
	cd ${SOURCE_DIR}/${CAREA_PACKAGE}/ ; \
	if [ ! -d m4 ] ; then ln -fs ../m4 ./m4 ;fi ; \
	if [ ! -e Makefile ] ; then \
	   ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

# Ugly fix for civet mask for ADNI.
$(CIVET):        $(CIVET_UNTAR)    $(GETOPT)    $(PMP)  $(ADNI)
	cd ${SOURCE_DIR}/${CIVET_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 #./configure --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) PERL=${PERL}; \
	 ./configure --prefix=$(PREFIX_PATH) PERL=${PERL}; \
	fi ; \
	${MAKE}; ${MAKE} install ; \
	cd $(PREFIX_PATH)/CIVET$(CIVET_VERS)/models ; \
	ln -sf ../../share/mni-models/Cerebellum_Ventricles_SubCortical_Mask-ADNI.mnc $(PREFIX_PATH)/CIVET$(CIVET_VERS)/models/

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

$(COLIN27):       $(COLIN27_UNTAR) $(AUTOREG) $(GETOPT)
	cd ${SOURCE_DIR}/${COLIN27_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	PERL5LIB=${PERL_PRIV} ; export PERL5LIB  ; \
        MINC_COMPRESS=${MINC_COMPRESS} ; export MINC_COMPRESS ; \
        MINC_FORCE_V2=${MINC_FORCE_V2} ; export MINC_FORCE_V2 ; \
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

$(MNIDISPLAY):      $(DISPLAY_UNTAR)  $(LIBBICPL)
	cd ${SOURCE_DIR}/${DISPLAY_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) LDFLAGS='${VIEWER_LDFLAGS}' ${VIEWER_OPTS} ${CFG_COMP_FLAGS}; \
	fi ; \
	${MAKE}; ${MAKE} install

$(GGS): $(GGS_UNTAR)
	cd ${SOURCE_DIR}/${GGS_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	  ./configure --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS}; \
	fi ; \
	${MAKE}; ${MAKE} install

$(GLIM):         ${GLIM_UNTAR}     ${LIBMINC}
	cd ${SOURCE_DIR}/${GLIM_PACKAGE}/ ; \
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

$(ICBM152NL09):       $(ICBM152NL09_UNTAR) $(AUTOREG) $(GETOPT)
	cd ${SOURCE_DIR}/${ICBM152NL09_PACKAGE}/ ; \
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

$(IMAGEMAGICK): $(IMAGEMAGICK_UNTAR) $(GGS)
	cd ${PREFIX_PATH}/share/ ; ${GTAR} ${GTAR_FLAGS} ${TRUEFONT_TAR} ; \
	cd ${SOURCE_DIR}/${IMAGEMAGICK_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	  ./configure --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) --with-gs-font-dir=$(PREFIX_PATH)/share/fonts/default/Type1/ ${CFG_COMP_FLAGS}; \
	fi ; \
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

$(LIBBICINVENTOR):     $(BICINVENTOR_UNTAR)    $(LIBBICPL)   $(LIBPCREPP)  $(LIBOOBPL)
	cd ${SOURCE_DIR}/${BICINVENTOR_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(LIBBICPL):     $(BPL_UNTAR)      $(LIBNETPBM)   $(LIBMINC)
	cd ${SOURCE_DIR}/${BPL_PACKAGE}/ ; \
	if [ ! -d m4 ] ; then ln -fs ../m4 ./m4 ;fi ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH):$(PREFIX_PATH)  ${BICPL_BUILD_SWITCH} ${CFG_COMP_FLAGS} ; \
	fi ; \
	${MAKE}; ${MAKE} install

$(LIBEBTKS):     $(EBTKS_UNTAR)    $(M4_UNTAR)   $(PL_LIB)       $(LIBNETCDF)
	cd ${EBTKS_UNTAR} ; \
        ./autogen.sh ; \
	if [ ! -d m4 ] ; then ln -fs ../m4 ./m4 ;fi ; \
	if [ ! -e Makefile ] ; then \
	 ./configure --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) ${CFG_COMP_FLAGS}; \
	fi ; \
	${MAKE}; ${MAKE} install

$(EMMA):     $(EMMA_UNTAR)    $(LIBMINC)
	cd ${SOURCE_DIR}/${EMMA_PACKAGE}/ ; \
	${MAKE} MATLAB_ROOT=$(MATLAB_ROOT) MINCLIBPATH=-L$(PREFIX_PATH)/lib MINCINCPATH=-I$(PREFIX_PATH)/include MINC_BASE=$(MINC_BASE) CC=gcc ; \
	${MAKE} MATLAB_ROOT=$(MATLAB_ROOT) MATLAB_INSTALL_DIR=$(PREFIX_PATH)/emma BIN_INSTALL_DIR=$(PREFIX_PATH)/bin DOC_INSTALL_DIR=$(PREFIX_PATH)/doc/emma install

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

$(LIBNETPBM):      $(NETPBM_UNTAR)
	cd ${SOURCE_DIR}/${NETPBM_PACKAGE}/ ; \
	if [ ! -e Makefile.config ] ; then \
	 echo "**************************************************************" ;\
	 echo "* You are about to configure netpbm for the CIVET quarantine *" ;\
	 echo "* Choose all defaults options except libraries=static,       *" ;\
	 echo "* Svgalib=none and X11=none.                                 *" ;\
	 echo "**************************************************************" ;\
	 ./configure ; \
	fi ; \
	${MAKE}; \
	rm -rf ${PREFIX_PATH}/pbm ; \
	${MAKE} package pkgdir=${PREFIX_PATH}/pbm/; \
	mv -f ${PREFIX_PATH}/pbm/link/* ${PREFIX_PATH}/lib ; \
	mv -f ${PREFIX_PATH}/pbm/include/* ${PREFIX_PATH}/include ; \
	rm -rf ${PREFIX_PATH}/pbm

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

$(LOBESEG):       $(LOBESEG_UNTAR)
	cd ${SOURCE_DIR}/${LOBESEG_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH); \
	fi ; \
	PERL5LIB=${PERL_PRIV} ; export PERL5LIB  ; \
        MINC_COMPRESS=${MINC_COMPRESS} ; export MINC_COMPRESS ; \
        MINC_FORCE_V2=${MINC_FORCE_V2} ; export MINC_FORCE_V2 ; \
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

$(QVAL):	$(QVAL_UNTAR)
	cd ${SOURCE_DIR}/ ; \
	mkdir -p $(R_LIBS) ; \
	R CMD INSTALL -l $(R_LIBS) qvalue

$(RAY_TRACE):    ${RAY_TRACE_UNTAR} $(LIBBICPL)  
	cd ${SOURCE_DIR}/${RAY_TRACE_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) LDFLAGS='${VIEWER_LDFLAGS}' ${VIEWER_OPTS} ${CFG_COMP_FLAGS}; \
	fi ; \
	${MAKE}; ${MAKE} install

$(REGISTER):     $(REGISTER_UNTAR) $(LIBBICPL)
	cd ${SOURCE_DIR}/${REGISTER_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	  ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) LDFLAGS='${VIEWER_LDFLAGS}' ${VIEWER_OPTS} ${CFG_COMP_FLAGS}; \
	fi ; \
	${MAKE}; ${MAKE} install

$(RMINC):     $(RMINC_UNTAR) $(LIBMINC) $(QVAL)
	cd ${SOURCE_DIR}/ ; \
	mkdir -p $(R_LIBS) ; \
	R CMD INSTALL --configure-args='--with-build-path=$(BUILD_PATH)' -l $(R_LIBS) ${RMINC_PACKAGE}

# to build RMINC package.tar.gz, but it doesn't really work:
#export LDFLAGS=-L$(BUILD_PATH)/lib ;\
#export CPPFLAGS=-I$(BUILD_PATH)/include ;\
#R CMD build --no-vignettes ${RMINC_PACKAGE}

$(RSTAT):     $(RSTAT_UNTAR)
	cd ${SOURCE_DIR}/ ; \
	mkdir -p $(R_LIBS) ; \
	R CMD INSTALL --configure-args='--with-build-path=$(BUILD_PATH)' -l $(R_LIBS) ${RSTAT_PACKAGE}

$(STXSEG):       $(STXSEG_UNTAR)
	cd ${SOURCE_DIR}/${STXSEG_PACKAGE}/ ; \
	if [ ! -e Makefile ] ; then \
	 ./configure --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH); \
	fi ; \
	PERL5LIB=${PERL_PRIV} ; export PERL5LIB  ; \
	${MAKE}; ${MAKE} install

$(SURFREG):     $(SURFREG_UNTAR)  $(LIBBICPL)   $(LIBGSL)  $(LIBCGAL) $(LIBBOOST)
	cd ${SOURCE_DIR}/${SURFREG_PACKAGE}/ ; \
	if [ ! -d m4 ] ; then ln -fs ../m4 ./m4 ;fi ; \
	if [ ! -e Makefile ] ; then \
	  [ "`uname`"m == "IRIX64"m ] && [ "`domainname`"m == "bic"m ] && [ -f /usr/local/gnu/bin/ar ] && export PATH=/usr/local/gnu/bin:${PATH} ; \
	CGAL_MAKEFILE=${SOURCE_DIR}/${CGAL_PACKAGE}/make/`ls -1 ${SOURCE_DIR}/${CGAL_PACKAGE}/make | grep makefile_ | grep '[0-9]$$'`; \
	 ./configure $(MINC_FLAG) --prefix=$(PREFIX_PATH) --with-build-path=$(BUILD_PATH) --with-cgal-makefile=$$CGAL_MAKEFILE PERL=${PERL} ${CFG_COMP_FLAGS} ; \
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
	   cd ./tools/build/v2/engine ; \
	   ./build.sh gcc ; \
	   cd ../../../.. ; \
	fi ;\
	${BJAM}/bjam link=static threading=single --prefix=$(PREFIX_PATH) --builddir=$(BOOSTTMP) --with-serialization install ; \
	echo If compilation aborts in BOOST, simply restart make. This is normal. ; \
	if [ -f ${LIBBOOST} ] ; then \
	  touch ${LIBBOOST} ; \
	fi ;

$(LIBCGAL):      $(CGAL_UNTAR) $(LIBBOOST)
	cd ${SOURCE_DIR}/${CGAL_PACKAGE} ; \
	./install_cgal --non-interactive --CXX g++ --disable-shared --without-autofind --with-BOOST --BOOST_INCL_DIR ${SOURCE_DIR}/${BOOST_PACKAGE}; \
	CGAL_OS_COMPILER=`ls -1 ${SOURCE_DIR}/${CGAL_PACKAGE}/make | grep makefile_ | grep '[0-9]$$' | sed -e 's/makefile_//'`; \
	cp -f ${SOURCE_DIR}/${CGAL_PACKAGE}/lib/$$CGAL_OS_COMPILER/libCGAL.a ${PREFIX_PATH}/lib/libCGAL.a ; \
	if [ -f  ${SOURCE_DIR}/${CGAL_PACKAGE}/lib/$$CGAL_OS_COMPILER/libCGAL.so ] ; then \
	  cp -f ${SOURCE_DIR}/${CGAL_PACKAGE}/lib/$$CGAL_OS_COMPILER/libCGAL.so ${PREFIX_PATH}/lib/libCGAL.so ;\
	fi ;\
	if [ -f  ${SOURCE_DIR}/${CGAL_PACKAGE}/lib/$$CGAL_OS_COMPILER/libCGAL.dylib ] ; then \
	  cp -f ${SOURCE_DIR}/${CGAL_PACKAGE}/lib/$$CGAL_OS_COMPILER/libCGAL.dylib ${PREFIX_PATH}/lib/libCGAL.dylib ;\
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
adni          :  $(ADNI)
arguments     :  $(LIBARGS)
autoreg       :  $(AUTOREG)
avg305        :  $(AVG305)
bicInventor   :  $(LIBBICINVENTOR)
bicpl         :  $(LIBBICPL)
boost         :  $(LIBBOOST)
brainview     :  $(BRAINVIEW)
cgal          :  $(LIBCGAL)
civet         :  $(CIVET) 
clasp         :  $(CLASP) 
classify      :  $(CLASSIFY)
colin27       :  $(COLIN27)
conglomerate  :  $(CONGLOMERATE)
cortex_area   :  $(CAREA)
cortical      :  $(CORTICAL)
display       :  $(MNIDISPLAY)
ebtks         :  $(LIBEBTKS)
emma          :  $(EMMA)
getopt        :  $(GETOPT)
ggs           :  $(GGS)
glim          :  $(GLIM)
gsl           :  $(LIBGSL)
hdf           :  $(LIBHDF)
icbm152       :  $(ICBM152)
icbm152nl     :  $(ICBM152NL)
icbm152nl09   :  $(ICBM152NL09)
icbmtemplate  :  $(ICBMTEMP)
imagemagick   :  $(IMAGEMAGICK)
inormalize    :  $(INORM)
laplace       :  $(LAPLACE)
lobesegment   :  $(LOBESEG)
m4            :  $(M4_UNTAR)
minc          :  $(LIBMINC)
mincbet       :  $(MINCBET)
mincmorph     :  $(MMORPH)
perllib       :  ${PL_LIB}
netcdf        :  $(LIBNETCDF)
netpbm        :  $(LIBNETPBM)
oobicpl       :  $(LIBOOBPL)
pcre          :  $(LIBPCRE)
pcrepp        :  $(LIBPCREPP)
pve           :  $(PVE)
qvalue        :  $(QVAL)
raytrace      :  $(RAY_TRACE)
register      :  $(REGISTER)
rminc         :  $(RMINC)
rstat         :  $(RSTAT)
stxsegment    :  $(STXSEG)
surfreg       :  $(SURFREG)

inits         :  ${ENV_FILES}

utils         :  perllib getopt PMP ILT m4
mnilibs       :  minc ebtks bicpl oobicpl
models        :  adni avg305 colin27 icbm152 icbm152nl icbm152nl09
avg305vbm     :  ${AVG305VBM}

main          :  utils N3 autoreg clasp classify conglomerate \
                 cortex_area cortical inormalize laplace \
                 mincbet mincmorph pve raytrace surfreg models \
                 icbmtemplate rminc rstat avg305vbm inits

visual        :  register display brainview

untar:   ${ADNI_UNTAR} \
         ${ARGS_UNTAR} \
         ${AUTOREG_UNTAR} \
         ${AVG305_UNTAR} \
         ${BET_UNTAR} \
         ${BICINVENTOR_UNTAR} \
         ${BOOST_UNTAR} \
         ${BPL_UNTAR} \
         ${BRAINVIEW_UNTAR} \
         ${CAREA_UNTAR} \
         ${CDF_UNTAR} \
         ${CGAL_UNTAR} \
         ${CIVET_UNTAR} \
         ${CLASP_UNTAR} \
         ${CLASSIFY_UNTAR} \
         ${COLIN27_UNTAR} \
         ${CONGLOMERATE_UNTAR} \
         ${CSURFACE_UNTAR} \
         ${DISPLAY_UNTAR} \
         ${EBTKS_UNTAR} \
         ${EMMA_UNTAR} \
         ${GETOPT_UNTAR} \
         ${GGS_UNTAR} \
         ${GLIM_UNTAR} \
         ${GSL_UNTAR} \
         ${HDF_UNTAR} \
         ${ICBM152_UNTAR} \
         ${ICBM152NL_UNTAR} \
         ${ICBM152NL09_UNTAR} \
         ${ICBMTEMP_UNTAR} \
         ${ILT_UNTAR} \
         ${IMAGEMAGICK_UNTAR} \
         ${INORM_UNTAR} \
         ${LOBESEG_UNTAR} \
         ${LAPLACE_UNTAR} \
         ${M4_UNTAR} \
         ${MINC_UNTAR} \
         ${MMORPH_UNTAR} \
         ${N3_UNTAR} \
         ${NETPBM_UNTAR} \
         ${OOBPL_UNTAR} \
         ${PCRE_UNTAR} \
         ${PCREPP_UNTAR} \
         ${PERLLIB_UNTAR} \
         ${PMP_UNTAR} \
         ${PVE_UNTAR} \
         ${QVAL_UNTAR} \
         ${RAY_TRACE_UNTAR} \
         ${REGISTER_UNTAR} \
         ${RMINC_UNTAR} \
         ${RSTAT_UNTAR} \
         ${STXSEG_UNTAR} \
         ${SURFREG_UNTAR}

#     +-----------------------------------------------------+
#     |  DELETION OF THE OBJECTS FILES OF THE MAIN PROGRAM  |
#     +-----------------------------------------------------+
#
remove_target:
	rm -f $(ADNI) \
	rm -f $(AUTOREG) \
	rm -f $(AVG305) \
	rm -f $(BRAINVIEW) \
	rm -f $(CAREA) \
	rm -f $(CIVET) \
	rm -f $(CLASP) \
	rm -f $(CLASSIFY) \
	rm -f $(COLIN27) \
	rm -f $(CONGLOMERATE) \
	rm -f $(CORTICAL) \
	rm -f $(MNIDISPLAY) \
	rm -f $(GETOPT) \
	rm -f $(GGS) \
	rm -f $(GLIM) \
	rm -f $(GSL) \
	rm -f $(ICBM152) \
	rm -f $(ICBM152NL) \
	rm -f $(ICBM152NL09) \
	rm -f $(ICBMTEMP) \
	rm -f $(ILT) \
	rm -f $(IMAGEMAGICK) \
	rm -f $(INORM) \
	rm -f $(LAPLACE) \
	rm -f $(LIBARGS) \
	rm -f $(LIBBICINVENTOR) \
	rm -f $(LIBBICPL) \
	rm -f $(LIBBOOST) \
	rm -f $(LIBCGAL) \
	rm -f $(LIBEBTKS) \
	rm -f $(EMMA) \
	rm -f $(LIBGSL) \
	rm -f $(LIBHDF) \
	rm -f $(LIBMINC) \
	rm -f $(LIBNETCDF) \
	rm -f $(LIBOOBPL) \
	rm -f $(LIBPCRE) \
	rm -f $(LIBPCREPP) \
	rm -f $(LOBESEG) \
	rm -f $(M4_UNTAR) \
	rm -f $(MINCBET) \
	rm -f $(MMORPH) \
	rm -f $(N3) \
	rm -f $(LIBNETPBM) \
	rm -f ${PL_LIB} \
	rm -f $(PMP) \
	rm -f $(PVE) \
	rm -f $(QVAL) \
	rm -f $(RAY_TRACE) \
	rm -f $(REGISTER) \
	rm -f $(RMINC) \
	rm -f $(RSTAT) \
	rm -f $(STXSEG) \
	rm -f $(SURFREG)

flush: clean remove_target

clean:
	cd ${SOURCE_DIR}/${ADNI_PACKAGE}   		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${ARGS_PACKAGE}   		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${AUTOREG_PACKAGE}   		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${AVG305_PACKAGE}/		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${BET_PACKAGE}/           	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${BICINVENTOR_PACKAGE}/          	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${BOOST_PACKAGE}               ; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${BPL_PACKAGE}/           	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${BRAINVIEW_PACKAGE}/		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${CAREA_PACKAGE}/         	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${CDF_PACKAGE}/src       	; ${MAKE} clean ; rm -f macros.make  ;\
	cd ${SOURCE_DIR}/${CGAL_PACKAGE}		; ${MAKE} clean ; rm -f config.log  ;\
	cd ${SOURCE_DIR}/${CIVET_PACKAGE}/         	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${CLASP_PACKAGE}/         	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${CLASSIFY_PACKAGE}/          	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${COLIN27_PACKAGE}/		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${CONGLOMERATE_PACKAGE}/  	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${CSURFACE_PACKAGE}/    	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${DISPLAY_PACKAGE}/        	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${EBTKS_PACKAGE}   		; ${MAKE} clean ; rm -f config.cache  ;\
	cd ${SOURCE_DIR}/${EMMA_PACKAGE}   		; ${MAKE} clean ;\
	cd ${SOURCE_DIR}/${GETOPT_PACKAGE}/ 	 	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${GGS_PACKAGE}                 ; ${MAKE} clean ; rm -f config.cache  ;\
	cd ${SOURCE_DIR}/${GSL_PACKAGE}                 ; ${MAKE} clean ; rm -f config.cache  ;\
	cd ${SOURCE_DIR}/${HDF_PACKAGE}              	; ${MAKE} clean ; rm -f config.cache  ;\
	cd ${SOURCE_DIR}/${ILT_PACKAGE}/              	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${IMAGEMAGICK_PACKAGE}/        ; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${INORM_PACKAGE}/          	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${LOBESEG_PACKAGE}   		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${LAPLACE_PACKAGE}/ 		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${MINC_PACKAGE}/           	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${MMORPH_PACKAGE}/          	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${N3_PACKAGE}/          	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${NETPBM_PACKAGE}/          	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${ICBM152_PACKAGE}/		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${ICBM152NL_PACKAGE}/		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${ICBM152NL09_PACKAGE}/	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${ICBMTEMP_PACKAGE}/		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${PERLLIB_PACKAGE}/     	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${SURFREG_PACKAGE}/   		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${OOBPL_PACKAGE}/          	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${PCRE_PACKAGE}             	; ${MAKE} clean ; rm -f config.cache  ;\
	cd ${SOURCE_DIR}/${PCREPP_PACKAGE}         	; ${MAKE} clean ; rm -f config.cache ;\
	cd ${SOURCE_DIR}/${PMP_PACKAGE}/               	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${REGISTER_PACKAGE}/      	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${PVE_PACKAGE}/                ; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${QVAL_PACKAGE}/               ; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/${RAY_TRACE_PACKAGE}/    	; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi ;\
	cd ${SOURCE_DIR}/   				; R CMD REMOVE ${RMINC_PACKAGE}  ;\
	cd ${SOURCE_DIR}/   				; R CMD REMOVE ${RSTAT_PACKAGE}  ;\
	cd ${SOURCE_DIR}/${STXSEG_PACKAGE}   		; if [ -e Makefile ] ; then ; ${MAKE} distclean ;  rm -f Makefile ; fi

