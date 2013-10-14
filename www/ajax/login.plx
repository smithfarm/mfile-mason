<%perl>
# AJAX component for LDAP authentication
use JSON;
use CGI;
use DBI;
use Net::LDAP;
use Net::LDAP::Filter;
use Logger::Syslog;
use MFILE;

logger_prefix("MFILE");

sub _authenticate_LDAP {

   my $user = shift;
   my $passwd = shift;

   if ($passwd) {
      info("Password is non-empty");
   } else {
      info("Password is empty");
   }

   # YIKES YIKES YIKES YIKES YIKES YIKES YIKES !!
   # get rid of this before going into production
   # ********************************************
   if ($user eq 'smithfarm' or $user eq 'ncutler' or $user eq 'demo') {
      info("User is $user -- bypassing LDAP authentication.");
      return "success";
   }

   my $server = $Global{'LdapServer'};
   my $base = $Global{'LdapBase'};
   my $filter = $Global{'LdapFilter'};

   debug("Attempting connection to LDAP server $server");
   my $ldap = Net::LDAP->new( $server ) or return "$@";
   
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

sub _authenticate_DB {
   my $user = shift;
   my $passwd = shift;

   if ($passwd) {
      info("Password is non-empty");
   } else {
      info("Password is empty");
   }

   # Look up the user in the DB and if they are an admin, let them in
   # without checking the password
   my ($sql, $sth);
   $sql = "SELECT admin FROM users WHERE name = ?";
   $sth = $Global{'dbh'}->prepare($sql);
   # should check $sth here
   debug("Attempting to look up admin field for user $user");
   if ( $sth->execute($user) ) {
      my $admin = $sth->fetchrow_array();
      debug("Value of admin field is $admin");
      if ($admin) {
         debug("Found something; looks like this user is an admin");
	 return "success";
      } else {
         debug("Found something, but looks like this user is not an admin");
	 return "bad credentials";
      }
   } else { 
      error("SELECT query failed in _authenticate_DB");
      # FATAL ERROR - THROW EXCEPTION
      return "INTERNAL ERROR in _authenticate_db";
   }
}

# log user in
sub _update_userdb {

   my $name = shift;

   my ($sql, $sth);
   my $id = MFILE::lookup_user($Global{'dbh'}, $name);

   # If user not found, add him/her to the db
   if (! $id) {
      $sql = "INSERT INTO users (name, admin, disabled, created) VALUES (?, 0, 0, NOW())";
      $sth = $Global{'dbh'}->prepare($sql);
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
      $id = MFILE::lookup_user($Global{'dbh'}, $name);
   }

   # Update the last_login field
   $sql = "UPDATE users SET last_login = NOW() WHERE id = ?";
   $sth = $Global{'dbh'}->prepare($sql);
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

   return $id;
}

#******
# MAIN
#******

# Get POST parameters
my $cgi = CGI->new;
my $user = $cgi->param("nam");
info("Username is '$user'");
my $passwd = $cgi->param("pwd");
my $userid;

# Sanity check
if (not exists $Global{'dbh'}) {
   die "MFILE: Globals not loaded properly";
}

# Authenticate the user
my $retval; 
if ($Global{'LdapEnable'} eq 'yes') {
   $retval = _authenticate_LDAP($user, $passwd);
   if ($retval ne 'success') {
      info("LDAP authentication failed ($retval)");
   }
} else {
   info("LDAP disabled. Authenticating against local user DB.");
   $retval = _authenticate_DB($user, $passwd);
}

# Update local user database
if ($retval eq "success") {
   info("User $user successfully authenticated");
   # log them in
   $userid = _update_userdb($user);
} else {
   info("Authentication failed for user $user");
   $userid = undef;
}

# Send result back to client
my %result = ('result' => $retval, 'username' => $user, 'userid' => $userid);
my $json_text = encode_json \%result;
print $json_text;
</%perl>
