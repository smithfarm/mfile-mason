<%perl>
# AJAX component for LDAP server ping test
use JSON;
use CGI;
use Net::Ping::External qw(ping);
use Logger::Syslog;

logger_prefix("MFILE");

my $cgi = CGI->new;
my $host = $cgi->param("server");
my $alive = ping(host => $host, timeout => 2);
my $retval = $alive ? "reachable" : "not reachable";
my %result = ('result' => $retval);
my $json_text = encode_json \%result;
print $json_text;
</%perl>
