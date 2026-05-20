
_manual_delay:

;EmbeddedActualFinalCodeForGroup8.c,1 :: 		void manual_delay(unsigned int d) {
;EmbeddedActualFinalCodeForGroup8.c,3 :: 		for(i = 0; i < d; i++) {
	CLRF       R1+0
	CLRF       R1+1
L_manual_delay0:
	MOVF       FARG_manual_delay_d+1, 0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manual_delay81
	MOVF       FARG_manual_delay_d+0, 0
	SUBWF      R1+0, 0
L__manual_delay81:
	BTFSC      STATUS+0, 0
	GOTO       L_manual_delay1
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
;EmbeddedActualFinalCodeForGroup8.c,5 :: 		}
	GOTO       L_manual_delay0
L_manual_delay1:
;EmbeddedActualFinalCodeForGroup8.c,6 :: 		}
L_end_manual_delay:
	RETURN
; end of _manual_delay

_timer1_delay_us:

;EmbeddedActualFinalCodeForGroup8.c,7 :: 		void timer1_delay_us(unsigned int us) {
;EmbeddedActualFinalCodeForGroup8.c,10 :: 		T1CON = 0x10;          //Timer1 OFF, internal clock, prescaler 1:2
	MOVLW      16
	MOVWF      T1CON+0
;EmbeddedActualFinalCodeForGroup8.c,12 :: 		preload = 65536 - us; //count to 2^16 before overflow
	MOVF       FARG_timer1_delay_us_us+0, 0
	SUBLW      0
	MOVWF      R3+0
	MOVF       FARG_timer1_delay_us_us+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBLW      0
	MOVWF      R3+1
;EmbeddedActualFinalCodeForGroup8.c,14 :: 		TMR1H = preload / 256; //high byte, Timer1 high
	MOVF       R3+1, 0
	MOVWF      R0+0
	CLRF       R0+1
	MOVF       R0+0, 0
	MOVWF      TMR1H+0
;EmbeddedActualFinalCodeForGroup8.c,15 :: 		TMR1L = preload % 256; //low byte, Timer1 Low
	MOVLW      255
	ANDWF      R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	MOVLW      0
	ANDWF      R0+1, 1
	MOVF       R0+0, 0
	MOVWF      TMR1L+0
;EmbeddedActualFinalCodeForGroup8.c,17 :: 		PIR1 = PIR1 & 0xFE;    //clear bit 0 (TMR1IF)
	MOVLW      254
	ANDWF      PIR1+0, 1
;EmbeddedActualFinalCodeForGroup8.c,19 :: 		T1CON = T1CON | 0x01;  //set bit 0 (TMR1ON)
	BSF        T1CON+0, 0
;EmbeddedActualFinalCodeForGroup8.c,21 :: 		while((PIR1 & 0x01) == 0);
L_timer1_delay_us3:
	MOVLW      1
	ANDWF      PIR1+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_timer1_delay_us4
	GOTO       L_timer1_delay_us3
L_timer1_delay_us4:
;EmbeddedActualFinalCodeForGroup8.c,23 :: 		T1CON = T1CON & 0xFE;  //clear bit 0 (T1CON)
	MOVLW      254
	ANDWF      T1CON+0, 1
;EmbeddedActualFinalCodeForGroup8.c,24 :: 		}
L_end_timer1_delay_us:
	RETURN
; end of _timer1_delay_us

_ADC_Init_LDR_RA1:

;EmbeddedActualFinalCodeForGroup8.c,30 :: 		void ADC_Init_LDR_RA1() {
;EmbeddedActualFinalCodeForGroup8.c,31 :: 		ADCON1 = 0x80; //PORTA analog inputs (right justified)
	MOVLW      128
	MOVWF      ADCON1+0
;EmbeddedActualFinalCodeForGroup8.c,32 :: 		ADCON0 = 0x49; //RA1 selected
	MOVLW      73
	MOVWF      ADCON0+0
;EmbeddedActualFinalCodeForGroup8.c,33 :: 		}
L_end_ADC_Init_LDR_RA1:
	RETURN
