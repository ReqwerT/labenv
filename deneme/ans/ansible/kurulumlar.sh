#!/bin/bash

# Sistemi Güncelle
sudo apt update -y && sudo apt upgrade -y

# Gerekli paketleri kur
sudo apt install software-properties-common -y

# Ansible PPA deposunu ekle
sudo add-apt-repository --yes --update ppa:ansible/ansible

# Ansible'ı kur
sudo apt install ansible -y

# Kurulumu kontrol et
ansible --version

# python3-pip kurulum
sudo apt install python3-pip

ansible-playbook -i /home/vagrant/ansible/hosts.ini /home/vagrant/ansible/install_qemu.yml

echo "Kurulum tamamlandı."