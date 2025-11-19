#!/usr/bin/perl

use warnings FATAL => 'all';
use strict;

local $/ = undef;

$_ = <>;

# Drop the header
s{^ \w+ \n =+ \n\n }{}x;

# Drop link anchors
s{\[ ([\w -]+) \] \[\w*\] }{$1}gx;

# Drop link targets
s{^ \[ .* \n}{}gmx;

# Coalesce blanks
s{\n\n\n+}{\n\n}gx;

# Drop backticks
s{\`}{}gx;

# Drop **foo** markup
s{\*\*}{}gx;

print $_;
