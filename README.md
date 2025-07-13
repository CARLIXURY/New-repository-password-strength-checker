#!/usr/bin/perl
use strict;
use warnings;
use Digest::MD5 qw(md5_hex);
use Digest::SHA qw(sha1_hex sha256_hex);
use Time::HiRes qw(time);

my $hashfile = 'hashes.txt';
my $dictfile = 'dict.txt';
my $outfile  = 'cracked.txt';

open my $hf, '<', $hashfile or die "Cannot open $hashfile: $!";
my @hashes = map { s/\s+//gr } <$hf>;
close $hf;

open my $df, '<', $dictfile or die "Cannot open $dictfile: $!";
my @words = map { chomp; $_ } <$df>;
close $df;

open my $out, '>', $outfile or die "Cannot write to $outfile: $!";

my %cracked;
my $start = time();
print "[*] Starting smart hash cracking...\n";

foreach my $hash (@hashes) {
    my $found = 0;
    foreach my $word (@words) {
        if ($hash eq md5_hex($word)) {
            print "[+] CRACKED [MD5]: $hash = $word\n";
            print $out "$hash:$word\n";
            $cracked{$hash} = $word;
            $found = 1;
            last;
        }
        elsif ($hash eq sha1_hex($word)) {
            print "[+] CRACKED [SHA1]: $hash = $word\n";
            print $out "$hash:$word\n";
            $cracked{$hash} = $word;
            $found = 1;
            last;
        }
        elsif ($hash eq sha256_hex($word)) {
            print "[+] CRACKED [SHA256]: $hash = $word\n";
            print $out "$hash:$word\n";
            $cracked{$hash} = $word;
            $found = 1;
            last;
        }
    }
    print "[-] FAILED: $hash\n" unless $found;
}

my $end = time();
my $total = scalar @hashes;
my $cracked = scalar keys %cracked;
my $failed = $total - $cracked;
my $duration = sprintf("%.2f", $end - $start);

print "\n[*] Summary:\n";
print "✅ Cracked: $cracked / $total\n";
print "❌ Failed: $failed\n";
print "⏱️ Time: $duration seconds\n";
print "📁 Saved to: $outfile\n";

close $out;
