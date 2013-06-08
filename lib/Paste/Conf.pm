package Paste::Conf;

use strict;
use warnings;

use Carp ();

sub get_db_conf_string {
    my ($class, $args) = @_;

    my $dbname = $args->{dbname};
    my $driver = $args->{driver};

    if ($driver !~ /\A\w+\z/) {
        Carp::confess (
            "\$args->{driver} driver is not all alphanumeric stuff. Please fix it."
        )
    }

    return "dbi:${driver}:dbname=${dbname}";
}

1;
