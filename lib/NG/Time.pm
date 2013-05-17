use strict;
use warnings;
use Time::HiRes ();
use POSIX       ();
use NG::Class;
NG::Class::def 'NG::Time' => [] => {

    now => sub {
        my @t = localtime;
        NG::Time->new(
            year   => $t[5] + 1900,
            month  => $t[4] + 1,
            day    => $t[3],
            hour   => $t[2],
            minute => $t[1],
            second => $t[0],
        );
    },
    
    year => sub {
        defined $_[0]->{year} ? $_[0]->{year} : 1970;
    },
    
    month => sub {
        $_[0]->{month} || 1;
    },
    
    day => sub {
        $_[0]->{day} || 1;
    },
    
    hour => sub {
        $_[0]->{hour} || 0;
    },
    
    minute => sub {
        $_[0]->{minute} || 0;
    },
    
    second => sub {
        $_[0]->{second} || 0;
    },
    
    microsecond => sub {
        $_[0]->{second} || +(Time::HiRes::gettimeofday)[1];
    },
    
    strftime => sub {
        my $self   = shift;
        my $format = shift;
        my @need_t;
        if ( ref( $_[0] ) eq 'NG::Time' ) {
            @need_t = localtime( shift->to_epoch );
        }
        else {
            @need_t = @_;
        }
        POSIX::strftime( $format, @need_t );
    },
    
    to_epoch => sub {
        my $self = shift;
        POSIX::mktime(
            $self->second, $self->minute, $self->hour, $self->day,
            $self->month - 1,
            $self->year - 1900
        );
    },
    
    from_epoch => sub {
        my $self = shift;
        my @t    = localtime(shift);
        $self->new(
            year   => $t[5] + 1900,
            month  => $t[4] + 1,
            day    => $t[3],
            hour   => $t[2],
            minute => $t[1],
            second => $t[0],
        );
    },
    
    to_float => sub {
        return Time::HiRes::time;
    },

};

1;
