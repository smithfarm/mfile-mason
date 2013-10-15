<%args>
$server
</%args>

<%perl>
# AJAX component for LDAP server ping test
use JSON;
use Net::Ping::External qw(ping);
use Logger::Syslog;

logger_prefix("MFILE");

my $alive = ping(host => $server, timeout => 2);
my $retval = $alive ? "reachable" : "not reachable";
my %result = ('result' => $retval);
my $json_text = encode_json \%result;
print $json_text;
</%perl>
