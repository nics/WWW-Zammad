package WWW::Zammad::Object;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo;
use namespace::clean;

sub resource_path {'object_manager_attributes'}

with 'WWW::Zammad::Role::Resource';
with 'WWW::Zammad::Role::List';
with 'WWW::Zammad::Role::Get';
with 'WWW::Zammad::Role::Create';
with 'WWW::Zammad::Role::Update';

sub migrate {
    my ($self) = @_;
    my $res = $self->transport->post($self->url . '_execute_migrations',
        '', $self->default_headers);
    $self->_maybe_get_json($res, 200);
}

1;

