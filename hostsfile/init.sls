# populate /etc/hosts with names and IP entries from your salt cluster
# the minion id has to be the fqdn for this to work

{%- set fqdn = grains['id'] %}
# example configuration for /etc/salt/master:
#
# peer:
#   .*:
#     - network.ip_addrs

{%- set addrs = salt['publish.publish']('*', 'network.ip_addrs', 'eth0') %}

{%- if addrs is defined %}

{%- for name, addrlist in addrs.items() %}
{{ name }}-host-entry:
  host.present:
    - ip:
      {%- for ip in addrlist %}
      - {{ ip }}
      {% endfor %}
    - names:
      - {{ name }}
{% endfor %}

{% endif %}
