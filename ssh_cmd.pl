require "ssh_base.pl";
require "cfg_base.pl";

sub hanganalyze{       
			my ( $hostName,$sid) = @_;
			    my ($fl,$IP,$OS,$user,$passwd)=getHostByName("$hostName");
       if( $fl ){
		       my  $ssh_conn=loginSSH2($IP,$user,$passwd);
		       my $chan2 = $ssh_conn->channel();
  				$chan2->exec("su - oracle -c \"export ORACLE_SID=$sid ; echo 'oradebug hanganalyze 3 ;' |sqlplus -prelim '/ as sysdba'   \" \n ");
					while (<$chan2>) 
					{
						print $_;
					}
		        $chan2->close;
		        $ssh_conn->disconnect;
      }
 }
 
 