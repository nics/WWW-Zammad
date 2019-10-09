package WWW::Zammad::OnlineNotification;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo;
use namespace::clean;

sub resource_path {'online_notifications'}

with 'WWW::Zammad::Role::Resource', 'WWW::Zammad::Role::All',
    'WWW::Zammad::Role::Get', 'WWW::Zammad::Role::Update',
    'WWW::Zammad::Role::Delete';

sub mark_as_read {
    my ($self) = @_;
    my $res = $self->transport->post($self->url . '/mark_all_as_read',
        '', $self->default_headers);
    $self->_maybe_get_json($res, 200);
}

1;

