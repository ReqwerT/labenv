
# Windows Disk Imaging with QEMU and Clonezilla on Debian

This guide explains how to take an image of a Windows disk and save it to a USB stick using QEMU and Clonezilla on a Debian system.

---

## 🔧 1. Authorization and Setup

### Add your user to the sudo group:
```bash
sudo usermod -aG sudo reqwert
```

### Install virtualization packages:
```bash
sudo apt install qemu-system qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
```

### Verify the installation:
```bash
kvm --version
virt-manager
```

### Add user to libvirt and kvm groups:
```bash
sudo usermod -aG libvirt reqwert
sudo usermod -aG kvm reqwert
```

---

## 💻 2. KDE Plasma Desktop Installation (Optional)
```bash
sudo apt install plasma-desktop
```

---

## 📥 3. Download Clonezilla ISO

[https://clonezilla.org/clonezilla-live.php](https://clonezilla.org/clonezilla-live.php)

---

## 💾 4. Check Disks

### List connected disks:
```bash
lsblk
```

### View disk details:
```bash
sudo fdisk -l
```

---

## 🚀 5. Start Clonezilla via QEMU

```bash
qemu-system-x86_64 -enable-kvm -m 4096 -smp 4 -boot d -cdrom path/your/clonezilla.iso -drive file=/dev/nvme0n1,format=raw,if=virtio -drive file=/dev/sda,format=raw,if=virtio -vga virtio
```

---

## 🧩 6. Clonezilla Imaging Steps

- Start Clonezilla Live (VGA)
- Select language and keyboard layout
- Choose `Start Clonezilla`
- Select `device-image` → `local_dev`
- Choose your USB drive → skip fsck with `no-fsck`
- Choose `Beginner` mode → `savedisk`
- Name your image → select Windows disk
- Choose compression: `z9p`
- Choose what to do after image (e.g., shutdown)
- Confirm and start: press `Y` → `Enter`

---

## ⏳ 7. Wait

The process may take several hours depending on disk size. Be patient.

---

## ✅ Result

The image of the Windows disk will be successfully saved to the USB stick.
