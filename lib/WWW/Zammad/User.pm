package WWW::Zammad::User;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo;
use namespace::clean;

sub resource_path {'users'}

with 'WWW::Zammad::Role::Resource', 'WWW::Zammad::Role::All',
    'WWW::Zammad::Role::Search', 'WWW::Zammad::Role::Get',
    'WWW::Zammad::Role::Create', 'WWW::Zammad::Role::Update',
    'WWW::Zammad::Role::Delete';

sub me {
    my ($self) = @_;
    my $res = $self->transport->get($self->url . '/me', {},
        $self->default_headers);
    $self->_maybe_get_json($res, 200);
}

1;

