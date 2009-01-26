BEGIN { require 5.010 }

use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Modern::Perl',
    license             => 'perl',
    dist_author         => 'chromatic <chromatic@wgz.org>',
    dist_version_from   => 'lib/Modern/Perl.pm',
    build_requires => {
        'Test::Simple'     => 0.80,
        'B::Hooks::Parser' => 0.08,
        'perl'             => 5.010,
    },
    add_to_cleanup      => [ 'Modern-Perl-*' ],
);

$builder->create_build_script();
