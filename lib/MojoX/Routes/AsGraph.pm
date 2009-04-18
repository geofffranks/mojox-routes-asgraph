package MojoX::Routes::AsGraph;

use warnings;
use strict;
use Graph::Easy;

our $VERSION = '0.01';

sub graph {
  my ($self, $r) = @_;
  return unless $r;
  
  my $g = Graph::Easy->new;
  _new_node($g, $r, {});
  
  return $g;
}

sub _new_node {
  my ($g, $r, $s) = @_;
  
  ### collect cool stuff
  my $name = $r->name;
  my $is_endpoint = $r->is_endpoint;
  my $pattern = $r->pattern;

  my $ctrl_actn;
  if ($pattern) {
    my $controller = $pattern->defaults->{controller};
    my $action     = $pattern->defaults->{action};

    $ctrl_actn = $controller || '';
    $ctrl_actn .= "->$action" if $action;

    $pattern    = $pattern->pattern;
  }

  ### Create node
  my @node_name = ($is_endpoint? '*' : '');

  if (!$pattern && !$ctrl_actn) {
    my $n = ++$s->{empty};
    push @node_name, "<empty $n>";
  }
  else {
    push @node_name, "'$pattern'"    if $pattern;
    push @node_name, "[$ctrl_actn]" if $ctrl_actn;
  }
  push @node_name, "($name)" if $name;
  my $node = $g->add_node(join(' ', @node_name));
  
  ### Draw my children
  for my $child (@{$r->children}) {
    my $child_node = _new_node($g, $child, $s);
    $g->add_edge($node, $child_node);
  }
  
  return $node;  
}

=head1 NAME

MojoX::Routes::AsGraph - The great new MojoX::Routes::AsGraph!

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use MojoX::Routes::AsGraph;

    my $foo = MojoX::Routes::AsGraph->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 function1

=cut

sub function1 {
}

=head2 function2

=cut

sub function2 {
}

=head1 AUTHOR

Pedro Melo, C<< <melo at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-mojox-routes-asgraph at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MojoX-Routes-AsGraph>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc MojoX::Routes::AsGraph


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MojoX-Routes-AsGraph>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MojoX-Routes-AsGraph>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MojoX-Routes-AsGraph>

=item * Search CPAN

L<http://search.cpan.org/dist/MojoX-Routes-AsGraph/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Pedro Melo, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of MojoX::Routes::AsGraph
