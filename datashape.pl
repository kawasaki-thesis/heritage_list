#!/usr/bin/perl
use Encode;
use utf8;

#binmode(STDOUT,":encoding(utf-8)");

#�f�[�^�̃t�@�C�������N���X���i�{�Ԃ�10
$fnum=10;

#�e�t�@�C�����疼���A�ŗL�����A�����A�`�e���𒊏o���Ċi�[
for($i=0; $i<$fnum; $i++){
	$j=0;
	#$inputfile="C:/Users/sayak/work/datashape/data/test" . $i . ".txt";
	$inputfile="C:/Users/sayak/work/datashape/data/class" . ($i+1) . ".txt";
	
	open(IN,$inputfile) || die "$!";
	#binmode(IN,":encoding(euc-jp)");
	
	while(<IN>){
		chomp;
		@list = split(/\t/);
		
		if($list[1] =~ /NN|VV|JJ|NP/){
			$words[$i][$j] = $list[2];
			$j++;
		}
	}
	close(IN);
}

#�N���X���Ƃ̃��[�h���X�g���A���[�h���ƂɃN���X�]�������悤�ɕό`
for($i=0; $i<$fnum; $i++){
	for($j=0; $j<=$#{$words[$i]}; $j++){
		$flag=0;
		foreach(@corpus){
			if(@{$_}[0] eq $words[$i][$j]){
				$flag=1;
				@{$_}[($i+1)]++;
				break;
			}
		}
		if($flag==0){
			$str=$words[$i][$j];
			push(@corpus, [$str,0,0,0,0,0,0,0,0,0,0]);
			$corpus[$#corpus][($i+1)]++;
		}
	}
}

#�]���l�𐳋K��
foreach (@corpus){
	@{$_}[0]='\'' . @{$_}[0] . '\'';
	$sum=0;
	for($i=0; $i<10; $i++) {$sum+=@{$_}[$i+1];}
	for($i=0; $i<10; $i++) {@{$_}[$i+1]=@{$_}[$i+1]/$sum;}
}

#�R�[�p�X��W���o��
foreach (@corpus){
	print "(" . join(", ", @{$_}) . ")\n";
	#j���J���}�ŉ��ɕ��ׂ�i�s�\��
}

#end