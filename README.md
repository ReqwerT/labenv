# QEMU Virtual Machine Management with Ansible and Vagrant

## Overview
This project involves setting up two virtual machines (`P3` and `P5`) using Vagrant on Hyper-V. Ansible is used for managing these machines via a third machine (`P4`) that contains the necessary configuration files (`yml` files) and an inventory file (`hosts.ini`). The `P5` machine is a Windows virtual machine managed by Ansible.

The setup allows QEMU to be installed and managed on the `P5` machine through Ansible playbooks.

---

## Prerequisites
1. **Enable Hyper-V, Virtual Machine Platform, and Windows Hypervisor Platform**
   - Go to: `Control Panel > Programs > Turn Windows features on or off`
   - Enable:
     - Hyper-V
     - Virtual Machine Platform
     - Windows Hypervisor Platform
   - Restart your computer.

2. **Install Vagrant**
   - Ensure you have Vagrant installed on your system.

3. **Ensure Ansible is installed and configured on `P3` machine**

---

## Initial Setup

### Starting the Machines
1. Navigate to the directories containing the `P3` and `P5` machines using **Powershell with administrator privileges**.
2. Run the following commands in each Powershell window:

```powershell
vagrant up
```

This will start both machines.

3. Once started, connect to the machines using:

- For `P5` (Windows machine):
```powershell
vagrant rdp
```

- For `P4` (Ansible machine):
```powershell
vagrant ssh
```

---

## Configuring Ansible
To enable Ansible management via WinRM, download and run the script:
- [Download ConfigureRemotingForAnsible.ps1](https://github.com/ansible/ansible-documentation/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1)

Hashes for verification:
- MD5: `6f40af8ac2d28a524b54a4f3b79e5bf0`
- SHA1: `f3f5621a2f19703e849fa5cb643819a621dbe0ab`
- SHA256: `eba72df06e3e77709595f75d1d5b4d95b06602429dd2a3f7867406df875b0c70`
- SHA512: `2cf08513bd74000280d37d1ca77c7e12e95140fdedc291849791340bfe5fe88d72c7281db03a6d065f352786adcb271a9556a04d0048941b9dd631b169918642`

Run the script in Powershell with administrator privileges.

Verify connection:
```bash
ansible win -i hosts.ini -m win_ping
```

---

## Installing QEMU
Run the following command on the Ansible machine (`P4`):

```bash
ansible-playbook -i hosts.ini install_qemu.yml
```

This will install QEMU 9.2.50 on the target machine and update the `PATH` variable. A restart is required to apply changes.

### Installing Vagrant on the Target Machine
If you wish to install Vagrant:

```bash
ansible-playbook -i hosts.ini install_vagrant.yml
```

This will use `Chocolatey` to install the latest version of Vagrant. If `Chocolatey` is not installed, it will be installed automatically.

---

## Disk Shrinking
If you need to shrink a disk:

```bash
ansible-playbook -i hosts.ini disk_shrink.yml
```

This command will generate a disk of the specified size and format. We are using `exFAT` as it is compatible with Linux, Windows, and macOS.

---

## Starting the Virtual Machine via QEMU
To start the VM:

```bash
ansible-playbook -i hosts.ini start_vm_via_qemu.yml
```

After execution, restart the system and connect using:
```powershell
vagrant rdp
```

### What This Playbook Does
- Creates necessary files in a specified folder.
- Places a `.bat` file in the startup folder to ensure the VM starts with Windows.
- Generates two `.txt` files: 
  - `iso.txt`: Contains the path of the selected ISO file.
  - `bootflag.txt`: Stores either `0` or `1`. 
    - `0` indicates the first boot, prompting ISO selection and installation.
    - `1` indicates subsequent boots, where the VM boots directly from the created `qcow2` disk.

---

## Boot Process Explained
- **First Boot (bootflag = 0):**
  - Lists ISO files from `C:/Users/user/Downloads`.
  - Prompts user to select an ISO file for installation.
  - Changes `bootflag` to `1` once the installation completes.

- **Subsequent Boots (bootflag = 1):**
  - Boots directly from the `qcow2` disk without ISO selection.

---



## Troubleshooting
Ensure your `hosts.ini` file is properly configured to match the IP addresses of your virtual machines.

---

## License
This project is licensed under the MIT License.
