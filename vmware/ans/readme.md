# 🧰 Ansible Automation Scripts (`ans/scripts` Directory)

This folder contains automation scripts to manage and configure a **Windows 11 virtual machine** using **Ansible**.  
The **Ubuntu-based Ansible control machine** provisions the Windows VM to install **QEMU**, enable **virtualization features**, and configure **automatic virtual machine startup** using `.qcow2` disk images.

---

## 📁 File Overview

### 🔹 `hosts.ini`

Defines the Ansible inventory, specifying the target Windows machine.

```ini
[win]
192.168.150.15
```

- `[win]` is the inventory group used in playbooks.
- This allows Ansible to identify and connect to the Windows VM using **WinRM**.
- Make sure the IP matches your actual static configuration.

---

### 🔹 `install_qemu.yml`

Installs **QEMU** and required **virtualization features** on the Windows host.

#### ✅ Tasks Performed:
- Downloads and silently installs the latest **QEMU** build.
- Adds `C:\Program Files\qemu` to the system **PATH**.
- Enables the following **Windows features**:
  - `Microsoft-Hyper-V-All`
  - `HypervisorPlatform`
  - `VirtualMachinePlatform`

> These features enable **QEMU** to run with **WHPX hardware acceleration**.

---

### 🔹 `start_vm.yml`

Scans for `.qcow2` images and configures them for **automatic launch** at system startup.

#### ↺ Process:
- Scans `/home/vagrant/shared_images` for `.qcow2` files (delegated to Ansible host).
- For each disk:
  - Creates a **PowerShell launch script** under `C:\vagrant_vm_boot\`.
  - Adds a `.bat` file in the **Windows Startup folder** to run the script on GUI login.
- Triggers a **reboot** to finalize configuration.

> After the reboot, Windows automatically starts each defined QEMU VM on login.

---

### 🔹 `req.sh`

A **Bash script** executed during provisioning of the Ubuntu **Ansible control machine**.

#### 📋 What It Does:
- Updates packages and installs **Ansible**
- Installs `pywinrm` to enable Ansible control of Windows over **WinRM**
- Automatically runs:
  - `install_qemu.yml` (QEMU install + feature enablement)
  - `start_vm.yml` (prepare auto-start VM scripts)

> This script ensures the control machine is fully prepared to manage the Windows VM and launch `.qcow2` virtual machines automatically.

---

## 📌 Summary

These tools work together to provide a seamless virtual environment managed from **Linux using Ansible** and executed within a **VMware-based Windows VM**.

From QEMU installation to automated virtual machine launch, every step is controlled remotely.

📂 **Be sure your `.qcow2` images are placed in the shared `win11/images/` folder** so they can be discovered and configured by Ansible.

