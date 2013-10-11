<%perl>
#
# gen_mac_finish.plx
#
# If user has accepted the MAC address, update the DB and
# close the transaction. Otherwise rollback.
# (see gen_mac_start.plx)
#
# 20131011 ncutler

use CGI;
use JSON;
use mfile_init;

# Get arguments: $mac is the MAC address
#                $accept is boolean value
my $cgi = CGI->new;
my $mac = $cgi->param("mac");
my $accept = $cgi->param("accept");

# Process the arguments
if ($accept) {
   # If $accept is true, update DB and finalize transaction

   # Update the record with MAC address, username, timestamp, etc.
   $sql = "UPDATE mac_addresses SET address = ?, owner_id = ? WHERE address = '000dummy'";
   $sth = $Global->{'dbh'}->prepare($sql);
   # should check $sth here
   debug("Attempting to update dummy record with MAC $mac and USERID " . $Global->{'userid'});
   if ( $sth->execute($mac, $Global->{'userid'}) ) {
      # success
      info("Dummy record updated");
   } else {
      # failure
      error("UPDATE failed on dummy with MAC $mac and USERID " . $Global->{'userid'} . ": " . $DBI::errstr);
      # TERMINATE - FATAL ERROR
   }
   $sql = "COMMIT WORK";
} else {
   # If $accept is false, rollback the transaction
   $sql = "ROLLBACK WORK";
}

# This finalizes the transaction
$sth = $Global->{'dbh'}->prepare($sql);
$sth->execute;

# Assume success
my $retval = "success";
my %result = ('result' => $retval);
my $json_text = encode_json \%result;
print $json_text;
</%perl>
