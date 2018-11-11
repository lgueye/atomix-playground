#!/usr/bin/env bash

source utils.sh

cd ../ansible

export ANSIBLE_TF_DIR=../terraform/digitalocean && time ansible-playbook -i /etc/ansible/terraform.py restore.yml -e "target_env=staging"

notify_result '../demo' 'Restore';

cd -
