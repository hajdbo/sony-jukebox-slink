int sonyPin = 8;                // choose the input/output pin

void setup() {
  Serial.begin(9600);
  pinMode(sonyPin, OUTPUT); 
  digitalWrite(sonyPin, HIGH); // default bus state: HIGH 5V
}

void send_init() {
  // wait 2000 usec after last msg
  digitalWrite(sonyPin, LOW);
  delayMicroseconds(2400);
  digitalWrite(sonyPin, HIGH);
  delayMicroseconds(600);
}
void send_bit1() {
  digitalWrite(sonyPin, LOW);
  delayMicroseconds(1200);
  digitalWrite(sonyPin, HIGH);
  delayMicroseconds(600);
}
void send_bit0() {
  digitalWrite(sonyPin, LOW);
  delayMicroseconds(600);
  digitalWrite(sonyPin, HIGH);
  delayMicroseconds(600);
}
void send_byte(byte octet) {
  for (int i=7; i>=0 ; i--) {
    if (octet & 1<<i) {send_bit1();} else {send_bit0();}
  }
}

void send_PLAY() {
// play CD1 : init 1001 0000 0000 0000
// 	0x90 (cd1) 0x00 (play) 
  send_init();
  send_byte(0x90);
  send_byte(0x00);
  delay(2);
}
void send_STOP() {
// 	0x90 (cd1) 0x01 (stop) 
  send_init();
  send_byte(0x90);
  send_byte(0x01);
  delay(2);
}
void send_PAUSE() {
// 	0x90 (cd1) 0x03 (toggle pause) 
  send_init();
  send_byte(0x90);
  send_byte(0x03);
  delay(2);
}
void send_NEXT() {
// 	0x90 (cd1) 0x08 (next track) 
  send_init();
  send_byte(0x90);
  send_byte(0x08);
  delay(2);
}
void send_PREV() {
// 	0x90 (cd1) 0x09 (previous track) 
  send_init();
  send_byte(0x90);
  send_byte(0x09);
  delay(2);
}
byte BCD(int val) {
  byte upper, lower;
  val   = val % 100;
  upper = (byte)((val / 10) << 4);
  lower = (byte)(val % 10);
  return (upper | lower);
}
byte DiscBCD(int val) {
  if (val < 100)
    return BCD(val);
  if (val <= 200)
    return (byte)((val - 100) + 0x9A);
  return 0;
}
byte bcd_convert(byte i) { //works only for 0-99
  byte result=0;
  byte first_half=i/10;
  byte second_half=i%10;
  result=first_half;
  result<=4;
  result+=second_half;
  return result;
}
void send_PLAYDISKTRACK(int disk, byte track) {
// 	0x90 (cd1) ou 0x93 (cd1>200) 0x50 (play disk, track)
// 001-100 : 0x90 0x50 0xBCD(disc) 0x01(track)
// 101-200 : 0x90 0x50 0x9A+HEX(disc) 0x01(track)
// 201-400 : 0x93 0x50 0xHEX(disc) 0x01(track)
  byte deck_address=(disk>200)?0x93:0x90;
  byte disk_address;
 
  if (disk>200) {disk_address=disk-200;}
  else {disk_address=DiscBCD(disk);}
  
  send_init();
  send_byte(deck_address);
  send_byte(0x50);
  send_byte(disk_address);
  send_byte(track);
  delay(2);
}
void send_PWON() {
// CD1 PWON init 1001 0000 0010 1110
// 	0x90 (cd1) 0x2E (pwon) 
  send_init();
  send_byte(0x90);
  send_byte(0x2E);
  delay(2);
}
void send_PWOFF() {
// CD1 PWOFF init 1001 0000 0010 1111
// 	0x90 (cd1) 0x2F (pwoff) 
  send_init();
  send_byte(0x90);
  send_byte(0x2F);
  delay(2);
}

void loop(){
  byte cmd; 
  // check if data has been sent from the computer
  if (Serial.available()) {
    cmd = Serial.read();
    switch (cmd) {
      case 'A': send_PWON(); break;
      case 'B': send_PWOFF(); break;
      case 'C': send_PLAY(); break;
      case 'D': send_STOP(); break;
      case 'P': send_PAUSE(); break;
      case 'E': send_NEXT(); break;
      case 'F': send_PREV(); break;
      case 'G': {  // 3 ascii disc    ex: G001   G148   G300
        while (Serial.available() < 3)  { delay(200); }
        int disc=(Serial.read()-48)*100; // ascii '0'=48(dec)  "byte" for CDP-CX250 or eq, or "int" for use CDP-CX400 (450)
        disc+=(Serial.read()-48)*10;
        disc+=Serial.read()-48;
        send_PLAYDISKTRACK(disc,1); } break; 
      default: break;
    }
  }
}
