# 🗂️ QCOW2 Images Directory

This directory is **critical** for enabling automatic virtual machine boot via QEMU inside the Windows 11 virtual machine.

---

## 📂 Purpose of This Directory

The `images/` folder is shared between the Ubuntu Ansible control machine and the Windows 11 guest system using Vagrant's synced folders.

Ansible scans this folder for `.qcow2` disk files and generates both PowerShell (`.ps1`) and Batch (`.bat`) scripts on the Windows VM. These scripts are configured to run at Windows GUI startup, automatically launching virtual machines using QEMU with WHPX acceleration.

---

## ⚙️ How It Works

1. Place your `.qcow2` virtual disk images into this folder.
2. Folder synchronization:
   - **Ubuntu (Ansible VM):** `/home/vagrant/shared_images`
   - **Windows 11 Guest:** `Z:\-vagrant\images\`
3. When `ansible-playbook start_vm.yml` is executed:
   - All `.qcow2` files in this folder are detected.
   - A PowerShell script is created for each image in `C:\vagrant_vm_boot`.
   - Corresponding `.bat` scripts are added to the Windows Startup folder.
   - When the GUI session starts, QEMU launches each image automatically.

---

## ✅ Sample Tested Images

These `.qcow2` disks have been successfully tested:

- `debian-10-openstack-amd64.qcow2`
- `kali-linux-2025.1c-qemu-amd64.qcow2`

You may add any other `.qcow2`-formatted operating systems to this directory for use.

---

## ⚠️ Important Notes

- All `.qcow2` files must be placed **directly** in this folder — subdirectories are not supported.
- Avoid spaces or non-ASCII characters in filenames.
- If the folder is empty, Ansible will skip processing and no virtual machines will start.
- Other image formats (e.g., `.iso`, `.vmdk`) are **not supported** by this automation.

---

## 🧠 Summary

This directory plays a key role in full automation. Once Ansible has configured the system, the Windows VM will automatically boot all `.qcow2` virtual machines on GUI startup. For the process to work as intended, this folder must contain valid and supported `.qcow2` disk files.
