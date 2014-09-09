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
  * $ cd $MININET_DIR created by topogen.sh
  * $ miniccnx --testbed

10. (Optional) if necessary clean the environment
  * $ ./topogen.sh clean
