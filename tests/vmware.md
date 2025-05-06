# Vagrant VMware Installation and Usage

## Vagrant Plugin Commands

- **To list the installed plugins:**

  `vagrant plugin list`

- **To uninstall an installed plugin:**

  `vagrant plugin uninstall <plugin-name>`

- **To install the VMware plugin:**

  `vagrant plugin install vagrant-vmware-desktop`

---

## Vagrant VMware Utility Installation

### 1. Add HashiCorp GPG Key and Repo Source

First, you need to download and add the HashiCorp GPG key to your system. Run the following commands:

- Add the GPG key:

  `wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg`

- Add the repo source:

  `echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list`

- Install Vagrant:

  `sudo apt update && sudo apt install vagrant`

---

### 2. Download and Install VMware Utility 1.0.24

Download the `.deb` installer for the VMware Utility from the [official releases page](https://releases.hashicorp.com/vagrant-vmware-utility/1.0.24/), or use the direct link below:

- [vagrant-vmware-utility_1.0.24_amd64.deb](https://releases.hashicorp.com/vagrant-vmware-utility/1.0.24/vagrant-vmware-utility_1.0.24_amd64.deb)

Once downloaded, install it using the following command:

```bash
sudo dpkg -i vagrant-vmware-utility_1.0.24_amd64.deb
```

> ✅ This installs the VMware Utility system-wide and prepares your environment for using the Vagrant VMware plugin.


---

## Boxes Used

- **Windows 10**:  
  `https://portal.cloud.hashicorp.com/vagrant/discover/gusztavvargadr/windows-10`

- **Windows 11**:  
  `https://portal.cloud.hashicorp.com/vagrant/discover/gusztavvargadr/windows-11`

---

## Resources

- [Vagrant VMware Utility Documentation](https://developer.hashicorp.com/vagrant/docs/providers/vmware/vagrant-vmware-utility)
- [Vagrant VMware Installation Guide](https://developer.hashicorp.com/vagrant/docs/providers/vmware/installation)
