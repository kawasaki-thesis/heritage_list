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
#2 area
$area = 2;
#3 img_url
$img = 3;
#4 description
$txt = 4;
#5 n
$ido = 5;
#6 e
$keido = 6;
#7~16 classflag
$c1=7;
$c2=8;
$c3=9;
$c4=10;
$c5=11;
$c6=12;
$c7=13;
$c8=14;
$c9=15;
$c10=16;
#################


#実際に必要なデータを参照し、成形し、二次元配列heritageに格納
$list_ref = $$data{row};
$i=0;
for (@$list_ref){
	$heritage[$i][$heritage_name] = %{$_}{'site'};
	$heritage[$i][$country] = %{$_}{'states'};
	$heritage[$i][$area] = %{$_}{'region'};
	$heritage[$i][$img] = %{$_}{'image_url'};
	$heritage[$i][$txt] = %{$_}{'short_description'};
	if(%{$_}{'latitude'} =~ /[0-9][0-9][0-9][0-9][0-9][0-9]/){
		$heritage[$i][$ido] = %{$_}{'latitude'};
	}else{
		#print Dumper(%{$_}{'latitude'});
		#print %{$_}{'site'};
		#print " / latitude \n";
		$heritage[$i][$ido] = 'NULL';
		$heritage[$i][$keido] = 'NULL';
	}
	if(%{$_}{'longitude'} =~ /[0-9][0-9][0-9][0-9][0-9][0-9]/){
		$heritage[$i][$keido] = %{$_}{'longitude'};
	}else{
		#print Dumper(%{$_}{'longitude'});
		#print %{$_}{'site'};
		#print " / longitude \n";
		$heritage[$i][$ido] = 'NULL';
		$heritage[$i][$keido] = 'NULL';
	}
	
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
#sql用にクオーテーションをエスケープ
for($a=0; $a<5; $a++){
	for($b=0; $b<$i; $b++){
	if ($heritage[$b][$a] =~ /\'/){
		$heritage[$b][$a] =~ s/\'/\'\'/g;
	}
	$heritage[$b][$a] ='\'' . $heritage[$b][$a] . '\'';
	}
}

#正しそうなデータをINSERTINTOで出力
foreach (@heritage){
	if(@{$_}){
		print "INSERT INTO world_heritage VALUES(";
		print encode('utf-8', join(", ", @{$_}));
		print ");";
		print"\n";
		#jをカンマで横に並べてi行表示
	}
}

#end