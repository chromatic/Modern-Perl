#! perl

use Test::More 0.98;

use Modern::Perl ();

eval q|
    Modern::Perl->import( '2009' );
    my @features = grep /^feature_/, keys %^H;
    is @features, 3, 'use Modern::Perl 2009 should enable three features';
    ok exists $^H{feature_switch}, '... switch';
    ok exists $^H{feature_say},    '... say';
    ok exists $^H{feature_state},  '... and state';
|;

my @features = grep /^feature_/, keys %^H;
is @features, 0, 'use Modern::Perl () should enable no features';

eval q|
    Modern::Perl->import( '2010' );
    my @features = grep /^feature_/, keys %^H;
    is @features, 3, 'use Modern::Perl 2010 should enable three features';
    ok exists $^H{feature_switch}, '... switch';
    ok exists $^H{feature_say},    '... say';
    ok exists $^H{feature_state},  '... and state';
|;

eval q|
    Modern::Perl->import( '2011' );
    my @features = grep /^feature_/, keys %^H;
    is @features, 4, 'use Modern::Perl 2011 should enable four features';
    ok exists $^H{feature_switch},  '... switch';
    ok exists $^H{feature_say},     '... say';
    ok exists $^H{feature_state},   '... state';
    ok exists $^H{feature_unicode}, '... and unicode_strings';
|;

eval q|
    Modern::Perl->import( '2012' );
    my @features = grep /^feature_/, keys %^H;
    is @features, 4, 'use Modern::Perl 2012 should enable four features';
    ok exists $^H{feature_switch},  '... switch';
    ok exists $^H{feature_say},     '... say';
    ok exists $^H{feature_state},   '... state';
    ok exists $^H{feature_unicode}, '... and unicode_strings';
|;

@features = grep /^feature_/, keys %^H;
is @features, 0, '... but none should leak out';

done_testing;
