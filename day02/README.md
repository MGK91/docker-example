# Ansible Example

This project demonstrates the use of Ansible ad-hoc commands to manage remote Linux servers using a simple inventory file (`host.ini`). It covers basic connectivity checks, package installation, file manipulation, service management, and user/group administration.

---

## 📂 Inventory File (`host.ini`)

```ini
[web]
webserver1 ansible_host=<IP_ADDRESS> ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/key.pem

[app]
appserver1 ansible_host=<IP_ADDRESS> ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/key.pem
```

> Replace `<IP_ADDRESS>` and SSH details with actual server information.

---

## 🔍 Basic Connectivity

```bash
ansible all -m ping -i host.ini
```

---

## 📈 System Info

```bash
# Uptime
ansible all -a "uptime" -i host.ini
ansible app -a "uptime" -i host.ini

# Check Python
ansible app -a "which python" -i host.ini
ansible app -a "which python3" -i host.ini

# Check Java processes
ansible app -a "ps -ef | grep java" -i host.ini
```

---

## 📦 Package Installation

```bash
# Install NGINX on web servers
ansible web -m yum -a "name=nginx state=present" -b -i host.ini

# Install Java and Tomcat on app servers
ansible app -m yum -a "name=java-11-openjdk-devel state=present" -b -i host.ini
ansible app -m yum -a "name=tomcat state=present" -b -i host.ini
```

---

## 📁 File & Directory Operations

```bash
# Create directory
ansible app -a "mkdir -p /var/www/html" -i host.ini
ansible web -a "mkdir -p /var/www/html" -b -i host.ini

# Copy index.html to web servers
ansible web -m copy -a "src=./index.html dest=/var/www/html" -b -i host.ini
ansible web -m copy -a "src=./index.html dest=/var/www/html owner=ec2-user group=ec2-user mode=0644" -b -i host.ini
ansible web -m copy -a "src=./index.html dest=/var/www/html owner=nginx group=nginx mode=0644" -b -i host.ini

# Remove file
ansible web -a "rm -rf /var/www/html/index.html" -b -i host.ini

# Fetch file from web servers
ansible web -m fetch -a "src=/var/www/html/index.html dest=./" -b -i host.ini
```

---

## 🔄 Service Management

```bash
# Restart NGINX
ansible web -m service -a "name=nginx state=restarted" -b -i host.ini
```

---

## 👥 User & Group Management

```bash
# Create nginx group and user
ansible web -m group -a "name=nginx state=present" -b -i host.ini
ansible web -m user -a "name=nginx group=nginx shell=/bin/bash state=present" -b -i host.ini

# Verify nginx user
ansible web -a "id nginx" -b -i host.ini
```

---

## ✅ Tips

- Use `-b` (become) when the task needs elevated privileges (e.g., installing packages).
- You can convert these ad-hoc commands into Ansible Playbooks for reusability and version control.

---

## 📚 Resources

- [Ansible Docs](https://docs.ansible.com/)
- [Ad-Hoc Commands](https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html)
