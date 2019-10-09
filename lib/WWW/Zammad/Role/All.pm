package WWW::Zammad::Role::All;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo::Role;
use namespace::clean;

sub all {
    my ($self) = @_;
    $self->_clear_last_error;
    my $res = $self->transport->get($self->url, {expand => 'true'},
        $self->default_headers);
    $self->_maybe_get_json($res, 200);
}

1;