; end of _ADC_Init_LDR_RA1

_read_ldr_RA1:

;EmbeddedActualFinalCodeForGroup8.c,35 :: 		unsigned int read_ldr_RA1() {
;EmbeddedActualFinalCodeForGroup8.c,36 :: 		ADCON0 = 0x49;
	MOVLW      73
	MOVWF      ADCON0+0
;EmbeddedActualFinalCodeForGroup8.c,37 :: 		manual_delay(20); //charge capacitor
	MOVLW      20
	MOVWF      FARG_manual_delay_d+0
	MOVLW      0
	MOVWF      FARG_manual_delay_d+1
	CALL       _manual_delay+0
;EmbeddedActualFinalCodeForGroup8.c,39 :: 		ADCON0 = ADCON0 | 0x04; //start ATD conversion
	BSF        ADCON0+0, 2
;EmbeddedActualFinalCodeForGroup8.c,41 :: 		while(ADCON0 & 0x04);
L_read_ldr_RA15:
	BTFSS      ADCON0+0, 2
	GOTO       L_read_ldr_RA16
	GOTO       L_read_ldr_RA15
L_read_ldr_RA16:
;EmbeddedActualFinalCodeForGroup8.c,43 :: 		return ((unsigned int)ADRESH * 256) + ADRESL;
	MOVF       ADRESH+0, 0
	MOVWF      R3+0
	CLRF       R3+1
	MOVF       R3+0, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       ADRESL+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
;EmbeddedActualFinalCodeForGroup8.c,44 :: 		}
L_end_read_ldr_RA1:
	RETURN
; end of _read_ldr_RA1

_CCPPWM_init:

;EmbeddedActualFinalCodeForGroup8.c,51 :: 		void CCPPWM_init(void) {
;EmbeddedActualFinalCodeForGroup8.c,52 :: 		TRISC = TRISC & 0xF9;
	MOVLW      249
	ANDWF      TRISC+0, 1
;EmbeddedActualFinalCodeForGroup8.c,54 :: 		PR2 = 250; //set pwm period register
	MOVLW      250
	MOVWF      PR2+0
;EmbeddedActualFinalCodeForGroup8.c,56 :: 		CCP1CON = 0x0C;
	MOVLW      12
	MOVWF      CCP1CON+0
;EmbeddedActualFinalCodeForGroup8.c,57 :: 		CCP2CON = 0x0C;
	MOVLW      12
	MOVWF      CCP2CON+0
;EmbeddedActualFinalCodeForGroup8.c,59 :: 		CCPR1L = 0;
	CLRF       CCPR1L+0
;EmbeddedActualFinalCodeForGroup8.c,60 :: 		CCPR2L = 0;
	CLRF       CCPR2L+0
;EmbeddedActualFinalCodeForGroup8.c,62 :: 		T2CON = 0x07; //start Timer2, prescaler 1:16, enable pwm signals
	MOVLW      7
	MOVWF      T2CON+0
;EmbeddedActualFinalCodeForGroup8.c,63 :: 		}
L_end_CCPPWM_init:
	RETURN
; end of _CCPPWM_init

_motor_R:

;EmbeddedActualFinalCodeForGroup8.c,68 :: 		void motor_R(unsigned char speed) {
;EmbeddedActualFinalCodeForGroup8.c,69 :: 		CCPR1L = speed;
	MOVF       FARG_motor_R_speed+0, 0
	MOVWF      CCPR1L+0
;EmbeddedActualFinalCodeForGroup8.c,70 :: 		}
L_end_motor_R:
	RETURN
; end of _motor_R

_motor_L:

;EmbeddedActualFinalCodeForGroup8.c,72 :: 		void motor_L(unsigned char speed) {
;EmbeddedActualFinalCodeForGroup8.c,73 :: 		CCPR2L = speed;
	MOVF       FARG_motor_L_speed+0, 0
	MOVWF      CCPR2L+0
;EmbeddedActualFinalCodeForGroup8.c,74 :: 		}
L_end_motor_L:
	RETURN
