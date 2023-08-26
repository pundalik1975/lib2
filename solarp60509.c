
/*****************************************************
derived from solarp60508.c
reason: to add gps
change recieve buffer size to 128bytes


derived from solarp60507.c
date: 13 jan 2021

backtracking achieved
todo
1. PWM soft start
2. PWM soft end


derived from solarp60506.c
reason: paramaters set_width and set_distance added in 6.c
todo:
add backtracking logic and set target angle accordingly.
also remove bug of limit angles.
also correct eeprom load addition of width and distance
CHANGED TO MEGA32


derived from solarp60505.c
to add backtracking parameters



derived from solarp60504.c
reason:
to change angle fro 0 to 180 to -90 to 90 degrees for backtracking compatibility


derived from solarmpu60503.c
to add complimentary filter to pitch/roll from gyroscope reading
pitch = 0.7(oldpitch*gyronormalised)+ 0.3(newpitch)

serived from  solarmpu60501.c
reason: to calculate pitch and roll from mpu data
 



derived from ravindra energy logic with no name
reason: to replace 3421 with MPU6050
adc3421 read and init routines changed


date: 22-09-2021
reason: to change the welcome message to remove micron instruments

derived from ravindra energy.c
date: 21-06-2019
reason: to add loading of rtc value  to eeprom on power up if rtc value is valid.


derived from only tracker1.c
date: 19 -06-2019
reason: to add protection for corruption of data

1. add backup for time and date if corrupt
        if time is corrupt, reset time to last stored value, if last stored value is ff, then reset to 12:00
        store time and date every 30mins. total writes /year =16000.
2. add limits to start angle and end angle. if they are corrupt reset them to 55/125 degrees



derived from tracker 3 phase.c
to change the latitude and longitude to 26.5 and 73.8 degrees
to change the start angle and end angle to 50 deg and 125 deg.

derived from micron 20W.c
reason: to create a only tracker software
todo
1. remove the battery charger and battery voltage related part
2. remove the adc sensing of various voltages. retain onlty the accelerometer part



DERIVED FROM LUBI ELECTRONIC.C
TO CHANGE WELCOME MESSAGE TO MICRON INSTRUMENTS



derived from tracker3.c
reason: to change welcome message to lubi electronics.


date : 17-11-2013
derived from tracker2.c

reason:
1.low battery indication in normal mode. hysterisis to be provided for reconnection on 12.4V
2. cutoff backlight on low battery status (errfl2)
3. if adc_battery > 15V, cut charging , put message ("no battery connected");
4. remove condition that if battery voltage < 5V, disconnect charging.
5. increase current limits to 1.2A/1A
6. overflow for OCR1A correction
7. fast charging depending on battery voltage
8. low battery/battery not connected sensing and algorithm.
9. bug of sleep mode.
10.MPPT changed to full charge PV >=battery + 2.0V





date: 13 nov 2013
derived from tracker1.c
reason: to test in new hardware
changes:
OC1A - pin 19 of mega32 - pwm output
OC1B = pin 18 of mega32 - shutdown for ir2104
mux lines pc7 and pc5 interchanged to suit new hardware solar4-main
rs232 to be re-introduced





derived from solar14.c

reason: to add algorithm for sleep mode between sunset + 30 min and sunrise - 30 min.
derived from solar13.c
reason: to make algorithm change to the mechanical error logic.
checked once every 30 seconds. if angle has changed more than 2 degrees then continue else end panel movement



date: 04-nov 2013
reason: to make following changes as suggested by tata solar
1.enter/exit of calibration mode for start/emd angle setting improved.**
2.LED indication in case of error on charger side to be inhibited.    **
3. timeout for mechanical error to be changed
4. battery low indication in absence of PV to be indicated.           **
5. output to relay to be inhibited in all conditions even in manual mode. **


date: 23-9-13
reason:
done: setting of latitude/longitude and timezone for user
result stored in riset,settm.

todo: put value in regular calculation of target angle.
remove existing table for sunrise/set.

********


date: 16-09-2013

derived from solar4.c
reason:to add latitude/longitude calculations.
only for checking purpose





date: 20 july 2013
reason:
to add logic to come out of the program mode after 29 seconds of inactivity of key pressed
the variable used is program_timeout, function added is clear_default();

date:5-7-13
reason: to add RS232 control to the unit.
if 'R' is received, send record count.
if 'P' is received, send print command.
if 's' is received , reset record count.


date : 29-6-13
derived from solar1.c
reason: 
to add fixed parameters batteryvoltage = 12V and MPPT 17V
and to monitor and control charging parameters

This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
� Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 27.06.2013
Author  : NeVaDa
Company : Warner Brothers Movie World
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 11,059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega32.h>
#include <delay.h>
#include <math.h>
#include <ctype.h>
#include <stdlib.h>
#include <sleep.h>
#include <string.h>

// I2C Bus functions
#asm
   .equ __i2c_port=0x1B ;PORTA
   .equ __sda_bit=4
   .equ __scl_bit=5
#endasm
#include <i2c.h>

// DS1307 Real Time Clock functions
#include <ds1307.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>

#define key1    PINA.0
#define key2    PINA.1
#define key3    PINA.2
#define key4    PINA.3
#define relay2  PORTC.0
#define relay1  PORTD.7
#define printkey PINA.6
#define led1    PORTD.3
#define led2    PORTC.4
#define led3    PORTD.6
#define led4    PORTC.3
#define led5    PORTC.1
#define led6    PORTC.2
#define mux1    PORTC.5
#define mux2    PORTC.6
#define mux3    PORTC.7
#define backlight   PORTB.3
#define shutdown    PORTD.4


#define battery_voltage 1200   //12V
//#define mppt           1600   //17V
#define equal_voltage   1350   //13.5V
#define boost_voltage   1440   //14.4V
#define boost_current   120    //1.200A
#define trickle_current 100    //1.0A
#define cutoff_voltage  1080   //10.8V
#define reconnect_voltage 1240 // reconnect voltage at 12.4V
#define set_capacity    700    //7AH
#define boost_timeout   36000    //1 hour
#define float_timeout   36000    //1 hour
#define log_interval    5       // 5 second interval

/////////

//////mpu6050 definition section//////////////
#define XG_OFFS_TC 0x00
#define YG_OFFS_TC 0x01
#define ZG_OFFS_TC 0x02
#define X_FINE_GAIN 0x03
#define Y_FINE_GAIN 0x04
#define Z_FINE_GAIN 0x05
#define XA_OFFS_H 0x06 
#define XA_OFFS_L_TC 0x07
#define YA_OFFS_H 0x08 
#define YA_OFFS_L_TC 0x09
#define ZA_OFFS_H 0x0A 
#define ZA_OFFS_L_TC 0x0B
#define XG_OFFS_USRH 0x13
#define XG_OFFS_USRL 0x14
#define YG_OFFS_USRH 0x15
#define YG_OFFS_USRL 0x16
#define ZG_OFFS_USRH 0x17
#define ZG_OFFS_USRL 0x18
#define SMPLRT_DIV 0x19
#define CONFIG 0x1A
#define GYRO_CONFIG 0x1B
#define ACCEL_CONFIG 0x1C
#define FF_THR 0x1D
#define FF_DUR 0x1E
#define MOT_THR 0x1F
#define MOT_DUR 0x20
#define ZRMOT_THR 0x21
#define ZRMOT_DUR 0x22
#define FIFO_EN 0x23
#define I2C_MST_CTRL 0x24
#define I2C_SLV0_ADDR 0x25
#define I2C_SLV0_REG 0x26
#define I2C_SLV0_CTRL 0x27
#define I2C_SLV1_ADDR 0x28
#define I2C_SLV1_REG 0x29
#define I2C_SLV1_CTRL 0x2A
#define I2C_SLV2_ADDR 0x2B
#define I2C_SLV2_REG 0x2C
#define I2C_SLV2_CTRL 0x2D
#define I2C_SLV3_ADDR 0x2E
#define I2C_SLV3_REG 0x2F
#define I2C_SLV3_CTRL 0x30
#define I2C_SLV4_ADDR 0x31
#define I2C_SLV4_REG 0x32
#define I2C_SLV4_DO 0x33
#define I2C_SLV4_CTRL 0x34
#define I2C_SLV4_DI 0x35
#define I2C_MST_STATUS 0x36
#define INT_PIN_CFG 0x37
#define INT_ENABLE 0x38
#define DMP_INT_STATUS 0x39
#define INT_STATUS 0x3A
#define ACCEL_XOUT_H 0x3B
#define ACCEL_XOUT_L 0x3C
#define ACCEL_YOUT_H 0x3D
#define ACCEL_YOUT_L 0x3E
#define ACCEL_ZOUT_H 0x3F
#define ACCEL_ZOUT_L 0x40
#define TEMP_OUT_H 0x41
#define TEMP_OUT_L 0x42
#define GYRO_XOUT_H 0x43
#define GYRO_XOUT_L 0x44
#define GYRO_YOUT_H 0x45
#define GYRO_YOUT_L 0x46
#define GYRO_ZOUT_H 0x47
#define GYRO_ZOUT_L 0x48
#define EXT_SENS_DATA_00 0x49
#define EXT_SENS_DATA_01 0x4A
#define EXT_SENS_DATA_02 0x4B
#define EXT_SENS_DATA_03 0x4C
#define EXT_SENS_DATA_04 0x4D
#define EXT_SENS_DATA_05 0x4E
#define EXT_SENS_DATA_06 0x4F
#define EXT_SENS_DATA_07 0x50
#define EXT_SENS_DATA_08 0x51
#define EXT_SENS_DATA_09 0x52
#define EXT_SENS_DATA_10 0x53
#define EXT_SENS_DATA_11 0x54
#define EXT_SENS_DATA_12 0x55
#define EXT_SENS_DATA_13 0x56
#define EXT_SENS_DATA_14 0x57
#define EXT_SENS_DATA_15 0x58
#define EXT_SENS_DATA_16 0x59
#define EXT_SENS_DATA_17 0x5A
#define EXT_SENS_DATA_18 0x5B
#define EXT_SENS_DATA_19 0x5C
#define EXT_SENS_DATA_20 0x5D
#define EXT_SENS_DATA_21 0x5E
#define EXT_SENS_DATA_22 0x5F
#define EXT_SENS_DATA_23 0x60
#define MOT_DETECT_STATUS 0x61
#define I2C_SLV0_DO 0x63
#define I2C_SLV1_DO 0x64
#define I2C_SLV2_DO 0x65
#define I2C_SLV3_DO 0x66
#define I2C_MST_DELAY_CTRL 0x67
#define SIGNAL_PATH_RESET 0x68
#define MOT_DETECT_CTRL 0x69
#define USER_CTRL 0x6A
#define PWR_MGMT_1 0x6B
#define PWR_MGMT_2 0x6C
#define BANK_SEL 0x6D
#define MEM_START_ADDR 0x6E
#define MEM_R_W 0x6F
#define DMP_CFG_1 0x70
#define DMP_CFG_2 0x71
#define FIFO_COUNTH 0x72
#define FIFO_COUNTL 0x73
#define FIFO_R_W 0x74
#define WHO_AM_I 0x75

#define Buffer_Size 150
#define degrees_buffer_size 20

///////////////////////////////////////////




float pi =3.14159;
float degs;
float rads;
float L,g;
float sundia = 0.53;
float airrefr = 34.0/60.0;
float settm,riset,daytime,sunrise_min,sunset_min;

///////////////////////////////////////////////////

long int adc_buffer,timeout_cnt,target_angle,sun_angle,printkeycnt,calibusercnt,program_timeout;
unsigned char hour,minute,second,week,day,month,year;
bit key1_old,key2_old,key3_old,key4_old,printkey_old,start_fl,end_fl,inf_fl;
//bit rcflag;
bit key1_fl,key2_fl,key3_fl,key4_fl,printkey_fl,err_fl,led_blinkfl,sleep_fl,print_fl;
bit pgm_fl,blink_fl,adc_fl,read_adcfl,boost_fl,trickle_fl,float_fl;
short int mode,set,item1,bright_cnt,mode0_seqcnt,end_cnt,sleep_counter;
//short int ir_cnt;
unsigned int time_cnt,time_cnt1,pwm_count;
unsigned int mode1_count,blink_count,display_cnt,manual_cnt;
//unsigned long int boost_time,float_time;
char blink_locx,blink_locy;
char blink_data;
signed int set_latit,set_longitude,low_angle,high_angle,time_interval,target_time,time_elap,set_timezone;
//int ircommand;
//unsigned long irsense;
long int zero_adc,span_adc;
unsigned char char_latitude,char_longitude,char_timezone,char_width,char_distance;
//char record_buffer[16];
eeprom signed int e_set_latit = 2650,e_set_longitude =7380,e_low_angle=-450,e_high_angle=450,e_time_interval=15,e_set_timezone=550;
eeprom long int e_zero_adc =900,e_span_adc=20000;
eeprom int record_cnt @0x020;
eeprom int record_cnt =0;
eeprom unsigned char e_hour=12,e_minute=0,e_second=0,e_week=1,e_month=6,e_day=1,e_year=19;
//flash int sunrise_time[] ={718,709,607,620,601,556,605,617,625,634,649,708};            //according to month
//flash int sunset_time[]={1818,1836,1848,1857,1909,1921,1923,1908,1841,1814,1757,1759};   //according to month
//flash int sunrise_min[]={438,429,407,380,361,356,365,377,385,394,409,428};
//flash int sunset_min[]={1098,1116,1128,1137,1149,1161,1163,1148,1121,1094,1077,1079};
//flash int daytime[]={659,687,720,757,788,804,798,771,736,700,668,651};
bit calibuser,calibfact,manual_fl=0;
//char flash *message1 = {"set the time"};
int x_angle,y_angle,z_angle,pitch,roll,angle,Gyrox,Gyroy,Gyroz;
int angle_filt[4]={0,0,0,0};
void display_update(void);
int set_distance,set_width;
eeprom int e_set_width =10,e_set_distance = 20;
signed int new_target,b_factor,gangle;

//gps variables
char Latitude_Buffer[15],Longitude_Buffer[15],Time_Buffer[15],Altitude_Buffer[8];

char degrees_buffer[degrees_buffer_size];   /* save latitude or longitude in degree */
char GGA_Buffer[Buffer_Size];               /* save GGA string */
short int GGA_Pointers[20];                   /* to store instances of ',' */
char GGA_CODE[3];

