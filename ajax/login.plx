<%perl>
# AJAX component for LDAP authentication
use JSON;
use CGI;
use DBI;
use Net::LDAP;
use Net::LDAP::Filter;
use Logger::Syslog;
use mfile_init;

logger_prefix("MFILE");

sub _authenticate {

   my $user = shift;
   my $passwd = shift;
   my $Global = shift;

   if ($passwd) {
      info("Password is non-empty");
   } else {
      info("Password is empty");
   }

   my $server = $Global->{'LdapServer'};
   my $base = $Global->{'LdapBase'};
   my $filter = $Global->{'LdapFilter'};

   debug("Attempting connection to LDAP server $server");
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
      info("Access denied because $user was not found on $server.");
      sleep 3;
      return "bad credentials";
   }

   $mesg = $ldap->bind( "$dn",
                           password => "$passwd",
                      );

   if ($mesg->code == Net::LDAP::LDAP_SUCCESS) {
      info("Access granted to $user");
      return "success";
   } else {
      info("Access denied to $user because of bad password.");
      return "bad credentials";
   }
}

sub _update_userdb {

   my $name = shift;
   my $Global = shift;

   my ($sql, $sth);
   my $id = mfile_init::lookup_user($name);

   # If user not found, add him/her to the db
   if (! $id) {
      $sql = "INSERT INTO users (name, admin, disabled, created) VALUES (?, 0, 0, NOW())";
      $sth = $Global->{'dbh'}->prepare($sql);
      # should check $sth here
      debug("Attempting to insert user $name into local db");
      if ( $sth->execute($name) ) {
         # success
	 info("User $name inserted into local db");
      } else {
         # failure
	 error("INSERT failed on user $name: " . $DBI::errstr);
	 # TERMINATE - FATAL ERROR
      }
      $id = mfile_init::lookup_user($name);
   }

   # User is now logged in for sure 
   debug("Calling mfile_init::login for user $name, USERID $id");
   mfile_init::login($name, $id);
   # error-checking here?

   # Update the last_login field
   $sql = "UPDATE users SET last_login = NOW() WHERE id = ?";
   $sth = $Global->{'dbh'}->prepare($sql);
   # should check $sth here
   debug("Attempting to UPDATE user record for last_login timestamp");
   if ( $sth->execute($id) ) {
      # success
      info("last_login timestamp updated for $name");
   } else {
      # failure
      error("UPDATE failed on user $name: " . $DBI::errstr);
      # TERMINATE - FATAL ERROR
   }
}

# Get POST parameters
my $cgi = CGI->new;
my $user = $cgi->param("nam");
info("Username is '$user'");
my $passwd = $cgi->param("pwd");

# Authenticate the user
my $retval = _authenticate($user, $passwd, $mfile_init::Global);

# Update local user database
if ($retval eq "success") {
   # check if user is in our database and, if not, add them
   _update_userdb($user, $mfile_init::Global);
}

# Send result back to client
my %result = ('result' => $retval);
my $json_text = encode_json \%result;
print $json_text;
</%perl>
