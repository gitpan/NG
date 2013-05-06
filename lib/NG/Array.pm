package NG::Array;

use strict;
use warnings;
use base qw(NG::Object);
use NG::Hashtable;
use List::Util;

sub new {
    my $pkg  = shift;
    my @args = @_;
    return bless \@args, $pkg;
}

sub each {
    my ( $self, $sub ) = @_;
    for my $i ( 0 .. scalar(@$self) - 1 ) {
        $sub->( $self->[$i], $i );
    }
    return $self;
}

sub pop {
    my ($self) = @_;
    return pop @$self;
}

sub push {
    my ( $self, $value ) = @_;
    push @$self, $value;
    return $self;
}

sub shift {
    my ($self) = @_;
    return shift @$self;
}

sub unshift {
    my ( $self, $value ) = @_;
    unshift @$self, $value;
    return $self;
}

sub sort {
    my ( $self, $sub ) = @_;
    my @tmp;
    if ( defined $sub ) {
        @tmp = sort { $sub->( $a, $b ) } @$self;
    }
    else {
        @tmp = sort @$self;
    }
    return NG::Array->new(@tmp);
}

sub size {
    my ($self) = @_;
    return scalar(@$self);
}

sub get {
    my ( $self, $index ) = @_;
    return $self->[$index];
}

sub join {
    my ( $self, $expr ) = @_;
    return join( $expr, @$self );
}

sub to_hash {
    my ($self) = @_;
    return NG::Hashtable->new(@$self);
}

sub zip {
    my ( $self, @arrs ) = @_;
    my $tmp  = NG::Array->new;
    my $size = NG::Array->new;
    $size->push($_->size) for @_;
    for my $i ( 0 .. $size->max - 1 ) {
        $tmp->push($_->get($i) || '') for @_;
    }
    return $tmp;
}

sub uniq {
    my ($self) = @_;
    my %seen;
    return $self->grep(sub {
        not $seen{$_}++;
    });
}

sub reduce {
    my ( $self, $sub ) = @_;
    return reduce { $sub->($a, $b) } @$self;
}

sub grep {
    my ( $self, $sub ) = @_;
    return NG::Array->new( grep { $sub->($_) } @$self );
}

sub map {
    my ( $self, $sub ) = @_;
    return NG::Array->new( map { $sub->($_) } @$self );
}

sub max {
    my ($self) = @_;
    return List::Util::max( @$self );
}

sub min {
    my ($self) = @_;
    return List::Util::min( @$self );
}

1;