volatile int GGA_Index, CommaCounter;

bit IsItGGAString;


///////////////




/* table for the user defined character
   arrow that points to the top right corner */



flash char char0[8]={
0b0001110,
0b0010001,
0b0010001,
0b0001110,
0b0000000,
0b0000000,
0b0000000,
0b0000000};

void backtrack(void);




/* function used to define user characters */
void define_char(char flash *pc,char char_code)
{
char i,a;
a=(char_code<<3) | 0x40;
for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
}

////GPSroutines
void convert_time_to_UTC()
{
	unsigned int hour, min, sec;
	long Time_value;
	Time_value = atol(Time_Buffer);       /* convert string to integer */
	hour = (Time_value / 10000);          /* extract hour from integer */
	min  = (Time_value % 10000) / 100;    /* extract minute from integer */
	sec  = (Time_value % 10000) % 100;    /* extract second from integer*/
    Time_Buffer[0] = (hour/10)+48;
    Time_Buffer[1] = (hour%10)+48;
    Time_Buffer[2] = ':';
    Time_Buffer[3] = (min/10)+48;
    Time_Buffer[4] = (min%10)+48;
    Time_Buffer[5] = ':';
    Time_Buffer[6] = (sec/10)+48;
    Time_Buffer[7] = (sec%10)+48;
    
//	sprintf(Time_Buffer, "%d:%d:%d", hour,min,sec);
}

void convert_to_degrees(char *raw){
	
	float value;
	float decimal_value,temp;
	
	long degrees;
	
	float position;
	value = atof(raw);    /* convert string into float for conversion */
	
	/* convert raw latitude/longitude into degree format */
	decimal_value = (value/100);
	degrees       = (int)(decimal_value);
	temp          = (decimal_value - (int)decimal_value)/0.6; 
	position      = (float)degrees + temp;
	
	ftoa(position, 4, degrees_buffer);  /* convert float value into string */	
}

void get_gpstime(void)
        {
	short int time_index=0,index;
	#asm("cli")
    
	/* parse Time in GGA string stored in buffer */
	for(index = 0; GGA_Buffer[index] != ',' ; index ++)
    {
		
		Time_Buffer[time_index] = GGA_Buffer[index];
		time_index++;
	}
	convert_time_to_UTC();
	#asm("sei");
    }

void get_latitude(long lat_pointer)
    {
	short int lat_index;
	short int index;
    #asm("cli")
    index = lat_pointer+1;
   	lat_index=0;
	
	/* parse Latitude in GGA string stored in buffer */
	for(;GGA_Buffer[index]!=',';index++)
    {
		Latitude_Buffer[lat_index]= GGA_Buffer[index];
		lat_index++;
	}
	
	Latitude_Buffer[lat_index++] = GGA_Buffer[index++];
	Latitude_Buffer[lat_index]   = GGA_Buffer[index];  // get direction 
	convert_to_degrees(Latitude_Buffer);
	#asm("sei");
    }

void get_longitude(int long_pointer)
    {
	short int long_index;
	short int index = long_pointer+1;
    #asm("cli")
	long_index=0;
	
	/* parse Longitude in GGA string stored in buffer */
	for( ; GGA_Buffer[index]!=','; index++)
    {
		Longitude_Buffer[long_index]= GGA_Buffer[index];
		long_index++;
	}
	
	Longitude_Buffer[long_index++] = GGA_Buffer[index++];
	Longitude_Buffer[long_index]   = GGA_Buffer[index]; /* get direction */
	convert_to_degrees(Longitude_Buffer);
	#asm("sei");
    }

void get_altitude(int alt_pointer)
    {
	short int alt_index;
	int index ;
    index = alt_pointer+1; 
    #asm("cli")

	alt_index=0;
	/* parse Altitude in GGA string stored in buffer */
	for( ; GGA_Buffer[index]!=','; index++)
    {
		Altitude_Buffer[alt_index]= GGA_Buffer[index];
		alt_index++;
	}
	
	Altitude_Buffer[alt_index] = GGA_Buffer[index+1];
	#asm("sei");
}


//////





//void control_buck_off(void)
//{   
//TCCR1A &= 0x3f;         // stop PWM outpu
//shutdown = 0;
//}

//void control_buck_on(void)
//{
//shutdown =1;
//delay_ms(2);
//TCCR1A |= 0x80;         // turn PWM on.
//}
//////*********

float fnday(long y,long m,long d,float h)
            {
            long int luku = -7 *(y+(m+9)/12)/4 + 275*m/9 + d;
            luku+=(long int) y*367;
            return (float)luku-730531.5 + h/24.0;
            }
            
float fnrange(float x)
            {
            float b = 0.5 * x / pi;
            float a = 2.0 * pi * (b - (long) b);
            if (a<0) a = 2.0 * pi+a;
            return a;
            }
            
            
float f0(float lat, float declin)
            {
            float f0,df0;
            df0 = rads *(0.5*sundia + airrefr);
            if (lat <0.0) df0 = -df0;
            f0 = tan(declin+df0) * tan(lat*rads);
            if (f0>0.99999) f0 = 1.0;
            f0 = asin(f0) + pi/2.0;
            return f0;
            }


float fnsun(float d)
            {
            L = fnrange(280.461* rads + 0.9856474 * rads * d);
            g = fnrange(357.528 * rads + 0.9856003 * rads * d);
            
            return fnrange(L+1.915 * rads * sin(g) + 0.02 * rads * sin(2*g));
            }
  
void rise_set( float day,float m,float y,float h,float latit,float longit,float tzone)
{
float d,lamda;
float obliq,alpha,delta,LL,equation,ha;
degs = 180.0/pi;
rads = pi/180.0;
h=12;
d= fnday (y,m,day,h);
lamda = fnsun(d);
obliq = 23.439 * rads - 0.0000004 * rads *d;
alpha =atan2(cos(obliq) * sin(lamda),cos(lamda));
delta = asin(sin(obliq) * sin(lamda));

LL = L-alpha;
if (L<pi) LL+= 2.0 * pi;
equation = 1440.0 * (1.0 - LL/pi/2.0);
ha = f0(latit,delta);
riset = 12.0 - 12.0 * ha/pi +tzone - longit/15.0 +equation/60.0;
settm = 12.0 + 12.0 * ha/pi +tzone - longit/15.0 + equation/60.0;
if (riset > 24.0) riset =riset -24.0;
if (settm > 24.0) settm =settm -24.0;
sunrise_min = riset * 60;       //rise time in minutes
sunset_min = settm * 60;        //set time in minutes
daytime = sunset_min - sunrise_min ;   //day time in minutes
}

/////*********


//void print_realtime(void);

