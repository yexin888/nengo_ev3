MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(dir $(MAKEFILE_PATH))

#LIB_STIM  ?= $(CURRENT_DIR)lib_eth_noc_stim
#LIB_JTAG  ?= $(CURRENT_DIR)lib_jtag_v2

CXX       := g++
CC        := gcc

FLAGS     += -Wall -O2 -fnon-call-exceptions -fPIC \
             -fdata-sections -ffunction-sections -I/usr/include/python2.7 
CFLAGS    += -Iinclude ${FLAGS}
CXXFLAGS  += ${FLAGS} \
             -std=gnu++11
CFLAGS    += -std=gnu99
LDFLAGS   ?= -Wl,-as-needed -Wl,-O1 -Wl,--gc-sections

LIBS      +=  -ldl -lpython2.7

MEM_PATH  := $(shell /usr/bin/env perl -e '$$_ = "$(CURDIR)"; s|.*/([^/]+)\.([^/]+)$$|$$ENV{QUADPE_ROOT_PATH}/pe-software/quadpe-testcases/$$1.$$2|; print')

BINARYSOURCES+=
CXXSOURCES   += 
CSOURCES     +=
OBJECTS      := $(foreach src, $(notdir $(CXXSOURCES:.cpp=.o)), .objects/${src})
COBJECTS     := $(foreach src, $(notdir $(CSOURCES:.c=.o)), .objects/${src})
BOBJECTS     := $(foreach src, $(notdir $(addsuffix .o, $(basename $(BINARYSOURCES)))), .objects/${src})
DEPENDS      := $(foreach src, $(CXXSOURCES:.cpp=.d), .deps/$(notdir ${src}))
DEPENDS      += $(foreach src, $(CSOURCES:.c=.d), .deps/$(notdir ${src}))

VPATH = .

APPLICATION  ?= 

.deps/%.d: %.c | .deps
	@${CC} ${CFLAGS} -MM -E $< | sed 's|\($*\)\.o|.objects/\1.o $@|g' > $@
	@ln -sf $*.d .deps/$*.dep

.objects/%.o: %.c .deps/%.d | .objects
	${CC} ${CFLAGS} -c -o $@ $<

.deps/%.d: %.cpp | .deps
	@${CXX} ${CXXFLAGS} -MM $< | sed 's|\($*\)\.o|.objects/\1.o $@|g' > $@
	@ln -sf $*.d .deps/$*.dep

.objects/%.o: %.cpp .deps/%.d | .objects
	@echo "$@";
	${CXX} ${CXXFLAGS} -c -o $@ $<

.objects/%.o: %.mem | .objects
	objcopy -I binary -O elf64-x86-64 -B i386 $< $@
.objects/%.o: %.tcl | .objects
	objcopy -I binary -O elf64-x86-64 -B i386 $< $@

.SECONDARY: $(DEPENDS)
.PHONY: all
all: ${APPLICATION}

.deps .objects:
	@mkdir -p $@

${APPLICATION}: .deps ${OBJECTS} ${COBJECTS} ${BOBJECTS}
	${CXX} ${LDFLAGS} ${OBJECTS} ${COBJECTS} ${BOBJECTS} -o $@ ${LIBS}

.PHONY: clean

clean:
	@\rm -rf .deps .objects ${OBJECTS} ${COBJECTS} ${BOBJECTS} ${APPLICATION} $(CXX_OBJECTS)

-include ${DEPENDS:.d=.dep}
