VIMBALL = diff-buffer-against-filesystem.vba

FILES = \
	plugin/now/diff-buffer-against-filesystem.vim

.PHONY: build install package

build: $(VIMBALL)

install: build
	ex -N --cmd 'set eventignore=all' -c 'so %' -c 'quit!' $(VIMBALL)

package: $(VIMBALL).gz

%.vba: Manifest
	ex -N -c '%MkVimball! $@ .' -c 'quit!' $<

%.gz: %
	gzip -c $< > $@

Manifest: Makefile
	for f in $(FILES); do echo $$f; done > $@

