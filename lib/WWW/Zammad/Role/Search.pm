package WWW::Zammad::Role::Search;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo::Role;
use namespace::clean;

sub search {
    my $self = shift;
    $self->_iterate($self->url . '/search', @_);
}

1;
