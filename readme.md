# Lab Ortamına Hoş Geldiniz 

Bu repoda üç farklı provider kullanarak sanal makine tabanlı bir test ortamı kuracağız.

## Kullanılan Providerlar:
  - **Libvirt**
  - **VMware**
  - **Hyper-V**

## Gerekli Uygulama ve Eklentiler:
  - Vagrant 2.4.5  
  - Vagrant VMware Plugin  
  - Vagrant Libvirt Plugin  
  - Vagrant Hyper-V Plugin  

## Kullanılan Fiziksel (Bare Metal) İşletim Sistemleri:
  - Debian 10 KDE Plasma  
  - Windows 10  
  - Windows 11  

---

## Test Ortamında Kullanılan Sanal Makineler

###  Virtual Windows 11  
  Bu sanal makine Ansible ile yönetilecek. Manuel müdahale olmadan, gerekli tüm uygulamalar kurulacak ve yapılandırmalar ansible sanal makinesi tarafından otomatik olarak yapılacak.

###  Virtual Linux for Ansible  
  Bu sanal makine, Ansible kontrol düğümü (sidecar) olarak kullanılacak. Windows makinesine gerekli yazılımları yükleyip yapılandırmaları uzaktan gerçekleştirecek. Ayrıca istenirse OpenVPN TAP sunucusu da kurulabilir.

---

## Test İçin Hazırlıklar

  Test senaryosunun çalışabilmesi için `.qcow2` formatında bazı sanal disk imajlarına ihtiyaç duyulmaktadır. Bu imajlar sayesinde hazır sistemler üzerinden hızlıca işlem yapılabilir. Testlerin amacı kurulum değil, yapılandırma ve otomatikleştirme olduğundan, kurulu makineler tercih edilmiştir.

  Bu sayede zaman kaybı önlenir ve gerçek sistemlere zarar verme riski ortadan kalkar, çünkü disk bölümlendirme işlemleri sanal ortamda yapılır.

`.qcow2` uzantılı disk imajlarını şu şekillerde temin edebilirsiniz:

  -  [qcow2 image oluşturma rehberi](#)
  -  [Hazır qcow2 dosyalarını indirmek için tıklayın](#)

---

##  Klasör Yapısı

    ```
    vagrant-lab-environment/
    ├── images/
    │   ├── kali.qcow2
    │   ├── Windows.qcow2
    │   └── manjaro.qcow2
    ├── Ans/
    │   ├── Vagrantfile
    │   └── scripts/
    │       ├── req.sh
    │       ├── install_qemu.yml
    │       ├── create_startup_qemu_file.yml
    │       └── hosts.ini
    ├── Win/
    │   └── Vagrantfile
    └── README.md
    ```

### Açıklamalar:

  - `images/` klasörü, Windows sanal makinesi üzerinden başlatılacak sanal makinelerin `.qcow2` uzantılı disk dosyalarını içerir. Hem Windows hem de Linux sanal makineleri bu klasöre dosya paylaşımı yoluyla erişebilir.
  
  - `Ans/` klasörü Ansible kontrol makinesine ait dosyaları içerir:
    - `Vagrantfile`: Ubuntu tabanlı sanal makineyi başlatır.
    - `scripts/req.sh`: `vagrant up` ile otomatik çalışır, Ansible kurulumu yapar ve diğer adımları tetikler.
    - `install_qemu.yml`: Hedef (Windows) makineye QEMU ve gerekli sanallaştırma özelliklerini yükler.
    - `create_startup_qemu_file.yml`: `images/` klasöründeki her disk için otomatik `.bat` dosyaları oluşturur ve Windows’un başlangıcına ekler. Böylece Windows her açıldığında ilgili sanal makineler de otomatik başlatılır.
  
  - `Win/` klasörü Windows sanal makinesini başlatmak için gereken `Vagrantfile`’ı içerir. Bu dosya:
    - Statik IP adresi atar,
    - WinRM servisini etkinleştirerek Ansible ile yönetilebilir hale getirir.
  
  ---

## Kurulum ve Çalıştırma Adımları

  1.  Repoyu sisteminize klonlayın  
  2.  `images/` klasörüne kullanmak istediğiniz `.qcow2` disk dosyalarını yerleştirin  
  3.  `Win/` klasöründe terminal açın  
  4.  `vagrant up` komutunu çalıştırın  
     > *Gerekli Vagrant eklentileri yüklü değilse hata alırsınız. Gerekirse [buraya tıklayarak](#) yükleyin*  
  5.  Windows sanal makinesi başlatılacak ve otomatik olarak yapılandırılacaktır  
  6.  Ardından `Ans/` klasörüne geçin  
  7.  `vagrant up` komutunu burada da çalıştırın  
     > Bu adım, Ansible kontrol makinesini başlatır ve otomatik işlemleri tetikler  
  8.  İşlem tamamlandığında, Windows sanal makinesi yeniden başlatılacak ve `.qcow2` disklerden sanal makineler otomatik olarak çalışacaktır  

---

## Bare Metal Debian İçin Test Ortamını Sağlayan Sistemler
 
  -  VMware ile test gerçekleştirmek için tıklayın  
  -  Hyper-V ile test gerçekleştirmek için tıklayın  
  -  Libvirt ile test gerçekleştirmek için tıklayın
