package WWW::Zammad::Role::Get;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo::Role;
use namespace::clean;

sub get {
    my ($self, $id) = @_;
    $self->_clear_last_error;
    my $res = $self->transport->get(
        join('/', $self->url, $id),
        {expand => 'true'},
        $self->default_headers
    );
    $self->_maybe_get_json($res, 200);
}

1;
