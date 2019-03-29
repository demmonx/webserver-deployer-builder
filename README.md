# Auto-deploy manager for a LEMP server ( deployement with Ansible / Vagrant profile) - Builder

## Background

Vagrant and VirtualBox are used to quickly build or rebuild virtual servers.

Those scripts use Vagrant profile to deploy a new server and install Nginx, PostgreSQL, SMTP and PHP using the [Ansible](http://www.ansible.com/) provisioner.

It's based on `https://github.com/demmonx/webserver-deployer` standalone project, and provide tools to generate `.deb` and `.rpm` without modifiying any line of the initial project.

## Getting Started
If you don't want to think too much, just download the installer :
```
Ubuntu / Debian : 
    wget https://github.com/demmonx/webserver-deployer/release/webserver-deployer.deb
    sudo dpkg -i webserver-deployer.deb
```
```
RedHat / CentOS / Fedora : 
    wget https://github.com/demmonx/webserver-deployer/release/webserver-deployer.rpm
    sudo yum install -y webserver-deployer.rpm
```

OR 

If you need to edit some sources : 
  1. Clone the current repo with submodules : `git clone --recurse-submodules https://github.com/demmonx/webserver-deployer`
  2. Run `./debian-build` or `./redhat-build` to generate `deb` or `rpm` 
  3. Run `cd releases` and next :
     1. Debian / Ubuntu : ` sudo dpkg -i webserver-deployer.deb`
     2. RedHat / CentOS / Fedora : `sudo yum install -y webserver-deployer.rpm`


## CLI interface

You can run directly `webserver-deployer` or use modules `webserver-deployer-<module>`, tape `webserver-deployer help` to show availables commands.

| Command | Description | Status
| --- | --- | --- |
| `webserver-deployer create` | Create a config file by asking the user | Working
| `webserver-deployer deploy <file1> [<file2> ...]` | Deploy new VMs | VM deployed, package installed but not configured -> debug needed
| `webserver-deployer stop <name1> [<name2> ...]` | Halt VMs | Working
| `webserver-deployer start <name1> [<name2> ...]` | Start VMs | Working
| `webserver-deployer update` | Update installed VMs | Working
| `webserver-deployer list` | List installed VMs | Working
| `sudo env "HOME=$HOME" webserver-deployer update-hosts` | Update /etc/hosts (as root) | Working
| `webserver-deployer remove <name1> [<name2> ...]` | Delete VMs | Working
| `webserver-deployer help` | Show available commands | Working

### Deploy new VMs
VM config **must be described in a yml file**. As least IP and name should be set, others fields are optionnals. 

Next run : `webserver-deployer deploy <file1> [<file2> ...]`

### Update hosts file (root only)
Update `/etc/hosts` to match existing VM and delete old VMs, in order to access them by using `http://{server name}/` instead of `http://{ip}/`wl, same for SSH (password = `vargant`)
You need to be root in order to run this command : 
`sudo env "HOME=$HOME" webserver-deployer update-hosts`

### Delete VMs 
You could delete on or more VMs using : 
`webserver-deployer-delete <name1> [<name2> ...]`
The VMs are stopped (if they are running) and next deleted from disk. They are removed from list of active VM (cannot update after delete) and added to list of removed host (they should be remove on `/etc/hosts` after next `webserver-deployer update-hosts`)

## Examples
See `example` folder to see all
### Machine configuration
```
machine:
  name: toto
  ram: [your-pass]
  cpu: 2 
  ip: 192.168.2.3

smtp:
  host: stmp.gmail.com
  user: [your-username]
  pass: [your-pass]

git:
  repo: [some git repo]

db:
  name: [db name]
  user: [db user name, granted on db]
  passwd: [db user password]
```

## Licence
MIT license
