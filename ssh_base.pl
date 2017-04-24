###ppm install http://www.sisyphusion.tk/ppm/Net-SSH2.ppd
##ppm install http://www.sisyphusion.tk/ppm/Net-SFTP-Foreign-Backend-Net_SSH2.ppd
##install NET::SFTP

use Net::SSH2;
use Net::SSH2::SFTP;
use Net::SFTP::Foreign;


sub loginSSH2{
 my ( $host, $user, $passwd ) = @_;

 my $ssh2 = Net::SSH2->new();
       $ssh2->connect("$host") or die "$!";
   
    if ( $ssh2->auth_password( "$user", "$passwd" ) ) {
        return $ssh2;
      }
 }
sub sftpGet{
 my ( $host, $user, $passwd,$fileName ) = @_;
my $sftp = Net::SFTP::Foreign->new($host, user => $user, password => $passwd, backend => Net_SSH2);
$sftp->die_on_error("Unable to connect to remote host");

$sftp->get($fileName);
$sftp->die_on_error("Unable to copy file");

}
 
sub sftpPut{
 my ( $host, $user, $passwd,$fileName ,$remoteFile) = @_;
my $sftp = Net::SFTP::Foreign->new($host, user => $user, password => $passwd, backend => Net_SSH2);
$sftp->die_on_error("Unable to connect to remote host");

$sftp->put($fileName,$remoteFile);
$sftp->die_on_error("Unable to copy file");

}

 
##sshMon;
##sftpGet("192.168.1.250","root","welcome","/root/hs_err_pid14801.log");
##sftpPut("192.168.1.250","root","welcome","./hs_err_pid14801.log","/tmp/a.err");
return 1;
