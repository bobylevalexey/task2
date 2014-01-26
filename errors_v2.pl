#!/usr/bin/perl
$file=$ARGV[0]; # folder or file needed to open first
$probility=($ARGV[1]>0)?$ARGV[1]:0.7; #probitity of success
@numbers=(); #array for numbers
$,="\n"; # for accurate printing of array

#wrappers
sub open_file{
	my $r=rand;
	if ($r<$probility){
		return open $_[0],$_[1];	
	}
	die "System error: open_file."
}
sub open_dir{
	my $r=rand;
	if ($r<$probility){
		return opendir $_[0],$_[1];	
	}
	die "System error: open_dir."	
}
sub read_file{
	my $string=readline $_[0];
	my $r=rand;
	if ($r<$probility){
		return $string;	
	}
	die "System error: read_file."	
}
sub read_dir{
	my $file=readdir $_[0];
	my $r=rand;
	if ($r<$probility){
		return $file;	
	}
	die "System error: read_dir."	
}
sub close_file{
	my $r=rand;
	if ($r<$probility){
		return close $_[0];	
	}
	die "System error: close_file."	
}
sub close_dir{
	my $r=rand;
	if ($r<$probility){
		return closedir $_[0];	
	}
	die "System error: close_dir."	
}

sub main{ # recursive function looking for all numbers in file or folder. arguments - name of file or folder 
	my $f;# descriptor of current file.
	my $res=eval{open_dir $f,$_[0]};# try to open as dir
	if ($@ ne ''){ 
		# print $@;
		return 0;# exit if system error occured with open
	}
	if (defined($res)){# if succsseed with open_dir 
		my $counter=0;# variable for checking the end of loop.
		while($counter<5){
			$res=eval{read_dir $f};
			if ($@ ne ''){
				$counter++;# if error occured 5 times in row then I think that the file is failed
				# print $@;
			} else {
				if (!defined($res)){
					$counter=5;# stop loop if eof
				} else {
					$counter=0;# reset counter if success
					if (($res ne '.') and ($res ne '..')){
						&main ($_[0].'/'.$res);#recursive call
					}
				}
			}
		}
		$res=eval{close_dir $f};#try to close
		if ($@ ne ''){
			#print $@;
		}
		return 1;#exit function
	}
	my $res=eval{open_file $f,$_[0]};# try to open as file
	if ($@ ne ''){
		# print $@;
		return 0;# exit if system error occured
	}
	if (defined($res)){
		my $counter=0;
		while($counter<5){
			$res=eval{read_file $f};
			if ($@ ne ''){
				$counter++;
				# print $@;
			} else {
				if (!defined($res)){
					$counter=5;
				} else {
					$counter=0;
					if ($res=~/^\s*(\d+)\s*$/){#if number then push it in array
						push @numbers,scalar($1);
					}
					# print $res;
				}
			}
		}
		$res=eval{close_file $f};#try to close
		if ($@ ne ''){
			# print $@;
		}
	}
}

main $file;
print sort {$a <=> $b} @numbers;#sort
print "\n";