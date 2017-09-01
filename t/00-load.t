#!perl -T
use 5.008;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Net::LDAP::Migrate' ) || print "Bail out!\n";
}

diag( "Testing Net::LDAP::Migrate $Net::LDAP::Migrate::VERSION, Perl $], $^X" );