; end of _motor_L

_stop_motors:

;EmbeddedActualFinalCodeForGroup8.c,83 :: 		void stop_motors() {
;EmbeddedActualFinalCodeForGroup8.c,84 :: 		PORTD = PORTD & 0xF0; //clear RD0-RD3, turn off direction
	MOVLW      240
	ANDWF      PORTD+0, 1
;EmbeddedActualFinalCodeForGroup8.c,86 :: 		motor_L(0);
	CLRF       FARG_motor_L_speed+0
	CALL       _motor_L+0
;EmbeddedActualFinalCodeForGroup8.c,87 :: 		motor_R(0);
	CLRF       FARG_motor_R_speed+0
	CALL       _motor_R+0
;EmbeddedActualFinalCodeForGroup8.c,88 :: 		}
L_end_stop_motors:
	RETURN
; end of _stop_motors

_forward:

;EmbeddedActualFinalCodeForGroup8.c,90 :: 		void forward() { //RD0 = 1,RD2 = 1
;EmbeddedActualFinalCodeForGroup8.c,92 :: 		PORTD = PORTD | 0x05;
	MOVLW      5
	IORWF      PORTD+0, 1
;EmbeddedActualFinalCodeForGroup8.c,93 :: 		PORTD = PORTD & 0xF5;
	MOVLW      245
	ANDWF      PORTD+0, 1
;EmbeddedActualFinalCodeForGroup8.c,95 :: 		motor_L(55);
	MOVLW      55
	MOVWF      FARG_motor_L_speed+0
	CALL       _motor_L+0
;EmbeddedActualFinalCodeForGroup8.c,96 :: 		motor_R(55);
	MOVLW      55
	MOVWF      FARG_motor_R_speed+0
	CALL       _motor_R+0
;EmbeddedActualFinalCodeForGroup8.c,97 :: 		}
L_end_forward:
	RETURN
; end of _forward

_turn_left:

;EmbeddedActualFinalCodeForGroup8.c,99 :: 		void turn_left() {
;EmbeddedActualFinalCodeForGroup8.c,101 :: 		PORTD = PORTD | 0x01;   //RD0 = 1
	BSF        PORTD+0, 0
;EmbeddedActualFinalCodeForGroup8.c,102 :: 		PORTD = PORTD & 0xF1;   //RD1, RD2, RD3 = 0
	MOVLW      241
	ANDWF      PORTD+0, 1
;EmbeddedActualFinalCodeForGroup8.c,104 :: 		motor_L(60);
	MOVLW      60
	MOVWF      FARG_motor_L_speed+0
	CALL       _motor_L+0
;EmbeddedActualFinalCodeForGroup8.c,105 :: 		motor_R(0);
	CLRF       FARG_motor_R_speed+0
	CALL       _motor_R+0
;EmbeddedActualFinalCodeForGroup8.c,106 :: 		}
L_end_turn_left:
	RETURN
; end of _turn_left

_turn_right:

;EmbeddedActualFinalCodeForGroup8.c,108 :: 		void turn_right() {
;EmbeddedActualFinalCodeForGroup8.c,109 :: 		PORTD = PORTD | 0x04;   //RD2 = 1
	BSF        PORTD+0, 2
;EmbeddedActualFinalCodeForGroup8.c,110 :: 		PORTD = PORTD & 0xF4;   //RD0, RD1, RD3 = 0
	MOVLW      244
	ANDWF      PORTD+0, 1
;EmbeddedActualFinalCodeForGroup8.c,112 :: 		motor_L(0);
	CLRF       FARG_motor_L_speed+0
	CALL       _motor_L+0
;EmbeddedActualFinalCodeForGroup8.c,113 :: 		motor_R(60);
	MOVLW      60
	MOVWF      FARG_motor_R_speed+0
	CALL       _motor_R+0
;EmbeddedActualFinalCodeForGroup8.c,114 :: 		}
L_end_turn_right:
	RETURN
