package MFILE;

sub lookup_user {
   my $dbh = shift;
   my $name = shift;

   my ($id, $sql, $sth);
   $sql = "SELECT id FROM users WHERE name = ?";
   $sth = $dbh->prepare($sql);
   # should check $sth here
   Logger::Syslog::debug("Attempting to look up user $name in local db");
   if ( $sth->execute($name) ) {
      $id = $sth->fetchrow_array();
      if ($id) {
         Logger::Syslog::debug("Found something; looks like $name has id $id");
      } else {
         Logger::Syslog::debug("User $name not found in local db");
      }
   } else {
      $id = undef;
      Logger::Syslog::error("SELECT failed on user $name: " . $DBI::errstr);
   }
   return $id;
}

1;
