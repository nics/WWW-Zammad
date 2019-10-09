package WWW::Zammad::Resource::UserAccessToken;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo;
use namespace::clean;

sub resource_path {'user_access_token'}

with 'WWW::Zammad::Role::Resource', 'WWW::Zammad::Role::All',
    'WWW::Zammad::Role::Create', 'WWW::Zammad::Role::Delete';

1;
