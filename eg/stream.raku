#!raku

use Digest::SHA256::Native;

say sha256-hex("The quick brown fox jumps over the lazy dog");

say sha256-hex supply {
   emit "The quick brown fox ";
   emit "jumps over the lazy dog"
}

