# NS-3 DCE Virtual Machine

To create a VM that support NS-3 and [Direct Code Execution (DCE)](http://www.nsnam.org/overview/projects/direct-code-execution/) framework, you can follow the steps bellow:

## 1 – Create a Ubuntu VM

We used [Ubuntu 12.04.5 LTS - Server](http://releases.ubuntu.com/12.04/) to create the VM because some modules and dependencies are not totaly compatible with the latest version.

NS-3 DCE VM used in our CCNX experiments was created using [Oracle VM VirtualBox](https://www.virtualbox.org/), and bellow are the VM configuration suggested:

```
- Disk space: 20GB
- Memory: 3GB
- Processor: 2 or more cores
- Network: 1 NIC (with Internet access)
```

## 2 - NS-3 DCE installation

Please, follow the steps bellow to install DCE in VM:

### 2.1 - Installing prerequisites

First of all, update your Ubuntu VM:

```
apt-get update
apt-get upgrade
```

And install all dependencies that will be needed:

```
apt-get install build-essential qt-sdk python2.7-dev libpcap-dev python-pygoocanvas python-pygraphviz bzr autoconf2.13 unzip unrar p7zip p7zip-rar cvs libboost-all-dev cmake git libdb-dev bison flex libssl-dev elfutils linux-headers-`uname -r` pkg-config gcc g++ libc6-dbg libxerces-c2-dev libpcre3-dev bison libtool libevent-dev gccxml python-pygccxml mercurial
```
Then, install WAF Framework
```
wget http://waf.googlecode.com/files/waf-1.6.11
$ mv waf-1.6.11 waf
$ python waf --version
```
Something like that will return: waf 1.6.11 (54dc13ba5f51bfe2ae277451ec5ac1d0a91c7aaf)

Edit bashrc to most easy use of waf:
```
vim ~/.bashrc
alias waf=`pwd`/waf

```
Update: 
```
source ~/.bashrc
```


### 2.2 - Building DCE advanced mode (with Linux kernel)

We assume that you are using root or other account with administrative privileges.

Go to the `/opt` directory. Install [bake](http://www.nsnam.org/docs/bake/tutorial/html/bake-over.html) integration tool and set some variables that are necessary to complete the instalation:

```
cd /opt

hg clone http://code.nsnam.org/bake bake

export BAKE_HOME=`pwd`/bake
export PATH=$PATH:$BAKE_HOME
export PYTHONPATH=$PYTHONPATH:$BAKE_HOME
```

So now, you can use `bake` to install all modules and dependencies that will be needed:

```
mkdir dce
cd dce

bake.py configure -e dce-linux-1.4
bake.py download
bake.py check (check if all dependencies is ok)
bake.py build
```

This procedure will install NS-3 DCE advanced mode, where DCE uses a Linux network stack.

P.s: The entire procedure presented here was taken from the [NS-3 DCE](http://www.nsnam.org/docs/dce/release/1.0/manual/html/getting-started.html) page.

### 2.3 - DCE CCNx Examples

If you want to test your DCE instalation, you can try an example script that is in `$DCE_PATH/source/ns-3-dce/example/ccnx` directory. To run it you can use `waf` like the example bellow:

`$DCE_PATH/source/ns-3-dce/waf --run dce-ccnd-simple`

`$DCE_PATH/source/ns-3-dce/waf --run "dce-ccnd-simple kernel=1"` 
(Using Kernel Stack on the simulation) 

And go to `file-0` directory to look for all logs and outputs returned from the test.

P.s: These test was taken from [DCE CCNx Examples](http://www.nsnam.org/docs/dce/release/1.0/manual/html/dce-ccnx.html) page.
