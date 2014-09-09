CCNx Evaluation Project
=======================

* Cesar Marcondes
* Denis Oliveira
* Emerson Barea

Steps to run the evaluation
1. Download the MiniCCNx VM
https://www.dropbox.com/s/ph79hafzin3o630/Ubuntu_Mini-CCNx.zip

2. Download and untar the BRITE topology generator tool
In order to run the CCNx evaluation project
we need a copy of the BRITE topology generator tool
http://www.cs.bu.edu/brite/download.pl/BRITE.tar.gz (official link)
https://dl.dropboxusercontent.com/u/8102772/BRITE.tar.gz (fast alternative)

# desconpactar o BRITE
# copiar o topogen.sh para dentro dele

# Gera a Topologia BRITE
$ ./topogen.sh make

# Converte BRITE -> miniccnx.conf
$ ./topogen.sh convert

# Gera estrutura mininet para simulação
$ ./topogen.sh gem

# Limpar ambiente
$ ./topogen.sh clean

OBS: utilizamos a vm pronta do miniccnx, para executar miniccnx
entrar no diretório do mininet criado pelo topogen.sh

$ miniccnx --testbed
