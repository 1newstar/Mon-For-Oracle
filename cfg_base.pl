use File::Basename;
use XML::Simple;


our $gLogLevel=0;


sub getSqlByName{
	my ( $sqlName ) = @_;
	my $xmlfile = dirname($0) . "/cfg/sql.xml";
		if (-e $xmlfile)
		{
		    my $xmlFA = XML::Simple->new(ForceArray => 1);
		    my $sql_XMLin = $xmlFA->XMLin($xmlfile);
		    # print output
		    my @allsqls = @{$sql_XMLin->{"SQLBLOCK"}};
		    foreach my $SQLBLOCK (@allsqls)
		    {
		      if( $SQLBLOCK->{"sqlName"} eq $sqlName )
		      {
							return (1,$SQLBLOCK->{"sqltxt"}[0],$SQLBLOCK->{"sqltype"},$SQLBLOCK->{"sqlbinds"});
		      }
		    }    
		}
		return (0);
}

sub getHostByName{
	my ( $hostName ) = @_;
		if (-e $xmlfile)
		{   
		    my $xmlFA = XML::Simple->new(ForceArray => 1);
		    my $sql_XMLin = $xmlFA->XMLin($xmlfile);
		    # print output
		    my @allXML = @{$sql_XMLin->{"Host"}};
		    foreach my $blk (@allXML)
		    {
		      if( $blk->{"hostName"} eq $hostName )
		      {
							return (1,$blk->{"IP"},$blk->{"OS"},$blk->{"User"}[0],$blk->{"Passwd"}[0]);
		      }
		    }    
		}
		return (0);
}

sub getDBByName{
	my ( $TNSName ) = @_;
		if (-e $xmlfile)
		{   
		    my $xmlFA = XML::Simple->new(ForceArray => 1);
		    my $sql_XMLin = $xmlFA->XMLin($xmlfile);
		    # print output
		    my @allXML = @{$sql_XMLin->{"DB"}};
		    foreach my $blk (@allXML)
		    {
		      if( $blk->{"TNSName"} eq $TNSName )
		      {
							return (1,$blk->{"DBUser"}[0],$blk->{"DBPasswd"}[0],$blk->{"hostName"},$blk->{"SysDBA"});
		      }
		    }    
		}
		return (0);
}

sub logger{
	print @_;
        print "\n";
}



return 1;
