set ns [new Simulator]
set nf [open ass1.nam w]
set f [open ass1.tr w]
$ns namtrace-all $nf
$ns trace-all $f
$ns rtproto Session

proc finish {} {

	global ns f
	$ns flush-trace
	close $f
	exec nam ass1.nam &
	exit 0
}

set n(1) [$ns node]
set n(2) [$ns node]
set n(3) [$ns node]
set n(4) [$ns node]

$n(2) color red
$n(4) color blue


$ns simplex-link $n(1) $n(2) 10Mb 5ms SFQ
$ns simplex-link $n(2) $n(3) 10Mb 5ms SFQ
$ns duplex-link $n(3) $n(4) 20Mb 10ms DropTail
$ns duplex-link $n(4) $n(1) 20Mb 10ms DropTail

set udp0 [new Agent/UDP]
$ns attach-agent $n(2) $udp0
set null [new Agent/Null]
$ns attach-agent $n(4) $null
$ns connect $udp0 $null
$udp0 set fid_ 2

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packetsize_ 512
$cbr0 set rate_ 0.01Mb
$cbr0 set random_ false

$ns at 0.0 "$cbr0 start"
$ns at 1.0 "$cbr0 stop"
$ns at 10.0 "finish"
$ns run
