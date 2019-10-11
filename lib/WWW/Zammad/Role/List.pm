package WWW::Zammad::Role::List;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo::Role;
use namespace::clean;

sub list {
    my $self = shift;
    $self->_iterate($self->url, @_);
}

1;