; end of _turn_right

_turn_right1:

;EmbeddedActualFinalCodeForGroup8.c,115 :: 		void turn_right1() { //RD0,RD2 = 1
;EmbeddedActualFinalCodeForGroup8.c,117 :: 		PORTD = PORTD | 0x05;
	MOVLW      5
	IORWF      PORTD+0, 1
;EmbeddedActualFinalCodeForGroup8.c,118 :: 		PORTD = PORTD & 0xF5;
	MOVLW      245
	ANDWF      PORTD+0, 1
;EmbeddedActualFinalCodeForGroup8.c,120 :: 		motor_L(45);
	MOVLW      45
	MOVWF      FARG_motor_L_speed+0
	CALL       _motor_L+0
;EmbeddedActualFinalCodeForGroup8.c,121 :: 		motor_R(65);
	MOVLW      65
	MOVWF      FARG_motor_R_speed+0
	CALL       _motor_R+0
;EmbeddedActualFinalCodeForGroup8.c,122 :: 		}
L_end_turn_right1:
	RETURN
; end of _turn_right1

_hard_right:

;EmbeddedActualFinalCodeForGroup8.c,123 :: 		void hard_right() { //RD1,RD2 = 1
;EmbeddedActualFinalCodeForGroup8.c,124 :: 		PORTD = PORTD & 0xF0;
	MOVLW      240
	ANDWF      PORTD+0, 1
;EmbeddedActualFinalCodeForGroup8.c,125 :: 		PORTD = PORTD | 0x06;
	MOVLW      6
	IORWF      PORTD+0, 1
;EmbeddedActualFinalCodeForGroup8.c,127 :: 		motor_L(70);
	MOVLW      70
	MOVWF      FARG_motor_L_speed+0
	CALL       _motor_L+0
;EmbeddedActualFinalCodeForGroup8.c,128 :: 		motor_R(70);
	MOVLW      70
	MOVWF      FARG_motor_R_speed+0
	CALL       _motor_R+0
;EmbeddedActualFinalCodeForGroup8.c,129 :: 		}
L_end_hard_right:
	RETURN
; end of _hard_right

_raise_servo_RD6:

