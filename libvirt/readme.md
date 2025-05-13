## Vagrant + Libvirt Test Ortamı

Bu proje, **bare-metal Debian** üzerinde **Vagrant** ve **libvirt/qemu-kvm** kullanarak otomatik sanal makine kurulum ve yapılandırma işlemlerini gerçekleştirir.

## Amaç

İki sanal makine oluşturacağız:

- **Windows 11** VM (ana hedef)
- **Ubuntu 22.04 (Ansible kontrol birimi - sidecar)**

Ana hedef, Windows 11 sanal makinesinin her açılışında, içinde WHPX ile hızlandırılmış başka sanal makinelerin otomatik olarak başlatılmasını sağlayacak.

## Sidecar Nedir?

"Sidecar", esas birimin yanında çalışan ve onu destekleyen yardımcı kontrol birimi anlamına gelir. Burada Ubuntu 22.04 Ansible VM, Windows makinemizi uzaktan yönetmek için bir sidecar görevi görmektedir.

---

## Yapılandırma Akışı

### Windows 11 Sanal Makinesi:

- Statik IP: `192.168.121.15`
- İlk açılışta, aşağıdaki PowerShell betiğini otomatik indiriyor ve otomatik olarak çalıştırıyor:  
  [`ConfigureRemotingForAnsible.ps1`](https://raw.githubusercontent.com/ansible/ansible-documentation/devel/examples/scripts/ConfigureRemotingForAnsible.ps1)
- Böylece, uzaktan Ansible ile yönetilebilir hâle gelir.

### Ubuntu Ansible Sidecar VM:

- Başlangıçta `req.sh` betiği ile gerekli paketleri yüklüyor.
- `hosts.ini` dosyasındaki hedef Windows IP’sine göre işlem yapıyor.
- Ardından şu Ansible playbook'lar çalıştırılıyor:

#### install_qemu.yml

- Hedef makineye sessizce QEMU indirir ve yükler.
- Hedef makinede, gerekli sanallaştırma özelliklerini aktif eder.
- QEMU için Sistem PATH ayarlanır.
- En sonunda sistemi yeniden başlatır.

####  start_vm.yml

- `images/` dizinindeki tüm `.qcow2` disk dosyalarını, isimlerini öğrenmek için tarıyor.
- Her biri için ismi ile birlikte `.ps1` başlatıcı script'leri hazırlıyor.
- Bunları çağıran `.bat` dosyaları oluşturuyor.
- Otomatik olarak Windows başlangıç klasörüne ekleniyor ve bu sayede windows her açıldığında, bu sanal makineler de çalışıyor.

---

## Uygulama Adımları

1. Öncelikle `images/` klasörüne `.qcow2` uzantılı disklerimizi yerleştirelim.
2. Ardından `win11/` dizinine terminal üzerinden gidelim:

   ```bash
   cd win11
   vagrant up
   ```

3. Windows makinesi açıldığında, Ansible için gerekli ortam otomatik hazırlanmış oluyor.
4. Daha sonra `ansible/` dizinine geçelim:

   ```bash
   cd ../ansible
   vagrant up
   ```

5. Ansible makinesi açılırken:
   - WinRM ve ansible otomatik olarak kurulur,
   - Hedef makinemiz üzerinde QEMU’yu kuruyor ve yapılandırıyor,
   - Hedef makinemizde WHPX etkinleştiriyor,
   - Windows’u yeniden başlatıyor,
   - Ardından WHPX destekli sanal makineler otomatik olarak başlıyor.
---

## Kullanılan Vagrant Box'lar

| VM Rolü      | Vagrant Box                 |
|--------------|-----------------------------|
| Ansible VM   | `[generic-x64/ubuntu2204](https://portal.cloud.hashicorp.com/vagrant/discover/generic-x64/ubuntu2204)`    |
| Windows VM   | `[tonyclemmey/windows11](https://portal.cloud.hashicorp.com/vagrant/discover/tonyclemmey/windows11)`     |

---

## QEMU Sanal Makinelerinin Özellikleri

Windows 11 VM içerisinde, aşağıdaki komutla QEMU sanal makineleri çalıştırılır:

```powershell
qemu-system-x86_64 `
    -accel whpx `
    -m 4096 `
    -drive file="C:\Users\vagrant\shared_f\{{ item }}",format=qcow2,if=virtio `
    -netdev user,id=net0 `
    -device virtio-net,netdev=net0 `
    -boot c
```

Bu komut, her `.qcow2` dosyası için otomatik hazırlanır ve Windows başlangıcında çalışacak şekilde ayarlanır.

---

## Sonuç

Bu yapı sayesinde:

- Vagrant ile iki sanal makine otomatik olarak kuruldu .
- Windows makinesi, uzaktan yönetim için hazırlandı.
- WHPX destekli QEMU makineleri, Sanal Windows her açıldığında otomatik başlatıyor.

