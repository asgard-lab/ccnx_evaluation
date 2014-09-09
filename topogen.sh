#!/bin/bash
# SDR - Estado da Arte

##
# Definitions
#

LC_NUMERIC=en_US.UTF-8

##
# Default Files
#

SEED_FILE=${SEED_FILE:='seed_file'}
BRITE_CONF=${BRITE_CONF:='topogen_brite.conf'}
BRITE_FILE=${BRITE_FILE:='topogen'}
HTML_FILE=${HTML_FILE:='topogen.html'}
MN_FILE=${MN_FILE:='topogen_mn.conf'}
MN_DIR=${MN_DIR:='mn'}
MN_OLD_DIR=${MN_OLD_DIR:='mn_old'}
MN_CCNX_FILE=${MN_CCNX_FILE:='topogen_mnccnx.conf'}
MN_CCNX_DIR=${MN_CCNX_DIR:='mnccnx'}
MN_CCNX_OLD_DIR=${MN_CCNX_OLD_DIR:='mnccnx_old'}
MN_CACHE=${MN_CACHE:='50000'}

##
# Files
#

seed_file() {
	SEED_FILE=$1
}

brite_conf() {
	BRITE_CONF=$1
}

brite_file() {
	BRITE_FILE=$1
}

html_file() {
	HTML_FILE=$1
}

mn_file() {
	MN_FILE=$1
}

mn_dir() {
	MN_DIR=$1
}

mn_old_dir() {
	MN_OLD_DIR=$1
}

mn_ccnx_file() {
	MN_CCNX_FILE=$1
}

mn_ccnx_dir() {
	MN_CCNX_DIR=$1
}

mn_ccnx_old_dir() {
	MN_CCNX_OLD_DIR=$1
}

mn_cache() {
	MN_CACHE=$1
}

##
# Default Begin Model
#

BM_NAME=${BM_NAME:=2}
BM_N=${BM_N:=10}
BM_HS=${BM_HS:=1000}
BM_LS=${BM_LS:=100}
BM_NP=${BM_NP:=2}
BM_M=${BM_M:=2}
BM_BWD=${BM_BWD:=3}
BM_VWMAX=${BM_BWMAX:='0.256'}
BM_BWMIN=${BM_BWMIN:='10.0'}

##
# Default Begin Output
#

BO_BRITE=${BO_BRITE:=1}
BO_OTTER=${BO_OTTER:=0}
BO_DML=${BO_DML:=0}
BO_NS=${BO_NS:=0}
BO_JAVASIM=${BO_JAVASIM:=0}

##
# Begin Model
#

bm_name() {
	[[ $1 =~ ^-?[0-9]+$ ]] && BM_NAME=$1
}

bm_n() {
	[[ $1 =~ ^-?[0-9]+$ ]] && BM_N=$1
}

bm_hs() {
	[[ $1 =~ ^-?[0-9]+$ ]] && BM_HS=$1
}

bm_ls() {
	[[ $1 =~ ^-?[0-9]+$ ]] && BM_LS=$1
}

bm_np() {
	[[ $1 =~ ^-?[0-9]+$ ]] && BM_NP=$1
}

bm_m() {
	[[ $1 =~ ^-?[0-9]+$ ]] && BM_M=$1
}

bm_bwd() {
	[[ $1 =~ ^-?[0-9]+$ ]] && BM_BWD=$1
}

bm_bwmax() {
	[[ $1 =~ ^-?[0-9]+$ ]] && BM_BWMAX=$1
}

bm_bwmin() {
	[[ $1 =~ ^-?[0-9]+$ ]] && BM_BWMIN=$1
}

##
# Begin Output
#

bo_brite() {
	BO_BRITE=1
}

bo_otter() {
	BO_OTTER=1
}

bo_dml() {
	BO_DML=1
}

bo_ns() {
	BO_NS=1
}

bo_javasim() {
	BO_JAVASIM=1
}

write_conf() {
cat > $BRITE_CONF <<EOF
BriteConfig

BeginModel
        Name =  $BM_NAME
        N = $BM_N
        HS = $BM_HS
        LS = $BM_LS
        NodePlacement = $BM_NP
        m = $BM_M
        BWDist = $BM_BWD
        BWMin = $BM_BWMIN
        BWMax = $BM_BWMAX
EndModel

BeginOutput
        BRITE = $BO_BRITE 
        OTTER = $BO_OTTER
        DML = $BO_DML
        NS = $BO_NS
        Javasim = $BO_JAVASIM
EndOutput
EOF


}

