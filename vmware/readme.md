# QEMU VM Automation Project (Ansible + Vagrant + Windows)

Before using this project, make sure the following components are installed on your system:

- **To install Vagrant**: [Vagrant 2.4.5](https://developer.hashicorp.com/vagrant/downloads)
- **To install the Vagrant VMware plugin**: [Install Vagrant VMware Utility](https://github.com/ReqwerT/labenv/blob/main/tests/vmware.md)
- **To install VMware Workstation (Pro or Player)**: [VMware Workstation Player](https://www.vmware.com/products/workstation-pro/workstation-pro-evaluation.html)

---

## ⚙️ System Requirements

- **Vagrant version**: `2.4.5`
- **VMware software**: `VMware Workstation Player`
- **Vagrant boxes used**:
  - [gusztavvargadr/ubuntu-desktop-2204-lts](https://portal.cloud.hashicorp.com/vagrant/discover/gusztavvargadr/ubuntu-desktop-2204-lts) (for the Ansible control machine)
  - [gusztavvargadr/windows-11](https://portal.cloud.hashicorp.com/vagrant/discover/gusztavvargadr/windows-11) (for the Windows QEMU host)
- **QCOW2 disk images used in this project**:
  - [debian-10-openstack-amd64.qcow2](https://cdimage.debian.org/images/cloud/OpenStack/current-10/debian-10-openstack-amd64.qcow2)
  - [kali-linux-2025.1c-qemu-amd64.qcow2](https://cdimage.kali.org/kali-2025.1c/kali-linux-2025.1c-qemu-amd64.7z)

> ⚠️ **These are the QCOW2 images I used for testing. You should use any QCOW2-based OS image you prefer by placing it in the `win11/images` folder.**

---

## 🚀 Getting Started

1. **Clone or download** this project to your local machine.
2. **Place your desired QCOW2-based OS image(s)** into the `win11/images` folder.
3. Open a terminal, navigate to the `win11` directory, and run:

   ```bash
   vagrant up
   ```

   This will start the Windows 11 VM and automatically configure WinRM for Ansible access.

4. Then, navigate to the `ans` directory and run:

   ```bash
   vagrant up
   ```

   This launches the Ansible control machine (Ubuntu) and runs the provisioning steps automatically.

5. Once provisioning completes, **restart the Windows VM**.

> ✅ Upon reboot, Windows will automatically launch QEMU with WHPX acceleration and boot the virtual machines defined by your QCOW2 images. This happens **every time** the system restarts.

---

## 🎯 Project Goals

- Manage **QEMU virtual machines on Windows remotely via Ansible**
- Automatically detect and launch **.qcow2 disks** with a proper configuration
- Ensure **VMs start automatically** when the Windows GUI session opens
- Install and configure QEMU, OpenVPN TAP, and Hyper-V features remotely

---
## 🖥️ Project Structure

```
.
├── ans
│   ├── Vagrantfile                     # Ansible control VM
│   └── scripts
│       ├── start_vm.yml               # Playbook to prepare VM startup
│       ├── qemu_install.yml           # Playbook to install QEMU and features
│       └── hosts.ini                  # Ansible inventory
├── win11
│   ├── Vagrantfile                    # Windows 11 QEMU host
│   └── images
│       ├── debian-10.qcow2
│       └── kali-linux-2025.qcow2
```
---

## ⚙️ How It Works

1. Vagrant launches an Ubuntu-based Ansible control VM.
2. The `win/images` folder is shared via Vagrant as `/home/vagrant/shared_images`.
3. Ansible scans this directory for `.qcow2` disk files.
4. For each disk:
   - A PowerShell script is created in `C:\vagrant_vm_boot`
   - A `.bat` file is added to the Startup folder to execute it
5. On GUI login, Windows runs each script, which starts the virtual machines via QEMU with WHPX acceleration.

---

## 💾 Accessing `.qcow2` Disks

- The Ansible VM reads disk filenames from `/home/vagrant/shared_images`
- Windows accesses the same files via `Z:\-vagrant\images\` (VMware Shared Folders)
- Each QEMU command in the scripts points to the appropriate path on `Z:`

---

## 🧪 Usage

To execute the provisioning:

```bash
ansible-playbook -i scripts/hosts.ini scripts/qemu_install.yml
ansible-playbook -i scripts/hosts.ini scripts/start_vm.yml
```

> - `qemu_install.yml`: Installs QEMU and enables Hyper-V
> - `start_vm.yml`: Scans `.qcow2` files, generates `.ps1` + `.bat` files for automatic startup

---

---
## 💻 Environment Matrix

| System Name             | RAM    | CPU | Disk  | Nested Virt | IP Address       | Purpose                             | Result                                                |
|-------------------------|--------|-----|-------|--------------|------------------|--------------------------------------|--------------------------------------------------------|
| Virtual Windows 11      | 16 GB  | 4   | 125 GB | Yes          | 192.168.150.15   | QEMU host and Ansible target        | QEMU installed, Ansible access configured              |
| Virtual Ubuntu (Ansible)| 4 GB   | 2   | 127 GB | -          | 192.168.150.20   | Ansible control node                | Connected to Windows host successfully via Ansible     |
| Kali Linux inside Virtual Win11 | 4 GB   | 2   | QCOW2 | -          | DHCP (e.g., 10.0.2.15) | Test VM (launched via QEMU)       | Auto-start successful   |
| Debian 10 inside Virtual Win11  | 4 GB   | 1   | QCOW2 | -          | DHCP (e.g., 10.0.2.16) | Test VM (launched via QEMU)       | Auto-start successful |
---


## ✅ Result

- `.qcow2` disks are automatically discovered and used
- PowerShell scripts are executed on GUI startup
- QEMU boots all VMs with the defined configuration
- All steps are fully automated via Ansible — no manual action needed on the Windows VM

---

## 🧾 Summary

Using **Vagrant** with **VMware Workstation Player** on a bare metal Debian system, two virtual machines have been successfully provisioned. One of them is a **Windows 11 VM**, and the other is an **Ubuntu 22.04 VM** designated as the **Ansible control node**.

- **Ubuntu VM IP**: `192.168.150.20`
- **Windows VM IP**: `192.168.150.15`

### Provisioning Steps:

1. Navigate to the `win11` folder and run `vagrant up`. This will:
   - Automatically download and import the Windows box (VMware Utility and Plugin must be installed beforehand).
   - Enable Ansible WinRM access by downloading and executing `ConfigureRemotingForAnsible.ps1` from GitHub with administrator privileges.
   - Assign the static IP `192.168.150.15` to the Windows VM.

2. Next, go to the `ans` folder and run `vagrant up`. This launches the Ubuntu VM and:
   - Installs Ansible automatically.
   - Runs the `install_qemu.yml` playbook to:
     - Download and silently install the latest version of QEMU.
     - Enable Windows virtualization features: **Hyper-V**, **Virtual Machine Platform**, and **Hypervisor Platform**.

3. Afterwards, the `start_vm.yml` playbook:
   - Scans the `win11/images` directory for `.qcow2` disk files.
   - Generates PowerShell (`.ps1`) and batch (`.bat`) files for each disk.
   - Places these files in startup folders so QEMU VMs will automatically launch on Windows login.

> ⚠️ **IMPORTANT**: Make sure to place your desired `.qcow2` images in the `win11/images` directory. The Ansible control node reads image filenames from this location and the Windows VM accesses the same directory via its Vagrant shared folder (e.g., `Z:\-vagrant\images\`).

Finally, after restarting the virtual Windows 11 machine, all QEMU-based virtual machines boot automatically with no manual intervention required.
