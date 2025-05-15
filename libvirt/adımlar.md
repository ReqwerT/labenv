# Vagrant 2.4.5 + Libvirt Installation (Bare Metal Debian)

## Vagrant Installation (v2.4.5)

First, let's download Vagrant 2.4.5 to bare metal Debian:

[Here](https://developer.hashicorp.com/vagrant/install) You can access the site directly from the link or type the following commands into the terminal to provide the steps to install Vagrant:

```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install vagrant
```

---

## Libvirt Installation

We can download and install libvirt with the following commands:

### 1) Is Virtualization Extension On?

```bash
grep -E -c '(vmx|svm)' /proc/cpuinfo
```
> **Note:** If we see a number greater than zero, it means our CPU supports hardware virtualization. If we don't see it, it means this feature is not enabled in the BIOS or the CPU does not support hardware virtualization.

### 2) Installing KVM and Required Packages

```bash
sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
sudo systemctl status libvirtd
```

### 3) Start Default Networking and Activate vhost_net Module

```bash
sudo virsh net-list --all
sudo virsh net-start default
sudo virsh net-autostart default

sudo modprobe vhost_net
echo "vhost_net" | sudo tee -a /etc/modules
lsmod | grep vhost
```

> **Note:** If you want to run `virsh` commands as a local user, add the user to the relevant groups with the following commands:

```bash
sudo adduser $USER libvirt
sudo adduser $USER libvirt-qemu
```

---

## Installing Vagrant Libvirt Plugin

Source: [vagrant-libvirt GitHub](https://github.com/vagrant-libvirt/vagrant-libvirt/pkgs/rubygems/vagrant-libvirt/125854293)

### 1) Installing Ruby with Required Packages

```bash
sudo apt install -y vagrant ruby ​​ruby-dev gcc libz-dev libvirt-dev
```

### 2) Installing Libvirt Plugin

```bash
gem install vagrant-libvirt
vagrant plugin install vagrant-libvirt
```

---

## Result

As a result of the above steps, we have installed Vagrant and libvirt on our bare metal Debian operating system.
