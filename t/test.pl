use Digest::MD5 qw/md5_hex/;
use File::Slurp;
my $content = read_file('log.txt');
my @content = read_file('log.txt');
print $content;
my $data = join("\n", grep { chomp } @content);
print $data;
print md5_hex($content),"\n";
print md5_hex($data),"\n";
