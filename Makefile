PWD = $(shell pwd)

define render_dockerfile
	cd $(PWD)/authconfig && \
	  python tests/filltmpl.py $(1)
endef

define docker_build
	cd $(PWD)/authconfig && \
	  docker build --force-rm -t authconfig:salt-testing-$(1) -t authconfig:local-salt-testing-$(1) -f tests/Dockerfile.$(1) .
endef

define docker_run_local
	docker run --rm -v $(PWD)/authconfig/tests:/opt/tests -h local-salt-testing-$(1) --name local-salt-testing-$(1) -it authconfig:local-salt-testing-$(1) /bin/bash
endef

define run_tests
	cd $(PWD)/authconfig/tests && ./run-tests.sh $(1)
endef


# ---------------------------------------------------------------
test-setup:
	# this should be run in a virtualenv
	pip install Jinja2

clean-local:
	find . -name '*.pyc' -exec rm '{}' ';'
	rm -rf authconfig/tests/Dockerfile*
	rm -rf authconfig/tests/pytests/tests/.pytest_cache
	rm -rf authconfig/tests/pytests/tests/__pycache__


# --- centos_master_2017.7.2 functions --------------------------
test_centos_master_2017.7.2: clean-local
	$(call render_dockerfile,centos_master_2017.7.2) && \
	  $(call docker_build,centos_master_2017.7.2) && \
	  $(call run_tests,centos_master_2017.7.2)

local-centos_master_2017.7.2: clean-local
	$(call render_dockerfile,centos_master_2017.7.2) && \
	  $(call docker_build,centos_master_2017.7.2) && \
	  $(call docker_run_local,centos_master_2017.7.2)


# --- debian_master_2017.7.2 functions --------------------------
test_debian_master_2017.7.2: clean-local
	$(call render_dockerfile,debian_master_2017.7.2) && \
	  $(call docker_build,debian_master_2017.7.2) && \
	  $(call run_tests,debian_master_2017.7.2)

local-debian_master_2017.7.2: clean-local
	$(call render_dockerfile,debian_master_2017.7.2) && \
	  $(call docker_build,debian_master_2017.7.2) && \
	  $(call docker_run_local,debian_master_2017.7.2)


# --- ubuntu_master_2017.7.2 functions --------------------------
test_ubuntu_master_2017.7.2: clean-local
	$(call render_dockerfile,ubuntu_master_2017.7.2) && \
	  $(call docker_build,ubuntu_master_2017.7.2) && \
	  $(call run_tests,ubuntu_master_2017.7.2)

local-ubuntu_master_2017.7.2: clean-local
	$(call render_dockerfile,ubuntu_master_2017.7.2) && \
	  $(call docker_build,ubuntu_master_2017.7.2) && \
	  $(call docker_run_local,ubuntu_master_2017.7.2)


# --- ubuntu_master_2016.11.3 functions --------------------------
test_ubuntu_master_2016.11.3: clean-local
	$(call render_dockerfile,ubuntu_master_2016.11.3) && \
	  $(call docker_build,ubuntu_master_2016.11.3) && \
	  $(call run_tests,ubuntu_master_2016.11.3)

local-ubuntu_master_2016.11.3: clean-local
	$(call render_dockerfile,ubuntu_master_2016.11.3) && \
	  $(call docker_build,ubuntu_master_2016.11.3) && \
	  $(call docker_run_local,ubuntu_master_2016.11.3)
