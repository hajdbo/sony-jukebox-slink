sony-jukebox-slink
==================

Arduino program to send commands to a Sony CDP-CX jukebox via the S-Link protocol
![Sony CDPDX jukebox](http://i.imgur.com/OlYsir5.jpg)

Commands are sent from a PC to the Arduino via this very basic serial protocol:
 * A: send_PWON
 * B: send_PWOFF
 * C: send_PLAY
 * D: send_STOP
 * P: send_PAUSE
 * E: send_NEXT
 * F: send_PREV
 * G127: select CD #127


Interface
---------
![interface](https://raw.githubusercontent.com/hajdbo/sony-jukebox-slink/master/slink_interface.png)

Connect the interface to one of the Control-A1 ports, using a 3.5mm mono male jack.
![control A1 port](http://i.imgur.com/pV647eY.jpg?1)


History
-------
This is based on the reverse engineering done by Jeff Behle. He wrote a linux kernel driver, which I converted to an Arduino sketch. His 2003 website is still visible via archive.org: http://web.archive.org/web/20040722060841/http://www.undeadscientist.com/slink/index.html


Notice
------
I don't have a jukebox anymore, so this repo will not change.
