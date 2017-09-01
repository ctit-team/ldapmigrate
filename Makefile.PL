use 5.008;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Net::LDAP::Migrate',
    AUTHOR           => q{Putta Khuncalee <ultimaweapon@outlook.com>},
    VERSION_FROM     => 'lib/Net/LDAP/Migrate.pm',
    ABSTRACT_FROM    => 'lib/Net/LDAP/Migrate.pm',
    LICENSE          => 'mit',
    PL_FILES         => {},
    EXE_FILES        => ['bin/ldapmigrate'],
    MIN_PERL_VERSION => '5.008',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '0',
    },
    BUILD_REQUIRES => {
        'Test::More' => '0',
    },
    PREREQ_PM => {
        #'ABC'              => '1.6',
        #'Foo::Bar::Module' => '5.0401',
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Net-LDAP-Migrate-*' },
);
