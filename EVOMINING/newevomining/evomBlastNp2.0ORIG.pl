#!/usr/bin/perl -w
#####################################################
# CODIGO PARA hacer Blast Vs NP
#
#####################################################

##use strict;
use CGI::Carp qw(fatalsToBrowser);
use CGI;
use Statistics::Basic qw(:all);
############################## def-DBM #################################
use Fcntl ; use DB_File ; $tipoDB = "DB_File" ; $RWC = O_CREAT|O_RDWR
;
############################## def-SUB  ################################
my $tfm = "mi_hashNombrePorNum.db" ;
my %Input;
my $query = new CGI;

$apacheCGIpath="/home/evoMining/newevomining";


$hand = tie my %NombresPorNum, $tipoDB , "$tfm" , $RWC , 0644 ;
print "$! \nerror tie para $tfm \n" if ($hand eq "");
my $tfm2 = "mi_hashNUMVia.db" ;
$hand2 = tie my %hashNUMVia, $tipoDB , "$tfm2" , 0 , 0644 ;
print "$! \nerror tie para $tfm2 \n" if ($hand2 eq "");

 
print $query->header,
      $query->start_html(-style => {-src => '/html/evoMining/css/tabla2.css'} );
my @pairs = $query->param;
foreach my $pair(@pairs){
$Input{$pair} = $query->param($pair);
}
($eval,$score2,$pidfecha)=recepcion_de_archivo(); #Iniciar la recepcion del archivo
system "touch $pidfecha/prueba$pidfecha";
$hashothernames{'enolase2'}="enolase";
$hashothernames{'enolase1'}="enolase";
$hashothernames{'enolase4'}="enolase";
$hashothernames{'enolase3'}="enolase";
$hashothernames{'phosphoglyceratemutase1'}="phosphoglycerate mutase";
$hashothernames{'phosphoglyceratemutase2'}="phosphoglycerate mutase";
$hashothernames{'phosphoglyceratemutase3'}="phosphoglycerate mutase";
$hashothernames{'phosphoglyceratemutase4'}="phosphoglycerate mutase";
$hashothernames{'phosphoglyceratekinase1'}="phosphoglycerate kinase";
$hashothernames{'phosphoglyceratekinase2'}="phosphoglycerate kinase";
$hashothernames{'phosphoglyceratekinase3'}="phosphoglycerate kinase";
$hashothernames{'phosphoglyceratekinase4'}="phosphoglycerate kinase";
$hashothernames{'Triosephosphateisomerase1'}="Triosephosphate isomerase";
$hashothernames{'Triosephosphateisomerase2'}="Triosephosphate isomerase";
$hashothernames{'Triosephosphateisomerase3'}="Triosephosphate isomerase";
$hashothernames{'Triosephosphateisomerase4'}="Triosephosphate isomerase";
$hashothernames{'Fructosebiphosphatealdolase1'}="Fructose biphosphate aldolase";
$hashothernames{'Fructosebiphosphatealdolase2'}="Fructose biphosphate aldolase";
$hashothernames{'Fructosebiphosphatealdolase3'}="Fructose biphosphate aldolase";
$hashothernames{'Fructosebiphosphatealdolase4'}="Fructose biphosphate aldolase";
$hashothernames{'Phosphofructokinase1'}="Phosphofructokinase";
$hashothernames{'Phosphofructokinase2'}="Phosphofructokinase";
$hashothernames{'Phosphofructokinase3'}="Phosphofructokinase";
$hashothernames{'Phosphofructokinase4'}="Phosphofructokinase";
$hashothernames{'Phosphofructokinase5'}="Phosphofructokinase";
$hashothernames{'Phosphofructokinase6'}="Phosphofructokinase";
$hashothernames{'Phosphofructokinase7'}="Phosphofructokinase";
$hashothernames{'Glucose6phosphateisomerase1'}="Glucose 6 phosphate isomerase";
$hashothernames{'Glucose6phosphateisomerase2'}="Glucose 6 phosphate isomerase";
$hashothernames{'Glucose6phosphateisomerase3'}="Glucose 6 phosphate isomerase";
$hashothernames{'Glucose6phosphateisomerase4'}="Glucose 6 phosphate isomerase";
$hashothernames{'Glucosekinase1'}="Glucose kinase";
$hashothernames{'Glucosekinase2'}="Glucose kinase";
$hashothernames{'Glucosekinase3'}="Glucose kinase";
$hashothernames{'Glucosekinase4'}="Glucose kinase";
$hashothernames{'Glucosekinase5'}="Glucose kinase";
$hashothernames{'Glucosekinase6'}="Glucose kinase";
$hashothernames{'Glucosekinase7'}="Glucose kinase";
$hashothernames{'Pyruvatekinase1'}="Pyruvate kinase";
$hashothernames{'Pyruvatekinase2'}="Pyruvate kinase";
$hashothernames{'Pyruvatekinase3'}="Pyruvate kinase";
$hashothernames{'Pyruvatekinase4'}="Pyruvate kinase";

