1. **Starting the Windows Machine:**
   - Access the `win` folder using the terminal:
     ```
     cd win
     ```
   - Then, execute the following command:
     ```
     vagrant up
     ```
   - This will start your Windows machine. Via the Vagrantfile, as soon as your Windows machine starts, it will automatically run a `ps1` file to make it manageable via Ansible.

2. **Starting the Ansible Machine:**
   - Access the `ans` folder using the terminal:
     ```
     cd ans
     ```
   - Then, execute the following command:
     ```
     vagrant up
     ```
   - This will start your Ansible machine. Upon startup, it will sequentially execute the commands in the `commands.sh` file, install the latest version of QEMU on your Windows machine, and set up the necessary startup configurations for the virtual machine to launch.

3. **Testing the Environment:**
   - After a successful installation, you can test your virtual environment.

4. **Configuring IP Addresses:**
   - If you want to use a different IP address configuration while managing your server, update the static IP addresses in the Vagrantfiles according to your preferences. 
   - Don't forget to update the IP address in the `hosts.ini` file as well.
