#!/usr/bin/perl

use warnings FATAL => 'all';
use strict;

local $/ = undef;

$_ = <>;

# Use curly apostrophe
s{\'}{’}gx;

# Use curly left double-quote
s{\"(\w)}{“$1}gx;

# Use curly right double-quote
s{\"}{”}gx;

# Use em dash
s{(?=^| )--(?= |$)}{—}gmx;

print $_;
