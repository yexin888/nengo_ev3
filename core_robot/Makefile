BUILDS = host.mk
DIRS = $(BUILDS:%=src/%)

all: $(BUILDS)
	for b in $(BUILDS); do $(MAKE) -f $$b || exit $$?; done

clean: $(BUILDS)
	for b in $(BUILDS); do $(MAKE) -f $$b clean || exit $$?; done
