#
# mfile-mason/mfile_init.pm
#
# load configuration parameters from /etc/mfile-mason.conf
# and populate %{$Global}
#
# 20131008 ncutler


package mfile_init;
use parent qw(Exporter);

our @EXPORT = qw($Global);
our $Global = {};

use DBI;
use Config::Simple;

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
