#!/usr/bin/env bash

# First Ansible run that installs Python, sudo, etc.
ansible-playbook --user alarm \
    --inventory '192.168.1.80,' \
    --become \
    --become-method su \
    --become-user root \
    --extra-vars ansible_become_pass=root \
    --key-file ~/.ssh/rpi3_rsa \
    ./ansible/init.yml