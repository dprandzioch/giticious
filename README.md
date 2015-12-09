= Giticious - Maybe the most lightweight Git Server

Giticious is a Ruby CLI tool that allows you to host multiple Git repositories with User Management/Access Control
almost effortlessly.

Repositories are served through SSH using public key authentication. All you need is a Linux system serving SSH on 
port 22 and Ruby >= 2.0 as well as a separate system user to host your Git repositories.


== Installation

While Giticious should run on almost any GNU/Linux distribution, a installation script currently only exists for Ubuntu 15.04 Vivid Vervet.

=== Ubuntu 15.04 (Vivid Vervet)

Log in as a user with privileges to run commands with `sudo` and run:

```
curl -s https://raw.githubusercontent.com/dprandzioch/giticious/master/install/ubuntu-vivid.sh | bash -s
```

Then follow the instruction on the screen.


=== Other GNU/Linux distros

Just run

```
gem install giticious
```

logged in as your `git` system user and then execute

```
giticious init
``` 

Make sure that SSH is running on port 22 and allows PubkeyAuthentication.


== Usage

Usage is as easy as this:

```
$ ~ (git)-[master] % sudo gem install giticious
Fetching: i18n-0.7.0.gem (100%)
Successfully installed i18n-0.7.0
[...]
Parsing documentation for giticious-0.9.1
Installing ri documentation for giticious-0.9.1
10 gems installed

$ ~ (git)-[master] % giticious init
-- create_table(:repositories)
   -> 0.0044s
-- create_table(:users)
   -> 0.0016s
-- create_table(:permissions)
   -> 0.0012s

$ ~ (git)-[master] % giticious user create testuser
User testuser has been created!
+---+----------+
| # | Username |
+---+----------+
| 1 | testuser |
+---+----------+

$ ~ (git)-[master] % giticious pubkey add testuser "ssh-rsa mypubkey"
Public key "ssh-rsa mypubkey" for user testuser has been added!
+----------+----------------------------+
| Username | Public key (last 80 chars) |
+----------+----------------------------+
| testuser | ssh-rsa mypubkey           |
+----------+----------------------------+

$ ~ (git)-[master] % giticious repo create mytestrepo
The repository has been created
+------------+------------------------------------------------+----------------------------------------------+
| Name       | Path                                           | SSH URL                                      |
+------------+------------------------------------------------+----------------------------------------------+
| mytestrepo | /Users/dprandzioch/repositories/mytestrepo.git | dprandzioch@<your-server-url>:mytestrepo.git |
+------------+------------------------------------------------+----------------------------------------------+

$ ~ (git)-[master] % giticious repo permit mytestrepo testuser rw
Permission granted!
+------------+----------+------+-------+
| Repository | User     | Read | Write |
+------------+----------+------+-------+
| mytestrepo | testuser | true | true  |
+------------+----------+------+-------+

$ ~ (git)-[master] % giticious repo list
+------------+------------------------------------------------+----------------------------------------------+
| Name       | Path                                           | SSH URL                                      |
+------------+------------------------------------------------+----------------------------------------------+
| mytestrepo | /Users/dprandzioch/repositories/mytestrepo.git | dprandzioch@<your-server-url>:mytestrepo.git |
+------------+------------------------------------------------+----------------------------------------------+
```


Now just go ahead and clone your repo:

```
git clone dprandzioch@<your-server-url>:mytestrepo.git
```


== License

Giticious is released under the terms of the MIT Expat license, so feel free to use it for your projects :-)