<%perl>
#
# gen_mac.plx
#
# Generate a random number between 0 and 16^6, print it out in decimal
# and hexadecimal, and then make a MAC address out of it.
#
# 20130616 ncutler
# 20131009 ncutler (adapted for use with HTML::Mason)

use JSON;
use mfile_init;

sub gen_mac {

   my $a = shift;      # get argument, which is assumed to be an integer

   die if ($a < 0);                     # bounds check
   die if ($a > (16*16*16*16*16*16));   # bounds check
   my ($a3, $a2, $a1);    # declare helper variables

   $a3 = int($a/(16*16*16*16));
   $a = $a - $a3 * (16*16*16*16);
   $a2 = int($a/(16*16));
   $a = $a - $a2 * (16*16);
   $a1 = $a;

   return sprintf("00:00:1b:%02x:%02x:%02x", $a3, $a2, $a1);
}

my $Global = $mfile_init::Global;
# Insert a dummy record into mac_addresses table
my ($sql, $sth);
$sql = "INSERT INTO mac_addresses (address, owner_id) VALUES ('000dummy', 0)";
$sth = $Global->{'dbh'}->prepare($sql);
# should check $sth here
debug("Attempting to insert dummy record into MAC address db");
if ( $sth->execute ) {
   # success
   info("Dummy record inserted into MAC address db");
} else {
   # failure
   error("INSERT failed on dummy MAC address: " . $DBI::errstr);
   # TERMINATE - FATAL ERROR
}

# Fetch the dummy record to get its id
my $id;
$sql = "SELECT id FROM mac_addresses WHERE address = '000dummy'";
$sth = $Global->{'dbh'}->prepare($sql);
# should check $sth here
debug("Attempting to look up id of dummy record in MAC address db");
if ( $sth->execute ) {
   $id = $sth->fetchrow_array();
   if ($id) {
      debug("Found something; looks like dummy MAC address has id $id");
   } else { 
      error("Dummy MAC address not found in local db");
      # FATAL ERROR - THROW EXCEPTION
   }
} else {
   $id = undef;
   error("SELECT failed on dummy MAC address: " . $DBI::errstr);
   # FATAL ERROR - THROW EXCEPTION
}

# Generate the MAC address
my $mac = gen_mac($id);

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

# Return the generated MAC address to the client
my $retval = "MAC: $mac";
my %result = ('result' => $retval);
my $json_text = encode_json \%result;
print $json_text;
</%perl>
