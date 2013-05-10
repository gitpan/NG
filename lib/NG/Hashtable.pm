use NG::Class;
use NG::Array;
NG::Class::def 'NG::Hashtable' => [] => {

    put => sub {
        my ( $self, $key, $val ) = @_;
        $self->{$key} = $val;
        return $self;
    },
    
    get => sub {
        my ( $self, $key ) = @_;
        return $self->{$key};
    },
    
    keys => sub {
        my ($self) = @_;
        return new NG::Array( keys %$self );
    },
    
    values => sub {
        my ($self) = @_;
        return new NG::Array( values %$self );
    },
    
    remove => sub {
        my ( $self, $key ) = @_;
        delete $self->{$key};
        return $self;
    },
    
    each => sub {
        my ( $self, $sub ) = @_;
        $self->keys->each(
            sub {
                my ($key) = @_;
                $sub->( $key, $self->get($key) );
            }
        );
        return $self;
    },
    
    flip => sub {
        my ($self) = @_;
        my $tmp = NG::Hashtable->new;
        $self->keys->each(
            sub {
                my ($key) = @_;
                $tmp->put( $self->get($key), $key );
            }
        );
        return $tmp;
    },

};

1;
