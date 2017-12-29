#!/usr/bin/perl
use Encode;
use utf8;

#################
#heritageのデータ
#0 name
$heritage_name = 0;
#1 area
$country = 1;
#2 subarea
$area = 2;
#3 n
$ido = 3;
#4 e
$keido = 4;
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

#CSV読み込み

$inputfile="C:/Users/sayak/work/heritage_list/data/all_wiki.csv";
$i=0;
$j=0;
$aflg==0;

open(IN,$inputfile) || die "$!";

while(<IN>){
	chomp;
	@list = split(/,/);
	foreach(@list){
		$_ =~ s/^\s*//;
		if($j==0){
			$_ =~ tr/^\"//d;
			$heritage[$i][$heritage_name]=$_;
		}elsif(/[0-9,\.]+..[N,S]\s[0-9,\.]+..[W,E]/){
			#@area = split(/\s/);
			#国名部分を取得
			$_ =~/([A-Z][a-z]+(\s[A-Z][a-z]+)*)/;
			$heritage[$i][$country] = $1;
			#緯度経度部分を取得
			$_ =~ /([0-9,\.]+)..[N,S]\s([0-9,\.]+)..[W,E]/;
			$heritage[$i][$ido] = $1;
			$heritage[$i][$keido] = $2;
			$aflg=1;
		}elsif(/Cultural|Natural|Mixed/){
			@class = split(/\(/);
			foreach $roman (@class){
				chop($roman);
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
			#クラス表示がないところを０に
			for($k=$c1; $k<=$c10; $k++){
				if($heritage[$i][$k]!=1){$heritage[$i][$k]=0;}
			}
			$aflg=1;
		}elsif($aflg==0 && $_ =~ /[A-Za-z]/){
			$_ =~ tr/^\"||\;||\*||\)||\(//d;
			$heritage[$i][$area]= $heritage[$i][$area] . ", " . $_;
		}
		$j++;
	}
	$heritage[$i][$area] =~ s/^((\,\s*)*)//;
	$i++;
	$j=0;
	$aflg=0;
}
close(IN);

#sql用にクオーテーションをエスケープ
for($a=0; $a<3; $a++){
	for($b=0; $b<$i; $b++){
	if ($heritage[$b][$a] =~ /\'/){
		$heritage[$b][$a] =~ s/\'/\'\'/g;
	}
	$heritage[$b][$a] ='\'' . $heritage[$b][$a] . '\'';
	}
}

#国名や緯度経度が正しくなさそうな行番号を配列damenumに記憶
for($j=0; $j<$i; $j++){
	if($heritage[$j][0] !~ /[A-Za-z]/||$heritage[$j][1] !~ /[A-Za-z]/||$heritage[$j][3] !~ /[0-9]/||$heritage[$j][4] !~ /[0-9]/){
		push(@damenum,$j);
	}
}

#もう一度ファイルを読み、正しくなさそうなデータを別に表示して配列から消す
$i=0;
$j=0;
open(IN,$inputfile) || die "$!";
while(<IN>){
	chomp;
	if($damenum[$j]==$i){
		print "INSERT INTO world_heritage VALUES(" . join(", ", @{$heritage[$i]}) . ");\n";
		print;
		print "\n\n";
		delete(@heritage[$i]);
		$j++;
	}
	$i++;
}
close($buff);

print "------ $j error -------------------------\n\n";

#正しそうなデータをINSERTINTOで出力
foreach (@heritage){
	if(@{$_}){
		print "INSERT INTO world_heritage VALUES(" . join(", ", @{$_}) . ");\n";
		#jをカンマで横に並べてi行表示
	}
}

#end