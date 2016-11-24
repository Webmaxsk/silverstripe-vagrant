# silverstripe-vagrant
Vagrant setup for SilverStripe CMS. All-in-one vagrant setup with sspak, composer, gulp, sake, apache, mysql in it.


## Project structure

       Project root
       /         \
    config.json    public
               	    \
              	    Silverstripe files



## Installation

clone vagrant to public folder
```bash
cd public && git clone git@github.com:Webmaxsk/silverstripe-vagrant.git vagrant && rm -rf vagrant/.git
```

add config.json to Project root
- you can find sample in public/vagrant/config.json.sample
- set your static IP, theme path (if using gulp), provider (virtualbox or lxc), db

initialize vagrant
```bash
cd public/vagrant && vagrant up 
```

OPTIONAL: if using non-default vagrant provider add provider to the end
```bash
cd public/vagrant && vagrant up --provider="lxc"
```

OPTIONAL: install quick vagrant execution script

Global script allowing execution of commands in vagrant guest from host 
(you must be in public or public/vagrant folder) 
```bash
cp -f public/vagrant/vrun /usr/local/bin/vrun
```

Example:
```bash
vrun top
```

NOTICE: all examples bellow will use this vrun script. Alternative to this script is:
```bash
cd public/vagrant
vagrant ssh
```
and executing script directly from vagrant shell.


## Post installation setup

You can edit httpd.conf according to your needs.
Restart apache after change:
```bash
vrun sudo service httpd restart
```

Install node modules (for gulp theme)
```bash
vrun mygulp install
```


## Usage
As our paths in vagrant guest are known and do not change in different projects, we can use extended versions of scripts with "my" prefix

### sspak
run any sspak command or use custom actions like save-local or load-2-local

```bash
vrun mysspak save-local test.sspak
```
will save test.sspak package to Project root

```bash
vrun mysspak load-to-local test.sspak
```
will load test.sspak stored in Project root. After execution, test.sspak will be renamed to test.sspak.used

If server_prod and/or server_test defined in config.json, you can use extra tasks:
 load-to-test, load-to-prod, save-test and save-prod

Warning: be carefull while loading to production server! Backup before you process. You will be asked for confirmation.

### sake
run any sake command quickly.
```bash
vrun mysake anything
```

### composer
run any composer command quickly
```bash
vrun mycomposer anything
```

### gulp (if available)
run any gulp command quickly or install theme dependencies
```bash
vrun mygulp anything
```
```bash
vrun mygulp install
```

### compass (if available)
run compass tasks or install theme dependencies
```bash
vrun mycompass anything
```
```bash
vrun mycompass install
```


## Save vagrant guest for later usage / vagrant backup
After you finish your project, I do recommend to create ready to use vagrant package for later use.
```bash
cd public/vagrant
vagrant package --output ../../test.box
```
will save test.box to Project root. After, you can safely destroy existing vagrant ("vrun vagrant destroy") and archive whole Project. Once you need to run this project again, just unarchive project and change config.json in row "box" with "test.box" and run "vrun vagrant up"

NOTICE: "vrun vagrant anything" is not executed on vagrant guest, but in host (shortcut - you don't need to go to public/vagrant folder).


## ToDo
xdebug, https
