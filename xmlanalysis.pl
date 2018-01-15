#!/usr/bin/perl
use Encode;
use utf8;
# ���W���[���̓ǂݍ��݂ƃI�u�W�F�N�g�̐���
use XML::Simple;
# XML::Simple���W���[���̓ǂݍ���
use Data::Dumper;
# Data�\���\���p���W���[���̓ǂݍ���
$xml = XML::Simple->new;

# XML�t�@�C���̃p�[�X
$data = $xml->XMLin('data.xml');

###############
#id_number image��http�Ɏg����ID�A������
#image_url
#region �n��
#states �����A�J���}��؂�̕�����
#http_url
#latitude
#longitude
#categoly Cultural,Natural,Mixed
#criteria_txt '(ii)(iii)(iv)(vi)'
#location ���Ȃǂ̏������G���A
#short_description
#long_description
#
#�ȉ��悭�킩��Ȃ�
#'site' => "Qhapaq \x{d1}an, Andean Road System",
#'iso_code' => 'ar,bo,cl,co,ec,pe',
#'historical_description' => {},
#'transboundary' => '1',
#'date_inscribed' => '2014',
#'justification' => {},
#'secondary_dates' => {},
#'revision' => '0'
###############

#��̓f�[�^�̎Q�Ƃ̎d��
#$heritage_ref = $$data{row}->[1009];
#print %$heritage_ref{'site'};


#################
#heritage�̃f�[�^
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


#���ۂɕK�v�ȃf�[�^���Q�Ƃ��A���`���A�񎟌��z��heritage�Ɋi�[
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
	#�N���X�\�����Ȃ��Ƃ�����O��
	for($k=$c1; $k<=$c10; $k++){
		if($heritage[$i][$k]!=1){$heritage[$i][$k]=0;}
	}
	$i++;
}
#sql�p�ɃN�I�[�e�[�V�������G�X�P�[�v
for($a=0; $a<5; $a++){
	for($b=0; $b<$i; $b++){
	if ($heritage[$b][$a] =~ /\'/){
		$heritage[$b][$a] =~ s/\'/\'\'/g;
	}
	$heritage[$b][$a] ='\'' . $heritage[$b][$a] . '\'';
	}
}

#���������ȃf�[�^��INSERTINTO�ŏo��
foreach (@heritage){
	if(@{$_}){
		print "INSERT INTO world_heritage VALUES(";
		print encode('utf-8', join(", ", @{$_}));
		print ");";
		print"\n";
		#j���J���}�ŉ��ɕ��ׂ�i�s�\��
	}
}

#end