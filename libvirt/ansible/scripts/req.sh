#!/bin/bash
set -e

echo "[+] Installing Ansible..."

sudo apt update -y
sudo apt install -y software-properties-common python3-pip

sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

echo "[+] Installing WinRM Python module..."
pip3 install pywinrm

echo "[+] Ansible and WinRM setup completed."


echo "[+] Installing QEMU on the target Windows machine..."

ansible-playbook -i /vagrant/scripts/hosts.ini /vagrant/scripts/install_qemu.yml

echo "[+] QEMU installation completed."

echo "[+] Setting up automatic VM boot scripts..."

ansible-playbook -i /vagrant/scripts/hosts.ini /vagrant/scripts/start_vm.yml

echo "[+] Setup complete. Rebooting the target machine..."
