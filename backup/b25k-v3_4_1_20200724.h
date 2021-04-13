#include <mega2561.h>
#include <delay.h>
#include <stdio.h>
#include <string.h>

/* ADDRESS MAPPING */
/* Interface of SOLENOID & PLC */
#define     PLC_CON         (*(volatile unsigned char *)0x8800)
#define     SOL_CH1         (*(volatile unsigned char *)0x8900)
#define     SOL_CH2         (*(volatile unsigned char *)0x8A00)
#define     SOL_CH3         (*(volatile unsigned char *)0x8B00)
#define     SOL_CH4         (*(volatile unsigned char *)0x8C00)
#define     SOL_CH5         (*(volatile unsigned char *)0x8D00)
#define     SOL_CH6         (*(volatile unsigned char *)0x8E00)
#define     SOL_CH7         (*(volatile unsigned char *)0x8F00)

/* Interface of EDI & PLC & ABD & ACD */
#define     EDI_CH0         (*(volatile unsigned char *)0xA000)     //Crack Detect
#define     EDI_CH1         (*(volatile unsigned char *)0xB000)     //Dot Detect

/* Interface of LED & BUZ */
#define     LED_BUZ         (*(volatile unsigned char *)0x9000)
/*************************/
/* GPIO Special function */
/*************************/
/* MACHINE ID SET */
#define     MACHINE_ID0     PIND.6
#define     MACHINE_ID1     PIND.7

/* ENCODER PHASE SET */
#define     PHASE_A         PINE.6
#define     PHASE_B         PINE.4
#define     PHASE_Z         PINE.7

/* EVENT START/STOP SET */
#define     EVENT_SIGNAL          PINE.5

#define     LEVEL_HI                1
#define     LEVEL_LO                0

#define     MACHINE_START           0x01
#define     EVENT_STOP              0x02
#define     WASHER_ON               0x04
#define     BROWA_ON                0x08
//Version 3.4.3���� ��� ����/����
//�ӵ����� �����Ʈ�� �����.
#define     INTER_LOCK_ON           0x20
//#define     ADJ_SPD_P0              0x10
//#define     ADJ_SPD_P1              0x20
//version 3.4.5���� ��ġ ����
#define     PRT_A_ON                0x80
#define     PRT_B_ON                0x80          //�ּ�ó�� �Ǿ�����
//version 3.4.5���� �����̵� ��� ��
#define     TRUE                    1
#define     FALSE                   0

/* LED_BUZZER Output Value */
#define     LED_INIT_OK             0x40
#define     LED_RUN_STOP            0x20
#define     LED_EVENT0              0x10
#define     LED_EVENT1              0x08
#define     LED_ENCODER_A           0x04
#define     LED_ENCODER_B           0x02
#define     LED_ENCODER_Z           0x01
#define     BUZZER_ON               0x80
/* ��� ��Ʈ�� ���� ���� */
#define     SOL_P0                  0x01
#define     SOL_P1                  0x02
#define     SOL_P2                  0x04
#define     SOL_P3                  0x08
#define     SOL_P4                  0x10
#define     SOL_P5                  0x20
#define     SOL_P6                  0x40
#define     SOL_P7                  0x80
#define     HOLDER_ON_SNG           0x80

/* MACHINE SETTING VALUE */
#define     MAX_BUCKET              300
#define     MAX_SOLENOID            6
#define     MAX_PACKER              9
#define     MAX_OUTPORT             7
#define     MAX_GRADE               9
#define     MAX_LDCELL              6
#define     MAX_PRT                 2

#define     ZeroMeasurePulse        10


/* ��� ���� ���� */
#define     COM_BUF_MAX             500
#define     COM_STX                 0
#define     COM_LEN                 1
#define     COM_DAT                 2
#define     COM_ETX                 3

#define     CMD_START               0x10
#define     CMD_SYSINFO             0x20
#define     CMD_SOLINFO             0x30
#define     CMD_GRADEINFO           0x40
#define     CMD_PRTINFO             0x50
#define     CMD_PACKERINFO          0x60
#define     CMD_MEASUREINFO         0x70
#define     CMD_LDCELLINFO          0x80
#define     CMD_GRADEDATA           0xA0
#define     CMD_SOLTEST             0xB0
#define     CMD_SYS_PARA_INIT       0xE0
#define     CMD_ENCODER_CHK         0xE1

