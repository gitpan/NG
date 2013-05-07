package NG::Autobox;
 
use strict;
use warnings;
use Carp;
 
use bigint;
use base qw(autobox);
use NG::Autobox::Number;
use NG::Autobox::String;
 
our $VERSION = '0.02';
 
sub import {
    shift->SUPER::import(
        NUMBER => 'NG::Autobox::Number',
        STRING => 'NG::Autobox::String',
        @_
    );
}
