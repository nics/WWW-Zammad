package WWW::Zammad::TicketState;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo;
use namespace::clean;

sub resource_path {'ticket_states'}

with 'WWW::Zammad::Role::Resource';
with 'WWW::Zammad::Role::List';
with 'WWW::Zammad::Role::Get';
with 'WWW::Zammad::Role::Create';
with 'WWW::Zammad::Role::Update';
with 'WWW::Zammad::Role::Delete';

1;

