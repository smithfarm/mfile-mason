<%perl>
# AJAX component to let server know user is logged out
use JSON;

our %Global;

delete $Global{'username'};
delete $Global{'userid'};

# return result to server
my $retval;
$retval = 'success';
my %result = ('result' => $retval);
my $json_text = encode_json \%result;
print $json_text;
</%perl>
