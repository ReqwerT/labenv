# Setting Up WinRM for Ansible on Windows Machines

## Step 1: Install WinRM on Windows

WinRM is a feature introduced with Windows Vista that allows management scripts to run remotely. To set it up, we need to download a `.ps1` file from a GitHub repository and run it using PowerShell. The name of the script is: **“ConfigureRemotingForAnsible.ps1”**.

Repository: [ConfigureRemotingForAnsible.ps1](https://github.com/ansible/ansible-documentation/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1)

After running this file on our Windows device, we are greeted with a screen indicating successful setup. 

> **Note:** The `win_psexec` module can help you enable WinRM on multiple machines if you have many Windows hosts to set up in your environment.

Additionally, you need to have Python installed on your system. You can download it from the Microsoft Store. In this setup, Python 3.10.11 was used.

---

## Step 2: Install Pywinrm
On the machine where Ansible is installed, run the following command to install Pywinrm:

```bash
pip install pywinrm
```

---

## Step 3: Preparing the Inventory File

To properly connect to your Windows host machine, you need to create a correctly formatted inventory file. Include `ansible_connection=winrm` because the connection will be established via WinRM. Below is an example of a properly formatted inventory file:

```ini
[win]
172.16.2.5
172.16.2.6

[win:vars]
ansible_user=vagrant
ansible_password=password
ansible_connection=winrm
ansible_winrm_server_cert_validation=ignore
```

---

## Step 4: Connection Test
To test the connection, use the following command:

```bash
ansible [host_group_name_in_inventory_file] -i hosts -m win_ping
```

When you run the above command on the virtual machine where Ansible is installed (after configuring the settings according to your environment), it will attempt to establish a test connection. If the connection is successful, it means the process has completed successfully and your Ansible machine is communicating with the target machine without any issues.


---

## Additional Information
Now, by writing `.yml` files on the machine where Ansible is installed, creating an `.ini` inventory file, and providing the necessary configurations, you can successfully manage your Windows machine.

### Resources
- [Red Hat Blog - Connecting to a Windows Host](https://www.redhat.com/en/blog/connecting-to-a-windows-host)

---
