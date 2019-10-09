package WWW::Zammad::TicketPriority;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo;
use namespace::clean;

sub resource_path {'ticket_priorities'}

with 'WWW::Zammad::Role::Resource', 'WWW::Zammad::Role::All',
    'WWW::Zammad::Role::Get',    'WWW::Zammad::Role::Create',
    'WWW::Zammad::Role::Update', 'WWW::Zammad::Role::Delete';

1;

