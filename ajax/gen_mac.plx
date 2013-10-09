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

my $ceiling = 16*16*16*16*16*16;   # 16^6
my $random = int( rand($ceiling));
my $retval = "MAC: " . gen_mac($random);
my %result = ('result' => $retval);
my $json_text = encode_json \%result;
print $json_text;
</%perl>
