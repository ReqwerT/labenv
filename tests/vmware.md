vagrant plugin list : yüklü olan pluginleri listeler

vagrant plugin uninstall <plugin-adı> : yüklü olan bir plugini siler

vagrant plugin install vagrant-vmware-desktop: vmware plugin yükler

---

vagrant vmware utility yükleme:  
`wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg`

`echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list`

`sudo apt update && sudo apt install vagrant`

`vagrant vmware utility 1.0.14: https://releases.hashicorp.com/vagrant-vmware-utility/1.0.14/`

yukarıdaki linki indirmek lazım  
ardından:  
`$ sudo mkdir -p /opt/vagrant-vmware-desktop/bin`  
`$ sudo unzip -d /opt/vagrant-vmware-desktop/bin vagrant-vmware-utility_1.0.0_linux_amd64.zip`

After the executable has been installed, the utility setup tasks must be run. First, generate the required certificates:

`$ sudo /opt/vagrant-vmware-desktop/bin/vagrant-vmware-utility certificate generate`

The path provided from this command can be used to set the utility_certificate_path in the Vagrantfile configuration if installing to a non-standard path.

Finally, install the service. This will also enable the service.

`$ sudo /opt/vagrant-vmware-desktop/bin/vagrant-vmware-utility service install`

---

KUllanılan box: (win10):  
`https://portal.cloud.hashicorp.com/vagrant/discover/gusztavvargadr/windows-10`

Kullanılan Box: (win11):  
`https://portal.cloud.hashicorp.com/vagrant/discover/gusztavvargadr/windows-11`
