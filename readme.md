# Lab Ortamına Hoş Geldiniz 👋

Bu repoda, 3 tane provider ile bir test gerçekleştireceğiz.

## Kullanılan Providerlar:
- **Libvirt**
- **Vmware**
- **Hyper-V**

## Test için gerekli Uygulama ve Pluginler:
- Vagrant 2.4.5  
- Vagrant Vmware Plugin  
- Vagrant Libvirt Plugin  
- Vagrant Hyper-V Plugin  

## Kullanılan Bare Metal İşletim Sistemleri:
- Debian 10 KDE Plasma  
- Windows10  
- Windows11  

---

## Test İçerisinde Kullanılan İşletim Sistemleri

### 1️⃣ Virtual Windows11  
Ansible ile bu virtual Windows makinesini yöneteceğiz. Bu makine içerisine hiçbir şey yapmadan tamamen otomatik bir biçimde gerekli uygulamaları kurup ayarları otomatik bir biçimde gerçekleştireceğiz.

### 2️⃣ Virtual Linux for Ansible  
Bu makinemiz sidecar görevi ile bir ansible işi görecek. Bu makine sayesinde gerekli uygulamalarımızı Windows makinesine yükleyip, gerekli ayarlamaları yapabileceğiz. OpenVPN TAP server da yükleyebiliriz.

---

## Test İçin Gerekli Diğer İşlemler

Bize test için bazı `.qcow2` uzantılı image dosyaları gerekiyor. Bu sayede testleri hızlıca gerçekleştirebileceğiz. Bu yüzden tüm yapıyı buna dayanarak hazırladım. Biz kurulum adımı ile ilgilenmeyeceğiz. Zaten kurulu makineler üzerinde işlemler gerçekleştireceğiz. Bu sayede kurmakla vakit kaybetmeyeceğiz. Sistemi Vagrant ile sanal bir ortamda test etmemizin amacı ise disk partitionlar ile uğraşacağız. Bunu sanal biçimde gerçekleştirmezsek, ana bilgisayarımızın işletim sistemine zarar verebiliriz.

Kendi `.qcow2` uzantılı image dosyanızı oluşturabilir, internetten bu `.qcow2` uzantılı image dosyalarını indirebilir veya benim oluşturmuş olduğum `.qcow2` image dosyalarını indirip kullanabilirsiniz:

- 👉 [qcow2 image dosyası oluşturmak için tıklayın](#)
- 👉 [Benim oluşturduğum qcow2 dosyalarını indirmek için tıklayın](#)

---

## Klasör Yapısı
- vagrant-lab-environment/
  - images/
    - kali.qcow2  
    - Windows.qcow2  
    - manjaro.qcow2  
  - Ans/
    - Vagrantfile  
    - scripts/
      - req.sh  
      - install_qemu.yml  
      - create_startup_qemu_file.yml  
      - hosts.ini  
  - Win/
    - Vagrantfile  
  - README.md
- `images` klasörü altında, bizim Windows sanal makinesi üzerinden başlatacağımız sanal makinelerin `.qcow2` uzantılı dosyaları bulunuyor. Bu klasöre, 2 sanal makinemizden de Vagrant dosya paylaşımı özelliği kullanarak bağlantı sağlayabileceğiz. Detaylara birazdan bakacağız.

- `Ans` klasörü altında, `Vagrantfile` dosyamız ve `scripts` klasörümüz bulunuyor. `scripts` klasörü içerisinde `req.sh`, `install_qemu.yml`, `create_startup_qemu_file.yml` dosyalarımız mevcut.

  - `req.sh` dosyamız, terminal ile bu klasör altındayken `vagrant up` dediğimizde, `"gusztavvargadr/ubuntu-desktop-2204-lts"` box'unu indirip, providerımıza yükleyecek. Ardından otomatik olarak makineyi başlatacak. Makine başlarken, `images` klasörüne ve `scripts` klasörüne erişim sağlayacak.
  - Bu dosya, öncelikle sanal Linux makinemize Ansible yükleyecek. Ardından sırasıyla `install_qemu.yml` ve `create_startup_qemu_file.yml` dosyaları çalıştıracak.
  - `install_qemu.yml` dosyamız, hedef sunucumuza internetten QEMU indirip yüklememize olanak sağlıyor ve sanal makinemiz içerisinde Hyper-V etkinleştiriyor.
  - `create_startup_qemu_file.yml` dosyamız ise `images` klasörü içerisindeki dosyaların adını okuyor, bu yolu kullanarak sanal Windows içerisinde sanal makine sayımız kadar betik dosyası oluşturuyor. Ardından aynı sayıda `.bat` dosyası oluşturarak bu dosyaları startup içerisine yerleştiriyor.
  - Bu sayede Windows sanal makinemiz her yeniden başlatıldığında bu `.bat` dosyası, sanal makineleri başlatacak olan betiği çalıştıracak ve sanal makinelerimiz QEMU ve WHPX ile ayağa kaldırılmış olacak.

- Windows makinemizde `vagrant up` yaptığımız zaman ise, otomatik olarak statik bir IP adresi alacak ve makineye Ansible yönetimi için `winrm` yüklenecek.

---

## Yapılması Gerekenler

1. ✅ Öncelikle repoyu sisteminize indirin  
2. 📦 `images` klasörüne başlatılmasını istediğiniz `.qcow2` uzantılı diskleri yerleştirin  
3. 🖥️ `Windows` klasörüne terminal ile erişim sağlayın  
4. 💻 Terminale `vagrant up` yazın (Gerekli pluginlerin yüklü olması gerekir. Yüklü değilse hata verebilir. [Yüklemek için tıklayın](#))  
5. 🟢 Bu sayede Windows makinemiz açılmış olacak ve `winrm` modülü de yüklenmiş olup, Ansible ile yönetime hazır hale gelecek  
6. 🖥️ Ardından `ansible` klasörüne terminal ile erişim sağlayalım  
7. 💻 Terminale `vagrant up` yazalım. Bu sayede Ansible makinemiz çalışmaya başlayacak ve tüm işlemleri gerçekleştirecek  
8. 🔄 Windows makinemiz, bu işlemden sonra otomatik olarak yeniden başlatılacak. Açıldığında ise sanal makinelerin QEMU ile çalıştığını göreceksiniz  

---

## Test Aşamalarına Erişmek İçin:

- 🧪 Bare Metal Debian  
- 🧪 Bu testi VMware ile gerçekleştirmek için  
- 🧪 Bu testi Hyper-V ile gerçekleştirmek için  
- 🧪 Bu testi Libvirt ile gerçekleştirmek için  
