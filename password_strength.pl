#!/usr/bin/perl
use strict;
use warnings;

print "Enter your password: ";
chomp(my $password = <STDIN>);

my $score = 0;
$score++ if length($password) >= 8;
$score++ if $password =~ /[A-Z]/;
$score++ if $password =~ /[a-z]/;
$score++ if $password =~ /[0-9]/;
$score++ if $password =~ /[\W_]/;

my @strength = ("Very Weak", "Weak", "Medium", "Strong", "Very Strong", "Excellent");
print "Password Strength: $strength[$score]\n";
