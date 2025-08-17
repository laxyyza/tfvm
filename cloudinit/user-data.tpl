#cloud-config
manage_etc_hosts: true
users:
  - name: ${user.name}
%{ if length(try(user.ssh_authorized_keys, [ssh_pub_key])) > 0 ~}
    ssh_authorized_keys:
%{ for key in try(user.ssh_authorized_keys, [ssh_pub_key]) ~}
    - ${key}
%{ endfor ~}
%{ endif ~}
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: [users, sudo]
    shell: /bin/bash
    passwd: "${ user.passwd }"
    lock_passwd: false
packages:
 - ${ packages }
%{ if length(cmds) > 0 ~}
runcmd:
${ cmds }
%{ endif ~}

%{ if length(write_files) > 0 ~}
write_files:
${ write_files }
%{ endif ~}
