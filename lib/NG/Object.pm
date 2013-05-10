package NG::Object;

use strict;
use warnings;
use Data::Dumper qw(Dumper);

sub new {
    my $pkg = shift;
    return bless {}, $pkg;
}

sub dump {
    my $self = shift;
    return Dumper($self);
}

sub meta {
    { attrs => [], methods => ['dump'] }
}

1;
