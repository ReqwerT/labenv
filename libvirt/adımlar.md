# Vagrant 2.4.5 + Libvirt Kurulumu (Bare Metal Debian)

## 🔧 Vagrant Kurulumu (v2.4.5)

Öncelikle Vagrant 2.4.5 sürümünü bare metal Debian’a indirelim:

Buradaki (https://developer.hashicorp.com/vagrant/install) linkten doğrudan siteye erişebilir veya aşağıdaki komutları terminale yazarak Vagrant kurma adımlarını sağlayabiliriz:

```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install vagrant
```

---

## 🧱 Libvirt Kurulumu

Aşağıdaki komutlarla libvirt’i indirip kurabiliriz:

### 1) Virtualization Extension Açık mı?

```bash
grep -E -c '(vmx|svm)' /proc/cpuinfo
```

### 2) KVM ve Gerekli Paketleri Yükleme

```bash
sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virtinst libvirt-daemon virt-manager -y
sudo systemctl status libvirtd
```

### 3) Varsayılan Ağı Başlat ve vhost_net Modülünü Aktifleştir

```bash
sudo virsh net-list --all
sudo virsh net-start default
sudo virsh net-autostart default

sudo modprobe vhost_net
echo "vhost_net" | sudo tee -a /etc/modules
lsmod | grep vhost
```

> 💡 **Not:** Eğer yerel kullanıcı olarak `virsh` komutlarını çalıştırmak istiyorsanız, aşağıdaki komutlarla kullanıcıyı ilgili gruplara ekleyin:

```bash
sudo adduser $USER libvirt
sudo adduser $USER libvirt-qemu
```

---

## 📦 Vagrant Libvirt Eklentisi Kurulumu

Kaynak: [vagrant-libvirt GitHub](https://github.com/vagrant-libvirt/vagrant-libvirt/pkgs/rubygems/vagrant-libvirt/125854293)

### 1) Ruby Gerekli Paketlerle Birlikte Kurulumu

```bash
sudo apt install -y vagrant ruby ruby-dev gcc libz-dev libvirt-dev
```

### 2) Libvirt Plugin Yükleme

```bash
gem install vagrant-libvirt
vagrant plugin install vagrant-libvirt
```

---

## ✅ Sonuç

Yukarıdaki adımlar sonucunda, Vagrant ve libvirt’i bare metal Debian işletim sistemimize kurmuş oluyoruz.
