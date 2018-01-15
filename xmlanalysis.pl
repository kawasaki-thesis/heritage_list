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


#���ۂɕK�v�ȃf�[�^���Q�Ƃ��A���`���A�񎟌��z��heritage�Ɋi�[
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
	#�N���X�\�����Ȃ��Ƃ�����O��
	for($k=$c1; $k<=$c10; $k++){
		if($heritage[$i][$k]!=1){$heritage[$i][$k]=0;}
	}
	$i++;
}


#���������ȃf�[�^��INSERTINTO�ŏo��
foreach (@heritage){
	if(@{$_}){
		#print "INSERT INTO world_heritage VALUES(";
		print join(", ", @{$_});
		#print ");"
		print"\n";
		#j���J���}�ŉ��ɕ��ׂ�i�s�\��
	}
}

#end