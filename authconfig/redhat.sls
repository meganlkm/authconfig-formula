{% from "authconfig/map.jinja" import authconfig with context %}
{% from "authconfig/map.jinja" import is_test %}
{% from "authconfig/krbdchost.sls" import url %}
{% from "authconfig/secrets.sls" import pass %}
{% from "authconfig/secrets.sls" import name %}

{% set run_opts= '--krb5realm=' + authconfig.domain  + ' ' + '--disablekrb5kdcdns' + ' ' + '--disablekrb5realmdns' + ' ' + '--krb5kdc=' + url + ' ' + '--krb5adminserver=' + authconfig.domain + ' ' + '--update' %}
{% do authconfig.update({'opts': run_opts}) %}
{% do authconfig.update({'sssd_pass': pass}) %}
{% do authconfig.update({'sssd_name': name}) %}

install_prereqs:
  pkg.installed:
    - pkgs: {{ authconfig.packages }}
    - refresh: True

{% if not is_test %}
join_domain:
  cmd.run:
    - name: echo -n {{ authconfig.sssd_pass }} | adcli join --stdin-password --domain-ou={{ authconfig.computer_ou }} --login-user={{ authconfig.sssd_name }} {{ authconfig.domain }}
    - creates: /etc/krb5.keytab
{% endif %}

run_authconfig:
  cmd.run:
    - name: /usr/sbin/authconfig {{ authconfig.opts }}
    - creates: /var/lib/authconfig/backup-configured

copy_nsswitch_conf:
  file.managed:
        - name: /etc/nsswitch.conf
        - source: salt://authconfig/files/nsswitch.conf
        - template: jinja

nsswitch_passwd:
  file.replace:
    - name: /etc/nsswitch.conf
    - repl: 'passwd:         files sss\n'
    - pattern: |
        ^passwd: .*

nsswitch_shadow:
  file.replace:
    - name: /etc/nsswitch.conf
    - repl: 'shadow:          files sss\n'
    - pattern: |
        ^shadow: .*

nsswitch_group:
  file.replace:
    - name: /etc/nsswitch.conf
    - repl: 'group:          files sss\n'
    - pattern: |
        ^group: .*
