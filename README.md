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
  * inside the BRITE directory
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
  * $ ./topogen.sh gem (generate the mininet topology for the simulation)

6. run the experiment
  * $ cd $MININET_DIR created by topogen.sh
  * $ miniccnx --testbed

7. (Optional) if necessary clean the environment
  * $ ./topogen.sh clean