;EmbeddedActualFinalCodeForGroup8.c,131 :: 		void raise_servo_RD6() {
;EmbeddedActualFinalCodeForGroup8.c,133 :: 		for(servo_i = 0; servo_i < 100; servo_i++) {
	CLRF       _servo_i+0
	CLRF       _servo_i+1
L_raise_servo_RD67:
	MOVLW      0
	SUBWF      _servo_i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__raise_servo_RD695
	MOVLW      100
	SUBWF      _servo_i+0, 0
L__raise_servo_RD695:
	BTFSC      STATUS+0, 0
	GOTO       L_raise_servo_RD68
;EmbeddedActualFinalCodeForGroup8.c,134 :: 		PORTD = PORTD | 0x40; //turn RD6 high
	BSF        PORTD+0, 6
;EmbeddedActualFinalCodeForGroup8.c,135 :: 		timer1_delay_us(2000);
	MOVLW      208
	MOVWF      FARG_timer1_delay_us_us+0
	MOVLW      7
	MOVWF      FARG_timer1_delay_us_us+1
	CALL       _timer1_delay_us+0
;EmbeddedActualFinalCodeForGroup8.c,136 :: 		PORTD = PORTD & ~0x40; //turn RD6 low
	BCF        PORTD+0, 6
;EmbeddedActualFinalCodeForGroup8.c,137 :: 		timer1_delay_us((unsigned int)(20000 - 2000));
	MOVLW      80
	MOVWF      FARG_timer1_delay_us_us+0
	MOVLW      70
	MOVWF      FARG_timer1_delay_us_us+1
	CALL       _timer1_delay_us+0
;EmbeddedActualFinalCodeForGroup8.c,133 :: 		for(servo_i = 0; servo_i < 100; servo_i++) {
	INCF       _servo_i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _servo_i+1, 1
;EmbeddedActualFinalCodeForGroup8.c,138 :: 		}
	GOTO       L_raise_servo_RD67
L_raise_servo_RD68:
;EmbeddedActualFinalCodeForGroup8.c,139 :: 		}
L_end_raise_servo_RD6:
	RETURN
; end of _raise_servo_RD6

_main:

;EmbeddedActualFinalCodeForGroup8.c,141 :: 		void main() {
;EmbeddedActualFinalCodeForGroup8.c,149 :: 		TRISC = TRISC & 0xF9;
	MOVLW      249
	ANDWF      TRISC+0, 1
;EmbeddedActualFinalCodeForGroup8.c,151 :: 		TRISD = 0xA0;
	MOVLW      160
	MOVWF      TRISD+0
;EmbeddedActualFinalCodeForGroup8.c,153 :: 		TRISB = TRISB | 0x0E;
	MOVLW      14
	IORWF      TRISB+0, 1
;EmbeddedActualFinalCodeForGroup8.c,154 :: 		TRISB = TRISB & 0x7F; //buzzer
	MOVLW      127
	ANDWF      TRISB+0, 1
;EmbeddedActualFinalCodeForGroup8.c,156 :: 		TRISA = TRISA | 0x02;
	BSF        TRISA+0, 1
;EmbeddedActualFinalCodeForGroup8.c,158 :: 		PORTD = 0x00;
	CLRF       PORTD+0
;EmbeddedActualFinalCodeForGroup8.c,159 :: 		PORTB = PORTB & 0x7F;
	MOVLW      127
	ANDWF      PORTB+0, 1
;EmbeddedActualFinalCodeForGroup8.c,161 :: 		ADC_Init_LDR_RA1();
	CALL       _ADC_Init_LDR_RA1+0
;EmbeddedActualFinalCodeForGroup8.c,162 :: 		CCPPWM_init();
	CALL       _CCPPWM_init+0
;EmbeddedActualFinalCodeForGroup8.c,164 :: 		stop_motors();
	CALL       _stop_motors+0
;EmbeddedActualFinalCodeForGroup8.c,168 :: 		ldr_value = read_ldr_RA1();
	CALL       _read_ldr_RA1+0
;EmbeddedActualFinalCodeForGroup8.c,169 :: 		while((PORTB & 0x80) == 0){    //while buzzer off
L_main12:
	MOVLW      128
	ANDWF      PORTB+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main13
;EmbeddedActualFinalCodeForGroup8.c,170 :: 		ldr_value = read_ldr_RA1();
	CALL       _read_ldr_RA1+0
;EmbeddedActualFinalCodeForGroup8.c,171 :: 		if(ldr_value > 270) {
	MOVF       R0+1, 0
	SUBLW      1
	BTFSS      STATUS+0, 2
	GOTO       L__main97
	MOVF       R0+0, 0
	SUBLW      14
L__main97:
	BTFSC      STATUS+0, 0
	GOTO       L_main14
;EmbeddedActualFinalCodeForGroup8.c,172 :: 		PORTB = PORTB | 0x80;
	BSF        PORTB+0, 7
;EmbeddedActualFinalCodeForGroup8.c,173 :: 		}
	GOTO       L_main15
L_main14:
;EmbeddedActualFinalCodeForGroup8.c,175 :: 		PORTB = PORTB & 0x7F;
	MOVLW      127
	ANDWF      PORTB+0, 1
;EmbeddedActualFinalCodeForGroup8.c,176 :: 		}
L_main15:
;EmbeddedActualFinalCodeForGroup8.c,180 :: 		sensor_R = PORTB & 0x04; //RB2
	MOVLW      4
	ANDWF      PORTB+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      main_sensor_R_L0+0
;EmbeddedActualFinalCodeForGroup8.c,181 :: 		sensor_L = PORTB & 0x08; //RB3
	MOVLW      8
	ANDWF      PORTB+0, 0
	MOVWF      main_sensor_L_L0+0
;EmbeddedActualFinalCodeForGroup8.c,183 :: 		if (sensor_R != 0 && sensor_L != 0) {
	MOVF       R1+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main18
	MOVF       main_sensor_L_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main18
L__main79:
;EmbeddedActualFinalCodeForGroup8.c,184 :: 		forward();
	CALL       _forward+0
;EmbeddedActualFinalCodeForGroup8.c,185 :: 		}
L_main18:
;EmbeddedActualFinalCodeForGroup8.c,186 :: 		if (sensor_R != 0 && sensor_L == 0) {
	MOVF       main_sensor_R_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main21
	MOVF       main_sensor_L_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main21
L__main78:
;EmbeddedActualFinalCodeForGroup8.c,187 :: 		turn_left();
	CALL       _turn_left+0
;EmbeddedActualFinalCodeForGroup8.c,188 :: 		}
L_main21:
;EmbeddedActualFinalCodeForGroup8.c,189 :: 		if (sensor_R == 0 && sensor_L != 0) {
	MOVF       main_sensor_R_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main24
	MOVF       main_sensor_L_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main24
L__main77:
;EmbeddedActualFinalCodeForGroup8.c,190 :: 		turn_right();
	CALL       _turn_right+0
;EmbeddedActualFinalCodeForGroup8.c,192 :: 		}
L_main24:
;EmbeddedActualFinalCodeForGroup8.c,193 :: 		if (sensor_R == 0 && sensor_L == 0) {
	MOVF       main_sensor_R_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main27
	MOVF       main_sensor_L_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main27
L__main76:
;EmbeddedActualFinalCodeForGroup8.c,194 :: 		stop_motors();
	CALL       _stop_motors+0
;EmbeddedActualFinalCodeForGroup8.c,195 :: 		manual_delay(2000);
	MOVLW      208
	MOVWF      FARG_manual_delay_d+0
	MOVLW      7
	MOVWF      FARG_manual_delay_d+1
	CALL       _manual_delay+0
;EmbeddedActualFinalCodeForGroup8.c,197 :: 		turn_left();
	CALL       _turn_left+0
;EmbeddedActualFinalCodeForGroup8.c,198 :: 		manual_delay(130000);
	MOVLW      208
	MOVWF      FARG_manual_delay_d+0
	MOVLW      251
	MOVWF      FARG_manual_delay_d+1
	CALL       _manual_delay+0
;EmbeddedActualFinalCodeForGroup8.c,199 :: 		}
L_main27:
;EmbeddedActualFinalCodeForGroup8.c,201 :: 		}
	GOTO       L_main12
L_main13:
;EmbeddedActualFinalCodeForGroup8.c,203 :: 		while((PORTB & 0x80) != 0){//while buzzeer on
L_main28:
	MOVLW      128
	ANDWF      PORTB+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main29
;EmbeddedActualFinalCodeForGroup8.c,204 :: 		ldr_value = read_ldr_RA1();
	CALL       _read_ldr_RA1+0
;EmbeddedActualFinalCodeForGroup8.c,205 :: 		if(ldr_value > 240) {
	MOVF       R0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main98
	MOVF       R0+0, 0
	SUBLW      240
L__main98:
	BTFSC      STATUS+0, 0
	GOTO       L_main30
;EmbeddedActualFinalCodeForGroup8.c,206 :: 		PORTB = PORTB | 0x80;
	BSF        PORTB+0, 7
;EmbeddedActualFinalCodeForGroup8.c,207 :: 		}
	GOTO       L_main31
L_main30:
;EmbeddedActualFinalCodeForGroup8.c,209 :: 		PORTB = PORTB & 0x7F;
	MOVLW      127
	ANDWF      PORTB+0, 1
;EmbeddedActualFinalCodeForGroup8.c,210 :: 		}
L_main31:
;EmbeddedActualFinalCodeForGroup8.c,213 :: 		sensor_R = PORTB & 0x04;
	MOVLW      4
	ANDWF      PORTB+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      main_sensor_R_L0+0
;EmbeddedActualFinalCodeForGroup8.c,214 :: 		sensor_L = PORTB & 0x08;
	MOVLW      8
	ANDWF      PORTB+0, 0
	MOVWF      main_sensor_L_L0+0
;EmbeddedActualFinalCodeForGroup8.c,216 :: 		if (sensor_R != 0 && sensor_L != 0) {
	MOVF       R1+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main34
	MOVF       main_sensor_L_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main34
L__main75:
;EmbeddedActualFinalCodeForGroup8.c,217 :: 		forward();
	CALL       _forward+0
;EmbeddedActualFinalCodeForGroup8.c,218 :: 		}
L_main34:
;EmbeddedActualFinalCodeForGroup8.c,219 :: 		if (sensor_R != 0 && sensor_L == 0) {
	MOVF       main_sensor_R_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main37
	MOVF       main_sensor_L_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main37
L__main74:
;EmbeddedActualFinalCodeForGroup8.c,220 :: 		turn_left();
	CALL       _turn_left+0
;EmbeddedActualFinalCodeForGroup8.c,221 :: 		}
L_main37:
;EmbeddedActualFinalCodeForGroup8.c,222 :: 		if (sensor_R == 0 && sensor_L != 0) {
	MOVF       main_sensor_R_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main40
	MOVF       main_sensor_L_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main40
L__main73:
;EmbeddedActualFinalCodeForGroup8.c,223 :: 		turn_right();
	CALL       _turn_right+0
;EmbeddedActualFinalCodeForGroup8.c,225 :: 		}
L_main40:
;EmbeddedActualFinalCodeForGroup8.c,227 :: 		}
	GOTO       L_main28
