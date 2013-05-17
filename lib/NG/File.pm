use NG::Array;
use NG::Hashtable;
use NG::Time;
use NG::Class;
use File::Copy::Recursive ();
use Digest::MD5 qw(md5_hex);

NG::Class::def 'NG::File' => ['name'] => {
    build => sub {
        my ( $self, $filepath ) = @_;
        $self->name = $filepath;
    },
    read => sub {
        my ( $self, $filepath ) = @_;
        $filepath //= $self->name;
        open my $fh, '<', $filepath;
        my $content = new NG::Array;
        while (<$fh>) {
            chomp;
            $content->push($_);
        }
        return $content;
    },
    copy => sub { shift; File::Copy::Recursive::rcopy(@_) },
    md5 => sub {
        my ( $self, $filepath ) = @_;
        $filepath //= $self->name;
        open my $fh, '<', $filepath;
        return md5_hex(
            do { local $/; <$fh> }
        );
    },
    fstat => sub {
        my ( $self, $filepath ) = @_;
        $filepath //= $self->name;
        my $ret = NG::Array->new( stat($filepath) );
        return NG::Hashtable->new(
            dev     => $ret->get(0),
            inode   => $ret->get(1),
            mode    => sprintf( "%04o", $ret->get(2) & 07777 ),
            nlink   => $ret->get(3),
            uid     => $ret->get(4),
            gid     => $ret->get(5),
            rdev    => $ret->get(6),
            size    => $ret->get(7),
            atime   => NG::Time->new->from_epoch( $ret->get(8) ),
            mtime   => NG::Time->new->from_epoch( $ret->get(9) ),
            ctime   => NG::Time->new->from_epoch( $ret->get(10) ),
            blksize => $ret->get(11),
            blocks  => $ret->get(12),
        );
    },
};

1;
__END__

=head1 NAME

NG::File - File object for NG.

=head1 SYNOPSIS

    my $f = NG::File->new('/tmp/file');
    say $f->fstat;

=head1 METHODS

=head2 from_json/yaml

Return Hashtable or Array:

    my $object = NG::File->from_yaml/json($file);

=head2 read_file

    my $filepath = '/home/chenryn/test.conf';
    my $content = NG::File->read_file($filepath);
 
    NG::File->new('test.txt')->read_file(sub {
        my ($content) = @_;
        say $content->get(1);
    });

=head2 read_dir

    read_dir('/root')->each(sub {
        my $file = shift;
        read_file( $file, sub {
            ...
        })
    });
    read_dir(qw(/root /tmp), sub{
        my ($dir, $file) = @_;
        ...
    });

=head2 fstat

     0 dev      device number of filesystem
     1 ino      inode number
     2 mode     file mode  (type and permissions)
     3 nlink    number of (hard) links to the file
     4 uid      numeric user ID of file's owner
     5 gid      numeric group ID of file's owner
     6 rdev     the device identifier (special files only)
     7 size     total size of file, in bytes
     8 atime    last access time in seconds since the epoch
     9 mtime    last modify time in seconds since the epoch
    10 ctime    inode change time in seconds since the epoch (*)
    11 blksize  preferred block size for file system I/O
    12 blocks   actual number of blocks allocated

=cut
