#!/bin/bash
set -e

echo "[+] Installing Ansible..."

# Update package lists and install dependencies
sudo apt update -y
sudo apt install -y software-properties-common python3-pip

# Add the official Ansible PPA and install Ansible
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

# Install pywinrm for Ansible to communicate with Windows hosts over WinRM
echo "[+] Installing WinRM Python module..."
pip3 install pywinrm

echo "[+] Ansible and WinRM setup completed."


echo "[+] Installing QEMU on the target Windows machine..."

# Run the playbook that installs QEMU and enables Hyper-V features on Windows
ansible-playbook -i /vagrant/scripts/hosts.ini /vagrant/scripts/install_qemu.yml

echo "[+] QEMU installation completed."

echo "[+] Setting up automatic VM boot scripts..."

# Run the playbook that generates PowerShell + BAT scripts to start VMs at Windows login
ansible-playbook -i /vagrant/scripts/hosts.ini /vagrant/scripts/start_vm.yml

echo "[+] Setup complete. Rebooting the target machine..."
