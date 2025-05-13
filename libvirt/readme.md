# 🧪 Vagrant + Libvirt Test Ortamı

Bu proje, **bare-metal Debian** üzerinde **Vagrant** ve **libvirt/qemu-kvm** kullanarak otomatik sanal makine kurulum ve yapılandırma işlemlerini gerçekleştirir.

##Amaç

İki sanal makine oluşturulacaktır:

- **Windows 11** VM (ana hedef)
- **Ubuntu 22.04 (Ansible kontrol birimi - sidecar)**

Ana hedef, Windows 11 sanal makinesinin her açılışında, içinde WHPX ile hızlandırılmış başka sanal makinelerin otomatik olarak başlatılmasını sağlamaktır.

## Sidecar Nedir?

"Sidecar", esas birimin yanında çalışan ve onu destekleyen yardımcı kontrol birimi anlamına gelir. Burada Ubuntu 22.04 Ansible VM, Windows makinemizi uzaktan yönetmek için bir sidecar görevi görmektedir.

---

## Yapılandırma Akışı

### Windows 11 Sanal Makinesi:

- Statik IP: `192.168.121.15`
- İlk açılışta, aşağıdaki PowerShell betiğini otomatik indirir ve çalıştırır:  
  [`ConfigureRemotingForAnsible.ps1`](https://raw.githubusercontent.com/ansible/ansible-documentation/devel/examples/scripts/ConfigureRemotingForAnsible.ps1)
- Böylece, uzaktan Ansible ile yönetilebilir hâle gelir.

### Ubuntu Ansible Sidecar VM:

- Başlangıçta `req.sh` betiği ile gerekli paketler yüklenir.
- `hosts.ini` dosyasındaki hedef Windows IP’sine göre işlem yapılır.
- Ardından şu Ansible playbook'lar çalıştırılır:

#### install_qemu.yml

- QEMU yüklenir.
- WHPX hızlandırıcı etkinleştirilir.
- Sistem PATH ayarlanır.
- Gerekli Windows bileşenleri açılır ve sistem yeniden başlatılır.

####  start_vm.yml

- `images/` dizinindeki tüm `.qcow2` disk dosyaları taranır.
- Her biri için özel `.ps1` başlatıcı script'leri hazırlanır.
- Bunları çağıran `.bat` dosyaları oluşturulur.
- Otomatik olarak Windows başlangıç klasörüne eklenir.

---

## Uygulama Adımları

1. `images/` klasörüne `.qcow2` uzantılı diskleri yerleştirin.
2. `win11/` dizinine terminal üzerinden girin:

   ```bash
   cd win11
   vagrant up
   ```

3. Windows makinesi açıldığında, Ansible için gerekli ortam otomatik hazırlanır.
4. Daha sonra `ansible/` dizinine geçin:

   ```bash
   cd ../ansible
   vagrant up
   ```

5. Ansible makinesi açılırken:
   - WinRM bağlantısı kurar,
   - QEMU’yu kurar ve yapılandırır,
   - WHPX etkinleştirir,
   - Windows’u yeniden başlatır,
   - Ardından WHPX destekli sanal makineler otomatik olarak başlar.

---

## Kullanılan Vagrant Box'lar

| VM Rolü      | Vagrant Box                 |
|--------------|-----------------------------|
| Ansible VM   | `generic-x64/ubuntu2204`    |
| Windows VM   | `tonyclemmey/windows11`     |

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

