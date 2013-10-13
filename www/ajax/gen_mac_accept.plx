<%perl>
#
# gen_mac_accept.plx
#
# If user has accepted the MAC address, update the DB
# (see gen_mac_start.plx)
#
# 20131011 ncutler

use CGI;
use JSON;
use Logger::Syslog;

# Get argument
my $cgi = CGI->new;
my $mac = $cgi->param("mac");
debug("gen_mac_accept.plx called with MAC address $mac and USERID " .  $Global{'userid'}); 

my $retval;
# Insert the MAC address, username, timestamp, etc.
my $sql = "INSERT INTO mac_addresses (address, owner_id) VALUES (?, ?)";
my $sth = $Global{'dbh'}->prepare($sql);
# should check $sth here
debug("Attempting to insert MAC $mac with owner USERID " . $Global{'userid'});
if ( $sth->execute($mac, $Global{'userid'}) ) {
   # success
   info("INSERT successful");
   $retval = "success";
} else {
   # failure
   $retval = $DBI::errstr;
   error("INSERT failed on MAC $mac and USERID " . $Global{'userid'} . ": $retval");
}

# Return result to client
my %result = ('result' => $retval);
my $json_text = encode_json \%result;
print $json_text;
</%perl>