#define     CMD_REFORM_WEIGHT       0xF0
#define     CMD_REFORM_START        0xF1
#define     CMD_REFORM_SET          0xF2
#define     CMD_REFORM_STOP         0xF3
#define     CMD_REFORM_EXIT         0xF4
#define     CMD_REFORM_DATA         0xFD
#define     CMD_REFORM_ZERO         0xFE

#define     CMD_COMCHK              0xAA

#define     tmrNONE                 0
#define     tmrADC                  1
#define     tmrSPEED                2
#define     tmrBUZ                  3

/* ���� ���� ���� */
#define     MACHINE_STOP            0
#define     NORMAL_RUN              1
#define     MEASURE_AD              2
#define     MEASURE_WEIGHT          3
#define     SOLENOID_TEST           4
#define     EMERGENCY_STOP          5
#define     MACHINE_RDY             6
#define     ENCODER_CHK             7

//��޹�ȣ
#define     g_KING                  0
#define     g_SPECIAL               1
#define     g_BIG                   2
#define     g_MIDDLE                3
#define     g_SMALL                 4
#define     g_LIGHT                 5
#define     g_CRACK                 6
#define     g_DOT                   7
#define     g_ETC                   8

#define     PRT_TYPE_NO             0
#define     PRT_TYPE_A              1
#define     PRT_TYPE_B              2

#define     SET                     0xA0
#define     CLEAR                   0x0A

#define     Signal_ON               1
#define     Signal_OFF              0

#define     HolderOFF               0
#define     HolderRDY               1
#define     HolderON                2


#define     MEM_CHK_CODE            0x13

#define     MANUAL_RUN_MODE         0
#define     AUTO_RUN_MODE           1

//Bucket InitValue
#define     BucketInitValue         0

//User Parameter Save Address
#define     GRADE_INFO_DATA         11
#define     SOL_INFO_DATA           12
#define     PACKER_INFO_DATA        13
#define     LDCELL_INFO_DATA        14
#define     MEASURE_INFO_DATA       15
#define     PRT_INFO_DATA           16
#define     SYS_INFO_DATA           17

/* Definition of Program Constant */
typedef struct struct_SOL_INFO{         //Solenoid Switch Info||��Ŀ ����
    unsigned char used[MAX_SOLENOID];              //�ַ����̵� �������||�ַ����̵� 6��|| 0 then unused, 1 then used
    unsigned char outsignal[MAX_SOLENOID];         //�ַ����̵� ��� ��ȣ ��ġ
    int ontime[MAX_SOLENOID];                      //Solenoid ON Time
    int offtime[MAX_SOLENOID];                     //Solenoid Off Time
    int sol_id[MAX_SOLENOID];                      //���� �ַ����̵��� ID
}SOL_INFO_TYPE;

typedef struct struct_GRADE_INFO{   //��� ���� ����||��,Ư,��,��,��,��,���,�Ķ�,����
    int hiLimit;                    //��� ����
    int loLimit;                    //��� ����
    char solenoidnumber;            //��޿� ������ �� ����
    char prttype;                   //�μ�� Ÿ��(A, B, NO)
    int prtSetCount;                //�μ��� ����
    int prtOutCount;                //�μ�� ����
}GRADE_INFO_TYPE;

typedef struct struct_PRT_INFO{     //�μ�� ���� ���� ����||�ִ� 2����
    int ontime;                     //ontime
    int offtime;                    //offtime
    int startpocketnumber;          //�μ�� ���� ��ġ
}PRT_INFO_TYPE;

typedef struct struct_PACKER_INFO{  //��Ŀ ����
    int  gradetype;                 //�Ҵ� ���
    char solcount;                 //�ַ����̵� ����
    char startpocketnumber;         //ù��° �ַ����̵� ������ġ
}PACKER_INFO_TYPE;

typedef struct struct_MeasureInfo{  //�߷� ���� �� �Ķ�, ���� ��ȣ üũ �ð� ����
    int ad_start_pulse;             //�߷� ���� ������
    int duringcount;                //�߷� ���� �ð�
    int zeroposition;               //���� ���� ������
    int crackchecktime;             //�Ķ� ��ȣ üũ�ð�
    int DotCheckTime;               //���� ��ȣ üũ�ð�
}MEASURE_INFO_TYPE;

typedef struct struct_LDCellInfo{   //�ε弿 ��� ����
    char channel;                   //�ε弿 ��� ��Ʈ ����
    int span;                       //�߷� ����
    int offset;                     //���� ����
}LDCELL_INFO_TYPE;

