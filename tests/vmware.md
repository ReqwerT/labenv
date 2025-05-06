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

### 2. Download and Install VMware Utility 1.0.14

Download VMware utility from [here](https://releases.hashicorp.com/vagrant-vmware-utility/1.0.24/).

Once the download is complete, install the utility using the following commands:

- Create the necessary directory:

  `sudo mkdir -p /opt/vagrant-vmware-desktop/bin`

- Unzip the downloaded file:

  `sudo unzip -d /opt/vagrant-vmware-desktop/bin vagrant-vmware-utility_1.0.0_linux_amd64.zip`

---

### 3. Generate Certificates

Once the installation is complete, you need to generate the required certificates. Run the following command:

`sudo /opt/vagrant-vmware-desktop/bin/vagrant-vmware-utility certificate generate`

> The output of this command can be used to set the `utility_certificate_path` in the `Vagrantfile` if installing to a non-standard path.

---

### 4. Install and Start the Service

In the final step, use the following command to install and start the VMware utility service:

`sudo /opt/vagrant-vmware-desktop/bin/vagrant-vmware-utility service install`

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
