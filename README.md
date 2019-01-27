# borg-snapshot
[borg](https://www.borgbackup.org/) is a modern backup solution. Its features include e.g.:
 * encryption
 * block based deduplication
 * server with append only mode
 *

borg is a command line tool configured with parameters and environment variables. [Setting it up](https://borgbackup.readthedocs.io/en/stable/) to regularly create backups, usually means writing some scripts. This is where borg-snapshot steps in to help.

borg-snapshots lets you setup a client server backup solution creating backups every hour. It will backup almost your entire root file system. However some big cache files are excluded (see [borg-snapshot-create.sh](borg-snapshot-create.sh)). It uses the one file system option, so every other filesystem will be excluded.

I use it to backup my servers and desktops.


## Installation
### Server
Borg uses ssh to securely connect to the server. borg-snapshot uses a ssh key and the ```authorized_keys``` file to restrict the clients permissions on the server. In fact the clients backup key is only allowed to do backups. So it is essential to disable password logins on the backup server via ssh. E.g. by:
```
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
systemctl restart ssh.service
```
It is necessary to install borg on the server and on the client. As I run debian stable, I did it with:
```
apt install borgbackup -t stretch-backports
```

### Clients
No further tasks need to be done on the server.
After installing borg on the client, too. One needs to clone borg-snapshot's repository only on the client:

```
git clone git@github.com:BenSartor/borg-snapshot.git
cd borg-snapshot
```

Create a config file containing a server and a password for the backups.
```
cat <<EOF > borg-snapshot-settings
#!/bin/sh

BORG_PASSPHRASE="n0t5ecure"
SERVER=backup.example.org
EOF
```

As we want to backup the root file system, we need to start the backup as root.
A root login to the backup is only needed for initialisation. The following script will create a ssh key (```/root/.ssh/id_borg-snapshot_ed25519```).
After that it will create a user on the backup server, assign the ssh key to it and restrict it to borg backup.
```
sudo ./borg-snapshot-init.sh
```

Now it is time to create your first backup. This might take some time.
```
sudo ./borg-snapshot-create.sh
```

Using cron to regularly invoke the backup script is pretty easy but using systemd timers is much more flexible and includes an awesome logging solution. The following script will create a systemd timer.
```
sudo ./borg-snapshot-create-systemd-timer.sh
```
The next backup will start in 30 seconds. You may watch it with:
```
journalctl -f -u borg-snapshot.service
```

```borg-snapshot.sh``` is a simple wrapper around borg, setting up everything to use your remote backup repository. You may use it with the parameters of the borg executable. E.g. the following command lists your backups.
```
sudo ./borg-snapshot.sh list
```

In order to restore files from your backup, you need to mount it.
```
sudo ./borg-snapshot-mount.sh
```
You may umount it like this:
```
borg umount /media/backup
```

## Deinstallation
If for any reason you want to remove your backup again, you may use the following script. It will remove everything created, including your backups, the backup user on the server, the systemd timer and borg-snapshot's ssh key.
```
sudo ./borg-snapshot-delete.sh
```