typedef struct struct_CPARAMETER{   //���� ����
    int risingTime;                 //�⵿�ð�||���� msec
    int fallingTime;                //�����ð�||���� msec
    char correction;                //�⵿������ �ַ����̵� ��Ÿ�� ����
    int stopcount;                  //���� ����� ������ ī���Ͱ�
    int z_encoder_interval;         //���ڴ� ���ش�
    int z_encoder_min_interval;     //z�� �Է½� a�� ī���Ͱ� 100ī���� �̻��϶�
    char bucket_ref_pulse_cnt;      //���� 1�� �̵��� �ҿ� ī����
    unsigned char chkCODE;          //�޸� üũ �ڵ�
    int DeAccelDelayCount;          //���� �������� ī��Ʈ
    int DeAccelDelayTime;           //���� �������� �ð�
    unsigned char ACD_CHK_POS;      //�İ��� ���� ���� ��ġ
}SYS_INFO_TYPE;

//GRADE Data
typedef struct struct_SYS_G_DATA{
    long gEWeight[MAX_LDCELL];      //�ε弿 ���� �Ǻ� �߷�
    long gECrack[MAX_LDCELL];       //ä�κ� ũ�� ����
    long gNumber[MAX_GRADE];        //��޺� �Ǻ� ����
    long gWeight[MAX_GRADE];        //��޺� �Ǻ� �߷�
    long pNumber[MAX_GRADE];        //��޺� �μ� ����
    long gTNumber;                  //��ü �Ǻ� ����
    long gTWeight;                  //��ü �Ǻ� �߷�
    long gHNumber;                  //���� ��� ��ȣ
    long gZCount;                   //����Ƚ��(Z count)
    long gSpeed;                    //���� �ӵ�
}G_DATA_TYPE;


//Grading Value Bit Table
// 0000 | 0000 | 0000 | 0000
//--------------------------
//   |      |     |       |-> Solenoid Position || Low Nibble
//   |      |     |---------> Solenoid Position || High Nibble
//   |      |---------------> Grade Position
//   |----------------------> Crack/DOT Info, PRT TYPE || 00:CLean, 01:CRACK, 02:DOT, 00:NONE, 01:PRT A, 02:PRT B
unsigned int BucketData[MAX_BUCKET];             //���� �̼� �����̾� ���� :: �ִ� 300��

//������ ���� ����
GRADE_INFO_TYPE     GRADE_INFO[MAX_GRADE];      //��ް��� ����
SOL_INFO_TYPE       SOL_INFO[MAX_PACKER];       //�ַ����̵� ����
PACKER_INFO_TYPE    PACKER_INFO[MAX_PACKER];    //��Ŀ ����
LDCELL_INFO_TYPE    LDCELL_INFO[MAX_LDCELL];    //�ε弿 ����
MEASURE_INFO_TYPE   MEASURE_INFO;               //�������� ����
PRT_INFO_TYPE       PRT_INFO[MAX_PRT+1];          //������ ���� ����
SYS_INFO_TYPE       SYS_INFO;                   //�ý��� ������ �ʿ��� ����

//������ ���� ����
G_DATA_TYPE         GRADE_DATA;                 //���� ����

#define     AVR_ZERO_LOOP       16

//unsigned int zero_div;
//long ad_average[MAX_LDCELL];
unsigned char ControllerRunMethod=0, SolenoidTestType, TestGrade, CW_DIR=1;
unsigned char z_led_flag, a_led_flag, modRunning, ScanEnable, crackValue, dotValue, crackCHKCNT[MAX_LDCELL], dotCHKCNT[MAX_LDCELL], scan_ad_ch, ScanStopEnable=0;
unsigned char PRT_A_OUT, PRT_B_OUT, pocketSTATE[MAX_PACKER][MAX_SOLENOID], sol_outcnt[MAX_PACKER][MAX_SOLENOID], sol_offcnt[MAX_PACKER][MAX_SOLENOID], sol_offcnt_on[MAX_PACKER][MAX_SOLENOID], do_value[MAX_PACKER], plc_prt_value;
unsigned int phase_a_cnt, max_scan_val=0, MAX_SCAN_REF=2500, max_scan_cnt=0, HolderState[MAX_PACKER], HolderOnTime[MAX_PACKER];
unsigned int weight_ad_end_pulse, weight_cal_end_pulse,zero_ad_end_pulse, zero_cal_end_pulse, ConvertPosition, convert_end_pulse;
unsigned int grading_end_pulse, crackchk_end_pulse, COMM_SET_Position=350, GradingPosition, cur_z_phase_cnt;

