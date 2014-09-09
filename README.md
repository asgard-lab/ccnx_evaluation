CCNx Evaluation Project
=======================

* Cesar Marcondes
* Denis Oliveira
* Emerson Barea

Steps to run the evaluation

1. Download the MiniCCNx VM
--* https://www.dropbox.com/s/ph79hafzin3o630/Ubuntu_Mini-CCNx.zip

2. Download and untar the BRITE topology generator tool
--* In order to run the CCNx evaluation project
--* we need a copy of the BRITE topology generator tool
--* http://www.cs.bu.edu/brite/download.pl/BRITE.tar.gz (official link)
--* https://dl.dropboxusercontent.com/u/8102772/BRITE.tar.gz (fast alternative)

3. untar and unzip the BRITE within the MiniCCNx VM

4. download the topogen.sh within the MiniCCNx VM--
--git clone https://github.com/asgard-lab/ccnx_evaluation.git

5. type the following commands to autogenerate the topology in mininet--
--$ ./topogen.sh make (generate the BRITE topology)--
--$ ./topogen.sh convert (convert the BRITE topology to mininet configuration)--
--$ ./topogen.sh gem (generate the mininet topology for the simulation)

6. run the experiment--
--$ cd $MININET_DIR created by topogen.sh--
--$ miniccnx --testbed

7. (Optional) if necessary clean the environment--
--$ ./topogen.sh clean
