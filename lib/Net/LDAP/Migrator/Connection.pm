package Net::LDAP::Migrator::Connection;

################################################################################
# imports
################################################################################

# pragma
use 5.8.8;
use strict;
use warnings;

# core modules
use Exporter 'import';

# external modules
use Net::LDAP;

# internal modules
use Net::LDAP::Migrator::ArgumentCollection;
use Net::LDAP::Migrator::Utility;

################################################################################
# exports
################################################################################

our %EXPORT_TAGS = (
    'sub' => [qw(connection)]
);

Exporter::export_tags(keys %EXPORT_TAGS);

################################################################################
# variables
################################################################################

my $connection = Net::LDAP->new(args->server_uri) || error "Unable to connect to ".args->server_uri.": $@\n";
my $connected = 0;

################################################################################
# operations
################################################################################

my $resp;

if (defined(my $dn = args->bind_dn)) {
    my $pw;
    unless (defined($pw = args->bind_pw)) {
        $pw = get_input('prompt' => "Binding password", 'mode' => 'password');
    }
    $resp = $connection->bind($dn, 'password' => $pw);
} else {
    $resp = $connection->bind();
}

if ($resp->code) {
    error "Binding failed: ".$resp->error."\n";
}

$connected = 1;

################################################################################
# subroutines
################################################################################

sub connection {
    return $connection;
}

END {
    if ($connected) {
        my $res = $connection->unbind();
        if ($res->code) {
            warn "Failed to close server session: ".$resp->error."\n";
        }
    }
}

return 1;
