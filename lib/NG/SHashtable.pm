use NG::Class;
NG::Class::def 'NG::SHashtable' => 'NG::Hashtable' => [] => {

    each => sub {
        my ( $self, $sub ) = @_;
        $self->keys->sort(
            sub {
                my ( $a, $b ) = @_;
                return $a cmp $b;
            }
          )->each(
            sub {
                my ($key) = @_;
                $sub->( $key, $self->get($key) );
            }
          );
        return $self;
    }

};

1;
