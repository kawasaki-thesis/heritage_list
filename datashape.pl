#!/usr/bin/perl
use Encode;
use utf8;

#CSV読み込み

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



#コーパスを標準出力
foreach (@heritage){
	print "(" . join(", ", @{$_}) . ")\n";
	#jをカンマで横に並べてi行表示
}

#end