unsigned int weight_value[MAX_LDCELL], zero_value[MAX_LDCELL], ref_zero_value[MAX_LDCELL], ConstWeight[MAX_LDCELL], ad_full_scan[600];
int ResultWeight[MAX_LDCELL];
long ad_measure_value[MAX_LDCELL], zero_measure_value[MAX_LDCELL];
long phase_z_cnt;

unsigned char RxBuffer[COM_BUF_MAX], TxBuffer[1500], COM_REV_ENABLE, COM_MOD, TxEnable, TxEnable_Event, TimerMode, adcnt, avr_loop_cnt=10, reformCH, StopEnable=0;
unsigned char A_TX_DATA[8] = {0x02,0x00,0x04,0xA0,0x00,0x00,0x00,0x03}, A_CNT_TX_HOLD=0;
unsigned int TxLength, txcnt, revcnt, RxLength, tmrSPEEDCNT;
long reformTotal;
unsigned int reform_ADC[24], reformVoltage, reformWeight, reformSigned, diffVoltage;
unsigned char prt_a_outcnt, prt_a_off_enable, prt_a_offcnt, prt_b_outcnt, prt_b_off_enable, prt_b_offcnt;
unsigned char CONTROLLER_ID, led_buz_value, do_value[MAX_PACKER];
unsigned char AccelStart, DeAccelStart, AccelStep, DeAccelStep, Sol_Correction_Count, InterLockON, InterLockCnt;
unsigned int  AccelCount, DeAccelCount;
unsigned char div_correct=10, timer_period=5, unit_correct, unit_rising, unit_falling, EVENT_ENABLE=0;
unsigned int  Tx_Cnt;

//void ConvertWeight(unsigned char);
//void WeightGrading(unsigned char);
void COMM_TX_SET(void);
void Initialize_GPIO(void);
void Initialize_REG(void);
void MovingBucket(void);
void MaskingBucket(void);

void  EachInitialize_PARAMETER(unsigned infotype){
    unsigned char icnt, icnt1;

    unsigned int grade_hilimit[MAX_GRADE]={850,679,599,519,479,419,850,0,0};
    unsigned int grade_lolimit[MAX_GRADE]={680,600,520,480,420,320,320,0,0};
    unsigned char sol_outsignal[MAX_SOLENOID] = {SOL_P0,SOL_P1,SOL_P2,SOL_P3,SOL_P4,SOL_P5};
    unsigned int  sol_ontime[MAX_SOLENOID] = {140,146,152,158,164,170};
    unsigned int  sol_offtime[MAX_SOLENOID] = {50,50,50,50,50,50};
    unsigned int  sol_id[MAX_SOLENOID] = {0x0000,0x0001,0x0002,0x0003,0x0004,0x0005};
    unsigned int  sol_packer[MAX_PACKER] = {0x0100,0x0200,0x0300,0x0400,0x0500,0x0600,0x0700,0x0800};
    unsigned char gtype[MAX_GRADE] = {2,1,0,3,4,5,6,7,8};
    unsigned int  startpocketnumber[MAX_PACKER] = {29,38,51,60,73,82,95,104};
    unsigned char ldcell_ch[MAX_LDCELL] = {0,1,2,3,4,5};

    switch(infotype){
        case GRADE_INFO_DATA :
            //��޺� ���� ���� �ʱ�ȭ
            for(icnt=0;icnt<MAX_GRADE;icnt++){
                GRADE_INFO[icnt].hiLimit = grade_hilimit[icnt];
                GRADE_INFO[icnt].loLimit = grade_lolimit[icnt];
                GRADE_INFO[icnt].solenoidnumber = 6;
                GRADE_INFO[icnt].prttype = 0;
                GRADE_INFO[icnt].prtSetCount = 0;
                GRADE_INFO[icnt].prtOutCount = 0;
            }
            break;
        case SOL_INFO_DATA :
            //�ַ����̵� ���� �ʱ�ȭ
            for(icnt=0;icnt<MAX_PACKER;icnt++){
                for(icnt1=0;icnt1<MAX_SOLENOID;icnt1++){
                    SOL_INFO[icnt].used[icnt1] = 1;
                    SOL_INFO[icnt].outsignal[icnt1] = sol_outsignal[icnt1];
                    SOL_INFO[icnt].ontime[icnt1] = sol_ontime[icnt1];
                    SOL_INFO[icnt].offtime[icnt1] = sol_offtime[icnt1];
                    SOL_INFO[icnt].sol_id[icnt1] = sol_packer[icnt] | sol_id[icnt1];
                }
            }
            break;
        case PACKER_INFO_DATA :
            //��Ŀ ���� �ʱ�ȭ
            for(icnt=0;icnt<MAX_PACKER;icnt++){
                PACKER_INFO[icnt].gradetype = gtype[icnt];
                PACKER_INFO[icnt].solcount = 6;
                PACKER_INFO[icnt].startpocketnumber = startpocketnumber[icnt];
            }
            break;
        case LDCELL_INFO_DATA :
            //�ε弿 ���� �ʱ�ȭ
            for(icnt=0;icnt<MAX_LDCELL;icnt++){
                LDCELL_INFO[icnt].channel = ldcell_ch[icnt];
                LDCELL_INFO[icnt].span = 1000;
                LDCELL_INFO[icnt].offset = 0;
            }
            break;
        case MEASURE_INFO_DATA :
            //������ ���� ���� �ʱ�ȭ
            MEASURE_INFO.ad_start_pulse = 70;
            MEASURE_INFO.duringcount = 10;
            MEASURE_INFO.crackchecktime = 60;
            MEASURE_INFO.DotCheckTime = 60;
            MEASURE_INFO.zeroposition = 225;
            break;
        case PRT_INFO_DATA :
            //�μ�� ���� ����
            for(icnt = 0;icnt<MAX_PRT;icnt++){
                PRT_INFO[icnt].ontime = 30;
                PRT_INFO[icnt].offtime = 40;
                PRT_INFO[icnt].startpocketnumber = 15;
            }
            break;
        case SYS_INFO_DATA :
            //�ý��� ���� ����
            SYS_INFO.bucket_ref_pulse_cnt = 60;
            SYS_INFO.correction = 60;
            SYS_INFO.fallingTime = 1600;
            SYS_INFO.risingTime = 1500;
            SYS_INFO.stopcount = 300;
            SYS_INFO.z_encoder_interval = 360;
            SYS_INFO.z_encoder_min_interval = 10;
            SYS_INFO.chkCODE = MEM_CHK_CODE;
            break;
    }
}