L_main29:
;EmbeddedActualFinalCodeForGroup8.c,230 :: 		while(1){
L_main41:
;EmbeddedActualFinalCodeForGroup8.c,232 :: 		PORTB = PORTB & 0x7F; //buzzer off
	MOVLW      127
	ANDWF      PORTB+0, 1
;EmbeddedActualFinalCodeForGroup8.c,233 :: 		sensor_R = PORTB & 0x04;
	MOVLW      4
	ANDWF      PORTB+0, 0
	MOVWF      main_sensor_R_L0+0
;EmbeddedActualFinalCodeForGroup8.c,234 :: 		sensor_L = PORTB & 0x08;
	MOVLW      8
	ANDWF      PORTB+0, 0
	MOVWF      main_sensor_L_L0+0
;EmbeddedActualFinalCodeForGroup8.c,235 :: 		obstacle_ir = PORTB & 0x02; //right IR
	MOVLW      2
	ANDWF      PORTB+0, 0
	MOVWF      main_obstacle_ir_L0+0
;EmbeddedActualFinalCodeForGroup8.c,236 :: 		obstacle_ir1 = PORTB & 0x01; //left IR
	MOVLW      1
	ANDWF      PORTB+0, 0
	MOVWF      main_obstacle_ir1_L0+0
;EmbeddedActualFinalCodeForGroup8.c,237 :: 		obstacle_irm = PORTD & 0x80; //center IR
	MOVLW      128
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      main_obstacle_irm_L0+0
;EmbeddedActualFinalCodeForGroup8.c,238 :: 		if(obstacle_irm == 0){
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main43
;EmbeddedActualFinalCodeForGroup8.c,239 :: 		turn_left(); }
	CALL       _turn_left+0
	GOTO       L_main44
L_main43:
;EmbeddedActualFinalCodeForGroup8.c,241 :: 		if(obstacle_ir == 0 && obstacle_irm != 0){
	MOVF       main_obstacle_ir_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main47
	MOVF       main_obstacle_irm_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main47
L__main72:
;EmbeddedActualFinalCodeForGroup8.c,242 :: 		turn_left(); }
	CALL       _turn_left+0
	GOTO       L_main48
L_main47:
;EmbeddedActualFinalCodeForGroup8.c,243 :: 		else if(obstacle_ir1 == 0 && obstacle_irm != 0) {
	MOVF       main_obstacle_ir1_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main51
	MOVF       main_obstacle_irm_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_main51
L__main71:
;EmbeddedActualFinalCodeForGroup8.c,244 :: 		turn_right();
	CALL       _turn_right+0
;EmbeddedActualFinalCodeForGroup8.c,245 :: 		}
	GOTO       L_main52
L_main51:
;EmbeddedActualFinalCodeForGroup8.c,246 :: 		else if(obstacle_ir1 == 0 && obstacle_irm == 0 ){
	MOVF       main_obstacle_ir1_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main55
	MOVF       main_obstacle_irm_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main55
L__main70:
;EmbeddedActualFinalCodeForGroup8.c,247 :: 		hard_right();
	CALL       _hard_right+0
;EmbeddedActualFinalCodeForGroup8.c,248 :: 		}
	GOTO       L_main56
L_main55:
;EmbeddedActualFinalCodeForGroup8.c,249 :: 		else if (sensor_R == 0 && sensor_L == 0) {
	MOVF       main_sensor_R_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main59
	MOVF       main_sensor_L_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main59
L__main69:
;EmbeddedActualFinalCodeForGroup8.c,250 :: 		break;
	GOTO       L_main42
;EmbeddedActualFinalCodeForGroup8.c,251 :: 		}
L_main59:
;EmbeddedActualFinalCodeForGroup8.c,252 :: 		else{ turn_right1();
	CALL       _turn_right1+0
;EmbeddedActualFinalCodeForGroup8.c,253 :: 		}
L_main56:
L_main52:
L_main48:
L_main44:
;EmbeddedActualFinalCodeForGroup8.c,257 :: 		}
	GOTO       L_main41
