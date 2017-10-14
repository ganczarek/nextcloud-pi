#!/usr/bin/env bash

if [ "$1" = "init" ]; then
    # First Ansible run that installs Python, sudo, etc.
    ansible-playbook --user alarm --inventory '192.168.1.80,' --key-file ~/.ssh/rpi3_rsa \
        --become \
        --become-method su \
        --become-user root \
        --extra-vars ansible_become_pass=root \
        ./ansible/init.yml
else
    ansible-playbook --user alarm --inventory '192.168.1.80,' --key-file ~/.ssh/rpi3_rsa ./ansible/rpi.yml
fi