void clear_to_default()
{
if (mode!=0)
    {
                mode1_count =0;
                mode =0;
                pgm_fl =0;  
                blink_fl =0;
                set =0;
                item1 =0;
                lcd_clear();
                delay_ms(10);
    }       
if (manual_fl)
    {
            manual_fl =0;
            lcd_clear();
            lcd_putsf("manual mode");
            lcd_gotoxy(0,1);
            lcd_putsf("exiting...");
            delay_ms(2000);
 
    }
}

int to_minute(char hr,char min)
{
return (hr*60 + min);
}



void put_message(long int a)
{
char b[5];
if (a <0)
{
lcd_putchar('-');
a = -a;
}
else
{
lcd_putchar(' ');
}
b[0] = a % 10 + 48;
a = a/10;
b[1] = a % 10 + 48;
a = a/10;
b[2] = a % 10 + 48;
a = a/10;
b[3] = a % 10 + 48;
a = a/10;
b[4] = a + 48;
lcd_putchar(b[4]);
lcd_putchar(b[3]);
lcd_putchar(b[2]);
lcd_putchar(b[1]);
lcd_putchar(b[0]);


}

void put_message2(unsigned char a)
{
char b[2];
b[0] = a % 10 + 48;
a = a/10;
b[1] = a + 48;
lcd_putchar(b[1]);
lcd_putchar(b[0]);
}

void put_message3(unsigned int a)
{
char b[3];
b[0] = (a %10) + 48;
a = a/10;
b[1] = (a %10) + 48;
a = a/10;
b[2] = a + 48;
lcd_putchar(b[2]);
lcd_putchar(b[1]);
lcd_putchar(b[0]);
}

void blink_control(void)
{
if (blink_fl)
{
 blink_count++;
 if (blink_count >=200) blink_count =0;
 
 if (blink_count >=150) 
 {
 lcd_gotoxy(blink_locx,blink_locy);
 lcd_putsf("  ");
 }
 else
 {
 lcd_gotoxy(blink_locx,blink_locy);
 put_message2(blink_data);
 }
     
 
 
 }
 }

void display_time(void)
{
      put_message2(hour);  
      lcd_putchar(':');
      put_message2(minute);
      lcd_putchar(':');
      put_message2(second); 
}

void display_latlong(signed int l)
{
unsigned int m;
if (l<0) 
lcd_putchar('-');
else
lcd_putchar('+');
m = abs(l);
put_message3(m/100);
lcd_putchar('.');
put_message2(m%100);
}

/*
void display_time2(int t)
{
    put_message2(t/100);
    lcd_putchar(':');
    put_message2((t%100)*6/10);
}
*/

void display_date(void)
{
      put_message2(day);  
      lcd_putchar('.');
      put_message2(month);
      lcd_putchar('.');
      lcd_putsf("20");
      put_message2(year); 
}

/*
void display_day(int data)
{
char a;
a = data /100;
put_message2(a);
lcd_putsf(":");
a = data%100;
put_message2(a);
}
*/

void display_day2(int data)
{
char a;
a = data /60;
put_message2(a);
lcd_putsf(":");
a = data%60;
put_message2(a);
}

void display_analog(int a)
{
    put_message2(a/100);
    lcd_putchar('.');
    put_message2(a%100);
}

void display_angle(int a)
{
char x,y;
if (a<0)
{
a = -a;
lcd_putchar('-');
}
else
{
lcd_putchar(' ');
}
y = a/10;
x = y%100;
y = y/100; 
lcd_putchar(y+48);       
put_message2(x);
  
lcd_putchar('.');
x = a%10;

lcd_putchar(x+48);
lcd_putchar(0);
}

void display_angle1(int a)
{
char x,y;
y = a/10;
x = y%100;
y = y/100; 
lcd_putchar(y+48);       
put_message2(x);
  
lcd_putchar('.');
x = a%10;

lcd_putchar(x+48);
lcd_putchar(0);
}


void check_mode(void)
{
//key1 =1;
if (!key1)
    { 
    bright_cnt =0;
    program_timeout=0;
        mode1_count++;
        if (mode1_count >= 1000)
        {
            if (mode == 0)
            {    
                mode1_count=0;
                mode =1;
                pgm_fl =1;
//                lcd_gotoxy(0,0);
                lcd_clear();
                lcd_putsf("set the time");
                lcd_gotoxy(0,1);
                display_time();
                blink_data = hour;
                blink_locx =0;
                blink_locy =1;
                blink_fl =1;                              
                set =0;
                item1 =0;
            }
            else
            {   
                mode1_count =0;
                mode =0;
                pgm_fl =0;  
                blink_fl =0;
                set =0;
                item1 =0;
                lcd_clear();
                delay_ms(10);
            }
        } 
    }
else
    mode1_count =0; 

//////manual mode key check
if (!key4)
{
manual_cnt++;
if (manual_cnt > 2000)
        {
        manual_cnt =0;
        if (!manual_fl)
            {
            manual_fl =1;
            lcd_clear();
            lcd_putsf("manual mode");
            lcd_gotoxy(0,1);
            lcd_putsf("entering....");
            delay_ms(2000);
            }
        else
            {
            manual_fl =0;
            lcd_clear();
            lcd_putsf("manual mode");
            lcd_gotoxy(0,1);
            lcd_putsf("exiting...");
            delay_ms(2000);
            }

        }

}



//////////////////////////



}

void check_increment(void)
{
if (key2_fl && pgm_fl)
{
    key2_fl =0; 
        bright_cnt =0;
        program_timeout=0;

    if (mode ==1)
    {
//    while(1);
    switch (item1)
    {
        case 0: hour++;
                if (hour > 24) hour =0;
                break;
        case 1: minute++;
                if (minute > 59) minute =0;
                break;
        case 2: second++;
                if (second >59) second =0;
                break;
        case 3: day++;
                if (day > 31) day =1;
                break;
        case 4: month++;
                if (month > 12) month = 1;
                break;
        case 5: year++;
                if (year >99) year = 13;
                break;
        case 6: set_latit+=100;
                if (set_latit > 9000) set_latit =9000;
                char_latitude = blink_data = abs(set_latit)/100;
                break;
        case 7: set_latit+=1;
                if (set_latit > 9000) set_latit =9000;
                char_latitude = blink_data = abs(set_latit)%100;
                break;
        case 8: set_longitude+=100;
                if (set_longitude > 18000) set_longitude = 18000;
                char_longitude = blink_data = (abs(set_longitude)/100)%100;
                break;
        case 9: set_longitude+=1;
                if (set_longitude > 18000) set_longitude = 18000;
                char_longitude = blink_data = abs(set_longitude)%100;
                break; 
        case 10:time_interval+=5;
                if (time_interval > 90) time_interval = 5; 
                break;
        case 11: set_timezone+=100;
                if(set_timezone > 1200) set_timezone = 1200;
                break;        
        case 12: set_timezone+=25;
                if(set_timezone > 1200) set_timezone = 1200;
                break;             
        case 13:set_width+=100;
                if (set_width > 9999) set_width = 99; 
                break;
        case 14:set_width+=10;
                if (set_width > 9999) set_width = 99; 
                break;
        case 15:set_distance+=100;
                if (set_distance > 9999) set_distance = 99; 
                break;
        case 16:set_distance+=10;
                if (set_distance > 9999) set_distance = 99; 
                break;
                 
       }
    
    }


}
}

void check_decrement(void)
{
if (key3_fl && pgm_fl)
{
    bright_cnt =0;
    program_timeout=0;
    key3_fl =0;
    if (mode ==1)
    {
    switch (item1)
    {
        case 0: hour--;
                if (hour > 23) hour =23; 
                break;
        case 1: minute--;
                if (minute > 59) minute =59;
                break;
        case 2: second--;
                if (second > 59) second =59;
                break;
        case 3: day--;
                if (day <1) day =31;
                break;
        case 4: month--;
                if (month <1) month = 12;
                break;
        case 5: year--;
                if (year >99) year = 99;
                break;
        case 6: set_latit-=100;
                if (set_latit <-9000) set_latit =-9000;
                char_latitude = blink_data = abs(set_latit)/100;
                break;
        case 7: set_latit-=1;
                if (set_latit <-9000) set_latit =-9000;        
                char_latitude = blink_data = abs(set_latit)%100;
                break;
        case 8: set_longitude-=100;
                if (set_longitude <-18000) set_longitude =-18000;
                char_longitude = blink_data = (abs(set_longitude)/100)%100;
                break;
        case 9: set_longitude-=1;
                if (set_longitude <-18000) set_longitude =-18000;
                char_longitude = blink_data = abs(set_longitude)%100;
                break;
        case 10:time_interval-=5;
                if(time_interval<5) time_interval =90;
                break;
        case 11: set_timezone-=100;
                if(set_timezone < -1200) set_timezone = -1200;
                break;        
        case 12: set_timezone-=25;
                if(set_timezone < -1200) set_timezone = -1200;
                break;        
        case 13:set_width-=100;
                if (set_width <1) set_width = 1; 
                break;
        case 14:set_width-=10;
                if (set_width <1) set_width = 1; 
                break;
        case 15:set_distance-=100;
                if (set_distance <1) set_distance = 1; 
                break;
        case 16:set_distance-=10;
                if (set_distance <1) set_distance = 1; 
                break;

    }
    
    }


}
}

void check_shift(void)
{
if (key4_fl && pgm_fl)
{
    bright_cnt =0;
    program_timeout=0;
    key4_fl =0;
    if (mode ==1)
    {
    item1++;
    if (set ==0 && item1>2) item1=0;
    if (set ==1 && (item1 <3 || item1 >5)) item1 =3;
    if (set ==2 && (item1 <6 || item1 >7)) item1 =6;
    if (set ==3 && (item1 <8 || item1 >9)) item1 =8;
    if (set ==4) item1 =10;
    if (set ==5 && (item1 <11 || item1 >12)) item1 = 11;
    if (set ==6 && (item1 <13 || item1 >14)) item1 = 13;
    if (set ==7 && (item1 <15 || item1 >16)) item1 = 15;;    
   }

}
}

