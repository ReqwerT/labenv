# Welcome to My Lab Environment

In this repo we will set up a test environment on a virtual machine base using three different providers.

## Goals:
Our main goal is to perform some tests safely without damaging our real system. That's why we set up a virtual environment. We perform these tests on virtual machines so that operations such as disk partitioning do not harm the computer. We also perform all operations automatically to prevent time loss.


## Mission:
Every time our virtual Windows machine boots up, it will automatically start another virtual machine using QEMU with WHPX acceleration. It will then access the shared folder at C:\Users\vagrant\sf.


## Using Providers:
  - [**Libvirt**](https://github.com/ReqwerT/labenv/tree/main/libvirt)
  - [**VMware**](https://github.com/ReqwerT/labenv/tree/main/vmware)
  - [**Hyper-V**](https://github.com/ReqwerT/labenv/tree/main/hyperv)

## Required Applications and Plugins:
  - Vagrant 2.4.5
  - Vagrant VMware Plugin  
  - Vagrant Libvirt Plugin  
  - Vagrant Hyper-V Plugin  

## Using Bare Metal Operating Systems:
  - Debian 10 KDE Plasma  
  - Windows 10  
  - Windows 11  

---

## Virtual Machines Used in The Test Environment

###  Virtual Windows 11  
  This virtual machine will be managed with Ansible. Without manual intervention, all necessary applications will be installed and configurations will be done automatically by the ansible virtual machine.

###  Virtual Linux for Ansible  
  This virtual machine will be used as an Ansible control node (sidecar). It will install the necessary software on the Windows machine and perform the configurations remotely. Additionally, an OpenVPN TAP server can be installed if desired.

---

## Preparations for the Test
  In order for the test scenario to work, some virtual disk images in `.qcow2` format are needed. With these images, operations can be performed quickly on ready systems. Since the purpose of the tests is not installation, but configuration and automation, installed machines were preferred.

  In this way, time loss is prevented and the risk of damaging real systems is eliminated, because disk partitioning operations are performed in a virtual environment.

`.qcow2` uzantılı disk imajlarını şu şekillerde temin edebilirsiniz:

   - [qcow2 image creation guide](#)
   - [Click to download ready qcow2 files](#)

---

##  Folder Structure

  
    vagrant-lab-environment/
    ├── images/
    │   ├── kali.qcow2
    │   ├── Windows.qcow2
    │   └── manjaro.qcow2
    ├── Ans/
    │   ├── Vagrantfile
    │   └── scripts/
    │       ├── req.sh
    │       ├── install_qemu.yml
    │       ├── create_startup_qemu_file.yml
    │       └── hosts.ini
    ├── Win/
    │   └── Vagrantfile
    └── README.md
    

### Remarks:
  - The `images/` folder contains the disk files with the `.qcow2` extension of the virtual machines that will be launched via the Windows virtual machine. Both Windows and Linux virtual machines can access this folder via file sharing.
  
  - The `Ans/` folder contains the files belonging to the Ansible control machine:
  - `Vagrantfile`: Starts the Ubuntu-based virtual machine.
  - `scripts/req.sh`: Automatically runs with `vagrant up`, installs Ansible and triggers other steps.
  - `install_qemu.yml`: Installs QEMU and necessary virtualization features on the target (Windows) machine.
  - `create_startup_qemu_file.yml`: Creates automatic `.bat` files for each disk in the `images/` folder and adds them to the Windows startup. Thus, the relevant virtual machines are automatically started every time Windows is started.
  - The `Win/` folder contains the `Vagrantfile` needed to start the Windows virtual machine. This file:
     - Assigns a static IP address,
     - Enables the WinRM service and makes it manageable with Ansible.

  ---

## Installation and Run Steps

  1. Clone the repo to your system
  2. Place the `.qcow2` disk files you want to use in the `images/` folder
  3. Open a terminal in the `Win/` folder
  4. Run the `vagrant up` command
     > *You will get an error if the required Vagrant extensions are not installed. Install them if necessary by [clicking here](#)*
  5. The Windows virtual machine will be started and automatically configured
  6. Then move to the `Ans/` folder
  7. Run the `vagrant up` command here as well
     > This step will start the Ansible control machine and trigger automatic operations
  8. Once the process is complete, the Windows virtual machine will be restarted and the virtual machines from the `.qcow2` disks will automatically run

---
## Systems Providing Test Environment for Bare Metal Debian

  - [Click to test with VMware](https://github.com/ReqwerT/labenv/tree/main/vmware)
  - [Click to test with Hyper-V](https://github.com/ReqwerT/labenv/tree/main/hyperv)
  - [Click to test with Libvirt](https://github.com/ReqwerT/labenv/tree/main/libvirt)

---
## All Test Logs
  - [Click to see all test logs](https://github.com/ReqwerT/labenv/blob/main/tests/baremetaldebian.md)
