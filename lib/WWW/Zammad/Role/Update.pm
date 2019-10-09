package WWW::Zammad::Role::Update;

use strict;
use warnings;

our $VERSION = '0.01';

use Cpanel::JSON::XS qw(encode_json);
use Moo::Role;
use namespace::clean;

sub update {
    my ($self, $id, $attrs) = @_;
    $self->_clear_last_error;
    my $json = encode_json($attrs);
    my $res  = $self->transport->put(join('/', $self->url, $id),
        $json, $self->default_headers);
    $self->_maybe_get_json($res, 200);
}

1;
