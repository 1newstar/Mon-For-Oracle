require "OraSQL.pl"; 
require "linux.pl"; 
use Sys::SigAction qw( set_sig_handler );
use Data::Dumper;
our $gDBConn ;
our $gSshConn;
our $gColDisplay=0;
our $gMsg='';
our $xmlfile='';
our $gMonObj='';

sub checkThreshold
{
	 my ($ckItem,$target, $rows, @cols) = @_; 
	 my %tmpHash ;##############HashTable Of Threshold
	 foreach my $col( @cols )
		{
			$tmpHash{$col->{item} }=$col->{"threshold"};
		}
	 foreach my $row (@$rows)
	 {
	 	if( exists $tmpHash{@$row[0]}  & $tmpHash{@$row[0]} <= @$row[1] )
	 	{
	 		 $gMsg = "Warning:$ckItem $target    ".@$row[0]." is ".@$row[1].",It over threshold  ". $tmpHash{@$row[0]};
			logger ($gMsg) ;

	 	}
				
	 }

}


sub	CMDMon {
	my @varss = @_;  
	if( $varss[0] eq "df" )
	{ 
		my $tmpfs=df();	
		return (1,$tmpfs);
	}
	
	if( $varss[0] eq "freeMem" )
	{ 
		my $tmpfs=freeMem();	
		return (1,$tmpfs);
	}
	
	
	return( 0 );
}


sub checkHost{
	my( $hName ) = @_;
	my($f1,$ip,$os,$user,$passwd )=getHostByName( "$hName");
	if( $f1 ){
		$gSshConn=loginSSH2($ip,$user,$passwd);
	}else{
		return(0);
	}	
	if (-e $xmlfile)
	{   
		    my $xmlFA = XML::Simple->new(ForceArray => 1);
		    my $monXMLin = $xmlFA->XMLin($xmlfile);
		    my @allMons = @{$monXMLin->{"Host"}};
		    foreach my $db (@allMons)
		    {
		      if( $db->{"hostName"} eq $hName )
		      {
						my @mons=@{$db->{"mon"}};
						foreach my $mon( @mons )
						{
							my $tmpCMD= $mon->{"sshCMD"};
							if( ! defined($tmpCMD)) { next ;};
							my($f2,$rows)=CMDMon( "$tmpCMD" );
							## print Dumper($rows );
							my @cols=@{$mon->{"COL"}};
							if( $f2 )
       					   		{
       	    	  						checkThreshold($tmpCMD,$hName,$rows, @cols );
       	   		 				}
						}
		      }
		    }    
	}
	$gSshConn->disconnect();
	return (1);
	
}

sub checkOraDB{
	my ( $hName ) = @_;
	
	
	
	###my $xmlfile = dirname($0) . "/mon.xml";
	if (-e $xmlfile)
	{   
		    my $xmlFA = XML::Simple->new(ForceArray => 1);
		    my $monXMLin = $xmlFA->XMLin($xmlfile);
		    # print output
		    my @allMons = @{$monXMLin->{"DB"}};
		    foreach my $db (@allMons)
		    {
		      if( $db->{"hostName"} eq $hName )
		      {
						my $tnsName =$db->{"TNSName"};
  					my($f1,$user,$passwd,$hostName,$oraSessMd)=getDBByName("$tnsName");
  					if( $f1 ){
	  					 $gDBConn=logonOracle($tnsName, $user, $passwd,$oraSessMd);
				    }else
    				{
    					return (0);
    				}

						my @mons=@{$db->{"mon"}};
						foreach my $mon( @mons )
						{
							my $tmpSQL= $mon->{"sqlName"};
							if( ! defined($tmpSQL)) { next ;};
							my($f2,$rows)=DoSelect( $tmpSQL );
							##print Dumper( $rows );
							my @cols=@{$mon->{"COL"}};
							if( $f2 )
      	    						{
       	    	  						checkThreshold($tmpSQL,$tnsName,$rows, @cols );
       	    						}
						}
						$gDBConn->disconnect();
		      }
		    }    
	}
	return (1);
}

$gMsg='';
$gMonObj=$ARGV[0];
$xmlfile=dirname($0)."/cfg/".$gMonObj.".xml";



eval {
	my $h = set_sig_handler('ALRM',sub{die "TimeOut\n";});
	alarm(10);
	checkHost($gMonObj);
	checkOraDB($gMonObj);
	alarm(0);
}
