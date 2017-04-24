#!/usr/bin/perl -w
#
# ch04/error/ex1: Small example using manual error checking.
### set PATH=D:\OraClient;c:\perl\bin;



use DBI; # Load the DBI module
### Perform the connection using the Oracle driver

require "cfg_base.pl";
sub logonOracle{
		my ( $tns, $user, $passwd,$oraSessMd ) = @_;
		my $timeout=30;
		my $Conn = DBI->connect( "dbi:Oracle:$tns", $user, $passwd, {
		PrintError => 1,
		RaiseError => 0,
		ora_session_mode=>$oraSessMd,
		ora_connect_with_default_signals =>['INT']
		} ) or die "Can't connect to the database: $DBI::errstr\n";
		return $Conn;
}

sub sessionWait{
my ( $tns, $user, $passwd, $oraSessMd) = @_;
my $dbh ;

		$dbh =  logonOracle($tns, $user, $passwd,$oraSessMd);

		$sth = $dbh->prepare( "select event,count(*) cnt from v\$session where WAIT_CLASS not in ( 'Idle','Network') and   event not like 'Streams%' and  event not like 'Space Manager%' group by event order by 2 " );
  	$sth->execute();
		for ( $i = 1 ; $i <= $sth->{NUM_OF_FIELDS} ; $i++ ) {
		  logger ( "Column $i is called $sth->{NAME}->[$i-1]\n");
		}
			
		my $rows = $sth->fetchall_arrayref();
		foreach my $row (@$rows)
		{
			   my ($col1, $col2) = @$row;
			   logger ( "$col1, $col2\n");
			
		}
 
  $dbh->disconnect();
}


sub DoSelect {
my @varss = @_;
    my ($fl,$sqlTxt,$sqlType,$sqlBinds)=getSqlByName($varss[0]);
    if( $fl ){
						$sth = $gDBConn->prepare( $sqlTxt );
						for ( $i = 1 ; $i <= $sqlBinds ; $i++ ) {
						  $sth->bind_param($i,$varss[$i]);
						}
				  	$sth->execute();
				  	if( $gColDisplay ){
					  for ( $i = 1 ; $i <= $sth->{NUM_OF_FIELDS} ; $i++ ) {
						  logger ( "$sth->{NAME}->[$i-1]\t");
						}
						logger ( "\n");
				  }
					my $rows = $sth->fetchall_arrayref();
			  	return (1,$rows);
		  } else { logger ( "Invalid SQL:$fl $sqlTxt\n");};
  
}



 
sub TestGetTns{       
			my ( $tnsName) = @_;
			    my ($fl,$user,$passwd,$hostName,$oraSessMd)=getDBByName("$tnsName");
       if( $fl ){
       	   print "$user,$passwd ,$hostName \n";
      }
 }
 
  

sub getTabAllStats{       
			 my ( $tnsName,$tabName,$owner) = @_;
			 my $timeout=30;
		 
			 my($f1,$user,$passwd,$hostName,$oraSessMd)=getDBByName("$tnsName");
       if( $f1 ){
       	   logger ( "##############$tabName表相关信息############## \n");
				   $gDBConn =  logonOracle($tnsName, $user, $passwd,$oraSessMd);
       	   $gColDisplay=1;
       	   my($f2,$rows)=DoSelect("getTabStats",$tabName,$owner);
       	   ##getSqlTxtBySQLID
       	   if( $f2 )
       	   {
			      	foreach my $row (@$rows)
							{
								logger ( "@$row\n");
							}

       	   }
       	   logger ( "\n");

       	   ($f2,$rows)=DoSelect("getTabCols",$tabName,$owner);
       	   ##getSqlTxtBySQLID
       	   if( $f2 )
       	   {
			      	foreach my $row (@$rows)
							{
								logger ( "@$row\n");
							}

       	   }
						logger ( "\n");
       	   ($f2,$rows)=DoSelect("getIndStats",$tabName,$owner);
       	   ##getSqlTxtBySQLID
       	   if( $f2 )
       	   {
			      	foreach my $row (@$rows)
							{
								logger ( "@$row\n");
							}

       	   }
						logger ( "\n");
       	   ($f2,$rows)=DoSelect("getIndCols",$tabName,$owner);
       	   ##getSqlTxtBySQLID
       	   if( $f2 )
       	   {
			      	foreach my $row (@$rows)
							{
								logger ( "@$row\n");
							}

       	   }
       	   logger ( "##############end############## \n");
       	   $gColDisplay=0;
       		 $gDBConn->disconnect();
      	   
      }

 }
 

return 1 ;
