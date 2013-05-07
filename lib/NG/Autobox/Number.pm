package NG::Autobox::Number;
use NG::Array;

sub to {
    return NG::Array->new( $_[0] .. $_[1] );
};

1;
