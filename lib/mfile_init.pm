#
# mfile-mason/mfile_init.pm
#
# load configuration parameters from /etc/mfile-mason.conf
# and populate %{$Global}
#
# 20131008 ncutler


package mfile_init;
use parent qw(Exporter);

our @EXPORT = qw($Global lookup_user login logout);
our $Global = {};

use DBI;
use Config::Simple;
use Logger::Syslog;

logger_prefix("MFILE");

# get mfile version number (hardcoded in VERSION file)
sub _get_mfile_version {

   my $Config = shift;

   if ( open my $fh, "<", $Config->{'RootDir'} . "VERSION" ) {
      $Global->{'mfilevernum'} = <$fh>;
      close $fh;
   } else {
      $Global->{'mfilevernum'} = $!;
   }

}

# get MariaDB version number from MariaDB server (and save the connection handle)
sub _get_mariadb_version {

   my $Config = shift;

   my ( $sql, $sth );
   my $result = $Global->{'dbh'} = DBI->connect( 'dbi:mysql:' . $Config->{'DbName'}, 
                                                 $Config->{'DbUsername'}, 
                                                 $Config->{'DbPassword'} );
   if ($result) {
      $sql = "SELECT version();";
      $sth = $Global->{'dbh'}->prepare($sql);
   } else {
      $Global->{'dbvernum'} = "$DBI::errstr\n";
      return;
   }
   if ( $sth->execute ) {
      $Global->{'dbvernum'} = $sth->fetchrow_array();
   } else {
      $Global->{'dbvernum'} = "$DBI::errstr\n";
   }

}

# move LDAP configuration from Config to Global, as Config is
# accessible only from within this package
sub _get_ldap_configuration {

   my $Config = shift;

   $Global->{'LdapEnable'} = $Config->{'LdapEnable'};
   $Global->{'LdapServer'} = $Config->{'LdapServer'};
   $Global->{'LdapBase'} = $Config->{'LdapBase'};
   $Global->{'LdapFilter'} = $Config->{'LdapFilter'};

}

# validate/look up a username in the local db
sub lookup_user {
   my $name = shift;

   my ($id, $sql, $sth);
   $sql = "SELECT id FROM users WHERE name = ?";
   $sth = $Global->{'dbh'}->prepare($sql);
   # should check $sth here
   debug("Attempting to look up user $name in local db");
   if ( $sth->execute($name) ) {
      $id = $sth->fetchrow_array();
      if ($id) {
         debug("Found something; looks like $name has id $id");
      } else {
         debug("User $name not found in local db");
      }
   } else {
      $id = undef;
      error("SELECT failed on user $user: " . $DBI::errstr);
   }
   return $id;
}

# log user in
sub login {
   my $username = shift;
   my $userid = shift;

   debug("Logging in user $username with USERID $userid");
   $Global->{'username'} = $username;
   $Global->{'userid'} = $userid;
}

# log user out
sub logout {
   my $retval;
   if (exists $mfile_init::Global->{'username'}) {
      delete $mfile_init::Global->{'username'};
   }
   if (exists $mfile_init::Global->{'userid'}) {
      delete $mfile_init::Global->{'userid'};
   }

   if ( exists $mfile_init::Global->{'username'} or
        exists $mfile_init::Global->{'userid'} ) {
      $retval = 0;
   } else {
      $retval = 1;
   }
   return $retval;
}

# load configuration parameters from file
sub LoadGlobal {

   my $Config = {};
   my $Global = {};

   # Hopefully, the location of the configuration file is the only
   # thing we will have hard-coded
   Config::Simple->import_from('/etc/mfile-mason.conf', $Config);
   _get_mfile_version($Config);
   _get_mariadb_version($Config);
   _get_ldap_configuration($Config);

   return %$Global;
}
 
1;
