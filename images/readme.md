## .qcow2 Image Dosyası Paylaşımı

Bu klasöre, açmak istediğiniz `.qcow2` uzantılı image dosyalarınızı yüklemeniz gerekiyor.

Ansible makinemiz, bu klasöre erişim sağlayarak dosya adını okuyacak ve bu dosya adı ile bir script oluşturup, **Windows sanal makinemizde otomatik açılış** sağlayacak.

> Klasör senkronizasyonu, `Vagrantfile` dosyamızda, aşağıdaki komut ile sağlanıyor.:

```ruby
 config.vm.synced_folder File.expand_path("../images", __dir__), "/home/vagrant/shared_images", type: "rsync"

```

Bu sayede `../images` klasörümüz, Ansible makinemizde `/home/vagrant/shared_images` klasöründe görünüyor.
