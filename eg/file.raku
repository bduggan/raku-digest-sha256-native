#!raku

use Digest::SHA256::Native;

# Hash a file, streamed from disk in bounded chunks -- never fully in memory.

my $path = @*ARGS[0] // $*PROGRAM;

say sha256-hex($path.IO);
