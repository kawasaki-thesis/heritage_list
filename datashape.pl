#!/usr/bin/perl
use Encode;
use utf8;

#CSV読み込み

$inputfile="C:/Users/sayak/work/heritage_list/data/EasternAsia_wiki.csv";
$i = 0;
$j = 0;

#################
#heritageのデータ
#0 name
#1 area
#2 subarea
#3 n
#4 e
#5~14 classflag
$c1=5;
$c2=6;
$c3=7;
$c4=8;
$c5=9;
$c6=10;
$c7=11;
$c8=12;
$c9=13;
$c10=14;
#################

open(IN,$inputfile) || die "$!";

while(<IN>){
	chomp;
	@list = split(/,/);
	foreach(@list){
		if($j=0){
			$heritage[$i][0]=$_;
			$heritage[$i][1]=0;
			$heritage[$i][2]=0;
			$heritage[$i][3]=0;
			$heritage[$i][4]=0;
		}elsif($_ = ~ /Cultual|Natural/){
			@class = split(/(||)/);
			foreach $roman (@class){
				if($roman eq "i"){ $heritage[$i][$c1]=1;
				}elsif($roman eq "ii"){ $heritage[$i][$c2]=1;
				}elsif($roman eq "iii"){ $heritage[$i][$c3]=1;
				}elsif($roman eq "iv"){ $heritage[$i][$c4]=1;
				}elsif($roman eq "v"){ $heritage[$i][$c5]=1;
				}elsif($roman eq "vi"){ $heritage[$i][$c6]=1;
				}elsif($roman eq "vii"){ $heritage[$i][$c7]=1;
				}elsif($roman eq "viii"){ $heritage[$i][$c8]=1;
				}elsif($roman eq "ix"){ $heritage[$i][$c9]=1;
				}elsif($roman eq "x"){ $heritage[$i][$c10]=1;}
			}
			for($k=$c1; $k<=$c10; $k++){
				if($heritage[$i][$k]!=1){$heritage[$i][$k]=0;}
			}
		}
	}
	$i++;
	$j=0;
=pod
	@list = split(/,/);
	
	if($list[1] =~ /NN|VV|JJ|NP/){
		$heritage[$i][$j] = $list[2];
		$j++;
	}
=cut
}
close(IN);



#コーパスを標準出力
foreach (@heritage){
	print "(" . join(", ", @{$_}) . ")\n";
	#jをカンマで横に並べてi行表示
}

#end