#!/bin/vbash
#https://docs.vyos.io/en/latest/automation/command-scripting.html
# https://sivasankar.org/2018/2066/vyos-virtual-router-for-home-lab-or-smb/?utm_source=pocket_mylist
source /opt/vyatta/etc/functions/script-template
configure
run show interfaces
set interfaces ethernet eth1 address 192.168.49.1/24
set interfaces ethernet eth1 description ETH1
set interfaces ethernet eth1 vif 1924 description 'Lab'
set interfaces ethernet eth1 vif 1924 address '192.168.50.1/24'
run show interfaces
set interfaces ethernet eth2 address 192.168.51.1/24
set interfaces ethernet eth2 description ETH2
set interfaces ethernet eth2 vif 1925 description 'Disco'
set interfaces ethernet eth2 vif 1925 address '192.168.52.1/24'
run show interfaces
set interfaces ethernet eth3 address 192.168.53.1/24
set interfaces ethernet eth3 description ETH3
set interfaces pseudo-ethernet peth0 source-interface eth3
set interfaces pseudo-ethernet peth0 address 192.168.54.1/24
# Set a description for the MACVLAN interface
set interfaces pseudo-ethernet peth0 description 'macvlan'
# Assign an IP address to the MACVLAN interface
#set interfaces pseudo-ethernet peth0 address '192.168.54.1/24'
run show interfaces
set interfaces ethernet eth4 address 192.168.55.1/24
set interfaces ethernet eth4 description ETH4
set interfaces ethernet eth4 vif 1927 description 'Metal'
set interfaces ethernet eth4 vif 1927 address '192.168.56.1/24'
run show interfaces
set interfaces ethernet eth5 address 192.168.57.1/24
set interfaces ethernet eth5 description ETH5
set interfaces ethernet eth5 vif 1928 description 'Provisioning'
set interfaces ethernet eth5 vif 1928 address '192.168.58.1/24'
run show interfaces
set nat source rule 10 outbound-interface name 'eth0'
set nat source rule 10 source address 192.168.122.2
set nat source rule 10 translation address masquerade
show nat source
commit
run ping  1.1.1.1 count 3 interface 192.168.122.2
set nat source rule 11 outbound-interface name 'eth0'
set nat source rule 11 source address 192.168.49.0/24
set nat source rule 11 translation address masquerade
show nat source
commit
run ping  1.1.1.1 count 3 interface 192.168.49.1
set nat source rule 12 outbound-interface name 'eth0'
set nat source rule 12 source address 192.168.50.0/24
set nat source rule 12 translation address masquerade
show nat source
commit
run ping  1.1.1.1 count 3 interface 192.168.50.1
set nat source rule 13 outbound-interface name 'eth0'
set nat source rule 13 source address 192.168.52.0/24
set nat source rule 13 translation address masquerade
show nat source
commit
run ping  1.1.1.1 count 3 interface 192.168.52.1
set nat source rule 14 outbound-interface name 'eth0'
set nat source rule 14 source address 192.168.54.0/24
set nat source rule 14 translation address masquerade
show nat source
commit
run ping  1.1.1.1 count 3 interface 192.168.54.1
set service dhcp-server shared-network-name Lab subnet 192.168.50.0/24 option default-router '192.168.50.1'
set service dhcp-server shared-network-name Lab subnet 192.168.50.0/24 option name-server '1.1.1.1'
set service dhcp-server shared-network-name Lab subnet 192.168.50.0/24 option domain-name 'example.com'
set service dhcp-server shared-network-name Lab subnet 192.168.50.0/24 lease '86400'
set service dhcp-server shared-network-name Lab subnet 192.168.50.0/24 range 0 start 192.168.50.100
set service dhcp-server shared-network-name Lab subnet 192.168.50.0/24 range 0 stop '192.168.50.199'
set service dhcp-server shared-network-name Lab subnet 192.168.50.0/24 subnet-id '1'
commit 
set service dhcp-server shared-network-name Disco subnet 192.168.52.0/24 option default-router '192.168.52.1'
set service dhcp-server shared-network-name Disco subnet 192.168.52.0/24 option name-server '1.1.1.1'
set service dhcp-server shared-network-name Disco subnet 192.168.52.0/24 option domain-name 'example.com'
set service dhcp-server shared-network-name Disco subnet 192.168.52.0/24 lease '86400'
set service dhcp-server shared-network-name Disco subnet 192.168.52.0/24 range 0 start 192.168.52.100
set service dhcp-server shared-network-name Disco subnet 192.168.52.0/24 range 0 stop '192.168.52.199'
set service dhcp-server shared-network-name Disco subnet 192.168.52.0/24 subnet-id '2'
commit 
set service dhcp-server shared-network-name Trans-Proxy subnet 192.168.54.0/24 option default-router '192.168.54.1'
set service dhcp-server shared-network-name Trans-Proxy subnet 192.168.54.0/24 option name-server '1.1.1.1'
set service dhcp-server shared-network-name Trans-Proxy subnet 192.168.54.0/24 option domain-name 'example.com'
set service dhcp-server shared-network-name Trans-Proxy subnet 192.168.54.0/24 lease '86400'
set service dhcp-server shared-network-name Trans-Proxy subnet 192.168.54.0/24 range 0 start 192.168.54.100
set service dhcp-server shared-network-name Trans-Proxy subnet 192.168.54.0/24 range 0 stop '192.168.54.199'
set service dhcp-server shared-network-name Trans-Proxy subnet 192.168.54.0/24 subnet-id '3'
commit 
set service dhcp-server shared-network-name Metal subnet 192.168.56.0/24 option default-router '192.168.56.1'
set service dhcp-server shared-network-name Metal subnet 192.168.56.0/24 option name-server '1.1.1.1'
set service dhcp-server shared-network-name Metal subnet 192.168.56.0/24 option domain-name 'example.com'
set service dhcp-server shared-network-name Metal subnet 192.168.56.0/24 lease '86400'
set service dhcp-server shared-network-name Metal subnet 192.168.56.0/24 range 0 start 192.168.56.100
set service dhcp-server shared-network-name Metal subnet 192.168.56.0/24 range 0 stop '192.168.56.199'
set service dhcp-server shared-network-name Metal subnet 192.168.56.0/24 subnet-id '4'
commit 
set service dhcp-server shared-network-name Provisioning subnet 192.168.58.0/24 option default-router '192.168.58.1'
set service dhcp-server shared-network-name Provisioning subnet 192.168.58.0/24 option name-server '1.1.1.1'
set service dhcp-server shared-network-name Provisioning subnet 192.168.58.0/24 option domain-name 'example.com'
set service dhcp-server shared-network-name Provisioning subnet 192.168.58.0/24 lease '86400'
set service dhcp-server shared-network-name Provisioning subnet 192.168.58.0/24 range 0 start 192.168.58.100
set service dhcp-server shared-network-name Provisioning subnet 192.168.58.0/24 range 0 stop '192.168.58.199'
set service dhcp-server shared-network-name Provisioning subnet 192.168.58.0/24 subnet-id '5'
commit
save
exit