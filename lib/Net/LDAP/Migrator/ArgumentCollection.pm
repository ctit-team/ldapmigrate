package Net::LDAP::Migrator::ArgumentCollection;

################################################################################
# imports
################################################################################

# pragma
use 5.8.8;
use strict;
use warnings;

# core modules
use Cwd;
use Exporter qw(import);
use Getopt::Long;
use Pod::Usage;

################################################################################
# exports
################################################################################

our %EXPORT_TAGS = (
    'const'   => [qw(OPERATION_DOWN OPERATION_UP)],
    'sub'     => [qw(args)]
);

Exporter::export_tags(keys %EXPORT_TAGS);

################################################################################
# constants
################################################################################

sub OPERATION_DOWN()    { 1 }
sub OPERATION_UP()      { 0 }

################################################################################
# variables
################################################################################

my $current = parse();

################################################################################
# methods
################################################################################

sub bind_dn {
    my $self = shift;
    return $self->{'bind-dn'};
}

sub bind_pw {
    my $self = shift;
    return $self->{'bind-pw'};
}

sub mode {
    my $self = shift;
    return $self->{'mode'};
}

sub scripts_dir {
    my $self = shift;
    return $self->{'scripts'};
}

sub server_uri {
    my $self = shift;
    return $self->{'server'};
}

################################################################################
# subroutines
################################################################################

sub args {
    return $current;
}

sub mode_converter {
    my $mode = shift;
    return OPERATION_UP unless defined $mode;
    $mode = lc $mode;

    if ($mode eq 'up') {
        return OPERATION_UP;
    } elsif ($mode eq 'down') {
        return OPERATION_DOWN;
    } else {
        die "Invalid mode: $mode\n";
    }
}

sub parse {
    # setup allowable arguments
    my @desc = (
        'bind-dn=s',
        'bind-pw=s',
        'help',
        'mode=s',
        'server=s'
    );

    # construct collection default values
    my $args = bless {
        'mode' => OPERATION_UP,
        'server' => 'ldap://localhost'
    };

    # setup value converters
    my %converters = (
        'mode' => \&mode_converter
    );

    # parse
    my %values;

    GetOptions(\%values, @desc) || exit 1;

    if ($values{'help'}) {
        pod2usage(
            -message => "Migrate LDAP database to difference version.\n",
            -exitval => 0,
            -verbose => 1,
            -output => \*STDOUT,
            -input => __FILE__
        );
    }

    # transform values
    while (my ($name, $val) = each %values) {
        $args->{$name} = defined($_ = $converters{$name}) ? $_->($val) : $val;
    }

    # scripts location
    if (scalar(@ARGV)) {
        $args->{'scripts'} = $ARGV[0];
    } else {
        $args->{'scripts'} = cwd();
    }

    return $args;
}

return 1;

__END__

=head1 NAME

ldapmigrate - Migrate LDAP database to difference version.

=head1 SYNOPSIS

ldapmigrate [OPTION]... [SCRIPTS]

=head1 OPTIONS

=over 8

=item B<--bind-dn DN>
DN to bind. Using anonymous binding if not provided.

=item B<--bind-pw PW>
Password for bind-dn. It will prompt for this when not provided.

=item B<--help>
Print this help message and exits.

=item B<--mode MODE>
Mode of operation, either up or down. Defaults is up.

=item B<--server URI>
URI of the target server. Default is ldap://localhost.

=back

=head1 ARGUMENTS

=over 8

=item B<SCRIPTS>
Path of directory contains migration scripts. Default is current directory.

=back

=cut
