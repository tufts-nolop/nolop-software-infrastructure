### Installing Ansible on WSL2
```
sudo apt update
sudo apt install python3-pip
pip install ansible --user
```
On Linux Mint, can also pull from repos.

```
sudo apt update
sudo apt install ansible
```

### Running some tasks ###

```
cd nolop-software-infrastructure
ansible-playbook -i ansible-inventory.ini printer-tasks.yaml
```

Also useful

```
ansible -i ansible-inventory.ini --list-hosts printers
ansible -i ansible-inventory.ini -u pi -m ping printers
```
