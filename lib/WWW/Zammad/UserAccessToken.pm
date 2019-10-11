package WWW::Zammad::Resource::UserAccessToken;

use strict;
use warnings;

our $VERSION = '0.01';

use Moo;
use namespace::clean;

sub resource_path {'user_access_token'}

with 'WWW::Zammad::Role::Resource';
with 'WWW::Zammad::Role::List';
with 'WWW::Zammad::Role::Create';
with 'WWW::Zammad::Role::Delete';

1;
