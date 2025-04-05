#!/bin/bash

# Sistemi Güncelle
sudo apt update -y && sudo apt upgrade -y

# Gerekli paketleri kur
sudo apt install software-properties-common -y

# Ansible PPA deposunu ekle
sudo add-apt-repository --yes --update ppa:ansible/ansible

# Ansible'ı kur
sudo apt install ansible -y
sudo apt install ansible-core -y

# Kurulumu kontrol et
ansible --version

# python3-pip kurulum
sudo apt install python3-pip

ansible-playbook -i /home/vagrant/commands/hosts.ini /home/vagrant/commands/install_qemu.yml

echo "QEMU installed successfully."
ansible-playbook -i /home/vagrant/commands/hosts.ini /home/vagrant/commands/start_vm_via_qemu.yml

echo "Kurulum tamamlandı."
