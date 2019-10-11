package WWW::Zammad::User;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo;
use namespace::clean;

sub resource_path {'users'}

with 'WWW::Zammad::Role::Resource';
with 'WWW::Zammad::Role::List';
with 'WWW::Zammad::Role::Search';
with 'WWW::Zammad::Role::Get';
with 'WWW::Zammad::Role::Create';
with 'WWW::Zammad::Role::Update';
with 'WWW::Zammad::Role::Delete';

sub me {
    my ($self) = @_;
    my $res = $self->transport->get($self->url . '/me', {},
        $self->default_headers);
    $self->_maybe_get_json($res, 200);
}

1;

