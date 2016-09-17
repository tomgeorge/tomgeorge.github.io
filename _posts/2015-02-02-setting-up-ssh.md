---
layout: post
title: Beating a Dead Horse&#58  Setting up SSH on Debian in VirtualBox
---

This is the first post in my "Beating a Dead Horse" series, where I make a tutorial on something that really doesn't need another tutorial.

The title says, "Setting up SSH on Debian in VirtualBox", but the basic idea is the same everywhere.  I want to walk you through how I set up ssh public-key authentication on my VirtualBox dev server.  I also set up port forwarding, allowing me to access the server through the public internet, which I may cover in a later post.

You will need `openssh-server` on the remote machine.

# Setting up ssh keys

### Generating the keys

Type the following into a shell on the machine you want to use to connect:

`mkdir -p ~/.ssh`

`ssh keygen -t rsa`

Or if you want a DSA key:

`ssh keygen -t dsa`

It asks you to give the key file a name and save it somewhere  (the default public/private key pair  is `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`).  It also asks if you want to give your key a passphrase (you should).

Change the permissions on your keys so that they are only writeable/readable by you:

`chmod 600 ~/.ssh/id_rsa*`

### Authorizing your machine to communicate with the remote host

You need to add your public key to a file called `authorized_keys`.  This lets ssh know who to let connect.  You can use the `ssh-copy-id` command to do this:

`ssh-agent bash`

`ssh-add /path/to/your/PRIVATE key (the one that doesn't end in .pub)`

It will ask for a password.

Then:

`ssh-copy-id user@host`

You should be able to access the remote machine now without a password.

### Disabling passphrase authentication and changing the default port

I also disabled passphrase authentication on my machine and changed the default port sshd listens on.  You can make a case that changing the default port doesn't really do anything to further secure yourself, but I figure why not take all practical steps.  It's not that hard.

The config files for the ssh server live in `/etc/ssh/sshd_config` on the remote machine.  Open up the `sshd_config` file (you probably have to use `sudo`) in an editor and uncomment the line:

`#PasswordAuthentication no`

Also, make sure this line is uncommented

`#PermitRootLogin no`

If the line doesn't exist, make it.

Optionally change the Port in the same file. If you do this, it might be a good idea to change the port value in `ssh_config` on the machine you use to connect as well.  This saves you from having to specify the port every time with `ssh -p`.

To see the impact of these changes, restart ssh on the remote machine:

`sudo service ssh restart`