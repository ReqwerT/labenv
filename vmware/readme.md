# QEMU VM Automation Project (Ansible + Vagrant + Windows)

Before using this project, make sure the following components are installed on your system:

- **To install Vagrant**: [https://developer.hashicorp.com/vagrant/downloads](https://developer.hashicorp.com/vagrant/downloads)
- **To install the Vagrant VMware plugin**: [Install Vagrant VMware Utility0](https://github.com/ReqwerT/labenv/blob/main/tests/vmware.md)
- **To install VMware Workstation (Pro or Player)**: [https://www.vmware.com/products/workstation-pro/workstation-pro-evaluation.html](https://www.vmware.com/products/workstation-pro/workstation-pro-evaluation.html)

---

## ⚙️ System Requirements

- **Vagrant version**: `2.4.5`
- **VMware software**: `VMware Workstation Player`
- **Vagrant boxes used**:
  - `gusztavvargadr/ubuntu-desktop-2204-lts` (for the Ansible control machine)
  - `gusztavvargadr/windows-11` (for the Windows QEMU host)
- **QCOW2 disk images used in this project**:
  - `debian-10-openstack-amd64.qcow2`
  - `kali-linux-2025.1c-qemu-amd64.qcow2`

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
├── Vagrantfile
├── scripts
│   ├── start_vm.yml               # Playbook to prepare VM startup
│   ├── qemu_install.yml           # Playbook to install QEMU and features
│   └── hosts.ini                  # Ansible inventory
├── win
│   └── images
│       ├── ubuntu.qcow2
│       └── debian-10.qcow2
└── shared_images (→ mounted in Ansible VM as /home/vagrant/shared_images)
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

> - `qemu_install.yml`: Installs QEMU, enables Hyper-V, sets up TAP and shares
> - `start_vm.yml`: Scans `.qcow2` files, generates `.ps1` + `.bat` files for automatic startup

---

## ✅ Result

- `.qcow2` disks are automatically discovered and used
- PowerShell scripts are executed on GUI startup
- QEMU boots all VMs with the defined configuration
- All steps are fully automated via Ansible — no manual action needed on the Windows VM
