#!/usr/bin/env bash

source utils.sh

cd ../terraform/digitalocean

echo "yes" | terraform destroy -var "do_token=${DO_API_TOKEN}" -var "pub_key=${HOME}/.ssh/id_rsa.pub" -var "pvt_key=${HOME}/.ssh/id_rsa" -var "ssh_fingerprint=`ssh-keygen -lf ~/.ssh/id_rsa.pub -E md5  | awk '{ print $2 }' | cut -c 5-`" -var "target_env=staging"

notify_result '../../demo' 'Infrastructure destroy';

cd -

cd ../ansible

export ANSIBLE_TF_DIR=../terraform/digitalocean && time ansible-playbook -i /etc/ansible/terraform.py cleanup_dns_entries.yml -e "target_env=staging"

notify_result '../demo' 'DNS entries cleanup';

cd -
