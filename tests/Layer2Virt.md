# Vagrant + Libvirt Nested Virtualization Test

## Overview
This document describes a nested virtualization test conducted on bare-metal Debian using Vagrant, libvirt, and KVM technologies.

---

## Environment Setup

### Install Libvirt and Required Packages on bare metal debian
```bash
sudo apt-get purge vagrant-libvirt
sudo apt-mark hold vagrant-libvirt
sudo apt-get install -y qemu libvirt-daemon-system libvirt-dev ebtables libguestfs-tools
sudo apt-get install -y vagrant ruby-fog-libvirt
vagrant plugin install vagrant-libvirt
```

After installation:
```bash
vagrant plugin list
# Output:
vagrant-libvirt (0.12.2, global)
```

### Box Used
- Box: [stromweld/windows-10](https://portal.cloud.hashicorp.com/vagrant/discover/stromweld/windows-10)
- Alternative used in test: `jtarpley/w11_23h2_base`

### Vagrantfile Content
```ruby
Vagrant.configure("2") do |config|
  config.vm.define "default" do |machine|
    machine.vm.box = "stromweld/windows-10"
    machine.vm.communicator = "winrm"
    machine.winrm.username = "vagrant"
    machine.winrm.password = "vagrant"
    config.vm.communicator = "winrm"
    machine.vm.provider :libvirt do |libvirt|
      libvirt.driver = "kvm"
      libvirt.uri = "qemu:///system"

      libvirt.memory = 16384
      libvirt.cpus = 4       
      libvirt.disk_bus = "virtio"

      libvirt.management_network_device = "virbr0"
      libvirt.nic_model_type = "virtio"

      libvirt.graphics_type = "spice"
      libvirt.video_type = "qxl"

      libvirt.cpu_mode = "host-passthrough"
    end

    machine.vm.provision "file", source: "bootstrap.ps1", destination: "C:\\Users\\vagrant\\bootstrap.ps1"
    machine.vm.provision "shell", inline: <<-SHELL
      powershell.exe -ExecutionPolicy Bypass -File C:\\Users\\vagrant\\bootstrap.ps1
    SHELL
  end
end

```

From the directory containing the Vagrantfile:
```bash
vagrant up
```
This launches the Windows 10 VM using KVM via libvirt.

---

## Rsync Error and Resolution
```bash
==> default: Rsyncing folder: /home/reqwert/Desktop/log/libvirt L2 virtualization/ => /vagrant
...
Error: rsync: connection unexpectedly closed (0 bytes received so far) [sender]
```

This error occurs due to rsync being unable to establish an SSH connection.

### Resolution:
- Installed WinRM inside the VM
- Enabled execution of `.ps1` scripts

---

## Nested Virtualization: VM Inside a VM

### Enabling Virtualization Inside Windows 10 VM
- A Debian VM was created inside the Windows 10 VM using Hyper-V.

### Second Vagrantfile (Debian on Hyper-V)
```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "ashrafmuqlis/debiandesktop"

  config.vm.provider "hyperv" do |h|
    h.memory = 1024
    h.vmname = "DebianDesktopVM"
    h.enable_virtualization_extensions = true
  end

  config.vm.network "private_network", type: "dhcp"
  config.vm.boot_timeout = 600
end
```

---

## bootstrap.ps1 Script

This script installs Chocolatey and Vagrant (if missing), enables virtualization features, and initializes a Hyper-V VM with Debian Desktop.

```powershell
# bootstrap.ps1

# 1. Enable Hyper-V and Virtualization Features
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -All -NoRestart

# 2. Install Chocolatey if not already installed
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# 3. Install Vagrant if not already installed
if (!(Get-Command vagrant -ErrorAction SilentlyContinue)) {
    choco install vagrant -y
}

# 4. Create working directory
$workDir = "$env:USERPROFILE\vagrant_hyperv_vm"
if (!(Test-Path $workDir)) {
    New-Item -ItemType Directory -Path $workDir
}
```

---

## Test Result
- **Windows 10 VM** launched from bare-metal Debian had WinRM installed, allowing `.ps1` scripts to be executed.
- A **Debian VM** was successfully launched inside the Windows 10 VM using Hyper-V.
- Despite being allocated only 1 GB RAM, the inner Debian VM performed quickly and stably.

---

## Conclusion
This test confirms that nested virtualization using Vagrant + Libvirt + KVM works as expected, enabling virtual machines inside virtual machines with successful provisioning and script execution capabilities.
