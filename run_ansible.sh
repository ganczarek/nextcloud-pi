#!/usr/bin/env bash

if [ "$1" = "init" ]; then
    # First Ansible run that installs Python, sudo, etc.
    ansible-playbook --inventory 'rpi3,' \
        --become \
        --become-method su \
        --become-user root \
        --extra-vars ansible_become_pass=root \
        ./ansible/init.yml
else
    ansible-playbook --inventory 'rpi3,' ./ansible/rpi.yml
fi