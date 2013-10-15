package MFILE;

use Logger::Syslog;

sub lookup_user {
   my $dbh = shift;
   my $name = shift;

   # Database lookup
   debug("Attempting to look up user $name in local db");
   my ($id, $sql, $sth);
   $sql = "SELECT id FROM users WHERE name = ?";
   $sth = $dbh->prepare($sql);
   if ( $sth->execute($name) ) {
      $id = $sth->fetchrow_array();
      if ($id) {
         debug("Found something; looks like $name has id $id");
      } else {
         debug("User $name not found in local db");
      }
   } else {
      $id = undef;
      error("SELECT failed on user $name: " . $DBI::errstr);
   }
   return $id;
}

1;
