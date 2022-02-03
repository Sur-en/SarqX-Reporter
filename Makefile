SHELL = /bin/sh

install:
	@mix deps.get

	@if mix deps.compile ; then \
    exit 0 ; \
  else \
    mix deps.compile; \
  fi

	@mix deps.compile
	@mix escript.build

create_systemd:
	@./create_systemd.sh

.PHONY = install create_systemd
