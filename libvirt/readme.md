## Vagrant + Libvirt Test Environment

This project performs automatic virtual machine setup and configuration using **Vagrant** and **libvirt/qemu-kvm** on **bare-metal Debian**.



## Requirements:

Before we begin, click here to prepare our computer:

## Goal/Mission:

We will create two virtual machines:

- **Windows 11** VM (main target)
- **Ubuntu 22.04 (Ansible controller - sidecar)**

The main target will ensure that every time a Windows 11 virtual machine boots up, other virtual machines accelerated with WHPX will be automatically started inside it.

## Neden Bunu Yapıyoruz?

## What is Sidecar?

"Sidecar" means a slave controller that runs alongside and supports the main unit. Here, the Ubuntu 22.04 Ansible VM acts as a sidecar to remotely manage our Windows machine.

---

### Windows 11 Virtual Machine:

- Static IP: `192.168.121.15`
- On first boot, it automatically downloads and automatically runs the following PowerShell script: 
[`ConfigureRemotingForAnsible.ps1`](https://raw.githubusercontent.com/ansible/ansible-documentation/devel/examples/scripts/ConfigureRemotingForAnsible.ps1)
- Thus, it can be managed remotely with Ansible.

### Ubuntu Ansible Sidecar VM:

- On startup, it installs the necessary packages with the `req.sh` script.
- It acts according to the target Windows IP in the `hosts.ini` file.
- Then, the following Ansible playbooks are run:

#### install_qemu.yml

- Silently downloads and installs QEMU on the target machine.
- Activates the necessary virtualization features on the target machine.

- Sets the System PATH for QEMU.

- Finally, restarts the system.

#### start_vm.yml

- Scans all `.qcow2` disk files in the `images/` directory to learn their names.

- Prepares `.ps1` launcher scripts with their names for each one.

- Creates `.bat` files that call them.

- Automatically added to the Windows startup folder, so that these virtual machines run every time Windows starts.
---

## Application Steps

1. First, let's place our disks with the extension `.qcow2` in the `images/` folder.

2. Then let's go to the `win11/` directory via terminal:

```bash
cd win11
vagrant up
```

3. When the Windows machine starts, the necessary environment for Ansible is automatically prepared.

4. Then let's go to the `ansible/` directory:

```
bash
cd ../ansible
vagrant up
```

5. While the Ansible machine is starting:
- WinRM and ansible are automatically installed,
- QEMU is installed and configured on our target machine,
- WHPX is enabled on our target machine,
- Windows is restarted,
- Then WHPX-supported virtual machines start automatically.

---

## Vagrant Boxes Used

| VM Role | Vagrant Box |
|--------------|--------------------------|
| Ansible VM | [generic-x64/ubuntu2204](https://portal.cloud.hashicorp.com/vagrant/discover/generic-x64/ubuntu2204) |
| Windows VM | [tonyclemmey/windows11](https://portal.cloud.hashicorp.com/vagrant/discover/tonyclemmey/windows11) |

---

## Features of QEMU Virtual Machines

At the end of the job, the script files we created automatically are run in Windows 11 VM with the following command:

```powershell
qemu-system-x86_64 `
-accel whpx `

-m 4096 `
-drive file="C:\Users\vagrant\shared_f\{{ item }}",format=qcow2,if=virtio `
-netdev user,id=net0 `
-device virtio-net,netdev=net0 `
-boot c
```

This command is automatically prepared for each `.qcow2` file and is set to run at Windows startup.

---

## Result

Thanks to this structure:

- We have automatically installed two virtual machines with Vagrant.
- The Windows machine has been automatically set up for remote management.
- We automatically started the WHPX-supported QEMU machines every time Virtual Windows was opened and successfully completed the test.