void Initailize_PARAMETER(void){
    unsigned char icnt, icnt1;
    unsigned int grade_hilimit[MAX_GRADE]={850,679,599,519,479,419,850,0,0};
    unsigned int grade_lolimit[MAX_GRADE]={680,600,520,480,420,320,320,0,0};
    unsigned char sol_outsignal[MAX_SOLENOID] = {SOL_P0,SOL_P1,SOL_P2,SOL_P3,SOL_P4,SOL_P5};
    unsigned int  sol_ontime[MAX_SOLENOID] = {20,33,46,59,72,85};
    unsigned int  sol_offtime[MAX_SOLENOID] = {50,50,50,50,50,50};
    unsigned int  sol_id[MAX_SOLENOID] = {0x0000,0x0001,0x0002,0x0003,0x0004,0x0005};
    unsigned int  sol_packer[MAX_PACKER] = {0x0100,0x0200,0x0300,0x0400,0x0500,0x0600,0x0700,0x0800};
    unsigned char gtype[MAX_GRADE] = {0,1,2,3,4,5,6,7,8};
    unsigned int  startpocketnumber[MAX_PACKER] = {29,38,51,60,73,82,95,104};
    unsigned char ldcell_ch[MAX_LDCELL] = {0,1,2,3,4,5};

    //��޺� ���� ���� �ʱ�ȭ
    for(icnt=0;icnt<MAX_GRADE;icnt++){
        GRADE_INFO[icnt].hiLimit = grade_hilimit[icnt];
        GRADE_INFO[icnt].loLimit = grade_lolimit[icnt];
        GRADE_INFO[icnt].solenoidnumber = 6;
        GRADE_INFO[icnt].prttype = 0;
        GRADE_INFO[icnt].prtSetCount = 0;
        GRADE_INFO[icnt].prtOutCount = 0;
    }

    //�ַ����̵� ���� �ʱ�ȭ
    for(icnt=0;icnt<MAX_PACKER;icnt++){
        for(icnt1=0;icnt1<MAX_SOLENOID;icnt1++){
            SOL_INFO[icnt].used[icnt1] = 1;
            SOL_INFO[icnt].outsignal[icnt1] = sol_outsignal[icnt1];
            SOL_INFO[icnt].ontime[icnt1] = sol_ontime[icnt1];
            SOL_INFO[icnt].offtime[icnt1] = sol_offtime[icnt1];
            SOL_INFO[icnt].sol_id[icnt1] = sol_packer[icnt] | sol_id[icnt1];
        }
    }

    //��Ŀ ���� �ʱ�ȭ
    for(icnt=0;icnt<MAX_PACKER;icnt++){
        PACKER_INFO[icnt].gradetype = gtype[icnt];
        PACKER_INFO[icnt].solcount = 6;
        PACKER_INFO[icnt].startpocketnumber = startpocketnumber[icnt];
    }

    //�ε弿 ���� �ʱ�ȭ
    for(icnt=0;icnt<MAX_LDCELL;icnt++){
        LDCELL_INFO[icnt].channel = ldcell_ch[icnt];
        LDCELL_INFO[icnt].span = 1000;
        LDCELL_INFO[icnt].offset = 0;
    }

    //������ ���� ���� �ʱ�ȭ
    MEASURE_INFO.ad_start_pulse = 70;
    MEASURE_INFO.duringcount = 10;
    MEASURE_INFO.crackchecktime = 60;
    MEASURE_INFO.DotCheckTime = 60;
    MEASURE_INFO.zeroposition = 225;

    //�μ�� ���� ����
    for(icnt = 0;icnt<MAX_PRT;icnt++){
        PRT_INFO[icnt].ontime = 30;
        PRT_INFO[icnt].offtime = 40;
        PRT_INFO[icnt].startpocketnumber = 15;
    }

    //�ý��� ���� ����
    SYS_INFO.bucket_ref_pulse_cnt = 60;
    SYS_INFO.correction = 60;
    SYS_INFO.fallingTime = 1600;
    SYS_INFO.risingTime = 1500;
    SYS_INFO.stopcount = 300;
    SYS_INFO.z_encoder_interval = 360;
    SYS_INFO.z_encoder_min_interval = 10;
    SYS_INFO.chkCODE = MEM_CHK_CODE;

}

