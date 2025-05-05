# QEMU VM Automation Project (Ansible + Vagrant + Windows)

This project enables **automatic startup of QEMU virtual machines on a Windows host**, orchestrated from a **Vagrant-based Ansible control node**. The process is fully automated: `.qcow2` disk images are scanned on the Ansible VM, scripts are generated for each, and Windows runs these scripts at GUI login.

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

1. Launch the Ansible control VM via Vagrant.
2. The local `win/images` folder is mounted into the Ansible VM as `/home/vagrant/shared_images`.
3. Ansible scans that folder for `.qcow2` files.
4. On the Windows host:
   - A PowerShell script (`start_vm_*.ps1`) is created for each disk.
   - A `.bat` launcher is placed in the Startup folder to execute it.
5. When the Windows GUI session starts, each VM is launched via PowerShell and QEMU.

---

## 💾 Accessing `.qcow2` Disks

- Ansible reads file names from `/home/vagrant/shared_images`.
- Windows accesses these disks from `Z:\-vagrant\images\` (via VMware Shared Folders).
- Each generated script refers to `Z:\-vagrant\images\your-disk.qcow2`.

---

## 🧪 Usage

To execute the playbooks:

```bash
ansible-playbook -i scripts/hosts.ini scripts/qemu_install.yml
ansible-playbook -i scripts/hosts.ini scripts/start_vm.yml
```

---

## ✅ Outcome

- `.qcow2` disks are automatically discovered.
- VMs are launched on GUI login via PowerShell scripts.
- The entire setup is automated through Ansible.
- No manual action is required on the Windows host.

---

## 📌 Requirements

- Ansible + Vagrant installed on the control VM
- QEMU installed and in PATH on the Windows host
- VMware Shared Folders enabled (`Z:\-vagrant\images`)
- OpenVPN TAP adapter installed
- Hyper-V features enabled (WHPX acceleration)