L_main42:
;EmbeddedActualFinalCodeForGroup8.c,258 :: 		while(1){
L_main61:
;EmbeddedActualFinalCodeForGroup8.c,259 :: 		obstacle_ir = PORTB & 0x02;
	MOVLW      2
	ANDWF      PORTB+0, 0
	MOVWF      main_obstacle_ir_L0+0
;EmbeddedActualFinalCodeForGroup8.c,260 :: 		obstacle_ir1 = PORTB & 0x01;
	MOVLW      1
	ANDWF      PORTB+0, 0
	MOVWF      main_obstacle_ir1_L0+0
;EmbeddedActualFinalCodeForGroup8.c,261 :: 		obstacle_irm = PORTD & 0x80;
	MOVLW      128
	ANDWF      PORTD+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      main_obstacle_irm_L0+0
;EmbeddedActualFinalCodeForGroup8.c,262 :: 		if(obstacle_irm == 0){
	MOVF       R1+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main63
;EmbeddedActualFinalCodeForGroup8.c,263 :: 		stop_motors();
	CALL       _stop_motors+0
;EmbeddedActualFinalCodeForGroup8.c,264 :: 		raise_servo_RD6();
	CALL       _raise_servo_RD6+0
;EmbeddedActualFinalCodeForGroup8.c,265 :: 		while(1)stop_motors();
L_main64:
	CALL       _stop_motors+0
	GOTO       L_main64
;EmbeddedActualFinalCodeForGroup8.c,266 :: 		}
L_main63:
;EmbeddedActualFinalCodeForGroup8.c,267 :: 		else if(obstacle_ir == 0) {
	MOVF       main_obstacle_ir_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main67
;EmbeddedActualFinalCodeForGroup8.c,268 :: 		turn_left();
	CALL       _turn_left+0
;EmbeddedActualFinalCodeForGroup8.c,269 :: 		}
	GOTO       L_main68
L_main67:
;EmbeddedActualFinalCodeForGroup8.c,270 :: 		else{ turn_right1();
	CALL       _turn_right1+0
;EmbeddedActualFinalCodeForGroup8.c,271 :: 		}
L_main68:
;EmbeddedActualFinalCodeForGroup8.c,272 :: 		}
	GOTO       L_main61
;EmbeddedActualFinalCodeForGroup8.c,273 :: 		}}
L_end_main:
	GOTO       $+0
; end of _main
