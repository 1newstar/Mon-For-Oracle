require "ssh_base.pl";
require "cfg_base.pl";
sub  freeMem{       
		my @mem=();
					my $channel=$gSshConn->channel();
  				$channel->exec("free|grep Mem ");
					my $buf;
					$buf=<$channel>;
					@g1 = map { split /\s+/ } $buf;
					$channel->close;
					
					
					my @tRow=("Free",@g1[3]);
					push @mem , \@tRow;
					my @tRow=("Used",@g1[2]);
					push @mem , \@tRow;		
					my @tRow=("PctUsed",@g1[2]/@g1[1]*100);
					push @mem , \@tRow;					
		      return \@mem;
 }

sub meminfo{       
          
          %tmpInfo;
					my $channel=$gSshConn->channel();
  				$channel->exec("cat /proc/meminfo");
					my $buf,$tmp;
					while (<$channel>) 
					{
						$buf=$_;
						next if( $buf=~/^Filesystem/);
						##@g1 = map { split /:/ } $buf;
						@g1=split(/:/,$buf); 
						$tmp=@g1[1];
						$tmp=~s/kB//;
				##		$tmp=~s/\s+//d;
						$tmpInfo{@g1[0]}=$tmp;
						print "@g1[0],$tmp\n";
					}
					##print @g1[1];
					$channel->close;
		      return @tmpInfo;
 }



sub df{      
		my @fs=();
	        my $channel=$gSshConn->channel(); 
  				$channel->exec("df -k");
					my $buf;
					while (<$channel>) 
					{
						$buf=$_;
						next if( $buf=~/^Filesystem/);
						@g1 = map { split /\s+/ } $buf;
						$pct=@g1[4];
						$pct=~ s/[\%]//;
                                                my @tRow=(@g1[5],$pct);
                                                push @fs , \@tRow;
					}
					$channel->close;
		return \@fs;
 }


## my $gSshConn;

##		my ($fl,$IP,$OS,$user,$passwd)=getHostByName("exam1");
##
##		$gSshConn=loginSSH2($IP,$user,$passwd);
##		my @tmpfs=&df;
##    foreach my $row (@tmpfs){
##   print "$row->[0],$row->[1]\n";
##		}
##		  
##		  $gSshConn->disconnect;
##
 
 
return 1; 
 
 
 
 
 
 
 

 
