# contents: Vim make rules.
#
# Copyright © 2008 Nikolai Weibull <now@bitwi.se>

.PHONY: install

prefix = $(HOME)/.vim

INSTALL = install

empty :=
space := $(empty) $(empty)
shell_quote = $(subst $(space),\ ,$(1))

define PLUGIN_template_file
install: $(2)
$(2): $(1)
	$$(INSTALL) -D -m 644 $$< $$(call shell_quote,$$@)

endef

define PLUGIN_template
$(eval $(foreach file,$(1),$(call PLUGIN_template_file,$(file),$(prefix)/$(file))))
endef

$(call PLUGIN_template,$(FILES))
