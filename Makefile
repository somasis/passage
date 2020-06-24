name = passage
version = 0

prefix ?= /usr/local
bindir ?= ${prefix}/bin
datadir ?= ${prefix}/share
mandir ?= ${datadir}/man
man1dir ?= ${mandir}/man1

ASCIIDOCTOR ?= asciidoctor
ASCIIDOCTOR_FLAGS := --failure-level=WARNING
ASCIIDOCTOR_FLAGS += -a manmanual="${name}"
ASCIIDOCTOR_FLAGS += -a mansource="${name} ${version}"

SHELLCHECK ?= shellcheck

-include config.mk

BINS = \
    passage

MAN1 = ${BINS:=.1}

MANS = ${MAN1}
HTMLS = ${MANS:=.html}

all: FRC ${BINS} ${MANS}
dev: FRC README all lint

bin: FRC ${BINS}
man: FRC ${MANS}
html: FRC ${HTMLS}

# NOTE: disable built-in rules which otherwise mess up creating .sh files
.SUFFIXES:

# ${IDIOMS_LIBDIR} is used to allow for testing prior to installation.
.SUFFIXES: .in
.in:
	sed \
	    -e "s|@@name@@|${name}|g" \
	    -e "s|@@version@@|${version}|g" \
	    -e "s|@@prefix@@|${prefix}|g" \
	    -e "s|@@bindir@@|${bindir}|g" \
	    -e "s|@@mandir@@|${mandir}|g" \
	    -e "s|@@man1dir@@|${man1dir}|g" \
	    $< > $@
	chmod +x $@

.sh:
	sed \
	    -e "s|@@name@@|${name}|g" \
	    -e "s|@@version@@|${version}|g" \
	    -e "s|@@prefix@@|${prefix}|g" \
	    -e "s|@@bindir@@|${bindir}|g" \
	    -e "s|@@mandir@@|${mandir}|g" \
	    -e "s|@@man1dir@@|${man1dir}|g" \
	    $< > $@

.SUFFIXES: .adoc
.html.adoc:
	${ASCIIDOCTOR} ${ASCIIDOCTOR_FLAGS} -b html5 -d manpage -o $@ $<

.adoc:
	${ASCIIDOCTOR} ${ASCIIDOCTOR_FLAGS} -b manpage -d manpage -o $@ $<

install: FRC all
	install -d \
	    ${DESTDIR}${bindir} \
	    ${DESTDIR}${mandir} \
	    ${DESTDIR}${man1dir} \

	for bin in ${BINS}; do install -m0755 $${bin} ${DESTDIR}${bindir}; done
	for man1 in ${MAN1}; do install -m0644 $${man1} ${DESTDIR}${man1dir}; done

clean: FRC
	rm -f ${BINS} ${MANS} ${HTMLS}

.DELETE_ON_ERROR: README
README: passage.1
	man ./$? | col -bx > $@

lint: FRC ${BINS}
	${SHELLCHECK} ${BINS}

FRC:
