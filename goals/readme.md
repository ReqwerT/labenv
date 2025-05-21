# Bare Metal Dual Boot Lab: OpenMediaVault Sharing Scenario

## General Structure

This lab environment is a dual boot test environment established on bare metal (hardware level) and provides data access between two operating systems using openmediavault. The system contains two main operating systems:

- **Windows 11**
- **Debian Linux**
In addition to the above, we have the OMV.qcow2 file in a 3rd disk that is shrunk. When we select one of the operating systems above, we access this exFAT disk and run the omv.qcow2 disk as a virtual machine using qemu and a suitable hardware accelerator, and this virtual machine accesses the shared data in the operating system that is not opened.

## Disk Structure and Partitions
`A sample scenario:`

Total disk capacity: `100 GB`

| Partition | Size | Description |
|-----|--------|------------------------------------------------------|
| Windows (NTFS) | 30 GB | Partition reserved for Windows operating system |
| Linux (ext4) | 20 GB | Partition reserved for Debian operating system |
| SANbox (exFAT) | 50 GB | Disk space hosting OMV virtual machine (qcow2 included)|

> 30 GB disk space will be reserved for Windows, 7 GB for installation + 23 GB for free, so that it will not starve in the future. Remaining 70 GB:
> - 20 GB Linux
> - 50 GB SANbox

## SANbox (OpenMediaVault) Virtual Machine

- Format: `qcow2`
- Storage: 50Gb in `SANbox` partition
- Disk format: `exFAT` (so that it can be written/read by both Linux and Windows)
- Operating system: `OpenMediaVault` (NAS platform)

## Dual Boot Behavior

### 1. When Windows is Started

- Windows operating system is started.
- `OMV.qcow2` virtual machine is started using `QEMU` + `WHPX`.
- Shared folders on OpenMediaVault are automatically mounted to Windows with **SMB protocol**.
- **Data on Linux disk** can be accessed via OMV and used by Windows.

### 2. When Linux is Started

- Debian operating system is started.
- `QEMU` + `KVM` and `OMV.qcow2` virtual machine is started.
- Folders shared by OpenMediaVault are mounted with **NFS protocol**.
- **Data on Windows disk** is accessed via OMV and becomes available, readable and modifiable by Linux.

## Sharing Methods

| Operating System | Virtual Machine Technology | Sharing Path |
|-----|------------------------|----------------|
| Windows | WHPX + QEMU | SMB |
| Linux | KVM + QEMU | NFS |

## Flowchart

1. The system will be dual boot. Our disk will be shrunk 2 times. One will be reserved for Linux, one for Windows and the last one for SANBox. Our Linux and Windows disks will be dual boot.
2. Every time our virtual machine opens, it will ask us whether we want to choose Windows or Linux.
3. Then the selected operating system will access the exFAT formatted SANbox disk.

4. It will run our `OMV.qcow2` image file in the SANBox disk using qemu and the required speed (whpx for Windows, kvm for Linux).

5. OMV virtual NAS will offer shared folders of other operating systems via file sharing protocols. In this way, we will be able to access data in Linux from within Windows, and we will be able to access and make changes to data in Windows from within Linux.

6. While we use NFS for Linux file sharing, we will use SMB for Windows file sharing.

## Notes

- Thanks to the `exFAT` file system, both Windows and Linux will be able to read and write data to the SANbox disk.

- The OMV virtual machine will manage file sharing and ensure data integrity between systems.

- With the written yml file, we will be able to perform shrink operations automatically on our virtual Windows disk using Ansible.

---
