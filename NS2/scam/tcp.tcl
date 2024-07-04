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

set tcp0 [new Agent/TCP]
$ns attach-agent $n(2) $tcp0
set sink [new Agent/TCPSink]
$ns attach-agent $n(4) $sink
$ns connect $tcp0 $sink
$tcp0 set fid_ 2
$tcp0 set packetsize_ 1024
$tcp0 set random_ true
$tcp0 set rate_ 0.02Mb

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set type_ FTP

$ns at 0.0 "$ftp0 start"
$ns at 1.0 "$ftp0 stop"
$ns at 10.0 "finish"
$ns run