#-----------------------JAVA SCRIPT------------------
print qq |
<script language="javascript">
function checkAll(formname, checktoggle)
{
  var checkboxes = new Array(); 
  checkboxes = document[formname].getElementsByTagName('input');
 
  for (var i=0; i<checkboxes.length; i++)  {
    if (checkboxes[i].type == 'checkbox')   {
      checkboxes[i].checked = checktoggle;
    }
  }
}
</script>

|;
#------------END JAVA SCRIPT-------------------------
print qq |

<div class="encabezado">
</div>
<div class="expandedd">Results</div>
|;
#------------ guarda hash----------------------
#print "Content-type: text/html\n\n";
open (VIAS, "$apacheCGIpath/PasosBioSin/ALL_curado.fasta");
open (VIASOUT, ">$apacheCGIpath/PasosBioSin/viasout");
#open (VIAS, "/var/www/newevomining/PasosBioSin/tRAPs_EvoMining.fa");
$counter=0;
while (<VIAS>){
chomp;
  if($_ =~ />/){
     @nomb =split (/\|/, $_);
     $nomb[2]=~ s/_//;
     if(!exists $uniqVIA{$nomb[2]}){
        $uniqVIA{$nomb[2]}=$counter; ## hash quwe contiele relacion:via original --> numero de via general de trabajo
        $counter++;
	print VIASOUT "$nomb[2]--->$uniqVIA{$nomb[2]}\n";
     }
     $hashnombreVIA{$counter}=$nomb[2];

  }
}

#----------------prepara blast Vs NP---------------------------
####weekend# en este caso se tiene que corregir que en pasos anteriores se generaron archivos vacios###
####weekend#
system "ls $apacheCGIpath/$pidfecha/FASTASparaNP > $apacheCGIpath/$pidfecha/ls.FASTANP";

#print "<h1>Blast  Central Met./NP VS Genome DB...</h1>";