write_seed_file() {
	touch $SEED_FILE
}

execute_brite() {
	java -Xmx256M -classpath Java/:. Main.Brite $BRITE_CONF $BRITE_FILE $SEED_FILE
}

convert_brite() {
	echo "Convertendo Brite"

	NODE_SIZE=${NODE_SIZE:='5'}

	NODES=$( head -n 1 topogen.brite | awk '{print $3}' )
	EDGES=$( head -n 1 topogen.brite | awk '{print $5}' )

	HOSTS=$(( $NODES * ( $RANDOM % 6 + 3 ) / 10 ))
	SERVERS=$(( $NODES * ( $RANDOM % 2 + 1 ) / 10 ))

	LINE=$( grep -n '^Nodes:' topogen.brite | cut -d : -f 1 )

	# NODES
	head -n $(( $NODES + $LINE )) topogen.brite | tail -n $NODES > tmp

	x=( $( awk '{print $2}' tmp ) )
	y=( $( awk '{print $3}' tmp ) )

	# EDGES
	tail -n $EDGES topogen.brite > tmp

	src=( $( awk '{print $2}' tmp ) )
	dst=( $( awk '{print $3}' tmp ) )
	bw=( $( awk '{print $6}' tmp ) )
	delay=( $( awk '{print $5}' tmp ) )

	hosts=( $( sort -g -k 6 tmp | head -n $HOSTS | awk '{print $2}' ) )
	servers=( $( sort -g -r -k 6 tmp | head -n $SERVERS | awk '{print $2}' ) )

	rm tmp

    # HTML VIEWER
cat > $HTML_FILE <<EOF
<!DOCTYPE>
<html>
<head>
        <title>Topologia Brite</title>
	<style>
		svg {
			padding: 25px;
			overflow: visible;
		}
	</style>
</head>
<body>
	<h1>Topologia Brite</h1>
	<svg>
		<g>
	$(
		for (( i=0; i<$NODES; i++ ))
		do
			echo '<circle id="svg_n_'$i'" r="'$NODE_SIZE'" cy="'${y[ $i ]}'" cx="'${x[ $i ]}'" stroke-width="1" stroke="#000000" fill="#FF0000"/>'
			echo '<text xml:space="preserve" text-anchor="middle" font-family="serif" font-size="12" id="svg_tn_'$i'" y="'$(( ${y[ $i ]} - 9 ))'" x="'${x[ $i ]}'" stroke-linecap="null" stroke-linejoin="null" stroke-dasharray="null" stroke-width="0" stroke="#000000" fill="#000000">node'$i'</text>'
		done
		for (( i=0; i<$HOSTS; i++ ))
		do
			random=$(( $RANDOM % 50 ))
			echo '<circle id="svg_h_'$i'" r="'$NODE_SIZE'" cy="'$(( ${y[ ${hosts[ $i ]} ]} + (50 + $random) ))'" cx="'$(( ${x[ ${hosts[ $i ]} ]} + (25 + $random) ))'" stroke-width="1" stroke="#000000" fill="#00FF00"/>'
			echo '<text xml:space="preserve" text-anchor="middle" font-family="serif" font-size="12" id="svg_th_'$i'" y="'$(( ${y[ ${hosts[ $i ]} ]} + (50 + $random - 9) ))'" x="'$(( ${x[ ${hosts[ $i ]} ]} + (25 + $random) ))'" stroke-linecap="null" stroke-linejoin="null" stroke-dasharray="null" stroke-width="0" stroke="#000000" fill="#000000">host'$i'</text>'
			echo '<line id="svg_he_'$i'" y2="'${y[ ${hosts[ $i ]} ]}'" x2="'${x[ ${hosts[ $i ]} ]}'" y1="'$(( ${y[ ${hosts[ $i ]} ]} + (50 + $random) ))'" x1="'$(( ${x[ ${hosts[ $i ]} ]} + (25 + $random) ))'" stroke-width="1" stroke="#000000" fill="none"/>'
		done
		for (( i=0; i<$SERVERS; i++ ))
		do
			random=$(( $RANDOM % 50 ))
			echo '<circle id="svg_s_'$i'" r="'$NODE_SIZE'" cy="'$(( ${y[ ${servers[ $i ]} ]} + (50 + $random) ))'" cx="'$(( ${x[ ${servers[ $i ]} ]} + (25 + $random) ))'" stroke-width="1" stroke="#000000" fill="#0000FF"/>'
			echo '<text xml:space="preserve" text-anchor="middle" font-family="serif" font-size="12" id="svg_ts_'$i'" y="'$(( ${y[ ${servers[ $i ]} ]} + (50 + $random - 9) ))'" x="'$(( ${x[ ${servers[ $i ]} ]} + (25 + $random) ))'" stroke-linecap="null" stroke-linejoin="null" stroke-dasharray="null" stroke-width="0" stroke="#000000" fill="#000000">server'$i'</text>'
			echo '<line id="svg_se_'$i'" y2="'${y[ ${servers[ $i ]} ]}'" x2="'${x[ ${servers[ $i ]} ]}'" y1="'$(( ${y[ ${servers[ $i ]} ]} + (50 + $random) ))'" x1="'$(( ${x[ ${servers[ $i ]} ]} + (25 + $random) ))'" stroke-width="1" stroke="#000000" fill="none"/>'
		done		
		for (( i=0; i<$EDGES; i++ ))
		do
			echo '<line id="svg_ne_'$i'" y2="'${y[ ${src[ $i ]} ]}'" x2="'${x[ ${src[ $i ]} ]}'" y1="'${y[ ${dst[ $i ]} ]}'" x1="'${x[ ${dst[ $i ]} ]}'" stroke-width="1" stroke="#000000" fill="none"/>'
		done
	)
		</g>
	</svg>
</body>
</html>
EOF


	# MININET
cat > $MN_FILE <<EOF
[nodes]
$(
	for (( i=0; i<$NODES; i++ ))
	do 
		echo "node$i : _ cache=$MN_CACHE"
	done
	for (( i=0; i<$HOSTS; i++ ))
	do 
		echo "host$i : _"
	done
	for (( i=0; i<$SERVERS; i++ ))
	do 
		echo "server$i : _"
	done
)
[links]
$(
	for (( i=0; i<$EDGES; i++ ))
	do
		echo "node${src[ $i ]}:node${dst[ $i ]} bw=$( printf '%.3f' ${bw[ $i ]} ) delay=$( awk 'BEGIN { printf "%.4f", '${delay[ $i ]}' * 100 }' )ms"
	done
	for (( i=0; i<$HOSTS; i++ ))
	do
		echo "host$i:node${hosts[ $i ]} bw=1000"
	done
	for (( i=0; i<$SERVERS; i++ ))
	do
		echo "server$i:node${servers[ $i ]} bw=1000"
	done
)
EOF


	# MINICCNX
cat > $MN_CCNX_FILE <<EOF
[nodes]
$(
	for (( i=0; i<$NODES; i++ ))
	do 
		echo "node$i : _ cache=$MN_CACHE"
	done
	for (( i=0; i<$HOSTS; i++ ))
	do 
		echo "host$i : _"
	done
	for (( i=0; i<$SERVERS; i++ ))
	do 
		echo "server$i : _"
	done
)
[links]
$(
	for (( i=0; i<$EDGES; i++ ))
	do
		echo "node${src[ $i ]}:node${dst[ $i ]} bw=${bw[ $i ]} delay=${delay[ $i ]}ms"
	done
	for (( i=0; i<$HOSTS; i++ ))
	do
		echo "host$i:node${hosts[ $i ]} bw=1000"
	done
	for (( i=0; i<$SERVERS; i++ ))
	do
		echo "server$i:node${servers[ $i ]} bw=1000"
	done
)
EOF


}


