# 🗂️ QCOW2 Images Directory

This folder is **crucial** to the automation system that powers QEMU virtual machines on the Windows 11 guest VM.

---

## 📂 Purpose

The `images/` directory is shared between the Windows 11 VM and the Ansible control node (Ubuntu VM) via Vagrant’s synced folder mechanism.

Ansible scans this directory for any `*.qcow2` files and generates the necessary PowerShell (`.ps1`) and batch (`.bat`) files inside the Windows guest. These startup scripts ensure that each virtual machine boots automatically when Windows starts.

---

## 📌 How It Works

1. Place any `.qcow2`-formatted virtual disk image into this `images/` folder.
2. The folder is synced to:
   - **Ubuntu (Ansible Control)** as: `/home/vagrant/shared_images`
   - **Windows 11 Guest** as: `Z:\-vagrant\images\`
3. When you run the playbook `start_vm.yml` from the Ubuntu Ansible control node, the following happens:
   - Ansible locates each `.qcow2` file in this folder.
   - Creates matching PowerShell and BAT files in `C:\vagrant_vm_boot` and the Windows Startup folder.
   - These scripts use QEMU to launch the virtual machines with WHPX acceleration.

---

## ⚠️ Important Notes

- Make sure all your `.qcow2` files are **directly** placed inside this folder (not in subfolders).
- Supported OS images include Debian, Kali Linux, and any OS compatible with QEMU.
- File names should not contain spaces or special characters.

---

## ✅ Example Files

