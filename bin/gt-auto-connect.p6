#! /usr/bin/env perl6

my $btc = Proc::Async.new('bluetoothctl', :w);

$btc.stdout.tap(-> $l { 
    print $l;
    $btc.put('connect 06:76:6F:D7:65:CC') if $l ~~ /'Device 06:76:6F:D7:65:CC Connected: no'/;
    $btc.put('connect 06:76:6F:D7:65:CC') if $l ~~ /'Device 06:76:6F:D7:65:CC RSSI:'/;
    $btc.put('pair 06:76:6F:D7:65:CC') if $l ~~ /.*? 'NEW' .*? 'Device 06:76:6F:D7:65:CC'/;
    # $btc.put('remove 06:76:6F:D7:65:CC') if $l ~~ /.*? 'CHG' .*? 'Device 06:76:6F:D7:65:CC ServicesResolved: no'/;
    $btc.put('connect 18:D6:C7:1D:20:95') if $l ~~ /'Device 18:D6:C7:1D:20:95 Connected: no'/;
    $btc.put('connect 18:D6:C7:1D:20:95') if $l ~~ /'Device 18:D6:C7:1D:20:95 RSSI:'/;
    $btc.put('pair 18:D6:C7:1D:20:95') if $l ~~ /.*? 'NEW' .*? 'Device 18:D6:C7:1D:20:95'/;
});

signal(SIGINT).tap({ $btc.close-stdin });

await $btc.start, Promise.in(2).then: { for 'remove 18:D6:C7:1D:20:95', 'remove 06:76:6F:D7:65:CC', 'power on', 'scan on' -> $l { $btc.put($l) } };

