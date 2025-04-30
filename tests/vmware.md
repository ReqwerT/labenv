
# Vagrant VMware Kurulum ve Kullanım

## Vagrant Plugin Komutları

Yüklü olan pluginleri listelemek için:

vagrant plugin list

Yüklü olan bir plugini silmek için:

vagrant plugin uninstall <plugin-adı>

VMware plugin yüklemek için:

vagrant plugin install vagrant-vmware-desktop

---

## Vagrant VMware Utility Kurulumu

### HashiCorp GPG Anahtarını ve Repo Kaynağını Ekleme

wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install vagrant

---

### VMware Utility 1.0.14 İndirip Kurma

VMware utility'yi [buradan](https://releases.hashicorp.com/vagrant-vmware-utility/1.0.14/) indir.

Ardından:

sudo mkdir -p /opt/vagrant-vmware-desktop/bin  
sudo unzip -d /opt/vagrant-vmware-desktop/bin vagrant-vmware-utility_1.0.0_linux_amd64.zip

---

### Sertifika Oluşturma

sudo /opt/vagrant-vmware-desktop/bin/vagrant-vmware-utility certificate generate

> Bu komut sonucunda verilen yol, `Vagrantfile` dosyasındaki `utility_certificate_path` alanına eklenebilir.

---

### Servisi Kurma ve Başlatma

sudo /opt/vagrant-vmware-desktop/bin/vagrant-vmware-utility service install

---

## Kullanılan Box'lar

- **Windows 10**:  
  `https://portal.cloud.hashicorp.com/vagrant/discover/gusztavvargadr/windows-10`

- **Windows 11**:  
  `https://portal.cloud.hashicorp.com/vagrant/discover/gusztavvargadr/windows-11`
