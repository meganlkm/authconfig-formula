{% from "authconfig/map.jinja" import authconfig with context %}

srvlookup_extract-dirs:
  file.directory:
    - name: {{ authconfig.discovery.tmpdir }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - require_in:
      - srvlookup_package_install

srvlookup_package_install:
  archive.extracted:
    - name: {{ authconfig.discovery.tmpdir }}
    - source: salt://authconfig/files/{{ authconfig.discovery.archive_name }}
    - archive_format: {{ authconfig.discovery.archive_type }}
    - enforce_toplevel: False
  {%- if authconfig.discovery.hashsum and grains['saltversioninfo'] > [2016, 11, 6] %}
    - source_hash: {{ authconfig.discovery.hashsum }}
  {%- endif %}
    - trim_output: 5
    - if_missing: {{ authconfig.discovery.tmpdir }}/{{ authconfig.discovery.archive_name }}

add_dc_discovery_script:
  file.managed:
    - name: /var/tmp/dclocator.py
    - source: salt://authconfig/files/dclocator.py
    - mode: 754
    - require:
      - srvlookup_package_install
