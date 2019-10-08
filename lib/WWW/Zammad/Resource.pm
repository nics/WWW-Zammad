package WWW::Zammad::Resource;

use strict;
use warnings;
use Cpanel::JSON::XS qw(encode_json decode_json);
use Moo;
use namespace::clean;

with 'WWW::Zammad::Role::Log';

has client    => (is => 'ro', required => 1, handles => [qw(transport default_headers)]);
has resource  => (is => 'ro', required => 1);
has url  => (is => 'lazy');
has last_error => (
    is       => 'rwp',
    init_arg => undef,
    clearer  => '_clear_last_error',
    trigger  => 1
);

sub _build_url {
    my ($self) = @_;
    join('/', $self->client->url, $self->resource);
}

sub _trigger_last_error {
    my ($self, $res) = @_;
    $self->log->errorf("%s", $res) if $self->log->is_error;
}

sub _maybe_get_json {
    my ($self, $res, $status_expected) = @_;
    if ($res->[0] eq $status_expected) {
        return decode_json($res->[2]);
    }
    $self->_set_last_error($res);
    return;
}

sub get {
    my ($self, $id) = @_;
    $self->_clear_last_error;
    my $res = $self->transport->get(join('/', $self->url, $id), {expand => 'true'}, $self->default_headers);
    $self->_maybe_get_json($res, 200);
}

sub all {
    my ($self) = @_;
    $self->_clear_last_error;
    my $res = $self->transport->get($self->url, {expand => 'true'}, $self->default_headers);
    $self->_maybe_get_json($res, 200);
}

sub search {
    my ($self, $params) = @_;
    $self->_clear_last_error;
    $params->{expand} //= 'true';
    my $res = $self->transport->get($self->url.'/search', $params, $self->default_headers);
    $self->_maybe_get_json($res, 200);
}

sub add {
    my ($self, $attrs) = @_;
    $self->_clear_last_error;
    my $json = encode_json($attrs);
    my $res = $self->transport->post($self->url, $json, $self->default_headers);
    $self->_maybe_get_json($res, 201);
}

sub update {
    my ($self, $id, $attrs) = @_;
    $self->_clear_last_error;
    my $json = encode_json($attrs);
    my $res = $self->transport->put(join('/', $self->url, $id), $json, $self->default_headers);
    $self->_maybe_get_json($res, 200);
}

sub delete {
    my ($self, $id, $attrs) = @_;
    $self->_clear_last_error;
    my $res = $self->transport->delete(join('/', $self->url, $id), {}, $self->default_headers);
    $self->_maybe_get_json($res, 200);
}

1;
