#cloud-config

network: 
  version: 2 
  ethernets: 
    ens3:
      dhcp4: ${ dhcp }
%{ if length(addresses) > 0 ~}
      addresses:
%{ for addr in addresses ~}
       - ${addr}/24
%{ endfor ~}
%{ endif ~}
      routes:
      - to: default
        via: ${ default_gateway }
      nameservers:
        addresses: 
%{ for addr in nameservers ~} 
        - ${addr}
%{ endfor ~}
