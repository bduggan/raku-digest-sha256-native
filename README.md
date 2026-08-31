[![Linux](https://github.com/bduggan/raku-digest-sha256-native/actions/workflows/linux.yml/badge.svg)](https://github.com/bduggan/raku-digest-sha256-native/actions/workflows/linux.yml)
[![MacOS](https://github.com/bduggan/raku-digest-sha256-native/actions/workflows/macos.yml/badge.svg)](https://github.com/bduggan/raku-digest-sha256-native/actions/workflows/macos.yml)
[![Windows](https://github.com/bduggan/raku-digest-sha256-native/actions/workflows/windows.yml/badge.svg)](https://github.com/bduggan/raku-digest-sha256-native/actions/workflows/windows.yml)
[![NixOS](https://github.com/bduggan/raku-digest-sha256-native/actions/workflows/nixos.yml/badge.svg)](https://github.com/bduggan/raku-digest-sha256-native/actions/workflows/nixos.yml)

NAME
====

Digest::SHA256::Native -- Fast SHA256 computation using NativeCall to C.

SYNOPSIS
========

    use Digest::SHA256::Native;

    # digest for a string
    say sha256-hex("The quick brown fox jumps over the lazy dog");

    # digest for a blob
    say sha256-hex("The quick brown fox jumps over the lazy dog".encode);

    # digest for a supply (stream)
    say sha256-hex supply { emit "The quick brown fox ";
                            emit "jumps over the lazy dog"
                          }

    # digest for a file (IO::Path)
    "dog.txt".IO.spurt: "The quick brown fox jumps over the lazy dog";
    say sha256-hex "dog.txt".IO;

    # The -hex is optional, without it, a binary blob (list of bytes) is returned
    say sha256("The quick brown fox jumps over the lazy dog").list.fmt('%02x','');

Output:

    d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592
    d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592
    d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592
    d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592
    d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592

DESCRIPTION
===========

`sha256-hex` computes a hex string.

`sha256` computes a Blob -- list of bytes -- representing the sha256.

Both of these accept multiple types of arguments:

* Str
* Blob
* Supply of Str/Blob chunks
* IO::Path (also takes an optional :chunk-size, default 64 * 1024)
* IO::Handle (ditto)


EXAMPLES
========

Compute the SHA 256 for a string.

    say sha256-hex "The quick brown fox jumps over the lazy dog";

Compute the SHA 256 for a file.

    say sha256-hex "somedata".IO;

Take an HMAC in addition to a SHA.

From <https://en.wikipedia.org/wiki/Hash-based_message_authentication_code#Examples>:

    use Digest::HMAC;
    use Digest::SHA256::Native;

    say hmac-hex("key","The quick brown fox jumps over the lazy dog",&sha256);

Output:

    f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8

SHA256 IMPLEMENTATION
=====================

The C implementation in [src/sha256.c](src/sha256.c) is taken from Brad Conte's
[crypto-algorithms](https://github.com/B-Con/crypto-algorithms).

AUTHOR
======

Brian Duggan (bduggan at matatu.org)

CONTRIBUTORS
============

* rcmlz
