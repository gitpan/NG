package NG::HTTP::DOM;
use warnings;
use strict;
use base 'NG::Object';
use NG::Array;
use HTML::TreeBuilder::XPath;
use HTML::Selector::XPath qw(selector_to_xpath);

=head1 DESCRIPTION
A mini implement of Web::Query, but all method return Array object, no matter wantarray or no.
I only want something work with web_get, so modify-relate methods all deleted.
=cut

sub new {
    my ( $pkg, $html ) = @_;
    my $tree = HTML::TreeBuilder::XPath->new;
    $tree->ignore_unknown(0);
    $tree->store_comments(1);
    $tree->parse_content($html);
    my $self = $pkg->new_from_element( NG::Array->new( $tree->guts ) );
    $self->{need_delete}++;
    return $self;
}

sub new_from_element {
    my $class = shift;
    my $trees = ref $_[0] eq 'NG::Array' ? $_[0] : NG::Array->new( $_[0] );
    return bless { trees => $trees, before => $_[1] }, ref($class) || $class;
}

sub end {
    my $self = shift;
    return $self->{before};
}

sub size {
    my $self = shift;
    return $self->{trees}->size;
}

sub parent {
    my $self = shift;
    my $new  = NG::Array->new;
    $self->{trees}->each(
        sub {
            $new->push( shift->getParentNode() );
        }
    );
    return ( ref $self || $self )->new_from_element( $new, $self );
}

sub first {
    my $self = shift;
    return ( ref $self || $self )
      ->new_from_element( NG::Array->new( $self->{trees}->get(0) || () ), $self );
}

sub last {
    my $self = shift;
    return ( ref $self || $self )
      ->new_from_element( NG::Array->new( $self->{trees}->get(-1) || () ), $self );
}

=head2 find
    my $dom = HTTP::DOM->new($content);
    print $dom->find('#m')->text;
=cut
sub find {
    my ( $self, $selector ) = @_;
    my $xpath_rootless = selector_to_xpath($selector);

    my $new = NG::Array->new;
    $self->{trees}->each(
        sub {
            my $tree = shift;
            $new->push($tree)
              if defined $tree->parent && $tree->matches($xpath_rootless);
            $new->push(
                $tree->findnodes(
                    selector_to_xpath(
                        $selector, root => defined $tree->parent ? './' : '/'
                    )
                )
            );
        }
    );

    return ( ref $self || $self )->new_from_element( $new, $self );
}

=head2 each
    $dom->find('#m')->each(sub {
        my $i = shift;
        printf "(%d) %s\n", $i+1, $_->text;
    })
=cut
sub each {
    my ($self, $code) = @_;
    my $i = 0;
    $self->{trees}->each(
        sub {
            my $tree = shift;
            local $_ = (ref $self || $self)->new_from_element(NG::Array->new($tree), $self);
            $code->($i++, $_);
        }
    );
    return $self;
}

=head2 html
=cut
sub html {
    my $self = shift;
    my $html = NG::Array->new;
    $self->{trees}->each(
        sub {
            $html->push( shift->as_HTML );
        }
    );
    return $html->join("\n");
}

sub xml {
    my $self = shift;
    my $html = NG::Array->new;
    $self->{trees}->each(
        sub {
            $html->push( shift->as_XML_indented );
        }
    );
    return $html->join("\n");
}

=head2 text
    my $dom = HTTP::DOM->new($content);
    print $dom->text;
=cut
sub text {
    my $self = shift;
    my $text = NG::Array->new;
    $self->{trees}->each(
        sub {
            $text->push( shift->as_text );
        }
    );
    return $text->join("\n");
}

=head2 attr
    my $url = 'http://www.baidu.com/';
    my $hc = HTTP::Client->new;
    my $content = $hc->web_get($url);
    my $dom = HTTP::DOM->new($content);
    print $dom->find('meta')->attr('content');
=cut
sub attr {
    my $self      = shift;
    my @attr_keys = @_;
    my $retval    = NG::Array->new;
    $self->{trees}->each(
        sub {
            $retval->push( shift->attr(@attr_keys) );
        }
    );
    return $retval->join("\n");
}

sub DESTROY {
    if ( $_[0]->{need_delete} ) {
        $_->delete for @{ $_[0]->{trees} };
    }
}

1;