void check_enter(void)
{



if (key1_fl && pgm_fl)
{
    bright_cnt =0;
    program_timeout=0;
    key1_fl =0;
    if (mode ==1)
    {
    switch(set)
    {
    case 0: rtc_set_time(hour,minute,second);
            break;
    case 1: rtc_set_date(week,day,month,year);   // pdi is week day not used.
            break;
    case 2: e_set_latit = set_latit;
            break;
    case 3: e_set_longitude = set_longitude;
            break;
    case 4: e_time_interval = time_interval;
            break; 
    case 5: e_set_timezone = set_timezone;  
            break;
    case 6: e_set_width = set_width ;
            break;
    case 7: e_set_distance = set_distance;
            break; 
    }

    set++;
    if (set>7)  set =0;
    
    switch (set)
    {
    case 0:     lcd_clear();
                lcd_putsf("Set Time");
                rtc_get_time(&hour,&minute,&second);
//                if (hour <0 || hour >24) rtc_err=1;         //added for rtc error
                lcd_gotoxy(0,1);
                display_time();
                blink_data = hour;
                blink_locx =0;
                blink_locy =1;
                blink_fl =1;                              
                set =0;
                item1 =0;
                break;

    case 1:     lcd_clear();
                lcd_putsf("Set Date");
                rtc_get_date(&week,&day,&month,&year);   // pdi is weekday not used only for cvavr2.05.
                lcd_gotoxy(0,1);
                display_date();
                blink_data = day;
                blink_locx =0;
                blink_locy =1;
                blink_fl =1;                              
                set =1;
                item1 = 3;  
                break;
    case 2:     lcd_clear();
                lcd_putsf("Set Latitude");
                set_latit = e_set_latit;
                lcd_gotoxy(0,1);
                display_latlong(set_latit);
                lcd_putchar(0);
                char_latitude = blink_data = (abs(set_latit)/100)%100 ;
                blink_locx =2;
                blink_locy =1;
                blink_fl =1;                              
                set =2;
                item1 =6;
                break;
    case 3:     lcd_clear();
                lcd_putsf("Set Longitude");
                set_longitude = e_set_longitude;
                lcd_gotoxy(0,1);
                display_latlong(set_longitude);
                lcd_putchar(0);
                char_longitude = blink_data = (abs(set_longitude)/100)%100 ;
                blink_locx =2;
                blink_locy =1;
                blink_fl =1;                              
                set =3;
                item1 =8;
                break;  
    case 4:     lcd_clear();
                lcd_putsf("Time Interval ");
                e_time_interval = time_interval;
                lcd_gotoxy(0,1);
                put_message2(time_interval);
                lcd_putsf(" minutes");
                blink_data = time_interval;
                blink_locx =0;
                blink_locy =1;
                blink_fl =1;                              
                set =4;
                item1 =10;
                break;
    case 5:     lcd_clear();
                lcd_putsf("Set Timezone");
                set_timezone = e_set_timezone;
                lcd_gotoxy(0,1);
                lcd_putsf("GMT ");        
                display_latlong(set_timezone);
                lcd_putsf("Hrs.");
                char_timezone = blink_data = (abs(set_timezone)/100)%100 ;
                blink_locx =6;
                blink_locy =1;
                blink_fl =1;                              
                set =5;
                item1 =11;
                break;
    case 6:     lcd_clear();
                lcd_putsf("Set Panel Width");
                set_width = e_set_width;
                lcd_gotoxy(0,1);
                lcd_putsf("    ");        
                display_latlong(set_width);
                lcd_putsf("Mtrs.");
                char_width = blink_data = (abs(set_width)/100)%100 ;
                blink_locx =6;
                blink_locy =1;
                blink_fl =1;                              
                set =6;
                item1 =13;
                break;
    case 7:     lcd_clear();
                lcd_putsf("Set Distance");
                set_distance = e_set_distance;
                lcd_gotoxy(0,1);
                lcd_putsf("    ");        
                display_latlong(set_distance);
                lcd_putsf("Mtrs.");
                char_distance = blink_data = (abs(set_distance)/100)%100 ;
                blink_locx =6;
                blink_locy =1;
                blink_fl =1;                              
                set =7;
                item1 =15;
                break;
        }
    
    }

}
}

void get_key(void)
{
if (!key1 && key1_old) key1_fl =1;
if (!key2 && key2_old) key2_fl =1;
if (!key3 && key3_old) key3_fl =1;
if (!key4 && key4_old) key4_fl =1;
if (!printkey && printkey_old) printkey_fl =1;
printkey_old = printkey;
key1_old = key1;
key2_old = key2;
key3_old = key3;
key4_old = key4;
if (!key3 && mode==0 && !manual_fl)
{
printkeycnt++;
if (printkeycnt >=4000)
            {
            printkeycnt=0;
            printkey_fl =1;
            }
}
else
printkeycnt=0;

if (!key2 && !manual_fl)              //calibuser calibration mode enter
            {
            calibusercnt++;
            if(calibusercnt >=2000)
                        {
                        calibusercnt=0;
                        calibuser=1;            //enter calibration mode for user
                        lcd_clear();
                        lcd_putsf("Calibration Mode");
                        lcd_gotoxy(0,1);
                        lcd_putsf("entering");
                        delay_ms(2000);
                        }
            }
else
calibusercnt=0;
}


 void mpu6050_init(void)
{                      
    delay_ms(150);                                        /* Power up time >100ms */
    i2c_start();
    i2c_write(0xD2);                                /* Start with device write address */
    i2c_write(SMPLRT_DIV);                                /* Write to sample rate register */
    i2c_write(0x07);                                    /* 1KHz sample rate */
    i2c_stop();

    i2c_start();
    i2c_write(0xD2);
    i2c_write(PWR_MGMT_1);                                /* Write to power management register */
    i2c_write(0x01);                                    /* X axis gyroscope reference frequency */
    i2c_stop();

    i2c_start();
    i2c_write(0xD2);
    i2c_write(CONFIG);                                    /* Write to Configuration register */
    i2c_write(0x06);                                    /* Fs = 8KHz */
    i2c_stop();

    i2c_start();
    i2c_write(0xD2);
    i2c_write(GYRO_CONFIG);                                /* Write to Gyro configuration register */
    i2c_write(0x18);                                    /* Full scale range +/- 2000 degree/C */
    i2c_stop();

    i2c_start();
    i2c_write(0xD2);
    i2c_write(INT_ENABLE);                                /* Write to interrupt enable register */
    i2c_write(0x01);
    i2c_stop();
}

/*
long int adc3421_read18(void)
{
 unsigned int buffer1;
 unsigned int buffer2,buffer3;
 long int buffer4;
 i2c_start();
 buffer1 = i2c_write(0xd3);
 buffer1 = i2c_read(1);
 buffer2 = i2c_read(1);
 buffer3 = i2c_read(0);
 i2c_stop();
 buffer1 = buffer1 & 0x01;
 buffer4 = (long) (buffer1) * 65536 ;
 buffer4 = buffer4 + ((long)(buffer2) * 256);
 buffer4 = buffer4 + (long)(buffer3);
 return(buffer4);
} 
*/

int mpu6050_read(void)
{
int pitchacc;
 // unsigned int buffer2,buffer3;
    i2c_start();
    i2c_write(0xD2);                                /* I2C start with device write address */
    i2c_write(ACCEL_XOUT_H);                            /* Write start location address from where to read */ 
    i2c_start();
    i2c_write(0xD3);                            /* I2C start with device read address */
    x_angle= (((int)i2c_read(1)<<8) | (int)i2c_read(1));
    y_angle= (((int)i2c_read(1)<<8) | (int)i2c_read(1));
    z_angle= (((int)i2c_read(1)<<8) | (int)i2c_read(0));
    i2c_stop();
    delay_ms(100);
    i2c_start();
    i2c_write(0xD2);                                /* I2C start with device write address */
    i2c_write(GYRO_XOUT_H);                            /* Write start location address from where to read */ 
    i2c_start();
    i2c_write(0xD3);                            /* I2C start with device read address */
    Gyrox= (((int)i2c_read(1)<<8) | (int)i2c_read(1))/131;       //131 is the gyro scaling factor in datasheet
    Gyroy= (((int)i2c_read(1)<<8) | (int)i2c_read(1)/131);
    Gyroz= (((int)i2c_read(1)<<8) | (int)i2c_read(0)/131);
    i2c_stop();
  
 
 //pitch = (atan2(-y_angle,z_angle)*1800.0)/3.1415;
 //roll = (atan2(x_angle,sqrt((long)y_angle*(long)y_angle+(long)z_angle*(long)z_angle))*1800.0)/3.1415;
    

roll = -1800.0 * atan ((long)x_angle/sqrt((long)y_angle*(long)y_angle + (long)z_angle*(long)z_angle))/3.141592;
pitchacc =1800.0 * atan ((long)y_angle/sqrt((long)x_angle*(long)x_angle + (long)z_angle*(long)z_angle))/3.141592;
//pitch = (0.1*((long)pitch+(long)Gyrox)) + (0.9 * (long)pitchacc);  
pitch = (long)pitchacc;  

    return (pitch);    
} 





void read_adc(void)
{
int offset;
if(adc_fl)
        {
//        adc_angle = mpu6050_read();
        adc_fl =0;
/*
        fil_cnt++;

        if (fil_cnt >=3) 
            {           
            fil_cnt =0;
            adc_angle = ((long)angle_filt[0]+(long)angle_filt[1]+(long)angle_filt[2])/3;
              read_adcfl =1; 
              angle = adc_angle;
            }
       angle_filt[fil_cnt] = mpu6050_read();
*/
        
        angle_filt[0] = mpu6050_read();
        angle = (angle_filt[0]); //+angle_filt[1]+angle_filt[2]+angle_filt[3])/4;        
        read_adcfl =1;
       offset = zero_adc;

        angle = (angle - offset);   
        }
// adjust offset and span

        
        
}


/*
void get_irkey(void)
{
// ir sensing
if (rcflag)
{
rcflag =0;
ircommand = irsense & 0x0f;
switch(ircommand)
    {
    case 0:     mode =1;
                pgm_fl =1;
//                lcd_gotoxy(0,0);
                lcd_clear();
                lcd_putsf("set the time");
                lcd_gotoxy(0,1);
                display_time();
                blink_data = hou;
                blink_locx =0;
                blink_locy =1;
                blink_fl =1;                              
                set =0;
                item1 =0; 
                break;
    case 1:     calibfact = calibuser =0;
                mode =0;
                pgm_fl =0;  
                blink_fl =0;
                set =0;
                item1 =0;
                lcd_clear();
                delay_ms(10);
                break;
    case 2:     key1_fl =1;
                key2_fl = key3_fl = key4_fl =0;
                break;
    case 3:     key4_fl=1;
                key1_fl = key2_fl = key3_fl =0;
                break;
    case 4:    key2_fl=1;
               key1_fl = key4_fl = key3_fl =0;

                break;
    case 5:    key3_fl=1;    
                    key1_fl = key2_fl = key4_fl =0;

                break;   
    case 6:     calibuser =1;
                calibfact =0;
                lcd_putsf("the panel ");
                lcd_gotoxy(0,1);
                lcd_putsf("calibration mode");
                delay_ms(3000);
                lcd_gotoxy(0,0);
                lcd_putsf("inc > inch up");
                lcd_gotoxy(0,1);
                lcd_putsf("dec > inch down");
                delay_ms(3000);
                lcd_gotoxy(0,0);
                lcd_putsf("set > enter low");
                lcd_gotoxy(0,1);
                lcd_putsf("shf-> enter high");
                delay_ms(3000);    
                break;
    }




}


}
*/


