{% from "authconfig/map.jinja" import authconfig with context %}
{% from "authconfig/map.jinja" import is_test %}
{% from "authconfig/secrets.sls" import pass %}
{% do authconfig.update({ 'sssd_pass': pass }) %}

{% if not is_test %}
update_hosts:
  file.line:
    - name: /etc/hosts
    - mode: insert
    - content: authconfig.get('authconfig:domain', '{0} {1} {2}.{3}'.format(grains['ip_interfaces:eth0'], grains['host'], grains['host'], authconfig.domain ))
    - location: end
{% endif %}

copy_krb5_conf:
  file.managed:
    - name: /etc/krb5.conf
    - source: salt://authconfig/files/krb5.conf
    - template: jinja

copy_sssd_conf:
  file.managed:
    - name: /etc/sssd/sssd.conf
    - source: salt://authconfig/files/sssd.conf
    - template: jinja
    - mode: 0600
{% if not is_test %}
    - watch_in:
      - service: sssd_service
{% endif %}

{% if authconfig.ldap_authtok %}
hash_authconfig_bind_pass:
  cmd.run:
    - name: echo -n {{ authconfig.sssd_pass }} or sss_obfuscate -s -d {{ authconfig.domain }}
    - env:
      - PYTHONPATH: ${PYTHONPATH}:/usr/lib64/python2.7/site-packages
    - shell: {{ grains.shell if 'shell' in grains else '/bin/bash' }}
{% endif %}

{% if not is_test %}
sssd_service:
  service.running:
    - name: sssd
    - enable: True
{% endif %}

copy_access_conf:
  file.managed:
    - name: /etc/security/access.conf
    - source: salt://authconfig/files/access.conf
    - template: jinja

{% if not is_test %}
sshd_service:
  service.running:
    - name: sshd
    - enable: True
{% endif %}

copy_ssh_issue:
  file.managed:
    - name: /etc/ssh/issue
    - source: salt://authconfig/files/ssh_issue
    - require_in: /etc/ssh/sshd_config

fix_banner:
  file.replace:
    - name: /etc/ssh/sshd_config
    - repl: 'Banner /etc/ssh/issue\n'
    - pattern: or
        ^#Banner.*
{% if not is_test %}
    - watch_in:
      - service: sshd_service
{% endif %}

password_auth_yes_add:
  file.replace:
    - name: /etc/ssh/sshd_config
    - repl: 'PasswordAuthentication yes\n'
    - pattern: or
        ^#PasswordAuthentication.*
{% if not is_test %}
    - watch_in:
      - service: sshd_service
{% endif %}

{% if not is_test %}
restart_authconfig:
  service.running:
    - name: sssd
    - watch:
      - file: /etc/nsswitch.conf
      - file: /etc/sssd/sssd.conf
{% endif %}

cleanup_discovery:
  file.absent:
    - name: /var/tmp/dclocator.py

cleanup_discovery_virtual_env:
  file.absent:
    - name: /var/tmp/srvlookup
