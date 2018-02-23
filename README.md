[![Build Status](https://travis-ci.org/intuitivetechnologygroup/authconfig-formula.svg?branch=master)](https://travis-ci.org/intuitivetechnologygroup/authconfig-formula)

# Authconfig

Formulas to set up authconfig and sssd on Linux systems.

* [Testing](#testing)
* [Available States](#states)
* [Pillar Customizations](#pillar)

---

**Note:**

See the full Salt Formulas installation and usage instructions
<http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>.

**Assumptions:**

`make` is on your system and available. If it is not or you are not sure what
`make` is, [this](https://www.gnu.org/software/make/) is a good place to start.


## <a name='testing'></a> Testing

### <a name='run-tests'></a> Run Tests

Tests will be run on the following base images:

* `simplyadrian/allsalt:centos_master_2017.7.2`
* `simplyadrian/allsalt:debian_master_2017.7.2`
* `simplyadrian/allsalt:ubuntu_master_2017.7.2`
* `simplyadrian/allsalt:ubuntu_master_2016.11.3`

##### Start a virtualenv

```bash
pip install -U virtualenv
virtualenv .venv
source .venv/bin/activate
```

##### Install local requirements

```bash
make setup
```

#### Run tests

* `make test-centos_master_2017.7.2`
* `make test-debian_master_2017.7.2`
* `make test-ubuntu_master_2017.7.2`
* `make test-ubuntu_master_2016.11.3`

### <a name='run-containers'></a> Run Containers

* `make local-centos_master_2017.7.2`
* `make local-debian_master_2017.7.2`
* `make local-ubuntu_master_2017.7.2`
* `make local-ubuntu_master_2016.11.3`


## <a name='states'></a> Available States

### `authconfig`
Install SSSD and its dependencies on both RHEL|CentOS and Ubuntu|Debian. The
default state will detect your OS based on default grains and run the
corresponding state file

### `authconfig.redhat`

Handles the installation of SSSD and its dependencies on a RHEL|CentOS system.

### `authconfig.ubuntu`

Handles the installation of SSSD and its dependencies on a Ubuntu|Debian system.


## <a name='pillar'></a> Pillar Customizations

Any of these values can be overwritten in a pillar file. If you do find yourself needing
more overrides follow the example below.

[pillar.example](authconfig/tests/pillar/authconfig/init.sls)
