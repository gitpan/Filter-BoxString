package Filter::BoxString;

our $VERSION = '0.04';

use 5.008008;
use strict;
use warnings FATAL => 'all';
use Filter::Simple;

my $delimiter = 'BOXSTRING';

my $BoxString_Regex = qr{
    ( (?: my \s+ )? \$\w+ \s* = \s* [+] (?: .*? ) + [+]; )
}msx;

FILTER_ONLY
executable => sub {

    while ( m/$BoxString_Regex/msxg ) {

        my $boxstring = $1;

        my $boxstring_regex;
        {
            my $boxstring_re = $boxstring;
            $boxstring_re =~ s{([\*\/\?\^\|\$\.+\-\\\(\)\[\]])}{\\$1}g;
            $boxstring_regex = qr{$boxstring_re};
        }

        # If the standard here-doc delimiter happens to be in the text
        # then append ints to it until it's not in the text.
        while ( $boxstring =~ m/$delimiter/ ) {
            $delimiter .= int rand 9;
        }

        my ($here_doc) = $boxstring =~ m/( (?: my \s+ )? \$[\w\{\}\[\]]+ \s* = ) \s* [+]/msx;

        $here_doc .= qq{ <<"$delimiter";\n};

        my @lines = split /\n\s*[|]/, $boxstring;

        shift @lines;
        
        # strip the trailing +---+;
        if ( @lines ) {
            $lines[$#lines] =~ s{ [+-;]+ \z}{}msxg;
        }

        for my $line (@lines) {

            if ( $line =~ s/ [|] \s* \z//msx ) {

                $here_doc .= "$line\n";
            }
            else {
                $line =~ s/ \s* \z//msx;

                $here_doc .= "$line\n";
            }
        }

        $here_doc .= $delimiter;

        # Swap out the box-string with the here-doc.
        s/$boxstring_regex/$here_doc/;
    }
};

1;

__END__

=pod

=head1 NAME

Filter::BoxString - Describe your multiline strings as text boxes.

=head1 SYNOPSIS

    use Filter::BoxString;

       # Trailing whitespace preserved
       my $list = +---------------+
                  | 1. Milk       |
                  | 2. Eggs       |
                  | 3. Apples     |
                  +---------------+;

    # Trailing whitespace dropped
    my $noodles = +-----------------------+
                  | Ramen
                  | Shirataki
                  | Soba
                  | Somen
                  | Udon
                  +;

        my $xml = +---------------------------------------+
                  |<?xml version="1.0" encoding="UTF-8"?>
                  |  <item>Milk</item>
                  |  <item>Eggs</item>
                  |  <item>Apples</item>
                  |</shopping_list>
                  +---------------------------------------+;


    my $beatles = +
                  | Love Me Do
                  | I wanna hold your hand
                  | Lucy In The Sky With Diamonds
                  | Penny Lane
                  +------------------------------+;

        my $sql = +
                  | SELECT *
                  | FROM the_table
                  | WHERE this = 'that'
                  | AND those = 'these'
                  | ORDER BY things ASC
                  +;

  my $metachars = +------------------------------------------------------------+
                  | \\  Quote the next metacharacter
                  | ^  Match the beginning of the line
                  | .  Match any character (except newline)
                  | \$  Match the end of the line (or before newline at the end)
                  | |  Alternation
                  | () Grouping
                  | [] Character class
                  +------------------------------------------------------------+;

  my $gibberish = +-----------------------------------+
                  | +!@#\$%^&*()_|"?><{}>~=-\'/.,[]
                  | +=!@#$%^&*()_-|\"':;?/>.<,}]{[><~`
                  +-----------------------------------+;


=head1 DESCRIPTION

This filter allows you to describe multiline strings in your code using ASCII art style boxes.
Underneath it all, this filter transforms your box-string to the equivilent here-doc.

The purpose is purely aesthetic. Please enjoy.

=head1 BUGS AND LIMITATIONS

The methodology is to capture your boxstring by matching something like " = + ... +; " 
which will break if your boxstring contains the sequence '+;'. 

=head1 TODO

Make the delimiters as flexible as perl. 

Perhaps:

 my $s = qq---------------+
          | "hello world" |
          +---------------qq;

 my $s = "---------------+
         | hello world+; |
         +---------------";

 my $s = '------------------+
         | qq{hello world}; |
         +------------------';

=head1 AUTHOR

Dylan Doxey E<lt>dylan.doxey@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Dylan Doxey

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
