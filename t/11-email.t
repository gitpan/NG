use Test::More;
use lib '../lib';
use NG::EMail;

my $password = $ARGV[0];
SKIP: {
    skip 'no one know your username/password~~', 4 unless $password;
    NG::EMail::get 'pop3.renren-inc.com', 'chenlin.rao', $password, sub {
        my ( $headers, $body, $num, $pop ) = @_;
        isa_ok $headers, 'NG::Hashtable';
        isa_ok $body, 'NG::Array';
        isa_ok $body->get(0), 'NG::HTTP::DOM';
        isa_ok $pop, 'Net::POP3';

        say $headers->{Subject};
        say $body->get(0)->text;
        $body->get(0)->find('div')->each(sub {
            print $_[1]->text;
        });
        exit;
    };
};

done_testing();
