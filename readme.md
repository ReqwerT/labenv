# Welcome to My Lab Environment

In this repo we will set up a test environment on a virtual machine base using three different providers.

## Using Providers:
  - **Libvirt**
  - **VMware**
  - **Hyper-V**

## Required Applications and Plugins:
    - Vagrant 2.4.5  
    - Vagrant VMware Plugin  
    - Vagrant Libvirt Plugin  
    - Vagrant Hyper-V Plugin  

## Using Bare Metal Operating Systems:
    - Debian 10 KDE Plasma  
    - Windows 10  
    - Windows 11  

---

## Virtual Machines Used in The Test Environment

###  Virtual Windows 11  
  This virtual machine will be managed with Ansible. Without manual intervention, all necessary applications will be installed and configurations will be done automatically by the ansible virtual machine.

###  Virtual Linux for Ansible  
  This virtual machine will be used as an Ansible control node (sidecar). It will install the necessary software on the Windows machine and perform the configurations remotely. Additionally, an OpenVPN TAP server can be installed if desired.

---

## Preparations for the Test
  In order for the test scenario to work, some virtual disk images in `.qcow2` format are needed. With these images, operations can be performed quickly on ready systems. Since the purpose of the tests is not installation, but configuration and automation, installed machines were preferred.

  In this way, time loss is prevented and the risk of damaging real systems is eliminated, because disk partitioning operations are performed in a virtual environment.

`.qcow2` uzantılı disk imajlarını şu şekillerde temin edebilirsiniz:

     - [qcow2 image creation guide](#)
     - [Click to download ready qcow2 files](#)

---

##  Folder Structure

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

### Remarks:
  - The `images/` folder contains the disk files with the `.qcow2` extension of the virtual machines that will be launched via the Windows virtual machine. Both Windows and Linux virtual machines can access this folder via file sharing.
  
  - The `Ans/` folder contains the files belonging to the Ansible control machine:
  - `Vagrantfile`: Starts the Ubuntu-based virtual machine.
  - `scripts/req.sh`: Automatically runs with `vagrant up`, installs Ansible and triggers other steps.
  - `install_qemu.yml`: Installs QEMU and necessary virtualization features on the target (Windows) machine.
  - `create_startup_qemu_file.yml`: Creates automatic `.bat` files for each disk in the `images/` folder and adds them to the Windows startup. Thus, the relevant virtual machines are automatically started every time Windows is started.
  - `Win/` klasörü Windows sanal makinesini başlatmak için gereken `Vagrantfile`’ı içerir. Bu dosya:
     - Assigns a static IP address,
     - Enables the WinRM service and makes it manageable with Ansible.

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
