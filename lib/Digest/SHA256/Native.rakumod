unit module Digest::SHA256::Fast;

use NativeCall;

constant SHA256 = %?RESOURCES<libraries/sha256>;

sub compute_sha256(Blob, size_t, CArray[uint8]) is native( SHA256 ) { * }
sub sha256_stream_ctx_size(--> size_t) is native( SHA256 ) { * }
sub sha256_stream_init(CArray[uint8]) is native( SHA256 ) { * }
sub sha256_stream_update(CArray[uint8], Blob, size_t) is native( SHA256 ) { * }
sub sha256_stream_final(CArray[uint8], CArray[uint8]) is native( SHA256 ) { * }

multi sub sha256-hex(Str $in) is export {
    sha256-hex($in.encode);
}

multi sub sha256-hex(Blob $in) is export {
    my size_t $len = $in.elems;

    my CArray[uint8] $hash .= new;
    $hash[127] = 0;

    compute_sha256($in,$len,$hash);

    my $str = $hash.list».chr.join.lc;

    return $str.substr(0,64);
}

my sub hexify(Blob:D $b --> Str) { $b.list.fmt('%02x','') }

multi sub sha256(Supply:D $in) is export {
  my $ctx = CArray[uint8].allocate(sha256_stream_ctx_size());
  sha256_stream_init($ctx);
  react whenever $in -> $chunk {
    my $blob = $chunk ~~ Blob ?? $chunk !! $chunk.Str.encode;
    sha256_stream_update($ctx, $blob, $blob.elems) if $blob.elems;
  }
  my $digest = CArray[uint8].allocate(32);
  sha256_stream_final($ctx, $digest);
  Blob.new($digest.list);
}

multi sub sha256(IO::Handle:D $in, Int:D :$chunk-size = 64 * 1024) is export {
  sha256 supply {
    while $in.read($chunk-size) -> $buf { emit $buf }
  }
}

multi sub sha256(IO::Path:D $in, Int:D :$chunk-size = 64 * 1024) is export {
  my $fh = $in.open(:r, :bin);
  LEAVE $fh.close;
  sha256($fh, :$chunk-size);
}

multi sub sha256-hex(Supply:D $in) is export { hexify sha256 $in }
multi sub sha256-hex(IO::Handle:D $in, Int:D :$chunk-size = 64 * 1024) is export {
  hexify sha256 $in, :$chunk-size;
}
multi sub sha256-hex(IO::Path:D $in, Int:D :$chunk-size = 64 * 1024) is export {
  hexify sha256 $in, :$chunk-size;
}

multi sub sha256($in) is export {
    Blob.new( sha256-hex($in).comb(2).map({ :16($_) }))
}
