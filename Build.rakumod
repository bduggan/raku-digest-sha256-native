use v6;
use LibraryMake;
use Shell::Command;

class Build {
    method build($dir) {
        my %vars = get-vars($dir);
        %vars<sha256> = $*VM.platform-library-name('sha256'.IO);
        mkdir "$dir/resources" unless "$dir/resources".IO.e;
        mkdir "$dir/resources/libraries" unless "$dir/resources/libraries".IO.e;
        # On Windows we ship a prebuilt DLL (LibraryMake picks `nmake`, which
        # isn't available on stock runners or most user machines).
        if $*DISTRO.is-win && "$dir/resources/libraries/%vars<sha256>".IO.e {
            return True;
        }
        process-makefile($dir, %vars);
        my $goback = $*CWD;
        chdir($dir);
        shell(%vars<MAKE>);
        chdir($goback);
        return True;
    }
}

