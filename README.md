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

3. **Ensure Ansible is installed and configured on `P4` machine**

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

## Configuration Files
- **Vagrantfile** and **yml files** are provided.
- To manage your own machine using only the `Vagrantfile`, modify the IP addresses in `hosts.ini` to match your Windows virtual machine.

---

## Installing QEMU
Run the following command on the Ansible machine (`P4`):

```bash
ansible-playbook -i hosts.ini install_qemu.yml
```

This will install QEMU on the target machine after some time.

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

## Example Setup Diagram

![Setup Diagram](images/setup_diagram.png)

---

## Example Boot Process Flow

![Boot Process](images/boot_process.png)

---

## Troubleshooting
Ensure your `hosts.ini` file is properly configured to match the IP addresses of your virtual machines.

---

## License
This project is licensed under the MIT License.