void Initialize_GPIO(void){
    DDRA = 0xFF;        PORTA = 0xFF;       //Data Bus
    DDRB = 0xA7;        PORTB = 0xA7;       //ADC, MEMORY, SCK
    DDRC = 0xFF;        PORTC = 0x7F;       //HIGH ADDRESS BUS
    DDRD = 0x08;        PORTD = 0xFF;       //PLC START, STOP, MACHINE ID, RXD, TXD
    DDRE = 0x06;        PORTE = 0xFF;       //ISP, MEM_CS, EXternal Interrupt::A,B,Z,rev
    DDRF = 0xFF;        PORTF = 0xFF;       //NULL
    DDRG = 0x01;        PORTG = 0x01;       //RD, WR
}

void Initialize_REG(void){
    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 15.625 kHz
    // Mode: Normal top=FFh
    // Timer0 Overflow interrupt
    TCCR0A=0x00;
    TCCR0B=0x05;
    TCNT0=0xF1;
    OCR0A=0x00;
    OCR0B=0x00;
    // Timer/Counter 0 Interrupt(s) initialization
    //TIMSK0=0x01;

    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 15.625 kHz
    // Mode: Normal top=FFFFh
    // Compare A Match Interrupt: On
    TCCR1A=0x00;        TCCR1B=0x00;
    TCNT1H=0x00;        TCNT1L=0x00;
    ICR1H=0x00;         ICR1L=0x00;
    OCR1AH=0x06;        OCR1AL=0x1A;
    OCR1BH=0x00;        OCR1BL=0x00;
    OCR1CH=0x00;        OCR1CL=0x00;
    // Timer/Counter 1 Interrupt(s) initialization
    TIMSK1=0x02;

    // External Interrupt(s) initialization
    // INT0 : ON, ANY CHANGE , INT1 : ON, Rising
    // INT5 : ON, ANY CHANGE , INT6 : ON, Rising , INT7 : ON, Rising
    EICRA=0x05;
    EICRB=0xF4;
    EIMSK=0xE3;
    EIFR=0xE3;

    // USART1 initialization
    // USART1 Rx On, Tx On, Baud Rate: 9600, Parameters: 8 Data, 1 Stop, No Parity
    //9600 :: 0x67 //38400::0x19 //57600::0x10 // 115200 = 0x08
    UCSR1A=0x00;
    UCSR1B=0xD8;
    UCSR1C=0x06;
    UBRR1H=0x00;
    //UBRR0L=0x67;
    UBRR1L=0x10;

    //Extention Memory
    MCUCR=0x00;
    XMCRA=0x80;
    XMCRB=0x00;


}