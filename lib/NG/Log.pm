package NG::Log;
use strict;
use warnings;
use autodie;
use 5.010;
use base qw(NG::Object);
use NG::Hashtable;
use NG::Array;
use NG::Log::IPMatcher;

=head1 process_log
my $logpath = '/opt/graphite/storage/log/webapp/access.log';
process_log($logpath, sub {
    my ($fields) = @_;    # 第一个参数是 Array 类型
    say $fields->get(6);  # 获取第6个字段
});
#}, '&');
=cut

sub process_log {
    my $logpath = shift;
    my $cb      = shift;
    my $sep     = shift || qr/\s+/;
    open my $fh, '<', $logpath;
    while (<$fh>) {
        chomp;
        my $lines = NG::Array->new( split( $sep, $_ ) );
        $cb->($lines);
    }
}

sub geo_ip {
    ...
}

1;
