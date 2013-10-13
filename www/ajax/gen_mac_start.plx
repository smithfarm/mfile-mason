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
use Logger::Syslog;
use mfile_init;

sub gen_mac {

   my $a = shift @_;      # get argument, which is assumed to be an integer
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

sub mac_exists {
   my $dbh = shift;
   my $mac = shift;

   my ($sql, $sth);
   $sql = "SELECT id FROM mac_addresses WHERE address LIKE ?";
   $sth = $dbh->prepare($sql);
   # should check $sth here
   debug("Looking up randomly generated MAC address $mac");
   if ( $sth->execute($mac) ) {
      my $id = $sth->fetchrow_array();
      if ($id) {
         debug("Found something; let's try again.");
         return 1;
      } else {
         debug("MAC not found in DB.");
         return 0;
      }
   } else {
      # ERROR
      error("SELECT query failed in mac_exists()");
      # FATAL ERROR - THROW EXCEPTION
      return "INTERNAL ERROR in mac_exists()";
   }
}

my $Global = $mfile_init::Global;
my $ceiling = 16*16*16*16*16*16;   # 16^6

# generate random MAC addresses until we find one that isn't already
# in the DB
my $mac;
do {
   my $random = int( rand($ceiling) );
   $mac = gen_mac($random);
} while ( mac_exists($Global->{'dbh'}, $mac) );

my %result = ('result' => $mac);
my $json_text = encode_json \%result;
print $json_text;
</%perl>
