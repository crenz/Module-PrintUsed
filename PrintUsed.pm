package Module::PrintUsed;

use 5.006;
use strict;
use warnings;

our @ISA = qw();

our $VERSION = '0.03';

sub ModulesList {
    my @modules;
    
    foreach (sort keys %INC) {
        my $name = $_;
        $name =~ s|[\\/]|::|g;
        $name =~ s|\.pm$||;
        my $version = eval " \$$name\::VERSION " || '';
        push @modules, { name => $name, version => $version,
            path => $INC{$_} };
    }
    
    return @modules;
}

sub FormattedModulesList {
    my $text = "\nModules used by $0:\n";
    my @modules = ModulesList();
    
    foreach (@modules) {
        $text .= " - $_->{name} " . (" " x (25 - length($_->{name}))) .
            "$_->{version} " . (" " x (8 - length($_->{version}))) .
            "$_->{path}\n";
    }
    $text .= "\n";
    
    return $text;
}

END {
    print STDERR FormattedModulesList();
}


1;
__END__
=head1 NAME

Module::PrintUsed - Prints modules used by your script when your script ends

=head1 SYNOPSIS

  use Module::PrintUsed;

=head1 DESCRIPTION

This module helps you to check which modules (and scripts) were C<use>d or
C<require>d during the runtime of your script. It prints the list of modules
to STDERR, including version numbers and paths.

Module::PrintUsed contains an C<END {}> block that will be executed when
your script exits (even if it died).

=head1 FUNCTIONS

=over 4

=item C<Module::PrintUsed::ModulesList()>

Returns a list of modules used in the format

    @modules = ({name => 'Some::Module', version => '0.1',
                 path => '/home/thisuser/lib/Some/Module.pm'}, ...);

=item C<Module::PrintUsed::FormattedModulesList()> 

Returns a scalar that contains a pretty-printed version of the
modules list.

=back

=head1 SEE ALSO

A more sophisticated way of finding module dependencies without having
to execute the script is performed by L<Module::ScanDeps>.

=head1 AUTHOR

Christian Renz, E<lt>crenz @ web42.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2004 Christian Renz E<lt>crenz @ web42.comE<gt>. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 