#system "mkdir NewFASTASparaNP";
open (BNP, "$apacheCGIpath/$pidfecha/ls.FASTANP") or die $!;
while (<BNP>){
chomp;
 ##########cuenta y saca secuencias corts y largas####################

  open(OUTFASTA, ">$pidfecha/NewFASTASparaNP/$_");
 open(TAM, "$pidfecha/FASTASparaNP/$_") or die $!;
  $contDentro=0;
  $contfuera=0;
  $contfueraabajo=0;
  undef %hashLARGASCORTAS;
  $hashLARGASCORTAS{$headerr}="";
 while($lineaa=<TAM>){
 chomp($lineaa);
  if($lineaa =~ />/){
     $headerr=$lineaa;
  }
  else{
      if(!exists $hashLARGASCORTAS{$headerr}){# solo para quitar el warning de qeu se concatenaba sin inicializar
        $hashLARGASCORTAS{$headerr}=$lineaa; 
      }
      else{
        $hashLARGASCORTAS{$headerr}=$hashLARGASCORTAS{$headerr}.$lineaa; 
      }
  }
 }#end while interno
 
 #------------------------- 
 #separa las bases y cuenta
 #------------------------- 
 ###print "Separando bases...\n"; 
 $cuentaSEQ=0;
 undef @arrpasos2;
 foreach my $x (keys %hashLARGASCORTAS){
   @baseees=split(//,$hashLARGASCORTAS{$x});
   $tamSEQ=$#baseees+1;
   $hashID_size{$x}=$tamSEQ;
   $cuentaSEQ++;
   $sumaTAM=$sumaTAM+$tamSEQ;
   $idtam=$x."&&&".$tamSEQ;
   push (@arrpasos2,$idtam);
   push (@arrpasos,$tamSEQ);
 }
 
  $promedioTamSEQ=$sumaTAM/$cuentaSEQ;
  
 #------------------------- 
 #promedio y DEVstd
 #------------------------- 
 ###print " Calculando devstd...\n";  
 #<STDIN>;
 ####################################################
 ##    CALCULO DE DESVIACION ESTANDAR
 ###################################################
   $contstd=1;
   my @v1  = vector(@arrpasos);
   my $std = stddev(@v1);
   $prommasDEV=$promedioTamSEQ+$std;
   $promminusDEV=$promedioTamSEQ-$std;
   $promminusDEV2=$promminusDEV-$std;# para experimentar quitando dos devstd abajo
   ##print "$_ ->prom:$promedioTamSEQ-->DEVstd:$std\n";
   ##<STDIN>;#
   $cuentaSEQ=0;
  $sumaTAM=0;
  
   foreach my $xids ( @arrpasos2 ){
     @idssize=split(/&&&/,$xids);
     if($idssize[1] > $prommasDEV){
       #print "$idssize[0] $idssize[1] > $prommasDEV";
       #<STDIN>;
       
       $SeqRecortada= substr ($hashLARGASCORTAS{$idssize[0]}, 0, $prommasDEV);  #recorta la secuencia al tamanio promedio+STDdev
       print OUTFASTA "$idssize[0]\n$SeqRecortada\n";
       $contfuera++;
     }
     elsif($idssize[1] < $promminusDEV2){
     
        
        $contfueraabajo++;
     }
     else{
        print OUTFASTA "$idssize[0]\n$hashLARGASCORTAS{$idssize[0]}\n";
        $contDentro++;
     }


       ### print "$xids\n";
  }
  
  $totalfuera=$contfuera+$contfueraabajo;
  ###print "Dentro :$contDentro  Fueraarriba: $contfuera  fueraabajo:$contfueraabajo totalfuera:$totalfuera";
  
  ###<STDIN>;

 ##
 ##$prommasDEV

 undef @arrpasos;
  #print "$_ ->prom:$promedioTamSEQ-->DEVstd:$std\n";
  #<STDIN>;
######################################################
 #foreach my $y (keys %hashID){
 #  print "$y-->$hashID{$y}-->prom:$promedioTamSEQ-->DEVstd:$std";
 #  <STDIN>;
 #}
  
  undef %hashID_size;
  undef %hashID;
  close TAM;
  close OUTFASTA;



 
 
 ##########FIN cuenta y saca secuencias corts y largas####################

system "touch $pidfecha/prueba0";
##################weekend#####################
## version con todos##
####weekend#
 $blast=`blastp -db $apacheCGIpath/NPDB/NP_DB_NOVEMBER2014clean.db -query $apacheCGIpath/$pidfecha/NewFASTASparaNP/$_ -outfmt 6 -num_threads 4 -evalue $eval -out $apacheCGIpath/$pidfecha/blast/$_\_ExpandedVsNp.blast`;#" or die "EERROOOR:$?,$!,%d, %s coredump";
 #my $returnCode = system( $systemCommand );

  
  system "touch $pidfecha/prueba1";

### version solo con resaltados en rojo en el heatplot##system "/opt/ncbi-blast-2.2.28+/bin/blastp -db /var/www/newevomining/NPDB/NP_DB_NOVEMBER2014clean.db -query /var/www/newevomining/NewFASTASparaNP/$_ -outfmt 6 -num_threads 4 -evalue $eval -out /var/www/newevomining/blast/$_\_ExpandedVsNp.blast";
########we######system "/opt/ncbi-blast-2.2.28+/bin/blastp -db /var/www/newevomining/NPDB/NATURAL_PRODUCTS_DB3.db -query /var/www/newevomining/FASTASparaNP/$_ -outfmt 6 -num_threads 4 -evalue $eval -out /var/www/newevomining/blast/$_\_ExpandedVsNp.blast";

#blast vs NP

}#end while externo

close BNP;
#print "<h1>Done...</h1>"; ]

system "touch $pidfecha/prueba1";
#----------------------------- filtra por score------------------------
system "ls $apacheCGIpath/$pidfecha/blast/*_ExpandedVsNp.blast > $apacheCGIpath/$pidfecha/ls.ExpandedVsNp.blast";

open (EXPPP, "$apacheCGIpath/$pidfecha/ls.ExpandedVsNp.blast") or die $!;
while(<EXPPP>){
chomp;
  open(CUUOUT, ">$_.2");
  open(CUU, "$_");
  while($linea=<CUU>){
  chomp($linea);
   @arreg=split("\t",$linea);
    if ($arreg[11] >= $score2){
      print CUUOUT "$linea\n";
    
    }
  
  }
  close CUU;
  close CUUOUT;
}
close EXPPP;
#----------------------end filtra por score--------------------------

system "ls $apacheCGIpath/$pidfecha/blast/*_ExpandedVsNp.blast.2 > $apacheCGIpath/$pidfecha/ls.ExpandedVsNp.blast2";
open (EXP, "$apacheCGIpath/$pidfecha/ls.ExpandedVsNp.blast2") or die $!;
while(<EXP>){
chomp;
#print "<h1>cat $_ |cut -f2 |sort -u >$_.recruitedUniq</h1>";
   $sii=`egrep -io [a-z] $_`;  # esta linea verifica qeu el archivo contenga texto.
   if($sii){
    ##############weekend############### 
         system "cat $_ |cut -f2 |sort -u >$_.recruitedUniq"; #Si tiene texto el archivo extrae la colunma2 que contiene el nombre del NP
   }
}
close EXP;
system "ls $apacheCGIpath/$pidfecha/blast/*.recruitedUniq > $apacheCGIpath/$pidfecha/ls.recruitedUniq ";

open (REC, "$apacheCGIpath/$pidfecha/ls.recruitedUniq") or die $!;
open (RECPR, ">$apacheCGIpath/$pidfecha/hash.log") or die $!;

while(<REC>){
chomp;
 open(OU,"$_");
 $sin=$_;
 $sin =~ s/$apacheCGIpath\/$pidfecha\/blast\///g;
 $sin =~ s/\.fasta_ExpandedVsNp\.blast\.2\.recruitedUniq//g;
   while($line=<OU>){
   chomp($line);
      #print RECPR "$line\n";
      $hashUniq{$line}=$line;
      $cad=$cad.",".$line;
       #print RECPR "$cad\n";      
   }
   $cad =~ s/^\,+//;     
   #$reg=$hashNUMVia{$sin}."---".$cad;
   $reg=$hashnombreVIA{$sin}."---".$cad;
   $hashNUM{$hashnombreVIA{$sin}}=$sin;
   if($cad){
    print RECPR "$sin===$reg\n";
   $reg2="$sin===$reg";
    
     push(@mostrar, $reg2);
   }
   
   $cad='';
 close OU;
 

 $sizeFIle= -s $_;
 if($sizeFIle > 0){
  open(OUTFASTA,">$_.fasta") or die $!;
  $nam=$_;
  $nam =~ s/\.fasta_ExpandedVsNp\.blast\.2\.recruitedUniq//;
  #system "touch $nam.nanana";
  push(@nom, $nam);
 }
 else {
  next;
 }
#open(NPDB, "/var/www/newevomining/NPDB/Natural_products_DB.prot_fasta")or die $!; 
#open(NPDB, "/var/www/newevomining/NPDB/NATURAL_PRODUCTS_DB3.fasta")or die $!;
open(NPDB, "$apacheCGIpath/NPDB/NP_DB_NOVEMBER2014clean.txt")or die $!;
 $si=0;  
 while($line2=<NPDB>){
  chomp($line2);
    if ($line2 =~ />/){
     #$header=$line2;
     $line2 =~ s/>//;
     
       if(exists $hashUniq{$line2}){
           print OUTFASTA ">$line2\n";
	   $si=1;        
       }
       else{
         $si=0;
       }
    }
    else{
       if($si ==1){
         print OUTFASTA "$line2\n";
       }
  
    }#

  }#end while NPDF
close NPDB;
close OUTFASTA;
%hashUniq ='';
}
close REC;

foreach my $x (@nom){
#system "touch $x.nananaaaaaa";
$tempor= $x;
$tempor =~ s/$apacheCGIpath\/$pidfecha\/blast\///;
#########weekend######

## version recortados
###weekend
system "cat $apacheCGIpath/$pidfecha/NewFASTASparaNP/$tempor.fasta $x.fasta_ExpandedVsNp.blast.2.recruitedUniq.fasta> $x.concat.fasta";
#version todos###system "cat /var/www/newevomining/FASTASparaNP/$tempor.fasta $x.fasta_ExpandedVsNp.blast.2.recruitedUniq.fasta> $x.preconcat.fasta";
#open (CONCAT, "$x.preconcat.fasta");
#open (CONCATOUT, ">$x.concat.fasta");
# $cuenta=0;
#  while (<CONCAT>){
#   chomp;
#   #$_ =~ s/\(|\)//g;
#   #$_ =~ s/\(//g;
#     if($_ =~ />/){
#    # $_ =~ s/\-|\.//g;
#       $cuenta++;
#       #$llave="$cuenta"."_header";
#       $llave="$cuenta";
#      $NombresPorNum{$llave}=$_;
#      
#      print CONCATOUT ">$llave\n";
#      
#     }
#     else{
#       print CONCATOUT "$_\n";
#    
#    }
# }
}#end foreach
#$claveee="si llegaaaaaaaa";
close CONCAT;
close CONCATOUT;
open (MAMA, ">mama.log");
#print "<h1>Done...ultimo</h1>"; 
#print "Content-type: text/html\n\n";
print qq| <form method="post" action="/cgi-bin/newevomining/alignGcontextORIG.pl" name="forma"> |;
print qq| <table class="segtabla">|;
print qq |<td></td>|;
print qq |<div class="subtitulo"><td>Central</td></div>|;
print qq |<div class="subtitulo"><td>Natural Products</td></div>|;
foreach my $x (@mostrar){
#print MAMA "$x\n";
@PREarray =split("===",$x);
@array =split("---",$PREarray[1]);
#$array[1] =~ s/_\d+//g;
print qq |<tr>|;
#$clave="clave_$PREarray[0]";#$hashNUM{$array[0]}";
$clave="clave_$PREarray[0]";#$hashNUM{$array[0]}";

print MAMA "$clave\n";
#print qq| <input type="hidden" name="$clave" value="$clave">|;
print qq |<td><input type="checkbox" name="$clave" checked> </td>|;

print qq |<div ><td>$hashNUMVia{$PREarray[0]}</td></div>|;
#print qq |<div ><td>$hashNUMVia{$PREarray[0]}-$PREarray[0]</td></div>|;
#print qq |<div class="campo2"><td>$clave</td></div>|;
$array[1]=~ s/\,/ \,/g;
print qq |<div ><td width="40%">$array[1]</td></div>|;
print qq |</tr>|;
}
print qq |<input type="hidden" value="$pidfecha" name="pidfecha" >|;
print qq |</table>|;
print qq| <table>|;
print qq |
<td><div ><a href="javascript:void();" onclick="javascript:checkAll('forma', true);">check all</a></div></td>
<td><div ><a href="javascript:void();" onclick="javascript:checkAll('forma', false);">uncheck all</a></div></td>

|;
print qq |<td><div class="boton"><button  value="Submit" name="Submit">SUBMIT</button></div></td>|;

print qq |</table>|;
#print "<h1>Done...</h1>";
#system "muscle -in FASTAINTER/$nomb -out ALIGNMENTSfasta/$_.muslce.pir -fasta -quiet -group";
print qq| </form> |; 
untie %NombresPorNum;
#exit(1);

######################################################
# funciones para upload
#######################################################
sub recepcion_de_archivo{

my $evalue = $Input{'evalue'};
my $score1 = $Input{'score'};
my $PIDfecha = $Input{'pidfecha'};
#my $nombre_en_servidor = $Input{'archivo'};

$evalue =~ s/ /_/gi;
$evalue =~ s!^.*(\\|\/)!!;
$score1=~ s/ /_/gi;
$score1 =~ s!^.*(\\|\/)!!;

my $extension_correcta = 1;

return $evalue,$score1,$PIDfecha ;

} #sub recepcion_de_archivo
