# 3 - Install MiniCCNx

First of all, you need to know that your VM already has a CCN version that was automaticaly installed in NS-3 DCE installation, but this CCN installation isn't built do be used in MiniCCNx experiments.

In this section, you will install MiniCCNx to emulate yours CCNx experiments.

P.s: The procedure presented here was totaly or partial taken from the [MiniCCNx](https://github.com/chesteve/mn-ccnx/wiki) page.

## 3.1 - VM Route

First, configure routing in your VM:

`echo 1 > /proc/sys/net/ipv4/ip_forward`

## 3.2 - Prerequesites and Dependencies

Install some required dependencies.

```
apt-get -u install ant

apt-get install autoconf libssl-dev libexpat1-dev libpcap-dev libecryptfs0 libxml2-utils automake gawk gcc g++ git-core pkg-config libpcre3-dev mininet dia default-jre default-jdk git
```
Create and configure a account to be used by CCNx.

```
useradd -m ccnd
passwd -l ccnd             
rm -f /home/ccnd/.bash*
mkdir /var/log/ccnd
chown ccnd /var/log/ccnd
```

## 3.3 - Install CCNx

P.s: NS-3 DCE framework uses CCNx 0.6.2 version, so, you need to install same CCNx version in MiniCCNx. If you prefer, you can try to upgrade CCNx in Ns-3 DCE and MiniCCNx to use newer versions.

Download CCNx from oficial website <http://www.ccnx.org/download/>

```
cd /opt
wget http://www.ccnx.org/releases/ccnx-0.6.2.tar.gz
tar -xvf ccnx-0.6.2.tar.gz
cd ccnx-0.6.2/
./configure
make
make install     
```

## 3.4 - Install MiniCCNx

Download MiniCCNx from oficial repository <git clone git://github.com/carlosmscabral/mn-ccnx>

```
cd /opt
git clone git://github.com/carlosmscabral/mn-ccnx
```

##### Replace the `/opt/mn-ccnx/util/install.sh` file for the `install.sh` file available [here](https://github.com/emersonbarea/testes/edit/master/install.sh). You need replace it because the original `install.sh` file only permit you install MiniCCNx in `/home/<user>` directory.

Iinstall MiniCCNx.

```
chmod +x /opt/mn-ccnx/util/install.sh
chmod +x /opt/mn-ccnx/bin/*

cd /opt/mn-ccnx/util
./install.sh -fnv
```

### 3.4.1 - MiniCCNx Tests and Examples (optional)

If you interested in test MiniCCNx to test your installation, you can run this [test](https://github.com/chesteve/mn-ccnx/wiki/Routing).

Look, you will need to have [OSPFN2.0](https://github.com/NDN-Routing/OSPFN2.0) running in your VM, so now, follow the procedure bellow to install OSPFN.

```
useradd -m quagga
passwd -l quagga             
rm -f /home/quagga/.bash*

cd /usr/local/etc/
mkdir quagga
chown quagga:quagga quagga
chmod g+w quagga

cd /var/run
mkdir quagga-state
chown quagga:quagga quagga-state
chmod g+w quagga-state

cd /opt
git clone https://github.com/NDN-Routing/OSPFN2.0
cd OSPFN2.0/

./configure --enable-opaque-lsa --disable-ipv6 --disable-ripd --disable-ripngd --disable-ospf6d --disable-bgpd --disable-bgp-announce --sysconfdir=/usr/local/etc/quagga --localstatedir=/var/run/quagga-state

make
make install

ldconfig
```

Now, you are able to continue installing others softwares needed. Continue [here](https://github.com/emersonbarea/testes/edit/master/4_install_FNSS.md).
