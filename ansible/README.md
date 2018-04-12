# prerequistes

(on your laptop)

* install ansible on your laptop
    - [on windows][1]
    - [on Linux][2]
    - [on MacOS X][3]
* `ansible-galaxy install -r requirements.yml`

https://galaxy.ansible.com/geerlingguy/security/
https://galaxy.ansible.com/franklinkim/sudo/


* mettre à jour `inventory` (nouvelle section env)
* `ansible-playbook -i inventory -u root -s --limit ENVXXX playbook-init.yml`
* `ansible-playbook -i inventory -u root -s --limit ENVXXX playbook-security.yml`

[1]: https://www.jeffgeerling.com/blog/2017/using-ansible-through-windows-10s-subsystem-linux
[2]: http://docs.ansible.com/ansible/latest/intro_installation.html#installing-the-control-machine
[3]: http://docs.ansible.com/ansible/latest/intro_installation.html#latest-releases-on-mac-osx
