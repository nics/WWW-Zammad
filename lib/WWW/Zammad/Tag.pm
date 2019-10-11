package WWW::Zammad::Tag;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo;
use namespace::clean;

sub resource_path {'tag_list'}

with 'WWW::Zammad::Role::Resource';
with 'WWW::Zammad::Role::List';
with 'WWW::Zammad::Role::Create';
with 'WWW::Zammad::Role::Update';
with 'WWW::Zammad::Role::Delete';

sub search {
    my ($self, $params) = @_;
    $self->_clear_last_error;
    my $res = $self->transport->get($self->client->url . '/tag_search',
        $params, $self->default_headers);
    $self->_maybe_get_json($res, 200);
}

1;

