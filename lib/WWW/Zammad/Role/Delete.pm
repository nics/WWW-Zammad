package WWW::Zammad::Role::Delete;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo::Role;
use namespace::clean;

sub delete {
    my ($self, $id, $attrs) = @_;
    $self->_clear_last_error;
    my $res = $self->transport->delete(join('/', $self->url, $id),
        {}, $self->default_headers);
    $self->_maybe_get_json($res, 200);
}

1;
