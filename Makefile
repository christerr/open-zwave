#
# Makefile for OpenzWave Mac OS X applications
# Greg Satz

# GNU make only

# requires libudev-dev

.SUFFIXES:	.d .cpp .o .a
.PHONY:	default clean install


top_srcdir := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
top_builddir ?= $(CURDIR)
export top_builddir
PREFIX ?= /usr/local
export PREFIX

all: 
	CPPFLAGS=$(CPPFLAGS) $(MAKE) -C $(top_srcdir)/cpp/build/ -$(MAKEFLAGS) 
	CPPFLAGS=$(CPPFLAGS) $(MAKE) -C $(top_srcdir)/cpp/examples/MinOZW/ -$(MAKEFLAGS) 

install:
	$(MAKE) -C $(top_srcdir)/cpp/build/ -$(MAKEFLAGS) $(MAKECMDGOALS)
	$(MAKE) -C $(top_srcdir)/cpp/examples/MinOZW/ -$(MAKEFLAGS) $(MAKECMDGOALS)

clean:
	$(MAKE) -C $(top_srcdir)/cpp/build/ -$(MAKEFLAGS) $(MAKECMDGOALS)
	$(MAKE) -C $(top_srcdir)/cpp/examples/MinOZW/ -$(MAKEFLAGS) $(MAKECMDGOALS)

cpp/src/vers.cpp:
	CPPFLAGS=$(CPPFLAGS) $(MAKE) -C $(top_srcdir)/cpp/build/ -$(MAKEFLAGS) $(top_srcdir)/cpp/src/vers.cpp

check: xmltest

include $(top_srcdir)/cpp/build/support.mk

ifeq ($(XMLLINT),)
xmltest:	$(XMLLINT)
	$(error xmllint command not found.)
else
xmltest:	$(XMLLINT)
	@$(XMLLINT) --noout --schema $(top_srcdir)/config/device_classes.xsd $(top_srcdir)/config/device_classes.xml
	@$(XMLLINT) --noout --schema $(top_srcdir)/config/options.xsd $(top_srcdir)/config/options.xml
	@$(XMLLINT) --noout --schema $(top_srcdir)/config/manufacturer_specific.xsd $(top_srcdir)/config/manufacturer_specific.xml
	@$(XMLLINT) --noout --schema $(top_srcdir)/config/device_configuration.xsd $(top_srcdir)/config/*/*.xml
	-@cpp/build/testconfig.pl
endif
fulltest:
	-@cpp/build/testconfig.pl --printwarnings



dist-update:
	@echo "Updating List of Distribition Files"
	@$(GIT) ls-files > .distfiles
	@$(top_srcdir)/makedist

DIST_FORMATS ?= gzip

include $(top_srcdir)/distfiles.mk
include $(top_srcdir)/dist.mk
