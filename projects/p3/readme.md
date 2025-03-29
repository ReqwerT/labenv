# README.md

## Deploying Ansible Playbook to Ubuntu 22.04 VM

After running `vagrant up` and successfully starting the virtual machine, you need to transfer the necessary `.yml` Ansible playbook files into the Ubuntu 22.04 VM. There are two main ways to achieve this:

---

### Method 1: Using `scp` to Transfer Files

You can securely copy the Ansible playbook files from your host machine to the virtual machine using `scp` (secure copy).

#### Step-by-Step Instructions

1. **Find the IP and Credentials of the VM**  
   If you’re using Vagrant with a default `Vagrantfile`, the VM is typically accessible via SSH with:

   ```bash
   vagrant ssh-config
   ```

   Note the values for `HostName`, `Port`, `User`, and `IdentityFile`.

2. **Use `scp` to transfer files**  
   From your host machine, run:

   ```bash
   scp -i /path/to/private_key -P PORT_NUMBER your_playbook.yml USER@HOST:/home/USER/
   ```

   Example:

   ```bash
   scp -i ~/.vagrant.d/insecure_private_key -P 2222 qemu-setup.yml vagrant@127.0.0.1:/home/vagrant/
   ```

3. **Verify file is in the VM**  
   SSH into the VM:

   ```bash
   vagrant ssh
   ```

   Then check:

   ```bash
   ls -l /home/vagrant/
   ```

---

### Method 2: Manually Create the YAML Files Inside the VM

If you prefer, you can manually create the Ansible playbook inside the virtual machine.

#### Step-by-Step Instructions

1. **SSH into the VM**

   ```bash
   vagrant ssh
   ```

2. **Open a text editor and create the file**

   For example, using `nano`:

   ```bash
   nano ~/qemu-setup.yml
   ```

3. **Paste the playbook content**  
   Copy the entire YAML content from your host machine and paste it into the open nano window.

4. **Save and exit**

   - Press `CTRL + O` to save.
   - Press `ENTER` to confirm the filename.
   - Press `CTRL + X` to exit the editor.

---

### Running the Playbook

Once the file is inside the VM, you can run the playbook using Ansible:

```bash
ansible-playbook qemu-setup.yml -i hosts.ini
```

> ⚠️ Make sure Ansible is installed inside your VM and that the inventory file is correctly configured.

---

### Notes

- Replace filenames and usernames as needed.
- If you plan to automate the deployment, `scp` is faster and scriptable.
- Manual creation is useful when network access is restricted or copy-paste is more convenient.
- This setup is intended for Ubuntu 22.04 guests.

---

Happy provisioning! 🚀
