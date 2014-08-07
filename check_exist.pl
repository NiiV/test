#!/usr/local/bin/perl

use strict;
#use warnings;

if ($#ARGV < 2){
	print "Used: check_exist.pl 'extention' 'csv_file' 'start_dir'\n";
	exit(0);
};

print "\n\n---### Results ###---\n\n";

my @files_list;
&get_file_list($ARGV[2], $ARGV[0]);
print "Files founded: ".scalar(@files_list)."\n";

my $file = $ARGV[1];
open(FI,"<$file");
open(FO,">$file.obr");
my $r_cnt=0;
my $a_cnt=0;
my $c_cnt=0;

while (my $str = <FI>){
	$r_cnt++;
	if($str=~m/[0-9]/){
		chomp($str);
		my @spl = split(";",$str);
		
		#    0          1        2       3       4       5          6         7       8       9
		# Varname   Classname   PosX    PosY    PosZ    Dir    SqmStylePos  VecDir  VecUp   IsUnit
		# "CLASSNAME";POSX;POSY;DIR;0.000000;0.000000;1.000000;0.000259;
		# "NonStrategic"5994.7642;9107.3809;0.006;0.000000;0.000000;1.000000;0.000000;
		
		$spl[1]=~s/Land_//; $spl[1]=~s/"//g; $spl[1]=$spl[1];
		
		if($spl[1].".p3d" ~~ @files_list){
			$a_cnt++;
			$spl[2]=$spl[2]+200000; # X-FIX XD
			$str=join(';', '"'.$spl[1].'"', $spl[2], $spl[3], $spl[5], "0.000000", "0.000000", "1.000000", "0.000000;");
			print FO $str."\n";
		}else{
			$c_cnt++;
		};
	};
};

close(FI);
close(FO);
print "Accepted: ".$a_cnt."\n";
print "Cancelled: ".$c_cnt."\n";
print "Rows processed: ".$r_cnt."\n";


sub get_file_list{
	my ($dir, $ext) = @_;
	opendir DIR, $dir or return;
	my @contents = map "$dir\\$_", sort grep !/^\.\.?$/, readdir DIR;
	closedir DIR;
	foreach (@contents)
	{
		if (!-l && -d){
			&get_file_list($_);
		}else{
			if ($_ =~ /$ext$/i){
				$_ =~ s/^.*\\//i; #/
				push(@files_list, $_);
			}
			else { next; }
		}
	}
};

print "\n---###   End   ###---\n\n";
