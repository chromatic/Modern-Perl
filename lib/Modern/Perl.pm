package Modern::Perl;
# ABSTRACT: enable all of the features of Modern Perl with one import

use 5.010_000;

use strict;
use warnings;

use autodie ();
use mro     ();
use feature ();

# enable methods on filehandles; unnecessary when 5.14 autoloads them
use IO::File   ();
use IO::Handle ();

sub import
{
    my ($class, $date) = @_;
    my $feature_tag    = validate_date( $date );

    warnings->import();
    strict->import();
    feature->import( $feature_tag );
    mro::set_mro( scalar caller(), 'c3' );
}

my %dates =
(
    2009 => ':5.10',
    2010 => ':5.10',
    2011 => ':5.12',
    2012 => ':5.14',
);

sub validate_date
{
    my $date = shift;
    return ':5.10' unless $date;

    my $year = substr $date, 0, 4;
    return $dates{$year} if exists $dates{$year};

    die "Unknown date '$date' requested\n";
}

=head1 SYNOPSIS

Modern Perl programs use several modules to enable additional features of Perl
and of the CPAN.  Instead of copying and pasting all of these C<use> lines,
instead write only one:

    use Modern::Perl;

For now, this only enables the L<strict> and L<warnings> pragmas, as well as
all of the features available in Perl 5.10.  It also enables C3 method
resolution order; see C<perldoc mro> for an explanation.  In the future, it
will include additional CPAN modules which have proven useful and stable.

See L<http://www.modernperlbooks.com/mt/2009/01/toward-a-modernperl.html> for
more information, L<http://www.modernperlbooks.com/> for further discussion of
Modern Perl and its implications, and
L<http://onyxneon.com/books/modern_perl/index.html> for a freely-downloadable
Modern Perl tutorial.

=head2 Forward Compatibility

For forward compatibility, I recommend you specify a I<year> as the single
optional import tag. For example:

    use Modern::Perl 2009;
    use Modern::Perl 2010;

... both enable 5.10 features, while:

    use Modern::Perl 2011;

... enables 5.12 features and:

    use Modern::Perl 2012;

... enables 5.14 features. Obviously you cannot use 5.14 features on earlier
versions, and Perl will throw the appropriate exception if you try.

In the future--probably the C<Modern::Perl> 2013 timeframe--this module may
drop support for 5.10 and will complain (once per process) if you use a year
too old.

=head1 AUTHOR

chromatic, C<< <chromatic at wgz.org> >>

=head1 BUGS

None reported.

Please report any bugs or feature requests to C<bug-modern-perl at
rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Modern-Perl>.  I will be
notified, and then you'll automatically be notified of progress on your bug as
I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Modern::Perl

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Modern-Perl>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Modern-Perl>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Modern-Perl>

=item * Search CPAN

L<http://search.cpan.org/dist/Modern-Perl/>

=back

=head1 ACKNOWLEDGEMENTS

Damian Conway (inspiration from L<Toolkit>), Florian Ragwitz
(L<B::Hooks::Parser>, so I didn't have to write it myself), chocolateboy (for
suggesting that I don't even need L<B::Hooks::Parser>), Damien Learns Perl,
David Moreno, Evan Carroll, and Elliot Shank for reporting bugs and requesting
features.

=head1 COPYRIGHT & LICENSE

Copyright 2009-2012 chromatic, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl 5.14 itself.

=cut

1;
