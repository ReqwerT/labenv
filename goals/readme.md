#  Bare Metal Dual Boot Lab: OpenMediaVault Paylaşım Senaryosu

##  Genel Yapı

Bu lab ortamı, bare metal (donanım düzeyinde) kurulan çift işletim sistemli (dual boot) bir sistem üzerinde çalışır. Sistem iki ana işletim sistemi içerir:

- **Windows 11** (WHPX + QEMU ile sanal makine desteği)
- **Debian Linux** (KVM/QEMU ile sanal makine desteği)

Her iki sistem de **OpenMediaVault (OMV)** tabanlı bir SANbox sanal sunucuya bağlanır. Bu sunucu, dosya paylaşım hizmetlerini merkezi olarak sunar.

##  Disk Yapısı ve Bölümler

Toplam disk kapasitesi: `100 GB`

| Bölüm           | Boyut  | Açıklama                                               |
|------------------|--------|---------------------------------------------------------|
| Windows (NTFS)   | 30 GB  | Windows işletim sistemi için ayrılan bölüm              |
| Linux (ext4)     | 20 GB  | Debian işletim sistemi için ayrılan bölüm               |
| SANbox (exFAT)   | 50 GB  | OMV sanal makinesini barındıran disk alanı (qcow2 dahil)|

> Windows’a 7 GB kurulum + 23 GB boşluk olacak şekilde 30 GB ayrılır. Kalan 70 GB:
> - 20 GB Linux
> - 50 GB SANbox

##  SANbox (OpenMediaVault) Sanal Makinesi

- Format: `qcow2`
- Depolama: `SANbox` bölümü içerisinde
- Disk formatı: `exFAT` (hem Linux hem Windows tarafından yazılabilir)
- İşletim sistemi: `OpenMediaVault` (NAS platformu)

##  Dual Boot Davranışı

### 1. Windows Açıldığında

- Windows işletim sistemi başlatılır.
- `QEMU` + `WHPX` kullanılarak `OMV.qcow2` sanal makinesi başlatılır.
- OpenMediaVault üzerinde paylaştırılmış klasörler otomatik olarak **SMB protokolü** ile Windows’a mount edilir.
- **Linux diskindeki veriler**, OMV üzerinden erişilerek Windows tarafından kullanılabilir.

### 2. Linux Açıldığında

- Debian işletim sistemi başlatılır.
- `QEMU` + `KVM` ile `OMV.qcow2` sanal makinesi ayağa kaldırılır.
- OpenMediaVault tarafından paylaştırılan klasörler **NFS protokolü** ile mount edilir.
- **Windows diskindeki veriler**, OMV üzerinden erişilerek Linux tarafından kullanılabilir.

## Paylaşım Yöntemleri

| İşletim Sistemi | Bağlantı Teknolojisi | Paylaşım Yolu |
|------------------|------------------------|----------------|
| Windows          | WHPX + QEMU            | SMB            |
| Linux            | KVM + QEMU             | NFS            |

##  Akış Şeması

1. Sistem dual boot olacak. Diskimiz 2 defa shrink olacak. Birisi Linux, Birisi Windows ve sonuncusu SANBox için ayrılacak. Linux ve Windows disklerimiz, dual boot olacak.
2. Sanal makinemiz her açıldığında, bize windows mu yoksa linux mu seçmek istediğimizi soracak.
3. Ardından seçilen işletim sistemi, exFAT formatlı SANbox diskine erişecek.
4. SANBox diski içerisindeki `OMV.qcow2` imaj dosyamızı, qemu ve gerekli hızlandırı kullanarak çalıştıracak (Windows için whpx, linux için kvm).
5. OMV sanal NAS, dosya paylaşım protokolleri üzerinden diğer işletim sistemlerinin paylaşılan klasörlerini sunacak. Bu sayede windows içerisinden, linuxtaki verilere erişebilirken, linux içerisinden windows içerisindeki verilere erişebileceğiz ve değişiklik yapabileceğiz.
6. Linux dosya paylaşımı için NFS kullanırken, windows dosya paylaşımı için SMB kullanacağız.

##  Notlar

- `exFAT` dosya sistemi sayesinde hem Windows hem de Linux, SANbox diskini okuyabilecek ve bu diske veri yazabilecek.
- OMV sanal makinesi dosya paylaşımını yöneterek sistemler arası veri bütünlüğünü sağlayacak.
- Yazılan yml dosyası ile ansible kulanılarak, sanal windows diskimiz üzerinde otomatik biçimde shrink işlemlerini yapabileceğiz.

---

