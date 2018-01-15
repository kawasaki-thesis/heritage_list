#!/usr/bin/perl
use Encode;
use utf8;
# モジュールの読み込みとオブジェクトの生成
use XML::Simple;
# XML::Simpleモジュールの読み込み
use Data::Dumper;
# Data構造表示用モジュールの読み込み
$xml = XML::Simple->new;

# XMLファイルのパース
$data = $xml->XMLin('data.xml');

###############
#id_number imageやhttpに使われるID、文字列
#image_url
#region 地域
#states 国名、カンマ区切りの文字列
#http_url
#latitude
#longitude
#categoly Cultural,Natural,Mixed
#criteria_txt '(ii)(iii)(iv)(vi)'
#location 県などの小さいエリア
#short_description
#long_description
#
#以下よくわからない
#'site' => "Qhapaq \x{d1}an, Andean Road System",
#'iso_code' => 'ar,bo,cl,co,ec,pe',
#'historical_description' => {},
#'transboundary' => '1',
#'date_inscribed' => '2014',
#'justification' => {},
#'secondary_dates' => {},
#'revision' => '0'
###############

#解析データの参照の仕方
#$heritage_ref = $$data{row}->[1009];
#print %$heritage_ref{'site'};


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


#実際に必要なデータを参照し、成形し、二次元配列heritageに格納
$list_ref = $$data{row};
$i=0;
for (@$list_ref){
	#print %{$_}{'site'};
	$heritage[$i][$heritage_name] = %{$_}{'site'};
	$heritage[$i][$country] = %{$_}{'states'};
	$heritage[$i][$area] = %{$_}{'location'};
	$heritage[$i][$ido] = %{$_}{'latitude'};
	$heritage[$i][$keido] = %{$_}{'longitude'};
	#criterion
	@class = split(/\(/, %{$_}{'criteria_txt'});
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
	$i++;
}


#正しそうなデータをINSERTINTOで出力
foreach (@heritage){
	if(@{$_}){
		#print "INSERT INTO world_heritage VALUES(";
		print join(", ", @{$_});
		#print ");"
		print"\n";
		#jをカンマで横に並べてi行表示
	}
}

#end