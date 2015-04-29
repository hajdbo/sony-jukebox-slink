sony-jukebox-slink
==================

Arduino program to send commands to a Sony CDP-CX jukebox via the S-Link protocol

Commands are sent to the arduino via a basic serial protocol
 * A: send_PWON
 * B: send_PWOFF
 * C: send_PLAY
 * D: send_STOP
 * P: send_PAUSE
 * E: send_NEXT
 * F: send_PREV
 * G127: select CD #127


Interface:

![interface](https://raw.githubusercontent.com/hajdbo/sony-jukebox-slink/master/slink_interface.png)


Based on the reverse engineering done by Jeff Behle.
His 2003 website is still visible via archive.org:
http://web.archive.org/web/20040722060841/http://www.undeadscientist.com/slink/index.html
