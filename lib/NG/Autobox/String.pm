package NG::Autobox::String;
use base 'NG::Object';
use NG::Array;

sub lc      { CORE::lc      $_[0] }
sub lcfirst { CORE::lcfirst $_[0] }
sub uc      { CORE::uc      $_[0] }
sub ucfirst { CORE::ucfirst $_[0] }
sub chomp   { CORE::chomp   $_[0] }
sub chop    { CORE::chop    $_[0] }
sub reverse { CORE::reverse $_[0] }
sub length  { CORE::length  $_[0] }
sub lines   { NG::Array->new( CORE::split '\n', $_[0] ) }
sub words   { NG::Array->new( CORE::split ' ',  $_[0] ) }
sub index   {
    return CORE::index($_[0], $_[1]) if scalar @_ == 2;
    return CORE::index($_[0], $_[1], $_[2]);
}
sub rindex  {
    return CORE::rindex($_[0], $_[1]) if scalar @_ == 2;
    return CORE::rindex($_[0], $_[1], $_[2]);
}
sub split   {
    return NG::Array->new( CORE::split($_[1], $_[0]) ) if scalar @_ == 2;
    return NG::Array->new( CORE::split($_[1], $_[0], $_[2]) );
}

1;
