#####Reference genome and query
$SPECIAL_ORG="5"; ## Reference organism having a known BGC, will be used as reference for BGC homology
$QUERIES="realAroA.query";

#####homology search parameters
$e="0.000000001"; 		#1E-15					# E value. Minimal for a gene to be considered a hit.
$bitscore="300"; ## Revisar el archivo .BLAST.pre para tener idea de este parámetro.
$ClusterRadio="30"; #number of genes in the neighborhood to be analized
$eCluster="0.001"; 		#Evalue for the search of queries (from reference organism) homologies, values above this will be colored
$eCore=$eCluster; 		#Evalue for the search of ortholog groups within the collection of BGCs	

#####db management
$RAST_IDs="RAST.IDs";
$BLAST_CALL="";
$DOWNLOAD="0";			#1 If you need to download The files needed for the script from RAST 0 if you already have downloaded your genomes database
$USER="nselem35";		#If you are going to download files
$PASS="q8Vf6ib";		#password for RAST account
$FORMAT_DB="0"; 		#here you put 0 if  the genomes DB is already formatted and 1 if you want to reformat the whole DB


#####working directory.. for most cases do not touch
$NAME="ClusterTools1";					##Name of the group (Taxa, gender etc)
$BLAST="$NAME.blast";
#$dir="/Users/FBG/Desktop/ClusterTools1/$NAME";		##The path of your directory
$dir="/home/nelly/Escritorio/ClusterTools3/$NAME";		##The path of your directory

#####for second round of analysis with selected genomes
$LIST = ""; 					##Wich genomes would you process in case you might, otherwise left empty for whole DB search
#$LIST = "12,59,58,60,310,316,318,321,322,345,346,348,358,359,360,361,510,780"; 		##Can be left blank if you want consecutive genomes starting from 1
$NUM = `wc -l < $RAST_IDs`;
chomp $NUM;
$NUM=int($NUM);
#the number of genomes to be analized in case you used the option $LIST, comment if $LIST is empty
#$NUM="17";