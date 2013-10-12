<%perl>
# AJAX component to let server know user is logged out
use JSON;
use Logger::Syslog;
use mfile_init;

logger_prefix("MFILE");

my $retval;
if (mfile_init::logout()) {
   $retval = 'success';
} else {
   $retval = 'failed to logout user on server';
}

# return result to server
my %result = ('result' => $retval);
my $json_text = encode_json \%result;
print $json_text;
</%perl>
