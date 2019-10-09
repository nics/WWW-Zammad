package WWW::Zammad::Role::Create;

use strict;
use warnings;

our $VERSION = '0.01';

use Cpanel::JSON::XS qw(encode_json);
use Moo::Role;
use namespace::clean;

sub create {
    my ($self, $attrs) = @_;
    $self->_clear_last_error;
    my $json = encode_json($attrs);
    my $res
        = $self->transport->post($self->url, $json, $self->default_headers);
    $self->_maybe_get_json($res, 201);
}

1;
