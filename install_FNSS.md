# 4 - FNSS

[FNSS](http://fnss.github.io/) is a toolchain to setup a network experiment scenario.

We will use `FNSS` to generate topology and traffic matrix in our emulated experiments (`MiniCCNx`) and simulated experiments (`NS-3 DCE`).

## 4.1 - Install FNSS to emulate (FNSS core)

To emulate scenarios in `MiniCCNx`, you need to install `FNSS core`. Do it following the step bellow:

```
cd /opt
git clone https://github.com/fnss/fnss.git
cd fnss
./ubuntu_install
```
This procedure install `FNSS core` files in `/usr/local/lib/python2.7/dist-packages/fnss` directory.

### 4.1.1 - Testing `FNSS core`

To test `FNSS core` installation, you can do the test bellow:

```
cd /opt/fnss/core

python
 >>> import fnss
 >>> topo = fnss.two_tier_topology(1,2,2)
 >>> fnss.write_topology(topo, 'fnss-topo.xml')
 >>> quit()

mn-fnss fnss-topo.xml
 *** Creating network
 *** Adding controller
 *** Adding hosts:
 h1 h2 h3 h4
 *** Adding switches:
 s1 s2 s3
 *** Adding links:
 (h1, s2) (h2, s2) (h3, s3) (h4, s3) (s1, s2) (s1, s3)
``` 

## 4.2.- Install FNSS to simulate (FNSS NS-3)

To install `FNSS NS-3`, you need make it giving the NS-3 installation directory. See bellow:

```
cd /opt/fnss/ns3
make install NS3_DIR=/opt/dce/source/ns-3.21/
```

If all is done, test it.

### 4.2.1 - Testing `FNSS NS-3`

```
cd /opt/dce/source/ns-3.21/
./waf --run fnss-example
```
Now, you finished all the installations needed. Go to [home](https://github.com/asgard-lab/ccnx_evaluation/master/4_install_.md) project.