void display_update(void)
{

if (mode ==0 && !manual_fl)
        {
        lcd_clear();
        mode0_seqcnt++;
        if (mode0_seqcnt > 65) mode0_seqcnt=0;
        if (mode0_seqcnt>=0 && mode0_seqcnt<=45)                //display date and time
                { 
                lcd_gotoxy(0,0);

                lcd_putsf("time: ");
                display_time(); 
                lcd_gotoxy(0,1);         
                    lcd_putsf("angle: ");       
                    display_angle(angle);        //x

                lcd_gotoxy(0,2);
        lcd_putsf("Lat: ");
		get_latitude(GGA_Pointers[0]);   /* Extract Latitude */
		lcd_puts(degrees_buffer);      /* display latitude in degree */
		memset(degrees_buffer,0,degrees_buffer_size);
        lcd_gotoxy(0,3);
		
		lcd_putsf("Long: ");
		get_longitude(GGA_Pointers[2]);  /* Extract Longitude */
		lcd_puts(degrees_buffer);      /* display longitude in degree */                
		memset(degrees_buffer,0,degrees_buffer_size);
                }



        if (mode0_seqcnt>=46 && mode0_seqcnt<=50)            //display sunrise and sunset time
                { 
                lcd_gotoxy(0,0);
                lcd_putsf("sunrise: ");
                display_day2(sunrise_min);          
                lcd_gotoxy(0,1);
                lcd_putsf("sunset: ");       
                display_day2(sunset_min);      
                }
        if (mode0_seqcnt>=51 && mode0_seqcnt<=55)
                {                                            //next target angle and time
                lcd_gotoxy(0,0);
                lcd_putsf("next time/angle:");
                lcd_gotoxy(0,1);
                display_day2(target_time);
                lcd_putchar('/');
                display_angle(target_angle);      
                }
        if (mode0_seqcnt>=56 && mode0_seqcnt<=65)             //pv volt and current
                { 
//                lcd_gotoxy(0,0);
//                lcd_putsf("charge: ");
//                if(boost_fl)
//                lcd_putsf("boost    ");
//                else if (float_fl)
//                lcd_putsf("equal..  ");
//                else
//                lcd_putsf("trickle  ");
 //               put_message(high_angle);
//               display_analog(adc_loadcurrent);
 //               lcd_putsf(" Amp.");          
                lcd_gotoxy(0,0);
                 lcd_putsf("date: ");       
                display_date();  
         //display_analog(current);
                lcd_gotoxy(0,1);
                display_angle1(low_angle);
                lcd_putsf(" / ");
                display_angle1(high_angle);
//                lcd_putsf("Degs.");
                } 
//         lcd_gotoxy(0,2);
//                lcd_putsf("sunrise: ");
//                display_time2(riset*100);          
//                lcd_gotoxy(0,3);
//                lcd_putsf("sunset: ");       
//                display_time2(settm*100);    

            lcd_gotoxy(0,1);
		lcd_putsf("Time: ");
		get_gpstime();                   /* Extract Time in UTC */
		lcd_puts(Time_Buffer);

                lcd_gotoxy(0,2);
        lcd_putsf("Lat: ");
		get_latitude(GGA_Pointers[0]);   /* Extract Latitude */
		lcd_puts(degrees_buffer);      /* display latitude in degree */
		memset(degrees_buffer,0,degrees_buffer_size);
        lcd_gotoxy(0,3);
		
		lcd_putsf("Long: ");
		get_longitude(GGA_Pointers[2]);  /* Extract Longitude */
		lcd_puts(degrees_buffer);      /* display longitude in degree */                
		memset(degrees_buffer,0,degrees_buffer_size);




            }
        



/*
         display_angle(sun_angle);
         lcd_putsf(" G:");
         display_angle(gangle); 
         lcd_gotoxy(0,3);
         display_angle(target_angle);
         lcd_putsf("b:");
         display_analog(OCR1A);
*/
        
if (mode == 1 && !manual_fl)
        {
        lcd_gotoxy(0,1);
        switch(set)
        {
        case 0: display_time();
                break;
        case 1: display_date();
                break;
        case 2: display_latlong(set_latit);
                lcd_putchar(0); 
                break;
        case 3: display_latlong(set_longitude);
                lcd_putchar(0);
                break;
        case 4: put_message2(time_interval);
                lcd_putsf(" minutes  ");
                break;
        case 5: lcd_putsf("GMT ");
                display_latlong(set_timezone);
                break;        
        case 6: lcd_putsf("    ");
                display_latlong(set_width);
                break;      
        case 7: lcd_putsf("    ");
                display_latlong(set_distance);
                break;      
        } 
        
        
           switch (item1)
                {
                case 0: blink_data = hour;
                        blink_locx =0;
                        blink_locy =1;  
                        break;
                case 1: blink_data = minute;
                        blink_locx =3;
                        blink_locy =1;  
                        break;
                case 2: blink_data = second;
                        blink_locx =6;
                        blink_locy =1;  
                        break;
                case 3: blink_data = day;
                        blink_locx =0;
                        blink_locy =1;  
                        break;
                case 4: blink_data = month;
                        blink_locx =3;
                        blink_locy =1;
                        break;
                case 5: blink_data = year;
                        blink_locx =8;
                        blink_locy =1;
                        break;
                case 6: char_latitude = blink_data = (abs(set_latit)/100)%100 ;
                        blink_locx =2;
                        blink_locy =1;
                        break;
                case 7: char_latitude = blink_data = abs(set_latit)%100 ;
                        blink_locx =5;
                        blink_locy =1;
                        break;
                case 8: char_longitude = blink_data = (abs(set_longitude)/100)%100 ;
                        blink_locx =2;
                        blink_locy =1;
                        break;
                case 9: char_longitude = blink_data = abs(set_longitude)%100 ;
                        blink_locx =5;
                        blink_locy =1;
                        break;
                case 10:blink_data = time_interval;
                        blink_locx =0;
                        blink_locy =1;
                        break;
                case 11:char_timezone = blink_data = (abs(set_timezone)/100)%100 ;
                        blink_locx =6;
                        blink_locy =1;
                        break;
                case 12:char_timezone =  blink_data = abs(set_timezone)%100;
                        blink_locx = 9;
                        blink_locy =1;
                        break; 
                case 13:char_width = blink_data = (abs(set_width)/100)%100 ;
                        blink_locx =6;
                        blink_locy =1;
                        break;
                case 14:char_width =  blink_data = abs(set_width)%100;
                        blink_locx = 9;
                        blink_locy =1;
                        break; 
                case 15:char_distance = blink_data = (abs(set_distance)/100)%100 ;
                        blink_locx =6;
                        blink_locy =1;
                        break;
                case 16:char_distance =  blink_data = abs(set_distance)%100;
                        blink_locx = 9;
                        blink_locy =1;
                        break; 
                        
                }       
        }
if (manual_fl)
    {
    lcd_gotoxy(0,0);
                lcd_putsf("* Manual Mode * ");

//    lcd_putsf("manual mode");
    lcd_gotoxy(0,1);
    lcd_putsf("angle: ");       
    display_angle(angle);  
    lcd_putchar(0);

    }


}




/*
void mpu6050_init(void)
{                      
i2c_start();
i2c_write(0xd2);
delay_ms(1);
i2c_write(0x9c);   //18 bit mode 1v/v
 i2c_stop();
}

long int adc3421_read(void)
{
 unsigned int buffer1;
 unsigned int buffer2,buffer3;
 long int buffer4;
 i2c_start();
 buffer1 = i2c_write(0xd3);
 buffer1 = i2c_read(1);
 buffer2 = i2c_read(1);
 buffer3 = i2c_read(0);
 i2c_stop();
 buffer1 = buffer1 & 0x01;
 buffer4 = (long) (buffer1) * 65536 ;
 buffer4 = buffer4 + ((long)(buffer2) * 256);
 buffer4 = buffer4 + (long)(buffer3);
 return(buffer4);
//return ((long)rand()+32000);
} 

void write_2464(unsigned int address,char data1,char data2,char data3,char data4,char data5,char data6,char data7,char data8,char data9,char data10,char data11,char data12,char data13,char data14)
{
unsigned int adhi,adlo;
adhi = address/256;
adlo = address%256;
i2c_start();
i2c_write(0xa0);               // write command
i2c_write(adhi);
i2c_write(adlo);
i2c_write(data1);
i2c_write(data2);
i2c_write(data3);
i2c_write(data4);
i2c_write(data5);
i2c_write(data6);
i2c_write(data7);
i2c_write(data8);
i2c_write(data9);
i2c_write(data10);
i2c_write(data11);
i2c_write(data12);
i2c_write(data13);
i2c_write(data14);
delay_ms(1000);

i2c_stop();
delay_ms(1);
}
*/

/*

void read_2464(int addr)
{
i2c_start();
i2c_write(0xa0);               // write command
i2c_write(addr/256);
i2c_write(addr%256);
//i2c_stop();
i2c_start();
i2c_write(0xa1);             //read address
record_buffer[0] = i2c_read(1);
record_buffer[1] = i2c_read(1);
record_buffer[2] = i2c_read(1);
record_buffer[3] = i2c_read(1);
record_buffer[4] = i2c_read(1);
record_buffer[5] = i2c_read(1);
record_buffer[6] = i2c_read(1);
record_buffer[7] = i2c_read(1);
record_buffer[8] = i2c_read(1);
record_buffer[9] = i2c_read(1);
record_buffer[10] = i2c_read(1);
record_buffer[11] = i2c_read(1);
record_buffer[12] = i2c_read(1);
record_buffer[13] = i2c_read(0);
i2c_stop();
}

*/


