package WWW::Zammad::Role::Search;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo::Role;
use namespace::clean;

sub search {
    my ($self, $params) = @_;
    $self->_clear_last_error;
    $params->{expand} //= 'true';
    my $res = $self->transport->get($self->url . '/search',
        $params, $self->default_headers);
    $self->_maybe_get_json($res, 200);
}

1;
