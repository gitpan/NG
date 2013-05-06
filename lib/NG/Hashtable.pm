package NG::Hashtable;

use strict;
use warnings;
use base qw(NG::Object);
use NG::Array;

sub new {
    my $pkg  = shift;
    my $hash = {@_};
    return bless $hash, $pkg;
}

sub put {
    my ( $self, $key, $val ) = @_;
    $self->{$key} = $val;
    return $self;
}

sub get {
    my ( $self, $key ) = @_;
    return $self->{$key};
}

sub keys {
    my ($self) = @_;
    return new NG::Array( keys %$self );
}

sub values {
    my ($self) = @_;
    return new NG::Array( values %$self );
}

sub remove {
    my ( $self, $key ) = @_;
    delete $self->{$key};
    return $self;
}

sub each {
    my ( $self, $sub ) = @_;
    $self->keys->each(
        sub {
            my ($key) = @_;
            $sub->( $key, $self->get($key) );
        }
    );
    return $self;
}

sub flip {
    my ($self) = @_;
    my $tmp = NG::Hashtable->new;
    $self->keys->each(
        sub {
            my ($key) = @_;
            $tmp->put( $self->get($key), $key );
        }
    );
    return $tmp;
}

1;