void cal_angle(void)
{
//float sensitivity,angle_rad;

//sensitivity = span_adc - zero_adc;
//angle_rad = asin(((float)adc_angle - (float)zero_adc) /sensitivity);
//angle_sum = angle_sum + ((angle_rad * 572.957795) + 900) ;
//angle=((angle_rad * 572.957795) + 900) ;
if (read_adcfl)
{
read_adcfl =0;
//angle = adc_angle;
}

//angle_cnt++;
/*
if (angle_cnt >=4)
{
angle_cnt =0;
angle = angle_sum/4;
angle_sum =0;
}
*///angle = (float)adc_buffer - (float)zero_adc /sensitivity ;
}

void target_cal(void)
{
long  a;
int y=1;
time_elap = to_minute(hour,minute);      // convert real time to minutes
if (time_elap > sunrise_min)
        {
        for (y=1;y<=150;y++)
        {
        if (time_elap <= (sunrise_min +(time_interval*y)))
                {                                                          
                target_time = sunrise_min +((long)(time_interval)*y);
                break;
                }
        }
        
        if (target_time > sunset_min) target_time = sunset_min;
        if (target_time < sunrise_min) target_time = sunrise_min;
        
        a = target_time - sunrise_min;     
        sun_angle = ((1800 * a)/ (long)daytime)-900;
        backtrack();                     // routine for backtracking 
        target_angle = new_target;
//        if (target_angle > high_angle) target_angle = high_angle;
//        if (target_angle < low_angle) target_angle = low_angle;
// bring the panel to 90 degrees (horizontal position ) 10 minutes after sunset.
// added to hardcode limit from 50 to 125 degrees for ravindra energy
        if (target_angle > 450) target_angle = 450;
       if (target_angle < -450) target_angle = -450;
/////////////////////remove this for other limits                

        if ((time_elap < sunrise_min) || (time_elap>sunset_min))
            {
            target_time = sunset_min+10;
            target_angle = 0;     // target angle is 0 degrees
            }

        if ((time_elap == target_time) && !start_fl && !end_fl)
        {
        start_fl =1;
        }
        
        }
}


/*
void current_control(int cur,int volt_limit,int PV_limit)
{
if (read_adcfl)                 // check if all adc readings over
{
read_adcfl =0;
if (adc_battery < volt_limit && adc_pvolt >= PV_limit)
{
        
if (adc_chargecurrent < cur-1) 
{
        if((adc_battery < volt_limit-50) &&(OCR1A < 500)) ocr_inc =10;
        else
        ocr_inc =1;  
OCR1A+=ocr_inc;   //hysterisis of +/- 0.02A
}
if (adc_chargecurrent > cur+1 && OCR1A != 0x000) 
{
        if((adc_battery > volt_limit+50)&&(OCR1A > 20)) ocr_inc =10;
        else
        ocr_inc =1;  
OCR1A-=ocr_inc;
}
if (OCR1A > 500) OCR1A = 500;
}
else if(adc_pvolt<= adc_battery+200)
{
OCR1A -=10;
if (OCR1A < 200) OCR1A =200;
}
else
{
if ((OCR1A < 0x05) ||((adc_pvolt <=(adc_battery+200)) && trickle_fl && float_fl)) OCR1A -=ocr_inc;
}
}
}


void voltage_control(int vol,int cur_limit,int PV_limit)
{
if (read_adcfl)                 // check if all adc readings over
{
read_adcfl =0;
            

if(adc_chargecurrent < cur_limit && adc_pvolt >= PV_limit)
{
if (adc_battery <= vol-1) 
{
        if((adc_battery < vol-50)&&(OCR1A < 500)) ocr_inc =10;
        else
        ocr_inc =1;  

OCR1A+=ocr_inc;   //hysterisis of +/- 0.02A
}
if (adc_battery > vol+1 && (OCR1A !=0x000)) 
{
        if ((adc_battery > vol+50)&&(OCR1A > 20)) ocr_inc =10;
        else
        ocr_inc =1;  


OCR1A-=ocr_inc;
}
if (OCR1A > 500) OCR1A = 500;
}
else if(adc_pvolt<= adc_battery + 200)
{
OCR1A-=10;
if (OCR1A < 200) OCR1A =200;
}
else
{
if ((OCR1A <= 0x05) || ((adc_pvolt <= (adc_battery+200))) && trickle_fl && float_fl) OCR1A-=1;
}
}
}



void battery_control(void)
{
//int a;
if (boost_fl)
{
//a = to_min(set_boost_timeout);
control_buck_on();
current_control(boost_current,boost_voltage,adc_battery + 100);
if ((adc_battery >= boost_voltage) || (boost_time >= boost_timeout))
{
boost_fl=0;
float_fl =1;
trickle_fl =0;
}
}

if (float_fl)
{
//a= set_float_timeout;
control_buck_on();     
voltage_control(boost_voltage,boost_current,adc_battery+100);
if (((adc_chargecurrent < set_capacity/50) && (adc_battery >=equal_voltage))||(float_time > float_timeout))                  // threshold current < 2% of capacity
{
boost_fl =0;
float_fl =0;
trickle_fl =1;
}
}
if (trickle_fl)
{
control_buck_on();     
voltage_control(equal_voltage,trickle_current,adc_battery+100);
if (adc_battery < cutoff_voltage)
{
boost_fl =1;
trickle_fl =0;
float_fl=0;
}
}
}
*/
/*
void check_lowbat(void)
{
if (adc_battery < cutoff_voltage)
bat_cur =1;         // turn off load output
if (adc_battery > cutoff_voltage+100)
bat_cur =0;
}
*/

void backtrack(void)
{
float b,gamma,rad;
rad = (sun_angle+900) * pi/1800;


b= set_distance * sin(rad)/ set_width;
b_factor =b*100;
if (b<1)
    {
    gamma = asin(b)*1800/pi;                                                      
    
    gangle = gamma;       
    if (sun_angle >= 0)         //evening
        {
        new_target = 0 -(1800 - gamma -sun_angle-900);
        }
    else 
        {
        new_target =0 -(gamma - sun_angle-900);
        }
    }
else
    {
    new_target = sun_angle;
    }
}

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
int night_time;
//#asm("wdr")
time_cnt1++;
if(time_cnt1>=300)   //5 minute record printout
    {         
    time_cnt1=0;
    print_fl=1;
    }
time_cnt++;
if (time_cnt>=1800)     //execute every 30minutes to save rtc value for backup
{
time_cnt =0;
e_day = day;
e_week =week;
e_year = year;
e_month =month;
e_hour = hour;
e_minute = minute;
e_second = second;
}
// Place your code here
rise_set((long)(day),(long)(month),(long)year+2000,12,(float)(set_latit)/100,(float)(set_longitude)/100,(float)(set_timezone)/100) ;
// Place your code here
if (mode ==0)
{
/*log_cnt++;
if(log_cnt >= log_interval)
{
log_cnt =0;
if(log_fl) print_realtime();
}
*/
rtc_get_time(&hour,&minute,&second);
 //               if (hour <0 || hour >24) rtc_err=1;         //added for rtc error

rtc_get_date(&week,&day,&month,&year);   //pdi is weekday not used only for cvavr2.05
//adc_buffer = adc_angle = mpu6050_read();
}
//if (boost_fl) boost_time++;
//if (float_fl) float_time++;
adc_fl =1;
led2=~relay1;
led1=~relay2;
//led3=~err_fl;
//led4= ~(boost_fl | float_fl) ;
//led5= ~trickle_fl;
//if (adc_battery < cutoff_voltage) led6 =0;
//else led6 =1; 
led_blinkfl = ~ led_blinkfl;

//display_update();
bright_cnt++;
if (bright_cnt > 20) bright_cnt =20;
if (bright_cnt<20 ) backlight =0;         // not valid for low battery
else backlight =0;
program_timeout++;
if (program_timeout >=30) program_timeout =30;
if (program_timeout ==29)
clear_to_default();     //reset to normal mode if no key is pressed for more than 29 seconds.

if (end_fl)
{
end_cnt++;
if (end_cnt >=61)
{
end_fl =0;
end_cnt =0;
}
}
// added code to check if time is between sunset and sunrise. if yes, invoke sleep
// sleep/standby mode.
night_time = to_minute(hour,minute);      // convert real time to minutes
if (((night_time > sunset_min +30)|| (night_time < sunrise_min - 30))&& key1 && key2 && key3 && key4)
        {
        sleep_counter++;
        if (sleep_counter >=30)
        {
        sleep_counter =30;
        relay1=relay2=0;        //turn off relay  
        backlight =1;                    //turn backlight off
        led1=led2=led3=led4=led5=led6 =1; //turn led off   
//        control_buck_off() ;
        lcd_gotoxy(0,0);
        lcd_putsf("  NIGHT MODE  ");
        lcd_gotoxy(0,1);
        display_time();
        sleep_fl =1;  
//        sleep_enable();
//        idle();
        }
        }
else
{
sleep_counter =0;
sleep_fl=0;
}
}






#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE<256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
short int oldsrg = SREG;
	char received_char;

	#asm("cli")
    received_char = UDR;
	
	if(received_char =='$'){                 /* check for '$' */
		GGA_Index = 0;
		CommaCounter = 0;
		IsItGGAString = 0;
	}
	else if(IsItGGAString == 1){          /* if true save GGA info. into buffer */
		if(received_char == ',' ) GGA_Pointers[CommaCounter++] = GGA_Index;     /* store instances of ',' in buffer */
		GGA_Buffer[GGA_Index++] = received_char;
	}
	else if(GGA_CODE[0] == 'G' && GGA_CODE[1] == 'G' && GGA_CODE[2] == 'A'){    /* check for GGA string */
		IsItGGAString = 1;
		GGA_CODE[0] = 0; GGA_CODE[1] = 0; GGA_CODE[2] = 0;
	}
	else{
		GGA_CODE[0] = GGA_CODE[1];  GGA_CODE[1] = GGA_CODE[2]; GGA_CODE[2] = received_char; 
	}
	SREG = oldsrg;


/*
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index]=data;
   if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      };
   };
*/
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE<256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index];
   if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index]=c;
   if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

// Declare your global variables here



void eeprom_transfer(void)
{
span_adc = e_span_adc;
zero_adc = e_zero_adc;
time_interval = e_time_interval;
low_angle = e_low_angle;
high_angle = e_high_angle;
set_latit = e_set_latit;
set_longitude = e_set_longitude;
set_timezone = e_set_timezone;
set_width = e_set_width;
set_distance = e_set_distance;
}


