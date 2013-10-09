<%perl>
# AJAX component for LDAP authentication
use JSON;
use CGI;
use Net::LDAP;
use Net::LDAP::Filter;
use Logger::Syslog;

logger_prefix("MFILE");

sub _authenticate {

   my $Global = shift;

   my $cgi = CGI->new;
   my $user = $cgi->param("nam");
   info("Username is '$user'");
   my $passwd = $cgi->param("pwd");
   if ($passwd) {
      info("Password is non-empty");
   } else {
      info("Password is empty");
   }

   my $server = $Global->{'LdapServer'};
   my $base = $Global->{'LdapBase'};
   my $filter = $Global->{'LdapFilter'};

   my $ldap = Net::LDAP->new( $server ) or die "$@";
   
   if (defined($filter) && ($filter ne "()")) {
       $filter = Net::LDAP::Filter->new(   "(&" .
                                           $filter .
                                           "(uid=$user)" .
                                           ")"
                                       );
   } else {
       die "LDAP Filter invalid or not present.";
   }

   my ($mesg, $entry, $count, $dn);

   info("Running LDAP search on $server with filter ".$filter->as_string);
   $mesg = $ldap->search(
                           base => "$base",
                           scope => "sub",
                           filter => $filter
                        );

   $mesg->code && die $mesg->error;

   $count = 0;
   for $entry ($mesg->entries) {
     $count += 1;
     if ($count == 1) {
         $dn = $entry->dn();
         last;
     }
   }

   if ($count > 0) {
      info("User $user was found on $server!");
   } else {
      info("Sorry. User $user was not found on $server.");
      sleep 3;
      return "bad credentials";
   }

   $mesg = $ldap->bind( "$dn",
                           password => "$passwd",
                      );

   if ($mesg->code == Net::LDAP::LDAP_SUCCESS) {
      info("You're in. Congratulations.");
      return "success";
   } else {
      info("Bad password. Authentication failed.");
      return "bad credentials";
   }
}

my $retval = _authenticate($mfile_init::Global);
my %result = ('result' => $retval);
my $json_text = encode_json \%result;
print $json_text;
</%perl>