num_to_ip() {
	id=""

	numeros=( $( echo "ibase=10; obase=256; $CONTADOR" | bc ) )
	for (( j=${#numeros[@]}; j<4; j++ ))
	do
		if [ -z "$id" ]
		then
			id=$id"1"
		else
			id=$id".0"
		fi
	done
		
	for (( j=0; j<${#numeros[@]}; j++ ))
	do
		id=$id.$(( 10#${numeros[ $j ]} + 0 ))
	done

	echo $id
}

gem_mininet() {
	echo "Generating Mininet"
	
	if [ -d $MN_DIR ]
	then
		echo "Move mn to mn_old"
		rm -rf $MN_OLD_DIR
		mv $MN_DIR $MN_OLD_DIR
	fi

	mkdir $MN_DIR


ln -s ../$MN_FILE $MN_DIR/miniccnx.conf

cat > $MN_DIR/clean.sh <<EOF
#!/bin/bash
 
pkill ccnd 
pkill ospf 
pkill zebra 
pkill monkey
pkill controller
 
rm -f log*
rm -f */*log
rm -rf /var/run/quagga-state/*
EOF


cat > $MN_DIR/ospfn-start.sh <<EOF
#!/bin/bash

ospfn -f ospfn.conf -d
sleep 1
EOF


cat > $MN_DIR/routing.sh <<EOF
#!/bin/bash

zebra -d -f zebra.conf -i /var/run/quagga-state/zebra.\$1.pid
ospfd -f ospfd.conf -i /var/run/quagga-state/ospfd.\$1.pid -d -a
EOF


	chmod 755 $MN_DIR/clean.sh
	chmod 755 $MN_DIR/ospfn-start.sh 
	chmod 755 $MN_DIR/routing.sh

	CONTADOR=0

	awk '{print $1}' $MN_FILE > tmp
	LINE=$(grep -n links tmp | cut -d : -f 1)

	nodes=( $( head -n $(( $LINE - 1 )) tmp | tail -n $(( $LINE - 2)) | sort -V ) )
	links=( $(		
			tail -n +$(( $LINE + 1 )) $MN_FILE | cut -d ' ' -f 2  | cut -d '=' -f 2 > tmpbw

			for line in $( tail -n +$(( $LINE + 1 )) tmp )
			do
				echo $line | tr ':' '\n' | sort -V | tr '\n' ':'
				echo
			done | cut -d ':' -f 1,2 > tmpsorted

			paste -d ':' tmpsorted tmpbw > tmp
			cat tmp | sort -V
		) )

	rm tmpbw tmpsorted

	for (( i=0; i<${#nodes[@]}; i++ ))
	do
		mkdir -p mn/${nodes[ $i ]}
		
		ln -s ../ospfn-start.sh $MN_DIR/${nodes[ $i ]}/ospfn-start.sh
		ln -s ../routing.sh  $MN_DIR/${nodes[ $i ]}/routing.sh

		id=$( num_to_ip $CONTADOR )
		(( CONTADOR++ ))


cat > $MN_DIR/${nodes[ $i ]}/ospfd.conf <<EOF
hostname ${nodes[ $i ]}
password pwd
enable password pwd
log file ospfd.log
!
router ospf
 ospf router-id $id
 ===line===
!
line vty
EOF


cat > $MN_DIR/${nodes[ $i ]}/zebra.conf <<EOF
hostname ${nodes[ $i ]}
password zebra
enable password zebra

===block===

log file zebra.log
EOF


cat > $MN_DIR/${nodes[ $i ]}/start.sh <<EOF
#!/bin/bash

$(
	case ${nodes[ $i ]} in
		server* )
			echo 'echo "--- SERVER ---"'
			echo '/programas/BRITE/monkey/bin/monkey &'
		;;
		host* )
			echo 'echo "--- HOST ----"'
			echo './batch &'	
		;;
		node* )
			echo 'echo "--- NODE ---"'
		;;
	esac
)
EOF


	chmod 755 $MN_DIR/${nodes[ $i ]}/start.sh
	done

	CONTADOR=0

	echo -e "Link1\tLink2\tBandwidth" > $MN_DIR/sorted-links

	for (( i=0; i<${#nodes[@]}; i++ ))
	do
		link=( $( echo ${links[@]} | tr ' ' '\n' | awk -F : '{if ($1 == "'${nodes[ $i ]}'") print $0}' ) )

		for (( j=0; j<${#link[@]}; j++ ))
		do
			network=$( num_to_ip $CONTADOR )

			link1=$( echo ${link[ $j ]} | cut -d : -f 1 )
			link2=$( echo ${link[ $j ]} | cut -d : -f 2 )
			bw=$( awk 'BEGIN { printf "%.0f", '$( echo ${link[ $j ]} | cut -d : -f 3 )' * 1024 }' )

			echo -e "$link1\t$link2\t$bw" >> $MN_DIR/sorted-links

			sed -i 's/===line===/network '$network'\/30 area 0\n ===line===/' $MN_DIR/$link1/ospfd.conf
			sed -i 's/===line===/network '$network'\/30 area 0\n ===line===/' $MN_DIR/$link2/ospfd.conf

			(( CONTADOR+=4 ))
		done
	done

	echo -e "Link1\tLink2\tBandwidth" > $MN_DIR/unsorted-links

	links=( $( cat tmp ) )
	for (( i=0; i<${#links[@]}; i++ ))
	do
		link1=$( echo ${links[ $i ]} | cut -d : -f 1 )
		link2=$( echo ${links[ $i ]} | cut -d : -f 2 )
		bw=$( awk 'BEGIN { printf "%.0f", '$( echo ${links[ $i ]} | cut -d : -f 3 )' * 1024 }' )
		
		echo -e "$link1\t$link2\t$bw" >> $MN_DIR/unsorted-links

		sed -i 's/===block===/interface '$link1'-eth===num===\n bandwidth '$bw'\n===block===/' $MN_DIR/$link1/zebra.conf	
		sed -i 's/===block===/interface '$link2'-eth===num===\n bandwidth '$bw'\n===block===/' $MN_DIR/$link2/zebra.conf	

	done

	for (( i=0; i<${#nodes[@]}; i++ ))
	do
		nics=$( grep -c network $MN_DIR/${nodes[ $i ]}/ospfd.conf )

		for (( j=0; j<$nics; j++ ))
		do
		     sed -i '0,/===num/s/===num===/'$j'/' $MN_DIR/${nodes[ $i ]}/zebra.conf
		done

		sed -i '/===block===/d' $MN_DIR/${nodes[ $i ]}/zebra.conf
		sed -i '/ ===line===/d' $MN_DIR/${nodes[ $i ]}/ospfd.conf
	done
}

gem_miniccnx() {
	echo "Generating MiniCCNx"
	
	if [ -d $MN_CCNX_DIR ]
	then
		echo "Move mnccnx to mnccnx_old"
		rm -rf $MN_CCNX_OLD_DIR
		mv $MN_CCNX_DIR $MN_CCNX_OLD_DIR
	fi

	mkdir $MN_CCNX_DIR

ln -s ../$MN_CCNX_FILE $MN_CCNX_DIR/miniccnx.conf

cat > $MN_CCNX_DIR/clean.sh <<EOF
#!/bin/bash
killall -9 ccnd ospf zebra
rm log*
rm */*log
rm -rf /var/run/quagga-state/*
EOF


cat > $MN_CCNX_DIR/ospfn-start.sh <<EOF
#!/bin/bash
ospfn -f ospfn.conf -d
sleep 1
EOF


cat > $MN_CCNX_DIR/routing.sh <<EOF
#!/bin/bash
zebra -d -f zebra.conf -i /var/run/quagga-state/zebra.\$1.pid
ospfd -f ospfd.conf -i /var/run/quagga-state/ospfd.\$1.pid -d -a
EOF


	chmod 755 $MN_CCNX_DIR/clean.sh
	chmod 755 $MN_CCNX_DIR/ospfn-start.sh 
	chmod 755 $MN_CCNX_DIR/routing.sh

	CONTADOR=0

	awk '{print $1}' $MN_CCNX_FILE > tmp
	LINE=$(grep -n links tmp | cut -d : -f 1)

	nodes=( $( head -n $(( $LINE - 1 )) tmp | tail -n $(( $LINE - 2)) ) )
	links=( $( tail -n +$(( $LINE + 1 )) tmp ) )
	
	rm tmp

	for (( i=0; i<${#nodes[@]}; i++ ))
	do
		mkdir -p $MN_CCNX_DIR/${nodes[ $i ]}
		
		ln -s ../ospfn-start.sh $MN_CCNX_DIR/${nodes[ $i ]}/ospfn-start.sh
		ln -s ../routing.sh  $MN_CCNX_DIR/${nodes[ $i ]}/routing.sh

		id=$( num_to_ip $CONTADOR )
		(( CONTADOR++ ))


cat > $MN_CCNX_DIR/${nodes[ $i ]}/ospfd.conf <<EOF
hostname ${nodes[ $i ]}
password pwd
enable password pwd
log file ospfd.log
!
 ===block===
!
router ospf
 ospf router-id $id
 redistribute connected
 distribute-list ospfn out connected   
 ===line===
 capability opaque
!
line vty
EOF


cat > $MN_CCNX_DIR/${nodes[ $i ]}/ospfn.conf  <<EOF
ccnname /ndn/${nodes[ $i ]}.com/ 1
logdir .
EOF


cat > $MN_CCNX_DIR/${nodes[ $i ]}/zebra.conf <<EOF
hostname ${nodes[ $i ]}
password zebra
enable password zebra

log file zebra.log
EOF


	done

	CONTADOR=0

	for (( i=0; i<${#nodes[@]}; i++ ))
	do

		link=( $( echo ${links[@]} | tr ' ' '\n' | awk -F : '{if ($1 == "'${nodes[ $i ]}'") print $0}' ) )

		for (( j=0; j<${#link[@]}; j++ ))
		do
			network=$( num_to_ip $CONTADOR )

			link1=$( echo ${link[ $j ]} | cut -d : -f 1 )
			link2=$( echo ${link[ $j ]} | cut -d : -f 2 )

			sed -i 's/===line===/network '$network'\/30 area 0\n ===line===/' $MN_CCNX_DIR/$link1/ospfd.conf
			sed -i 's/===line===/network '$network'\/30 area 0\n ===line===/' $MN_CCNX_DIR/$link2/ospfd.conf

			(( CONTADOR+=4 ))
		done
	done
	
	for (( i=0; i<${#nodes[@]}; i++ ))
	do
		nics=$( grep -c network $MN_CCNX_DIR/${nodes[ $i ]}/ospfd.conf )

		for (( j=0; j<$nics; j++ ))
		do
		     sed -i 's/===block===/interface '${nodes[ $i ]}'-eth'$j'\n ===block===/' $MN_CCNX_DIR/${nodes[ $i ]}/ospfd.conf	
		done

		sed -i '/ ===block===/d' $MN_CCNX_DIR/${nodes[ $i ]}/ospfd.conf
		sed -i '/ ===line===/d' $MN_CCNX_DIR/${nodes[ $i ]}/ospfd.conf
	done
}

gem_surge() {
	echo "Generating Surge"

	mkdir -p files
	pushd files

	echo "... zipf ..."
	../surge/bin/zipf 100 100

	echo "... sizes ..."
	../surge/bin/sizes 100

	echo "... match ..."
	../surge/bin/match 2
	
	echo "... object ..."
	../surge/bin/object

	echo "... lru ..."
	../surge/bin/lru 100 100

	echo "... surfoff ..."
	../surge/bin/surfoff 100

	echo "... files ..."
	../surge/bin/files

	popd

	echo "... Files to Monkey ..."
	rm -f monkey/htdocs/*.txt
	cp files/[0-9]* monkey/htdocs/

	echo "... Get Server Ips ..."
	for server in $( ls $MN_DIR | grep server )
	do
		grep network mn/$server/ospfd.conf | \
		cut -d ' ' -f 3 | cut -d '/' -f 1 | \
		awk -F . '{ print $1"."$2"."$3"."$4 + 2}' \
		>> $MN_DIR/server-ips
	done

	echo "... Surge to $MN_DIR ..."
	cp surge/bin/Surge $MN_DIR

	echo "... Surgeclient to $MN_DIR ..."
	cp surge/bin/Surgeclient $MN_DIR

	echo "... batch to $MN_DIR ..."
cat > $MN_DIR/batch <<EOF
#!/bin/bash

time=10
uemin=1
uemax=10
uestep=2

for ((ue=\$uemin; ue<=\$uemax; ue=\$ue+\$uestep))
do
   ./Surge 4 \$ue \$time === server === / 1
   # Let server rest for a while before restarting
   sleep 60
   mv Surge.log S-\$ue.log
done
EOF


	chmod 755 $MN_DIR/batch
	echo "... Surge files to $MN_DIR ..."
	cp files/[a-z]*.txt $MN_DIR

	ip=( $( cat $MN_DIR/server-ips ) )
	server=$( cat $MN_DIR/server-ips | wc -l )

	pushd $MN_DIR
	txts=$( ls *.txt)
	popd

	for host in $( ls $MN_DIR | grep host )
	do
		random=$(( $RANDOM % $server ))

		ln -s ../Surge $MN_DIR/$host/
		ln -s ../Surgeclient $MN_DIR/$host/
		
		for txt in $txts
		do
			ln -s ../$txt $MN_DIR/$host/
		done

		cp $MN_DIR/batch $MN_DIR/$host/
		sed -i 's/=== server ===/'${ip[ $random ]}'/' $MN_DIR/$host/batch
	done
}

test_mininet() {
	echo "Teste Mininet"
}

test_miniccnx() {
	echo "Teste Miniccnx"
}

print_results_mininet() {
	echo "Resultados Mininet"
}

print_results_miniccnx() {
	echo "Resultados Miniccnx"
}

all() {
	write_seed_file
	write_conf
	execute_brite
	convert_brite
	gem_mininet
	gem_miniccnx
	gem_surge
	test_mininet
	test_miniccnx
}

make() {
	write_seed_file
	write_conf
	execute_brite
}

convert() {
	convert_brite
}

gem() {
	gem_mininet
#	gem_miniccnx
	gem_surge
}

test() {
	test_mininet
	test_miniccnx
}

clean() {
	echo "Excluindo "$SEED_FILE
	rm -f $SEED_FILE

	echo "Excluindo "$BRITE_CONF
	rm -f $BRITE_CONF

	echo "Excluindo "$BRITE_FILE".brite"
	rm -f $BRITE_FILE.brite

	echo "Excluindo "$HTML_FILE
	rm -f $HTML_FILE

	echo "Excluindo "$MN_FILE
	rm -f $MN_FILE

	echo "Excluindo "$MN_DIR
	rm -rf $MN_DIR

	echo "Excluindo "$MN_OLD_DIR
	rm -rf $MN_OLD_DIR

	echo "Excluindo "$MN_CCNX_FILE
	rm -f $MN_CCNX_FILE

	echo "Ecluindo "$MN_CCNX_DIR
	rm -rf $MN_CCNX_DIR

	echo "Excluindo "$MN_CCNX_OLD_DIR
	rm -rf $MN_CCNX_OLD_DIR

	echo "Excluindo Surge Files"
	rm -rf files

	echo "Excluindo Surge Files from Monkey"
	rm monkey/htdocs/*.txt
}

help() {
	echo "topogen - Script Gerador de Topologias"
	echo "MININET e MINICCNX utilizando a ferramenta BRITE"
	echo "... - ..."
	echo "all - Execute all procediments"
	echo "make - Generate BRITE file"
	echo "convert - Convert BRITE file to Mininet"
	echo "gem - Generete Files to Test"
	echo "test - Topologies' Test"
	echo "clean - Delete All files"
	echo "... - ..."
	echo "mn_dir - Parametro"
	echo "mn_file - Parametro"
	echo "mn_ccnx_dir - Parametro"
	echo "mn_ccnx_file - Parametro"
	echo "mn_cache - Set cache size from Mininet"
	echo "... - ..."
	echo "seed_file - Parametro"
	echo "brite_conf - Parametro"
	echo "brite_file - Parametro"
	echo "bm_name - Parametro"
	echo "bm_n - Parametro"
	echo "bm_hs - Parametro"
	echo "bm_ls - Parametro"
	echo "bm_np - Parametro"
	echo "bm_m - Parametro"
	echo "bm_bwd - Parametro"
	echo "bm_vwmax - Parametro"
	echo "bm_bwmin - Parametro"
	echo "bo_brite - Parametro"
	echo "bo_otter - Parametro"
	echo "bo_dml - Parametro "
	echo "bo_ns - Parametro"
	echo "bo_javasim - Parametro"
	echo "... - ..."
	exit 0
}

parameters() {
        while [ -n "$1" ]
        do
                case "$1" in
                        "seed_file" | "brite_conf" | "brite_file" | "html_file" | \
			"mn_file" | "mn_dir" | "mn_old_dir" | "mn_ccnx_file" | \
			"mn_ccnx_dir" | "mn_ccnx_old_dir" | "mn_cache" | \
			"bm_name" | "bm_n" | \
			"bm_hs" | "bm_ls" | "bm_np" | "bm_m" | "bm_bwd" | "bm_vwmax" | \
			"bm_bwmin" )
                                $1 $2
                                shift
                        ;;
                        "bo_brite" | "bo_otter" | "bo_dml" | "bo_ns" | "bo_javasim" | \
			"all" | "make" | "convert" | "gem" | "test" | "clean" )
                                $1
                        ;;
                        * )
                                help
                        ;;
                esac
                shift 
        done
}

main() {
	parameters $@
}

main $@
exit 0
