SHELL = /bin/sh

install:
	@mix deps.get

	@if mix deps.compile ; then \
    exit 0 ; \
  else \
    mix deps.compile; \
  fi

	@mix deps.compile
	@MIX_ENV=prod mix escript.build

dev_install:
	@mix deps.get

	@if mix deps.compile ; then \
    exit 0 ; \
  else \
    mix deps.compile; \
  fi

	@mix deps.compile
	@mix escript.build

create_systemd:
	@./create_systemd.sh prod

create_systemd_dev:
	@./create_systemd.sh dev

clean:
	@sudo rm /etc/systemd/system/sarqxd.service
	@sudo rm -rf /etc/opt/sarqx-reporter
	@sudo rm -rf /var/opt/sarqx-reporter

clean_dev:
	@sudo rm -rf ./logs/**
	@rm -rf ./etc/**

clean_systemd_dev:
	@sudo rm /etc/systemd/system/sarqxd-dev.service

.PHONY = install dev_install create_systemd create_systemd_dev clean clean_dev clean_systemd_dev
