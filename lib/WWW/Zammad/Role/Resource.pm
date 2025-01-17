package WWW::Zammad::Role::Resource;

use strict;
use warnings;

our $VERSION = '0.01';

use Cpanel::JSON::XS qw(decode_json);
use Moo::Role;
use namespace::clean;

with 'WWW::Zammad::Role::Log';

requires 'resource_path';

has client => (is => 'ro', required => 1, handles => [qw(transport)]);
has default_headers => (is => 'lazy');
has url             => (is => 'lazy');
has last_error      => (
    is       => 'rwp',
    init_arg => undef,
    clearer  => '_clear_last_error',
    trigger  => 1
);

sub _build_default_headers {
    my ($self) = @_;
    +{%{$self->client->default_headers}};
}

sub _build_url {
    my ($self) = @_;
    join('/', $self->client->url, $self->resource_path);
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

sub _iterate {
    my $self   = shift;
    my $url    = shift;
    my $params = ref($_[0]) && ref($_[0]) eq 'HASH' ? shift : {};
    my $cb     = shift;

    my $p = {expand => 'true', page => 1, per_page => 10, %$params};

    if ($cb) {
        my $n = 0;
        while (1) {
            my $res = $self->transport->get($url,
                $p, $self->default_headers);
            my $items = $self->_maybe_get_json($res, 200) // last;
            @$items // last;
            $cb->($_, $n++) for @$items;
            $p->{page}++;
        }
        return $n;
    }

    my $res = $self->transport->get($url,
        $p, $self->default_headers);
    $self->_maybe_get_json($res, 200);
}

sub on_behalf_of {
    my ($self, $on_behalf_of, $cb) = @_;
    my $prev = $self->default_headers->{'X-On-Behalf-Of'};
    try {
        $cb->();
    }
    catch {
        $self->default_headers->{'X-On-Behalf-Of'} = $prev if defined $prev;
        die $_;
    };
}

1;
