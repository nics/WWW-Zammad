package WWW::Zammad::Ticket;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo;
use namespace::clean;

sub resource_path {'tickets'}

with 'WWW::Zammad::Role::Resource';
with 'WWW::Zammad::Role::List';
with 'WWW::Zammad::Role::Get';
with 'WWW::Zammad::Role::Search';
with 'WWW::Zammad::Role::Create';
with 'WWW::Zammad::Role::Update';
with 'WWW::Zammad::Role::Delete';

sub tags {
    my ($self, $id) = @_;
    $self->_clear_last_error;
    my $res = $self->transport->get(
        $self->client->url . '/tags',
        {object => 'Ticket', o_id => $id},
        $self->default_headers
    );
    $self->_maybe_get_json($res, 200);
}

sub add_tag {
    my ($self, $id, $tag) = @_;
    $self->_clear_last_error;
    my $res = $self->transport->get(
        $self->client->url . '/tags/add',
        {object => 'Ticket', o_id => $id, item => $tag},
        $self->default_headers
    );
    $self->_maybe_get_json($res, 200);
}

sub remove_tag {
    my ($self, $id, $tag) = @_;
    $self->_clear_last_error;
    my $res = $self->transport->get(
        $self->client->url . '/tags/remove',
        {object => 'Ticket', o_id => $id, item => $tag},
        $self->default_headers
    );
    $self->_maybe_get_json($res, 200);
}

1;

