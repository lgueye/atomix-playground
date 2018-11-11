#!/usr/bin/env bash

source utils.sh

cd ../ansible

export ANSIBLE_TF_DIR=../terraform/digitalocean && ansible-galaxy install -r requirements.yml && time ansible-playbook --vault-id ~/.ansible_vault_pass.txt -i /etc/ansible/terraform.py sos.yml -e "target_env=staging rev=`git log -1 --pretty='%h'` security_mode=secure"

notify_result '../../demo' 'Infrastructure provisioning';

cd -
