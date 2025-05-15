Öncelikle sanal switch oluşturulması laızm:

Terminal i yönetici olarak açalım:
1-)New-VMSwitch -SwitchName "VagrantSwitch" -SwitchType Internal
2-)New-NetIPAddress -IPAddress 192.168.121.1 -PrefixLength 24 -InterfaceAlias "vEthernet (VagrantSwitch)"



Yukarıdaki komutlar sayesinde hyper-v üzerinde sanal switch açabiliriz ve vagrant ile sanal makine çalıştırırken istediğimiz static ip yi verebiliriz.
