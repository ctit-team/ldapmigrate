package version1;

# pragma
use strict;
use warnings;

# external modules
use Net::LDAP::LDIF;
use Net::LDAP::Migrator::Connection;
use Net::LDAP::Migrator::Utility;

# open data section
my $ldif = Net::LDAP::LDIF->new(\*DATA);

while (!$ldif->eof()) {
    # read entry
    my $entry = $ldif->read_entry();
    if (defined(my $error = $ldif->error)) {
        error $error;
    }

    # add
    my $res = connection->add($entry);
    error('Failed to add '.$entry->dn.': '.$res->error) if $res->code;
}

return 1;

__DATA__

dn: ou=People,dc=example,dc=com
objectClass: top
objectClass: organizationalUnit
ou: People
