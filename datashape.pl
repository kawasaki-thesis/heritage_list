#!/usr/bin/perl
use Encode;
use utf8;

#CSV�ǂݍ���

$inputfile="C:/Users/sayak/work/heritage_list/data/EasternAsia_wiki.csv";
$i = 0;

open(IN,$inputfile) || die "$!";

while(<IN>){
	chomp;
	@list = split(/,/);
	foreach(@list){
		print "$_\n";
	}
	$i++;
=pod
	@list = split(/,/);
	
	if($list[1] =~ /NN|VV|JJ|NP/){
		$heritage[$i][$j] = $list[2];
		$j++;
	}
=cut
}
close(IN);



#�R�[�p�X��W���o��
foreach (@heritage){
	print "(" . join(", ", @{$_}) . ")\n";
	#j���J���}�ŉ��ɕ��ׂ�i�s�\��
}

#end