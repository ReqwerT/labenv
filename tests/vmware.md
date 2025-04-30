# Vagrant VMware Kurulum ve Kullanım

## Vagrant Plugin Komutları

- **Yüklü olan pluginleri listelemek için:**

  `vagrant plugin list`

- **Yüklü olan bir plugini silmek için:**

  `vagrant plugin uninstall <plugin-adı>`

- **VMware plugin yüklemek için:**

  `vagrant plugin install vagrant-vmware-desktop`

---

## Vagrant VMware Utility Kurulumu

### 1. HashiCorp GPG Anahtarını ve Repo Kaynağını Ekleme

Öncelikle, HashiCorp GPG anahtarını indirip sisteminize eklemeniz gerekiyor. Aşağıdaki komutları sırayla çalıştırın:

- GPG anahtarını ekleyin:

  `wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg`

- Repo kaynağını ekleyin:

  `echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list`

- Vagrant'ı kurun:

  `sudo apt update && sudo apt install vagrant`

---

### 2. VMware Utility 1.0.14 İndirip Kurma

VMware utility'yi [buradan](https://releases.hashicorp.com/vagrant-vmware-utility/1.0.14/) indirin.

İndirme işlemi tamamlandıktan sonra, utility'yi kurmak için şu komutları çalıştırın:

- Gerekli dizini oluşturun:

  `sudo mkdir -p /opt/vagrant-vmware-desktop/bin`

- İndirilen dosyayı çıkartın:

  `sudo unzip -d /opt/vagrant-vmware-desktop/bin vagrant-vmware-utility_1.0.0_linux_amd64.zip`

---

### 3. Sertifika Oluşturma

Kurulum tamamlandıktan sonra, gerekli sertifikaları oluşturmanız gerekiyor. Bunun için şu komutu çalıştırın:

`sudo /opt/vagrant-vmware-desktop/bin/vagrant-vmware-utility certificate generate`

> Bu komutun çıktısı, `Vagrantfile` dosyasındaki `utility_certificate_path` alanına eklenebilir.

---

### 4. Servisi Kurma ve Başlatma

Son adımda, VMware utility servisini kurmak ve başlatmak için şu komutu kullanın:

`sudo /opt/vagrant-vmware-desktop/bin/vagrant-vmware-utility service install`

---

## Kullanılan Box'lar

- **Windows 10**:  
  `https://portal.cloud.hashicorp.com/vagrant/discover/gusztavvargadr/windows-10`

- **Windows 11**:  
  `https://portal.cloud.hashicorp.com/vagrant/discover/gusztavvargadr/windows-11`

---

Bu düzenleme ile adımları daha net ve anlaşılır şekilde sunmaya çalıştım. Umarım şimdi istediğiniz gibi olmuştur!