void init(void)
{// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=P State2=P State1=P State0=P 
PORTA=0xFF;
DDRA=0x20;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x08;  //pb.3 is bcklight
DDRB=0x08;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=1 State3=1 State2=1 State1=1 State0=0 
PORTC=0x1E;
DDRC=0xFF;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In 
// State7=0 State6=1 State5=0 State4=0 State3=1 State2=T State1=T State0=T 
PORTD=0x4C;
DDRD=0xF8;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 11.719 kHz
// Mode: Fast PWM top=0x01FF
// OC1A output: Inverted PWM
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 43.691 ms
// Output Pulse(s):
// OC1A Period: 43.691 ms Width: 21.888 ms
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(1<<COM1A1) | (1<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0xFF;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: Off
// INT2: Off
GICR|=0x40;
MCUCR=0x02;
MCUCSR=0x00;
GIFR=0x40;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;


// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(1<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x4D;


// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;



// I2C Bus initialization
i2c_init();
delay_ms(1000);

// DS1307 Real Time Clock initialization
// Square wave output on pin SQW/OUT: Off
// SQW/OUT pin state: 1
rtc_init(0,1,0);

// LCD module initialization
lcd_init(16);
delay_ms(100);
mpu6050_init();
boost_fl =1;
float_fl = trickle_fl =0;

define_char(char0,0);
// Global enable interrupts
sleep_fl =0;

}

/*
void WDT_ON()
{
    
//    Watchdog timer enables with typical timeout period 2.1 
//    second.
    
    WDTCR = (1<<WDE)|(1<<WDP2)|(1<<WDP1)|(1<<WDP0);
}
 */
void WDT_OFF()
{
    /*
    This function use for disable the watchdog timer.
    */
    WDTCR = (1<<WDTOE)|(1<<WDE);
    WDTCR = 0x00;
}


/*

void check_print(void)
{
int i,j=0;
if(printkey_fl)
    {
    lcd_clear();
    lcd_putsf("printing");
    lcd_gotoxy(0,1);
    printkey_fl =0;
    if (record_cnt>13)
        {
            #asm("cli") 
        putchar(0x0a);
        putchar(0x0d);
        putsf("angle  target  time     date       PV   chargecur.   batvolt");
//        putchar(0x0a);
//        putchar(0x0d);
        for(i=0;i<=(record_cnt-1);i+=14)
            {
            j++;
            if (j>=15)                                      //lower display printing algo
                        {
                        j=0;
                        lcd_gotoxy(0,1);
                        lcd_putsf("               ");
                        lcd_gotoxy(0,1);        
                        }
            lcd_putchar('.');
            read_2464(i);    
            delay_ms(200);
            putchar((record_buffer[0]/10)+48);
            putchar((record_buffer[0]%10)+48);
            putchar((record_buffer[1]/10)+48);
            putchar('.');
            putchar((record_buffer[1]%10)+48);
            putchar(' ');
            putchar(' ');

            putchar((record_buffer[2]/10)+48);
            putchar((record_buffer[2]%10)+48);
            putchar((record_buffer[3]/10)+48);
            putchar('.');
            putchar((record_buffer[3]%10)+48);
            putchar(' ');
            putchar(' ');

            putchar((record_buffer[4]/10)+48);
            putchar((record_buffer[4]%10)+48);
            putchar(':');
            putchar((record_buffer[5]/10)+48);
            putchar((record_buffer[5]%10)+48);
            putchar(' ');
            putchar(' ');

            putchar((record_buffer[6]/10)+48);
            putchar((record_buffer[6]%10)+48);
            putchar('-');
            putchar((record_buffer[7]/10)+48);
            putchar((record_buffer[7]%10)+48);
            putchar('-');
            putchar('2');
            putchar('0');
            putchar('1');
            putchar('3');
                        
            putchar(' ');
            putchar(' ');

            putchar((record_buffer[8]/10)+48);
            putchar((record_buffer[8]%10)+48);
            putchar('.');
            putchar((record_buffer[9]/10)+48);
            putchar((record_buffer[9]%10)+48);
            putchar('V');
            putchar(' ');

            putchar((record_buffer[10]/10)+48);
            putchar('.');
            putchar((record_buffer[10]%10)+48);
            putchar((record_buffer[11]/10)+48);
            putchar((record_buffer[11]%10)+48);
            putchar('A');
            putchar(' ');

            putchar((record_buffer[12]/10)+48);
            putchar((record_buffer[12]%10)+48);
            putchar('.');
            putchar((record_buffer[13]/10)+48);
            putchar((record_buffer[13]%10)+48);
            putchar('V');
            putchar(' ');
            putsf(" ");//new line character

            }
        #asm("sei")
        lcd_clear();
//        record_cnt =0;          //reset record count to 00;
        }

    } 
}

*/

/*
void print_analog(int a,short int decimal)
{
if (a<0)
{
putchar('-');
a = -a;
}
else
{
putchar('+');
}
putchar((a/1000)+48);
a =a%1000;
if (decimal == 1) putchar('.');
putchar((a/100)+48);
a = a%100;
if (decimal == 2) putchar('.');
putchar((a/10)+48);
if (decimal ==3) putchar('.');
putchar((a%10)+48);
}

void print_realtime()
{
            print_analog(angle,3);
 //           putchar('�');
            putchar(' ');

            print_analog(target_angle,3);
//            putchar('�');
            putchar(' '); 
            
            print_analog(sun_angle,3);
//            putchar('�');
            putchar(' '); 

            putchar((hour/10)+48);
            putchar((hour%10)+48);
            putchar(':');
            putchar((minute/10)+48);
            putchar((minute%10)+48);
            putchar(' ');
            putchar(' ');

            putchar((day/10)+48);
            putchar((day%10)+48);
            putchar('-');
            putchar((month/10)+48);
            putchar((month%10)+48);
            putchar('-');
            putchar('2');
            putchar('0');
            putchar('2');
            putchar('1');
                        
            putchar(' ');
            putchar(' ');


}


void print_data(void)
{
    #asm("cli") 
    print_realtime();        
       putchar(0x0a);
       putchar(0x0d);
    #asm("sei")
}

*/

void panel_movement(void)
{
//int panel_cutoff;
//bit flag_01;
int angle_old;
if(start_fl)
        { 
        OCR1A =20;          // initially set PWM output to zero
        pwm_count =0;   
        lcd_clear();
if (angle < target_angle)
        {
        timeout_cnt =0;
        inf_fl =1;
        angle_old = angle;
//        panel_cutoff =0;
        while(angle < target_angle && inf_fl)
                { 
/*
  // check routine for low voltage . if battery voltage drops below
  // 10.8V, then display low battery indication. if it recovers within 20 seconds
  // then, get back, else break.
                if (adc_battery < cutoff_voltage)
                panel_cutoff++;
                else
                panel_cutoff =0;        //reset                      
                
                if (panel_cutoff > 100 && panel_cutoff < 5000) //15 seconds
                        {
                        lcd_gotoxy(0,1);
                        lcd_putsf("!!LOW BATTERY!!");
                        flag_01 =1;
//                        delay_ms(500);
                        } 
                        else
                        flag_01 =0; // to display low battery only 
                        
                if (panel_cutoff > 5000)
                        {
                        lcd_clear();
                        err_fl =1;
                        
                        lcd_putsf("LOW BATTERY");
                        lcd_gotoxy(0,1);
                        lcd_putsf("!!!ERROR!!!    ");        
                        relay1=relay2 =0;
                        delay_ms(2000);
                        err_fl =0;
                        inf_fl =0;  // break while loop
                         }                                                        
*/
/////////////////////////////////////////////////////////////////////                        
 //               delay_ms(1);
 //               adc_buffer = adc3421_read();
                #asm("wdr")
                pwm_count++;
                if(pwm_count >200)
                    {
                    pwm_count =0;
                    OCR1A+=2;
                    if (OCR1A >500)
                        {   
                        OCR1A =500;
                        }
                    }
                read_adc();
                cal_angle(); 
                lcd_gotoxy(0,0);           
                lcd_putsf("ang: ");
                display_angle(angle);
                lcd_gotoxy(0,1);
                
                lcd_putsf("tar: ");
                display_angle(target_angle);
               
                relay1=0;
                relay2=1;
                timeout_cnt++;
                if(timeout_cnt >100000)      //once every 30 seconds
                        {
                        timeout_cnt =0;
                        if (!((angle < angle_old - 20) || (angle > angle_old +20)))
                            {
                            lcd_clear();
                            err_fl =1;
                            led3 =0;
                            lcd_putsf("mech. error");
                            relay1=relay2 =0;
                            delay_ms(3000);
                            err_fl =0;
                            led3  =1;
                            inf_fl =0;  // break while loop
                            }
                        else
                            {
                            angle_old = angle;
                            }
                        }
                
                if(!key1) 
                    {
                    inf_fl =0;        //emergency stop movement by pressing enter key
                    relay1=relay2=0;
                    }
                }
        start_fl =0;
        end_fl =1;        
        relay1=relay2=0;
        }
else if (angle > target_angle +20)     //hysterisis of 2 degrees before action
        {
        timeout_cnt =0;
        inf_fl =1;  
        angle_old = angle; 
 //       panel_cutoff =0;
        while(angle > target_angle && inf_fl)
                { 
/*
  // check routine for low voltage . if battery voltage drops below
  // 10.8V, then display low battery indication. if it recovers within 20 seconds
  // then, get back, else break.
                if (adc_battery < cutoff_voltage)
                panel_cutoff++;
                else
                panel_cutoff =0;        //reset                      
                
                if (panel_cutoff > 100 && panel_cutoff < 5000) //15 seconds
                        {
                        lcd_gotoxy(0,1);
                        lcd_putsf("!!LOW BATTERY!!"); 
                        flag_01 =1;
//                        delay_ms(500);
                        }
                else
                        flag_01 =0;
                if (panel_cutoff > 5000)
                        {                              
                        panel_cutoff =0;
                        lcd_clear();
                        err_fl =1;
                        lcd_putsf("LOW BATTERY");
                        lcd_gotoxy(0,1);
                        lcd_putsf("!!!ERROR!!!    ");        
                        relay1=relay2 =0;
                        delay_ms(2000);
                        err_fl =0;
                        inf_fl =0;  // break while loop
                         }                                                        
*/
/////////////////////////////////////////////////////////////////////    
//                delay_ms(1);
//                adc_buffer = adc3421_read();
                #asm("wdr") 
                pwm_count++;
                if(pwm_count >200)
                    {
                    pwm_count =0;
                    OCR1A+=2;
                    if (OCR1A >500)
                        {   
                        OCR1A =500;
                        }
                    }
                read_adc();
                cal_angle(); 
                lcd_gotoxy(0,0);           
                lcd_putsf("ang: ");
                display_angle(angle);
                lcd_gotoxy(0,1);
                
                lcd_putsf("tar: ");
                display_angle(target_angle);
                
                relay1=1;
                relay2=0;
                timeout_cnt++;
                if(timeout_cnt >100000)
                        {
                        timeout_cnt =0;
                        if (!((angle < angle_old - 20) || (angle > angle_old +20)))
                            {  
                             lcd_clear();
                            err_fl =1;
                            led3 =0;
                            lcd_putsf("mech. error");
                            relay1=relay2 =0;
                            delay_ms(3000);
                            err_fl =0;
                            led3 =1;
                            inf_fl =0;  // break while loop
                            }
                        else
                            {
                            angle_old = angle;
                            }
                        
                        }
                if(!key1) 
                    {
                    inf_fl =0;        //emergency stop movement by pressing enter key
                    relay1=relay2=0;
                    }
                
                
                }
        start_fl =0;
        end_fl =1;        
        relay1=relay2=0; 
//        print_data();
        } 
else            
        start_fl =0;
        
        end_fl =1;        
        relay1=relay2=0;
//        #asm("cli")
//        write_2464(record_cnt,angle/100,angle%100,target_angle/100,target_angle%100,hour,minute,day,month,adc_pvolt/100,adc_pvolt%100,adc_chargecurrent/100,adc_chargecurrent%100,adc_battery/100,adc_battery%100);
//        #asm("sei")
        record_cnt =0;
        }
}


/*
void error_check()
{
if (adc_pvolt < 1000 || adc_battery <300)
err_fl1 = 1;
else
err_fl1=0;
if (adc_battery < cutoff_voltage)
err_fl2 =1;
if(err_fl2 && adc_battery > reconnect_voltage)//hysterisis for reconnect 
err_fl2 =0;
}
*/
void led_check()
{
led2=~relay1;
led1=~relay2;
led4 = led5 = led6 = 1;   // turn battery related leds off

if (err_fl )
led3 =0;
else

led3 =1;
/*
        if (!err_fl1)
            {
            if (boost_fl)
            led4 =0;
            else if (float_fl)
            led4 = led_blinkfl;
            else
            led4 =1;
            led5= ~trickle_fl;
          }
        else
            {
            led4 = led5 =1;
            }
       if (adc_battery < cutoff_voltage) led6 =0;       //low battery indication
       else led6 =1; 
*/  
}




/*
void print_control()
{
char data;
while (rx_counter)                     //receive buffer is not empty
{
data = getchar();
switch (data)
            {
            case 'p':   printkey_fl =1;    
                        delay_ms(100);
                        break;
            case 'r':   putsf("no. of records stored :");
                        print_analog(record_cnt/14,0);
                        putsf(" ");
                        break;
            case 's':   record_cnt =0;
                        putsf("records reset!!!");
                        break;
            case 'v':   putsf("Panel voltage:");
                        print_analog(adc_pvolt,2);
                        putchar('V'); 
                        putsf(" ");
                        break;
            case 'b':   putsf("Battery voltage:");
                        print_analog(adc_battery,2);
                        putchar('V');
                        putsf(" ");
                        break;            
            case 'c':   putsf("charge current:");
                        print_analog(adc_chargecurrent,2);
                        putchar('A');
                        putsf(" ");
                        break; 
            case 'l':   log_fl=1; 
                        putsf("angle  target  time     date       PV   current  batvolt");
                        putsf("logging started...");
                        break;
            case 'm':   log_fl=0;
                        putsf("logging stopped");
                        break;                  
            default:    break;
              }
}
}
*/


 

void rtc_reset(void)
{
//rtc_get_time(&hour,&minute,&second);
//rtc_get_date(&week,&day,&month,&year);

if (hour>23 || second > 59)
{
#asm("cli");
rtc_init(0,1,0);
delay_ms(500);
rtc_set_date(e_week,e_day,e_month,e_year);
rtc_set_time(e_hour,e_minute,e_second);
#asm("sei");
}
}

/*
void WDT_off(void)
{
// reset WDT 
#asm("wdr")
// Write logical one to WDTOE and WDE 
WDTCR |= (1<<4) | (1<<3);
// Turn off WDT 
WDTCR = 0x00;
}
*/
void main(void)
{
// Declare your local variables here
#asm("cli")
WDT_OFF();
//#asm ("sei")

init();
// Global enable interrupts
#asm("sei")
delay_ms(250);
rtc_get_time(&hour,&minute,&second);
rtc_get_date(&week,&day,&month,&year);   //pdi is weekday not used only for cvavr2.05
if (hour>24 || second>59)
{
rtc_reset();
}
else
{
//if valid rtc data, store the data in eeprom for backup
e_hour = hour;
e_minute = minute;
e_second = second;
e_day = day;
e_month = month;
e_year = year;
}

//WDT_ON();
calibuser = calibfact =0;
//if (!key1 && key2 && key3 && key4) calibuser =1;
if (key1 && key2 && !key3 && !key4) calibfact =1;
lcd_clear();
if (!calibfact)
{
lcd_putsf("* SINGLE AXIS  *");
lcd_gotoxy(0,1);
lcd_putsf("*SOLAR TRACKER *");
delay_ms(2000);
lcd_clear();
lcd_putsf("*   PLEASE     *");
lcd_gotoxy(0,1);
lcd_putsf("*    WAIT      *");
delay_ms(1000);
}
if(calibuser)
{
lcd_putsf("the panel ");
lcd_gotoxy(0,1);
lcd_putsf("calibration mode");
delay_ms(3000);
lcd_gotoxy(0,0);
lcd_putsf("inc > inch up");
lcd_gotoxy(0,1);
lcd_putsf("dec > inch down");
delay_ms(3000);
lcd_gotoxy(0,0);
lcd_putsf("set-> enter low");
lcd_gotoxy(0,1);
lcd_putsf("shf-> enter high");
delay_ms(3000);
}
if(calibfact)
{
lcd_putsf("adc: ");
lcd_gotoxy(0,1);
lcd_putsf("angle:");
}


OCR1A = 0x13f;
//rtc_set_time(12,13,26);
delay_ms(10);
eeprom_transfer();
while (1)
{  
#asm("wdr")             //reset watchdog timer


if (sleep_fl ==1)
{
//sleep_enable();
//idle();
//delay_ms(500);
}
else
{   
sleep_disable(); 
        get_key(); 
//        ir_cnt++;
//        if(ir_cnt>500)
//        {
//        ir_cnt =0;
//        get_irkey();
//        }
//normal run mode with configuration setting and real time display on power on.
    if(!calibuser || !calibfact )    
     {   
         rtc_reset();
        led_check();
        led2 = ~relay1;
        led1 = ~relay2;
        check_mode();
        read_adc();            
        delay_ms(1); 
        target_cal();
        check_increment();
        check_decrement();
        check_shift();
        check_enter();
        blink_control();
        display_cnt++;
        if(print_fl)
            {
            print_fl =0;
//            print_data();
            }
        if (display_cnt > 100)
                {
                display_cnt =0;
                display_update();
                cal_angle();
                }
        
        if (mode==0 && !manual_fl ) panel_movement();   
        if (manual_fl)
        {
            relay1 = ~key2;
            relay2 = ~key3;
        }
     } 
        
         
///////////////////////////////////////////////////////// 


//calibration mode for user to set start and end angles
    if(calibuser)
    {
    lcd_clear();
    delay_ms(1);
    lcd_putsf("Set Start Angle");
    while(key4)
    { 
//    get_irkey();
    get_key();
    delay_ms(1);
//        error_check();

//    lcd_gotoxy(0,0);
//    lcd_putsf("Set Start Angle")
    
//    put_message(zero_adc);
//    lcd_putsf("   ");
//    put_message(span_adc);
    lcd_gotoxy(0,1);
    lcd_putsf("angle:");
//    adc_buffer = adc3421_read();
    read_adc();
    relay1 = ~key2;
    relay2 = ~key3;
//    key2_fl = key3_fl =0;
    cal_angle();
    display_angle(angle);
    }
    e_low_angle = low_angle = angle;
    lcd_gotoxy(0,0);
    lcd_putsf("start angle ");
    lcd_gotoxy(0,1);
    lcd_putsf("accepted!");
    delay_ms(1500);
    
    lcd_clear();
    lcd_putsf("Set End Angle");
    while(key1)
    {  
//    get_irkey();
    get_key();
    delay_ms(1);
//        error_check();

    lcd_gotoxy(0,1);
    lcd_putsf("angle:");
//    adc_buffer = adc3421_read();
    read_adc();
    relay1 = ~key2;
    relay2 = ~key3;
//    key2_fl = key3_fl =0;
    cal_angle();
    display_angle(angle);
    }
    e_high_angle = high_angle = angle;
    lcd_gotoxy(0,0);
    lcd_putsf("end angle ");
    lcd_gotoxy(0,1);
    lcd_putsf("accepted! ");
    delay_ms(3000);    
    calibuser =0;  
    lcd_clear();
    }    
////////////////////////////////////////////////////////////////////



 // factory setting for inclinometer and pv/current input calibration.

   if(calibfact)
    {
    record_cnt=0;   //reset record count for printing
    lcd_clear();
    mux1 =1;
    mux2 =0;
    mux3 =1;
    delay_ms(250);
    while(key2)
    {    
    adc_buffer = mpu6050_read();
    cal_angle();
    lcd_gotoxy(0,0);
    delay_ms(500);    
    lcd_putsf("adc: ");
    put_message(adc_buffer);        
    lcd_gotoxy(0,1);
    lcd_putsf("angle: ");
    display_angle(angle);
    }
    e_zero_adc = zero_adc = adc_buffer;
    lcd_clear();   
    lcd_putsf("zero angle ");
    lcd_gotoxy(0,1);
    lcd_putsf("accepted! ");
    delay_ms(3000);
    lcd_clear();
    delay_ms(250);
    while(key1)
    {
    adc_buffer = mpu6050_read();
    cal_angle();
    lcd_gotoxy(0,0); 
    delay_ms(500);
    lcd_putsf("adc: ");
    put_message(adc_buffer);        
    lcd_gotoxy(0,1);
    lcd_putsf("angle: ");
    display_angle(angle);
    }
    e_span_adc = span_adc = adc_buffer;
    lcd_clear(); 
    delay_ms(100);  
    lcd_putsf("span angle ");
    lcd_gotoxy(0,1);
    lcd_putsf("accepted! ");
    delay_ms(1500);
    calibfact =0;  
    lcd_clear();
    }    
///////////////////////////////////////////////


    }
    }; //end of while loop

}

