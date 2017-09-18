package Net::LDAP::Migrator::Utility;

################################################################################
# imports
################################################################################

# pragma
use 5.8.8;
use strict;
use warnings;

# core modules
use Exporter 'import';

################################################################################
# exports
################################################################################

our %EXPORT_TAGS = (
    'io' => [qw(error get_input)]
);

Exporter::export_tags(keys %EXPORT_TAGS);

################################################################################
# subroutines
################################################################################

sub error {
    print STDERR @_;
    exit 1;
}

sub get_input {
    my %opt = @_;

    require Term::ReadKey;

    # set mode according to option
    if ($opt{'mode'} eq 'password') {
        Term::ReadKey::ReadMode('noecho');
    }

    # read input
    if (defined(my $prompt = $opt{'prompt'})) {
        print "$prompt: ";
    }

    my $input = Term::ReadKey::ReadLine(0);
    chomp $input;
    print "\n";

    # restore input mode
    Term::ReadKey::ReadMode('restore');

    return $input;
}

return 1;
