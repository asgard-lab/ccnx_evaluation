CCNx Evaluation Project
=======================

* Cesar Marcondes
* Denis Oliveira
* Emerson Barea

Steps to run the evaluation

1. Download the MiniCCNx VM
  * https://www.dropbox.com/s/ph79hafzin3o630/Ubuntu_Mini-CCNx.zip

2. Download and untar the BRITE topology generator tool
  * In order to run the CCNx evaluation project
  * we need a copy of the BRITE topology generator tool
  * http://www.cs.bu.edu/brite/download.pl/BRITE.tar.gz (official link)
  * https://dl.dropboxusercontent.com/u/8102772/BRITE.tar.gz (fast alternative)

3. Download the SURGE traffic generator tool
  * Somewhat hard to find in the original website
  * For convenience, there is an alternative copy here
  * https://dl.dropboxusercontent.com/u/8102772/surge.tar.gz

3. unzip and untar the BRITE within the MiniCCNx VM
  * tar xzvf BRITE.tar.gz

4. download the topogen.sh within the MiniCCNx VM
  * git clone https://github.com/asgard-lab/ccnx_evaluation.git

5. type the following commands to autogenerate the topology in mininet
  * copy topogen.sh inside the BRITE directory
  * $ ./topogen.sh make (generate the BRITE topology)

```
    user@user-VirtualBox:~/ccnx_evaluation/BRITE$ ./topogen.sh make
    [DEBUG]  : Parser found Router Barabasi
    [MESSAGE]: Placing 10 nodes...          DONE.
    [MESSAGE]: Connecting Nodes...           DONE.
    [MESSAGE]: Assigning Edge Bandwidth..3          DONE.
    [MESSAGE]: Checking for connectivity:   Connected
    [MESSAGE]: Exporting Topology in BRITE format to: topogen.brite
    [MESSAGE]: Exporting random number seeds to seedfile
    [MESSAGE]: Topology Generation Complete.
```
  * $ ./topogen.sh convert (convert the BRITE topology to mininet configuration)

```
    user@user-VirtualBox:~/ccnx_evaluation/BRITE$ ./topogen.sh convert
    Convertendo Brite
```

6. Copy the surge directory inside BRITE dir (from VM, binaries should work)
  * test if it works

```
user@user-VirtualBox:~/ccnx_evaluation/BRITE$ surge/bin/zipf 100 100
Generating reference values...
Total number of requests = 482
```

7. Download and install the monkey web server (lightweight)

```
$ wget http://monkey-project.com/releases/1.5/monkey-1.5.3.tar.gz
$ tar zxfv monkey-1.5.3.tar.gz
$ cd monkey-1.5.3
$ ./configure
$ make
$ cd ..
$ mv monkey-1.5.3 monkey
```

8. Finish the topology and traffic generation setup
  * $ ./topogen.sh gem (generate the mininet topology for the simulation)

```
user@user-VirtualBox:~/ccnx_evaluation/BRITE$ ./topogen.sh gem
Generating Mininet
Move mn to mn_old
Generating Surge
~/ccnx_evaluation/BRITE/files ~/ccnx_evaluation/BRITE
... zipf ...
Generating reference values...
Total number of requests = 482
... sizes ...
Generating file size data...
Total bytes = 2860165, Mean = 28601 Max = 858235
Writing data to yout.txt
... match ...
Doing matching via minimal error in tail
Maxrq = 52.674572
Accumulated error = 609.545410
Max error = 99.879929 Index = 14
Total Requests = 482.000000
... object ...
Generating objects...
Largest object has 38 files
Total embedded files from mout.txt = 38
Total total base files = 30, Total objects = 62
Number of unused embedded file = 0
Number of embedded files with ref count > 5 0
Number of embedded files with ref count < -20 0
... lru ...
SEED = 100, WINDOW = 100
Generating sequence via probablistic sliding window...
Top0 = 4 Lrg = 0
Top1 = 3 Lrg = 0
Top2 = 5 Lrg = 0
Top3 = 4 Lrg = 0
Top4 = 6 Lrg = 0
Top5 = 4 Lrg = 1
Top6 = 5 Lrg = 0
Top7 = 7 Lrg = 0
Top8 = 6 Lrg = 0
Top9 = 6 Lrg = 0
... surfoff ...
SEED = 100
Generating OFF time values...
259 Inactive OFF times generated
Generating Session Lengths...
259 Session lengths generated
... files ...
Generating files
~/ccnx_evaluation/BRITE
... Files to Monkey ...
... Get Server Ips ...
... Surge to mn ...
... Surgeclient to mn ...
... batch to mn ...
... Surge files to mn ...
```

9. run the experiment
  * $ cd mn (inside BRITE, created by topogen.sh)
  * $ sudo miniccnx --testbed

```
user@user-VirtualBox:~/ccnx_evaluation/BRITE/mn$ sudo miniccnx --testbed
[sudo] password for user:
Parse of miniccnx.conf done.
*** Creating network
*** Adding controller
*** Adding hosts:
host0 host1 host2 node0 node1 node2 node3 node4 node5 node6 node7 node8 node9 server0
*** Adding switches:
 
*** Adding links:
(1000.00Mbit) (1000.00Mbit) (host0, node7) (1000.00Mbit) (1000.00Mbit) (host1, node5) (1000.00Mbit) (1000.00Mbit) (host2, node1) (103.00Mbit -100.0000ms delay) (103.00Mbit -100.0000ms delay) (node0, node1) (71.00Mbit -100.0000ms delay) (71.00Mbit -100.0000ms delay) (node0, node2) (28.00Mbit 0.0000ms delay) (28.00Mbit 0.0000ms delay) (node0, node7) (29.00Mbit -100.0000ms delay) (29.00Mbit -100.0000ms delay) (node1, node2) (65.00Mbit 0.0000ms delay) (65.00Mbit 0.0000ms delay) (node1, node3) (28.00Mbit 0.0000ms delay) (28.00Mbit 0.0000ms delay) (node1, node5) (84.00Mbit 0.0000ms delay) (84.00Mbit 0.0000ms delay) (node1, node8) (30.00Mbit 0.0000ms delay) (30.00Mbit 0.0000ms delay) (node1, node9) (50.00Mbit 0.0000ms delay) (50.00Mbit 0.0000ms delay) (node2, node3) (41.00Mbit 0.0000ms delay) (41.00Mbit 0.0000ms delay) (node2, node4) (87.00Mbit 0.0000ms delay) (87.00Mbit 0.0000ms delay) (node2, node6) (127.00Mbit 0.0000ms delay) (127.00Mbit 0.0000ms delay) (node3, node4) (82.00Mbit 0.0000ms delay) (82.00Mbit 0.0000ms delay) (node3, node5) (134.00Mbit 0.0000ms delay) (134.00Mbit 0.0000ms delay) (node3, node6) (118.00Mbit 0.0000ms delay) (118.00Mbit 0.0000ms delay) (node3, node7) (100.00Mbit 0.0000ms delay) (100.00Mbit 0.0000ms delay) (node4, node8) (62.00Mbit 0.0000ms delay) (62.00Mbit 0.0000ms delay) (node4, node9) (1000.00Mbit) (1000.00Mbit) (node6, server0)
*** Configuring hosts
host0 host1 host2 node0 node1 node2 node3 node4 node5 node6 node7 node8 node9 server0
Setup time: 2
*** Starting controller
*** Starting 0 switches
 
Starting OSPFN ...
OSPFN configuration completed!
*** Starting CLI:
miniccnx>
```

10. (Optional) if necessary clean the environment
  * $ ./topogen.sh clean
