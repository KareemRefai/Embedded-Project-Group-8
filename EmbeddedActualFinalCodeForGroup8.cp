#line 1 "C:/Users/user1/Desktop/Group8EmbeddedFinalCode/EmbeddedActualFinalCodeForGroup8.c"
void manual_delay(unsigned int d) {
 unsigned int i;
 for(i = 0; i < d; i++) {

 }
}
void timer1_delay_us(unsigned int us) {
 unsigned int preload;

 T1CON = 0x10;

 preload = 65536 - us;

 TMR1H = preload / 256;
 TMR1L = preload % 256;

 PIR1 = PIR1 & 0xFE;

 T1CON = T1CON | 0x01;

 while((PIR1 & 0x01) == 0);

 T1CON = T1CON & 0xFE;
}

unsigned int servo_i;



void ADC_Init_LDR_RA1() {
 ADCON1 = 0x80;
 ADCON0 = 0x49;
}

unsigned int read_ldr_RA1() {
 ADCON0 = 0x49;
 manual_delay(20);

 ADCON0 = ADCON0 | 0x04;

 while(ADCON0 & 0x04);

 return ((unsigned int)ADRESH * 256) + ADRESL;
}






void CCPPWM_init(void) {
 TRISC = TRISC & 0xF9;

 PR2 = 250;

 CCP1CON = 0x0C;
 CCP2CON = 0x0C;

 CCPR1L = 0;
 CCPR2L = 0;

 T2CON = 0x07;
}




void motor_R(unsigned char speed) {
 CCPR1L = speed;
}

void motor_L(unsigned char speed) {
 CCPR2L = speed;
}








void stop_motors() {
 PORTD = PORTD & 0xF0;

 motor_L(0);
 motor_R(0);
}

void forward() {

 PORTD = PORTD | 0x05;
 PORTD = PORTD & 0xF5;

 motor_L(55);
 motor_R(55);
}

void turn_left() {

 PORTD = PORTD | 0x01;
 PORTD = PORTD & 0xF1;

 motor_L(60);
 motor_R(0);
}

void turn_right() {
 PORTD = PORTD | 0x04;
 PORTD = PORTD & 0xF4;

 motor_L(0);
 motor_R(60);
}
void turn_right1() {

 PORTD = PORTD | 0x05;
 PORTD = PORTD & 0xF5;

 motor_L(45);
 motor_R(65);
}
void hard_right() {
 PORTD = PORTD & 0xF0;
 PORTD = PORTD | 0x06;

 motor_L(70);
 motor_R(70);
}

void raise_servo_RD6() {

 for(servo_i = 0; servo_i < 100; servo_i++) {
 PORTD = PORTD | 0x40;
 timer1_delay_us(2000);
 PORTD = PORTD & ~0x40;
 timer1_delay_us((unsigned int)(20000 - 2000));
 }
}

void main() {
 unsigned int ldr_value;

 unsigned char sensor_R;
 unsigned char sensor_L;
 unsigned char obstacle_ir;
 unsigned char obstacle_ir1;
 unsigned char obstacle_irm;
 TRISC = TRISC & 0xF9;

 TRISD = 0xA0;

 TRISB = TRISB | 0x0E;
 TRISB = TRISB & 0x7F;

 TRISA = TRISA | 0x02;

 PORTD = 0x00;
 PORTB = PORTB & 0x7F;

 ADC_Init_LDR_RA1();
 CCPPWM_init();

 stop_motors();


 while(1) {
 ldr_value = read_ldr_RA1();
 while((PORTB & 0x80) == 0){
 ldr_value = read_ldr_RA1();
 if(ldr_value > 270) {
 PORTB = PORTB | 0x80;
 }
 else {
 PORTB = PORTB & 0x7F;
 }



 sensor_R = PORTB & 0x04;
 sensor_L = PORTB & 0x08;

 if (sensor_R != 0 && sensor_L != 0) {
 forward();
 }
 if (sensor_R != 0 && sensor_L == 0) {
 turn_left();
 }
 if (sensor_R == 0 && sensor_L != 0) {
 turn_right();

 }
 if (sensor_R == 0 && sensor_L == 0) {
 stop_motors();
 manual_delay(2000);

 turn_left();
 manual_delay(130000);
 }

 }

 while((PORTB & 0x80) != 0){
 ldr_value = read_ldr_RA1();
 if(ldr_value > 240) {
 PORTB = PORTB | 0x80;
 }
 else {
 PORTB = PORTB & 0x7F;
 }


 sensor_R = PORTB & 0x04;
 sensor_L = PORTB & 0x08;

 if (sensor_R != 0 && sensor_L != 0) {
 forward();
 }
 if (sensor_R != 0 && sensor_L == 0) {
 turn_left();
 }
 if (sensor_R == 0 && sensor_L != 0) {
 turn_right();

 }

 }


 while(1){

 PORTB = PORTB & 0x7F;
 sensor_R = PORTB & 0x04;
 sensor_L = PORTB & 0x08;
 obstacle_ir = PORTB & 0x02;
 obstacle_ir1 = PORTB & 0x01;
 obstacle_irm = PORTD & 0x80;
 if(obstacle_irm == 0){
 turn_left(); }
 else
 if(obstacle_ir == 0 && obstacle_irm != 0){
 turn_left(); }
 else if(obstacle_ir1 == 0 && obstacle_irm != 0) {
 turn_right();
 }
 else if(obstacle_ir1 == 0 && obstacle_irm == 0 ){
 hard_right();
 }
 else if (sensor_R == 0 && sensor_L == 0) {
 break;
 }
 else{ turn_right1();
 }



 }
 while(1){
 obstacle_ir = PORTB & 0x02;
 obstacle_ir1 = PORTB & 0x01;
 obstacle_irm = PORTD & 0x80;
 if(obstacle_irm == 0){
 stop_motors();
 raise_servo_RD6();
 while(1)stop_motors();
 }
 else if(obstacle_ir == 0) {
 turn_left();
 }
 else{ turn_right1();
 }
}
}}
