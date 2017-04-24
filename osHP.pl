require "ssh_base.pl";
require "cfg_base.pl";
our $gSshConn;
sub freeMem{       

					my $channel=$gSshConn->channel();
  				$channel->exec("free|grep Mem");
					my $buf;
					$buf=<$channel>;
					@g1 = map { split /\s+/ } $buf;
					##print @g1[1];
					$channel->close;
		      return @g1[1],@g1[2],@g1[3],@g1[6]
 }

sub bdf{      
	        my $channel=$gSshConn->channel(); 
  				$channel->exec("bdf");
					my $buf;
					while (<$channel>) 
					{
						$buf=$_;
						next if( $buf=~/^Filesystem/);
						@g1 = map { split /\s+/ } $buf;
						print "@g1[5],@g1[3],@g1[1]\n";
					}
					$channel->close;
 }
 
sub swapinfo{      
	        my $channel=$gSshConn->channel(); 
  				$channel->exec("swapinfo");
					my $buf;
					while (<$channel>) 
					{
						$buf=$_;
						if( $buf=~/^memory/){
							@g1 = map { split /\s+/ } $buf;
							return @g1[1],@g1[2];
						}
					}
					$channel->close;
 }
 
 
 
 
 
 
 
 
 
 
		 my ($fl,$IP,$OS,$user,$passwd)=getHostByName("BSSZJ_OLD");
		if( $fl ){
				$gSshConn=loginSSH2($IP,$user,$passwd);
				
			}
		##	my($total,$used,$free,$cache)=freeMem;
  ##		print "$total,$used,$free,$cache";

		##	bdf;
			swapinfo;
		  
		  $gSshConn->disconnect;

 