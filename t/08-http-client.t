use Test::More 'no_plan';
use Test::Deep;
use lib '../lib';
use NG::HTTP::Client;
use NG::SHashtable;

my $hc = new NG::HTTP::Client;

isa_ok $hc, 'NG::HTTP::Client';

my $url = 'http://www.baidu.com/';
my $got = NG::HTTP::Client::web_get($url)->find('div')->xml;
like $got, qr/<.*>/, 'return HTML format-like strings';

my @urls = qw(http://www.baidu.com http://www.sina.com.cn);
NG::HTTP::Client::web_get(@urls, sub {
    my ($content, $code, $res_headers) = @_;   # $res_headers 是 SHashtable 类型
    is $code, 200, 'HTTP code ok';
    isa_ok $res_headers, 'NG::SHashtable';
    print $res_headers->{URL}," tested\n";
});
