<%perl>
# AJAX component to let server know user is logged out
use JSON;
use Logger::Syslog;
use mfile_init;

logger_prefix("MFILE");

if (exists $mfile_init::Global->{'username'}) {
   delete $mfile_init::Global->{'username'};
}
if (exists $mfile_init::Global->{'userid'}) {
   delete $mfile_init::Global->{'userid'};
}

if ( exists $mfile_init::Global->{'username'} or
     exists $mfile_init::Global->{'userid'} ) {
   $retval = 'failed to logout user on server';
} else {
   $retval = 'success';
}

# return result to server
my %result = ('result' => $retval);
my $json_text = encode_json \%result;
print $json_text;
</%perl>
