package NG::EMail;
use warnings;
use strict;
use base 'NG::Object';
use NG::Hashtable;
use NG::Array;
use NG::HTTP::DOM;
use Net::SMTP;
use Net::POP3;
use Email::MIME;
use Encode;

=head2 send
    send 'smtp.host.com', \%headers, $body;
=cut
sub send {
    my ( $host, $headers, $body ) = @_;
    my $smtp = Net::SMTP->new($host);
    if ( $headers->{username} and $headers->{password} ) {
        $smtp->auth( $headers->{username}, $headers->{password} );
    }
    my $dataheader;
    for my $i (qw/to cc bcc/) {
        next unless $headers->{$i};
        eval $smtp->$i( $headers->{bcc} );
        $dataheader .= uc($i) . ': ' . $headers->{$i} . "\n";
    }

    $smtp->data();
    $smtp->datasend($dataheader);
    $smtp->datasend("$body\n");
    $smtp->dataend();

    $smtp->quit;
}

=head2 get
    get 'pop3.host.com', $user, $password, sub {
        my ( $headers, $body, $num, $pop ) = @_;
            say $headers->get('Subject');
            say $body->get(0)->text;
            $pop->delete($num);
    };
=cut
sub get {
    my $cb = pop;
    my ( $host, $user, $pass ) = @_;
    my $pop = Net::POP3->new($host);
    return unless $pop->login( $user, $pass ) > 0;

    my $msgnums = $pop->list;
    for my $msgnum ( sort { $b <=> $a } keys %$msgnums ) {
        my $parsed = Email::MIME->new( join( '', @{ $pop->get($msgnum) } ) );

        my $headers = NG::Hashtable->new( @{ $parsed->{header}->{headers} } );
        $headers->each(
            sub {
                $headers->put( $_[0], Encode::decode( 'MIME-Header', $_[1] ) );
            }
        );

        my $body = new NG::Array;
        my @parts = $parsed->parts;
        my $html = +( shift @parts )->body_str;
        $html = '<html><head></head><body><div>' . $html . '</div></body></html>'
          if $html !~ /^\s*\<htm/;
        $body->push( NG::HTTP::DOM->new($html) );
        $body->push( $_->body_raw ) for @parts;

        $cb->( $headers, $body, $msgnum, $pop );
    }

    $pop->quit;
}

1;
