---
layout: post
title: Setting up SSH on Debian in VirtualBox
---

The title says "Setting up SSH on Debian in VirtualBox" but the basic idea is the same everywhere.  I want to walk you through how I set up ssh public-key authentication on my VirtualBox dev server.  I also set up port forwarding, allowing me to access the server through the public internet, which I may cover in a later post.  First, I'll talk real quick about what ssh is and why public-key authentication is a good idea.

You will need `openssh-server` on the remote machine.

##SSH

**S**ecure **SH**ell, fittingly, is a method that allows two machines to communicate securely over a network.  I'm sure it uses algorithms and whatever to work.  

##Public key authentication

Public key authentication is a pretty simple concept that took me like a year to figure out.  You generate a public and private keypair with SSH (or something else).  When you want to communicate with someone securely, you give them your public key, and they give you theirs.  When communicating, you encrypt your message with the recepients public key.  Nobody can decrypt the message without the corresponding private key.

##Setting up ssh keys

###Generating the keys 

Type the following into a shell on the machine you want to use to connect:

`mkdir -p ~/.ssh`

`ssh keygen -t rsa`

Or if you want a DSA key:

`ssh keygen -t dsa`

It asks you to give the key file a name and save it somewhere  (the default public/private key pair  is `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`).  It also asks if you want to give your key a passphrase (you should).

Change the permissions on your keys so that they are only writeable/readable by you:

`chmod 600 ~/.ssh/id_rsa*`

###Authorizing your machine to communicate with the remote host

You need to add your public key to a file called `authorized_keys`.  This lets ssh know who to let connect.  You can `scp` your key over to the remote machine (or pscp with PuTTY):

`scp ~/.ssh/id_rsa.pub remote_machine:/home/you/.ssh`

Once the public key is on the remote machine, add it to `authorized_keys`:

`cat id_rsa.pub >> ~/.ssh/authorized_keys`

Make sure the key has actually been added to `authorized_keys`.  When you know it's in there, delete the public key:

`rm id_rsa.pub`

You should be able to access the remote machine now without a password.

###Disabling passphrase authentication and changing the default port

I also disabled passphrase authentication on my machine and changed the default port sshd listens on.  You can make a case that changing the default port doesn't really do anything to further secure yourself, but I figure why not take all practical steps.  It's not that hard.

The config files for the ssh server live in `/etc/ssh/sshd` on the remote machine.  Open up the `sshd_config` file (you might have to sudo) in an editor and uncomment the line:

`#PasswordAuthentication no`

Optionally change the Port in the same file. If you do this, it might be a good idea to change the port value in `ssh_config` on the machine you use to connect as well.  This saves you from having to specify the port every time with `ssh -p`.

 
