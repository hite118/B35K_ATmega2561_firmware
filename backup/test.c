/**************************************************/
/* PROJECT NAME : EGG GRADER & PACKING SYSTEM     */
/* AUTHOR COMPANY : EGGTEC.,CO.LTD                */
/* MACHINE NAME : B25K-V3                         */
/* DESCRITE : GRADE SPEED 25,000~30,000           */
/*            MAX 8 GRADE & PACKER                */
/* 1st revision : 2013. 06.17 (MJHyun)            */
/* 2nd revision : 2013. 10.01                     */
/* 3rd revision : 2013. 10.15                     */
/* 4th revision : 2014. 01.25                     */
/*              인쇄기능수정:등외란 인쇄가능      */
/*                           무한,유한 오류수정   */
/*              시작/정지시 솔타점 유지시간 보정  */
/* 5th revision : 2014. 03.10                     */
/*              시작/정지시 보정분해능 상향       */
/* 6th revision : 2014.10.12                      */
/*              나벨 저가 acd 신호처리 변경       */
/*              신호처리 버퍼에 넣고              */
/*              특정한 버퍼 위치 값을 체크        */
/*              선별 데이터 전송 프로토콜 변경,   */
/*              헤더 파일 변경                    */
/* 7th revision : 2019.08.13                      */
/*              마킹기 마킹 모드를 8종으로 확대   */
/*                                                */
/*                                                */
/*                                                */
/**************************************************/

#include "b25k-v3_4_1.h"
#include "ADS8344E-ADC.h"
#include "AT45DB_FLASH.h"

#define     AccelStartPos       5

#define     Mark_M0             0x00
#define     Mark_M1             0x10
#define     Mark_M2             0x20
#define     Mark_M3             0x30
#define     Mark_M4             0x40
#define     Mark_M5             0x50
#define     Mark_M6             0x60
#define     Mark_M7             0x70

void SolenoidRunning(void);
void ConvertWeight(unsigned char);
void CorrectionData(unsigned char);
void SaveParameter(void);
void WeightGrading(unsigned char);

unsigned char A_TX_DATA[8], old_prttype[9];
unsigned char led_toggle, StopCMD, MACHINE_STATE=0, Crack_Dot_Chk_Enable=1, weight_ad_cnt, zero_ad_cnt;
unsigned int old_Zero[6];
unsigned int correct_data_end_pulse, voltData[6][20], off_Correction_Count=0, init_off_correction=25;
unsigned int deAccelStartCount=5, accelStartCount=3, DeAccelDelay=0, DelayTimeCount=10;
unsigned char timerstop = 0, deaccel_chk=0, accel_chk=0, SpeedAdjEnable=0, debugMode=0;
unsigned char slidemotor_state;
unsigned char ACD_DATA_BUF[150], acd_chk_pos;
unsigned char slidemotor_state, accel_rdy=1, deaccel_rdy=0, PackerSharedEnable=9;
unsigned char Marking_MOUT;
unsigned char Marking_MOUT_SNG[8]={Mark_M0, Mark_M1, Mark_M2, Mark_M3, Mark_M4, Mark_M5, Mark_M6, Mark_M7};


interrupt [EXT_INT0] void ext_int0_isr(void)
{
    //version 3.4.2
    //슬라이드 모터 기동/정지 신호를 이용
    //기동시 슬라이드 모터 High신호시 운전시작 accelate 보정시작
    //                     low신호시  accelate보정 종료

    if(SpeedAdjEnable==1)
    {
        //슬라이드 모터 OFF
        if(PIND.0==1)
        {
            if(slidemotor_state ==1)
            {
                if(accel_chk==1){
                    if(MACHINE_STATE==1)
                    {       //가속종료
                        if(debugMode==1)
                        {
                            UDR1 =0xA1;            while(!(UCSR1A & 0x20));
                        }

                        //Acclate Finish
                        AccelStart = 0;
                        AccelStep = 0;
                        AccelCount=accelStartCount;
                        Sol_Correction_Count = 0;
                        SpeedAdjEnable = 0;
                        slidemotor_state = 0;
                        accel_chk = 0;
                        //deaccel_rdy = 1;
                    }
                }
            }
        }

        //슬라이드모터ON
        else if(PIND.0==0)
        {
            if(slidemotor_state==0)
            {
                if(MACHINE_STATE==0)
                {  //가속시작
                    if(accel_rdy==1)
                    {
                        if(debugMode==1)
                        {
                            UDR1 =0xA0;            while(!(UCSR1A & 0x20));
                        }
                        slidemotor_state = 1;
                        accel_rdy = 0;
                        accel_chk = 1;
                        timerstop = 0;
                        AccelCount =0;
                        AccelStep = accelStartCount;
                        MACHINE_STATE =1;
                        off_Correction_Count = init_off_correction;

                        Sol_Correction_Count=SYS_INFO.correction+AccelStartPos;

                        AccelStart = 1;
                        TimerMode = tmrSPEED;
                        OCR1AH=0x00;        OCR1AL=0x4E;        //5msec /1024 prescaler
                        TCCR1B = 0x05;
                    }
                }
            }
        }
    }
}

interrupt [EXT_INT1] void ext_int1_isr(void)
{
    //version 3.4.2
    //정지시 슬라이드 모터 high 신호시 운전 시작 deaccelate보정시작
    //       슬라이드 모터 low신호시 deaccelate 보정 종료
    if(SpeedAdjEnable==1)
    {
        //슬라이드 모터 OFF
        if(PIND.1==1)
        {
            if(slidemotor_state ==1)
            {
                if(MACHINE_STATE==0)
                {                       //감속종료
                    if(deaccel_chk==1)
                    {
                        if(debugMode==1)
                        {
                            UDR1 =0xB1;            while(!(UCSR1A & 0x20));
                        }
                        DeAccelStart = 0;           //감속종료
                        DeAccelStep = deAccelStartCount;
                        DeAccelCount=0;

                        deaccel_chk = 0;
                        timerstop = 1;
                        MACHINE_STATE = 0;
                        slidemotor_state = 0;

                        if(StopCMD==1)
                        {
                            plc_prt_value &= ~MACHINE_START;
                            PLC_CON = plc_prt_value;
                            led_buz_value &= ~LED_RUN_STOP;
                            LED_BUZ = led_buz_value;
                            StopCMD = 0;
                        }
                    }
                }
            }
        }

        //슬라이드모터ON
        else if(PIND.1==0)
        {
            if(slidemotor_state==0)
            {
                if(MACHINE_STATE==1)
                {       //감속시작
                    if(deaccel_rdy==1)
                    {
                        if(debugMode==1)
                        {
                            UDR1 =0xB0;            while(!(UCSR1A & 0x20));
                        }
                        DeAccelDelay=0;
                        DeAccelCount=0;
                        DeAccelStep = deAccelStartCount;
                        off_Correction_Count=0;
                        DeAccelStart = 1;
                        MACHINE_STATE = 0;
                        deaccel_rdy = 0;
                        deaccel_chk =1;
                        slidemotor_state = 1;
                    }
                }
            }
        }
    }
}

/***********************************/
/*         Event Start/Stop        */
/***********************************/
interrupt [EXT_INT5] void ext_int5_isr(void)
{
    //이벤트 신호가 입력되면, 정지 명령
    //이벤트 신호가 off되면, 기동 명령
    //version 3.4.2
    if(EVENT_SIGNAL==0)
    {//정지
        if(debugMode==1)
        {
            UDR1 =0xA3;            while(!(UCSR1A & 0x20));
        }
        EVENT_ENABLE = 1;
        SpeedAdjEnable = 1;

        deaccel_rdy = 1;
    }

    else
    {//기동시작
        EVENT_ENABLE = 0;
        SpeedAdjEnable = 1;
        accel_rdy = 1;
        led_buz_value |= LED_RUN_STOP;
        LED_BUZ = led_buz_value;

        if(debugMode==1)
        {
            UDR1 =0xA2;            while(!(UCSR1A & 0x20));
        }
        plc_prt_value &= ~EVENT_STOP;
        PLC_CON = plc_prt_value;
    }
}

/**************************************/
/*         Encoder Z-Phase Signal     */
/**************************************/
// A상이 1이면 포워딩 상태
// A상이 0이면 리워딩 상태
interrupt [EXT_INT6] void ext_int6_isr(void)
{
    unsigned char tmp_acd_data[150]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                                     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                                     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                                     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                                     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                                     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                                     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                                     0,0,0,0,0,0,0,0,0,0};

    //Moving ACD Data bucket
    memcpy(&tmp_acd_data[0],&ACD_DATA_BUF[0],sizeof(ACD_DATA_BUF));

    //z상 상태표시를 위해 led on 한뒤, a상펄스가 100pulse정도에 후에 off
    //a상 상태 체크를 위한 대기시간

    //A상이 하이 레벨일때 포워딩
    //A상이 로우 레벨이면 백워딩
    //if(old_a_cnt != phase_a_cnt){

    //old_a_cnt = phase_a_cnt;
    //if(phase_a_cnt>2){
    if(PHASE_A==LEVEL_HI)
    {
        if(phase_z_cnt==0 )
        {                             //전원이 ON된후 처음 시작한 뒤, z펄스가 들어오면 클리어
            phase_z_cnt = 1; phase_a_cnt =0;
            z_led_flag = 1;
            led_buz_value |= LED_ENCODER_Z;                     //z상 엔코더 led ON
            if(modRunning == MEASURE_AD)
            {
                ScanEnable = 1;     max_scan_val = 0;
            }
        }
        else if( phase_a_cnt >= SYS_INFO.z_encoder_interval && phase_z_cnt>=1)
        {       //a상 카운터값이 엔코더 max 카운터보다 크면 클리어
            phase_a_cnt =0;                                     //a상 카운터 초기화
            phase_z_cnt++;
            z_led_flag = 1;                                     //z상 led on
            led_buz_value |= LED_ENCODER_Z;                     //z상 엔코더 led ON
        }
        /*else if(phase_a_cnt < SYS_INFO.z_encoder_min_interval && phase_z_cnt>=1){  //a상 카운터가 최소 100카운터 이상들어와야 함.|| 백러쉬, 노이즈성 펄스 방지
            phase_a_cnt =0;
            phase_z_cnt++;
            z_led_flag = 1;
            led_buz_value |= LED_ENCODER_Z;             //z상 엔코더 led ON
            UDR1 =0xBB;            while(!(UCSR1A & 0x20));
        }*/
        else
        {
            phase_a_cnt = 0;
            z_led_flag = 1;
            phase_z_cnt++;
            led_buz_value |= LED_ENCODER_Z;
        }
        //Moving ACD Data bucket
        memcpy(&ACD_DATA_BUF[1],&tmp_acd_data[0],sizeof(ACD_DATA_BUF)-1);
        ACD_DATA_BUF[0]=0;
    }
    LED_BUZ = led_buz_value;

    if(Proximity_sensor_cnt_a_check == TRUE)
    {
        Proximity_sensor_cnt_a++;
        A_TX_DATA[0] = 0x02;
        A_TX_DATA[1] = Proximity_sensor_cnt_a >> 8 ;
        A_TX_DATA[2] = Proximity_sensor_cnt_a ;
        A_TX_DATA[3] = 0x03;
        memcpy(&TxBuffer[0],&A_TX_DATA[0],sizeof(A_TX_DATA));
        TxEnable = 1;   txcnt = 1;  TxLength = 3;   UDR1 = TxBuffer[0];
        Proximity_sensor_cnt_a_check = FALSE;
    }

    if(Proximity_sensor_cnt_b_check == TRUE)
    {
        Proximity_sensor_cnt_b++;
        A_TX_DATA[0] = 0x02;
        A_TX_DATA[1] = Proximity_sensor_cnt_b >> 8 ;
        A_TX_DATA[2] = Proximity_sensor_cnt_b ;
        A_TX_DATA[3] = 0x03;
        memcpy(&TxBuffer[0],&A_TX_DATA[0],sizeof(A_TX_DATA));
        TxEnable = 1;   txcnt = 1;  TxLength = 3;   UDR1 = TxBuffer[0];
        Proximity_sensor_cnt_a_check = FALSE;
    }


}

/**************************************/
/*         Encoder A-Phase Signal     */
/**************************************/
// Encoder A-Phase Signal :: Edge High check
// A상이 1일 때 B상이 0이면 포워딩
// A상이 1일 때 B상이 1이면 백워딩 상태 읽기
interrupt [EXT_INT7] void ext_int7_isr(void)
{
    unsigned int lcnt, datalen=0;
    unsigned char cal_cnt=0;
    unsigned char phaseB;
    unsigned char crack_dot_ch;
    unsigned int rawdata;

    //UDR1 = PHASE_B;            while(!(UCSR1A & 0x20));
    //포워딩 상태일때
    phaseB = PHASE_B;

    if(phaseB==CW_DIR)
    {    //알찬 & 공장용 엔코더 :: 우방향  :: CW_DIR = 1
    //if(phaseB==0){      //상지 집란장 :: 좌방향 :: CW_DIR = 0
        //매 60펄스마다 A상 LED ON, bucket count

        /*if(DeAccelStart==1){
            UDR1 =DeAccelStep;            while(!(UCSR1A & 0x20));
            UDR1 =0xAA;            while(!(UCSR1A & 0x20));
        } */
        switch(phase_a_cnt)
        {
            case 1 : case 61 : case 121 : case 181 : case 241 : case 301 :
                MovingBucket();
                //if(modRunning==NORMAL_RUN || modRunning==SOLENOID_TEST){
                MaskingBucket();
                //}
                led_buz_value |= LED_ENCODER_A;
                a_led_flag = 1;

                if(EDI_CH1 == 0x01)
                {
                   Proximity_sensor_cnt_a_check = TRUE;
                }

                if(EDI_CH1 == 0x02)
                {
                   Proximity_sensor_cnt_b_check = TRUE;
                }

                break;
        }

        //A-Phase LED OFF
        if((phase_a_cnt % SYS_INFO.bucket_ref_pulse_cnt)==30)
        {
            if(a_led_flag ==1)
            {
                a_led_flag = 0;
                led_buz_value &= ~LED_ENCODER_A;
            }
        }

         //InterLock OFF
        if(InterLockON == 1)
        {
            InterLockCnt++;
            if(InterLockCnt > 10)
            {
                InterLockON = 0;
                InterLockCnt = 0;
                plc_prt_value &= ~INTER_LOCK_ON;
                PLC_CON = plc_prt_value;
            }
        }

        //장비 정지 신호 출력
        //장비 정지 신호 출력후 PLC정지 신호 올때 까지 기동 유지
        //이때부터 타이머을 이용 DeAcceltime 적용, 솔레노이드 동작 시간 조정
        if(StopEnable==1 && phase_a_cnt == SYS_INFO.stopcount)
        {
            StopEnable = 0;
            plc_prt_value &= ~MACHINE_START;
            plc_prt_value |= EVENT_STOP;

            EVENT_ENABLE = 2;

            PLC_CON = plc_prt_value;

            led_buz_value &= ~LED_RUN_STOP;
            LED_BUZ = led_buz_value;
        }

        //이벤트 신호 입력시 정지
        if(EVENT_ENABLE==1 && phase_a_cnt == SYS_INFO.stopcount)
        {
            plc_prt_value |= EVENT_STOP;
            PLC_CON = plc_prt_value;

            EVENT_ENABLE = 2;
            led_buz_value &= ~LED_RUN_STOP;
            LED_BUZ = led_buz_value;
        }

        A_TX_DATA[0] = 0x02;
        A_TX_DATA[1] = 0x00;
        A_TX_DATA[2] = 0x04;
        A_TX_DATA[3] = 0xE1;
        A_TX_DATA[4] = 0x01;
        A_TX_DATA[5] = phase_a_cnt >> 8 ;
        A_TX_DATA[6] = phase_a_cnt;
        A_TX_DATA[7] = 0x03;

        if(A_CNT_TX_HOLD==0 && TxEnable==0)
        {
            //memcpy(&TxBuffer[0],&A_TX_DATA[0],sizeof(A_TX_DATA));
            if(COMM_SET_Position!=phase_a_cnt)
            {
                //TxEnable = 1;   txcnt = 1;  TxLength = 8;   UDR1 = TxBuffer[0];
            }
        }

        switch(modRunning)
        {
            case ENCODER_CHK :
                //while(TxEnable);
                memcpy(&TxBuffer[0],&A_TX_DATA[0],sizeof(A_TX_DATA));
                //if(COMM_SET_Position!=phase_a_cnt){
                    TxEnable = 1;   txcnt = 1;  TxLength = 8;   UDR1 = TxBuffer[0];
                //}
                break;

            case MACHINE_STOP :
                break;

            case NORMAL_RUN :
                //매 펄스마다 체크하여 영점 위치에서 AD체크, 중량체크
                //                     중량체크 이후에 분류, 통신
                //
                /*if(MEASURE_INFO.ad_start_pulse <= phase_a_cnt&& phase_a_cnt < weight_ad_end_pulse ){
                    //중량 측정 시작 펄스보다 같거나 크고 측정 종료 펄스보다 작으면
                    //중량 측정 || 1pulse 6channel
                    for(lcnt=0;lcnt<MAX_LDCELL;lcnt++){
                        ad_measure_value[lcnt] += (long)RD_ADC(lcnt);
                    }
                    weight_ad_cnt++;
                }
                else if(weight_ad_end_pulse <= phase_a_cnt && phase_a_cnt < weight_cal_end_pulse){
                    //중량 측정 종료 펄스보다 같거나 크고 측정 종료 펄스에서 6펄스 더한 값보다 작으면
                    //중량 연산 || 1pulse 1channel average calculate
                    cal_cnt = phase_a_cnt - weight_ad_end_pulse;
                    //ad_measure_value[cal_cnt] /= MEASURE_INFO.duringcount;
                    ad_measure_value[cal_cnt] /= weight_ad_cnt;
                    weight_value[cal_cnt] = (ad_measure_value[cal_cnt]* 763)/10000;
                    ad_measure_value[cal_cnt]=0;
                    if(cal_cnt>=5) weight_ad_cnt=0;
                }
                else if(ConvertPosition <=phase_a_cnt && phase_a_cnt < convert_end_pulse){
                    //측정된 데이터를 무게값으로 환산
                    cal_cnt = phase_a_cnt - ConvertPosition;

                    UDR1 =zero_value[cal_cnt]>>8;            while(!(UCSR1A & 0x20));
                    UDR1 =zero_value[cal_cnt];            while(!(UCSR1A & 0x20));
                    UDR1 =0xCC;            while(!(UCSR1A & 0x20));

                    if(cal_cnt>=5) {
                        zero_ad_cnt=0;
                        UDR1 =0xCF;            while(!(UCSR1A & 0x20));
                    }

                    ConvertWeight(cal_cnt);
                } */

                //중량측정시작-3.3.4
                if(MEASURE_INFO.ad_start_pulse <= phase_a_cnt&& phase_a_cnt < weight_ad_end_pulse )
                {
                    //중량 측정 시작 펄스보다 같거나 크고 측정 종료 펄스보다 작으면
                    //중량 측정 || 1pulse 6channel
                    for(lcnt=0;lcnt<MAX_LDCELL;lcnt++)
                    {
                        rawdata = RD_ADC(lcnt);
                        voltData[lcnt][weight_ad_cnt] = ((long)rawdata*763)/10000;
                    }
                    weight_ad_cnt++;
                }
                else if(weight_ad_end_pulse <= phase_a_cnt && phase_a_cnt < correct_data_end_pulse)
                {
                    //중량측정 구간의 raw데이터를 평균값, 최대, 최소값에 의해 보정
                    cal_cnt = phase_a_cnt - weight_ad_end_pulse;
                    CorrectionData(cal_cnt);
                    if(cal_cnt>=5) weight_ad_cnt=0;
                }
                else if(ConvertPosition <=phase_a_cnt && phase_a_cnt < convert_end_pulse)
                {
                    //측정된 데이터를 무게값으로 환산
                    cal_cnt = phase_a_cnt - ConvertPosition;
                    /*
                    //UDR1 =cal_cnt;            while(!(UCSR1A & 0x20));
                    //UDR1 =zero_value[cal_cnt]>>8;            while(!(UCSR1A & 0x20));
                    //UDR1 =zero_value[cal_cnt];            while(!(UCSR1A & 0x20));
                    //UDR1 =0xCC;            while(!(UCSR1A & 0x20));

                    if(cal_cnt>=5) {
                        zero_ad_cnt=0;
                        UDR1 =0xCF;            while(!(UCSR1A & 0x20));
                    }
                    */
                    ConvertWeight(cal_cnt);
                }

                //영점 측정 시작
                if(MEASURE_INFO.zeroposition <= phase_a_cnt && phase_a_cnt < zero_ad_end_pulse)
                {
                    //영점 측정 시작 펄스보다 같거나 크고 측정 종료 펄스보다 작으면
                    //영점 중량 측정 || 1pulse 6channel
                    for(lcnt=0;lcnt<MAX_LDCELL;lcnt++)
                    {
                        zero_measure_value[lcnt] += (long)RD_ADC(lcnt);
                    }
                    zero_ad_cnt++;

                }
                else if(zero_ad_end_pulse <= phase_a_cnt && phase_a_cnt < zero_cal_end_pulse)
                {
                    //영점 측정 종료 펄스보다 같거나 크고 측정 종료 펄스에서 6펄스 더한 값보다 작으면
                    //영점 연산 || 1pulse 1channel average calculate
                    cal_cnt = phase_a_cnt - zero_ad_end_pulse;
                    //평균
                    //zero_measure_value[cal_cnt] /= ZeroMeasurePulse;
                    zero_measure_value[cal_cnt] /= zero_ad_cnt;
                    //Digit to Voltage
                    zero_value[cal_cnt] = (zero_measure_value[cal_cnt]* 763)/10000;
                    zero_measure_value[cal_cnt] = 0;
                    //UDR1 =zero_value[cal_cnt]>>8;            while(!(UCSR1A & 0x20));
                    //UDR1 =zero_value[cal_cnt];            while(!(UCSR1A & 0x20));
                    //UDR1 =0xEE;            while(!(UCSR1A & 0x20));

                    if(cal_cnt>=5)
                    {
                        zero_ad_cnt=0;
                        //UDR1 =0xEF;            while(!(UCSR1A & 0x20));
                    }
                }

                if(COMM_SET_Position==phase_a_cnt)
                {
                    //전송될 통신 데이터 셋팅 및 전송 시작 명령
                    A_CNT_TX_HOLD=1;
                    if(debugMode==0)
                    {
                        COMM_TX_SET();
                    }
                }

                if(GradingPosition <= phase_a_cnt && phase_a_cnt < grading_end_pulse)
                {
                    cal_cnt = phase_a_cnt - GradingPosition;
                    WeightGrading(cal_cnt);
                }


                //if(MEASURE_INFO.crackchecktime  <=phase_a_cnt && phase_a_cnt < crackchk_end_pulse){
                if(MEASURE_INFO.crackchecktime <=phase_a_cnt && phase_a_cnt < crackchk_end_pulse )
                {
                    if(Crack_Dot_Chk_Enable==1)
                    {//크랙디텍터, 오란검출기 신호 체크
                        crackValue = EDI_CH0;
                        dotValue = EDI_CH1;



                        for(lcnt=0;lcnt<6;lcnt++)
                        {
                            crack_dot_ch = 0x01 << lcnt;
                            if((crackValue & crack_dot_ch)==crack_dot_ch)
                            { //각 채널별 crack신호가 있으면
                                crackCHKCNT[lcnt]++;
                            }
                            //오물란 신호 감지 일시중지
                            /*if((dotValue & crack_dot_ch)==crack_dot_ch){ //각 채널별 crack신호가 있으면
                                dotCHKCNT[lcnt]++;
                            }*/
                            dotCHKCNT[lcnt] = 0;
                        }

                        if(phase_a_cnt == (crackchk_end_pulse-1))
                        {
                            for(lcnt=0;lcnt<6;lcnt++)
                            {
                                crack_dot_ch = 0x01 << lcnt;
                                if(debugMode==3)
                                {
                                    //UDR1 =0xFC;            while(!(UCSR1A & 0x20));
                                }
                                //저가형 acd적용
                                if(crackCHKCNT[lcnt] > 10)
                                {
                                    ACD_DATA_BUF[0] |= (0x01<<lcnt);
                                    if(debugMode==3)
                                    {
                                        UDR1 =ACD_DATA_BUF[0];            while(!(UCSR1A & 0x20));
                                        UDR1 =0xFA;            while(!(UCSR1A & 0x20));
                                    }
                                    crackCHKCNT[lcnt] = 0;
                                }
                                else
                                {
                                    if(debugMode==3)
                                    {
                                        UDR1 =crackCHKCNT[lcnt];            while(!(UCSR1A & 0x20));
                                        UDR1 =0xFD;            while(!(UCSR1A & 0x20));
                                    }
                                    crackCHKCNT[lcnt] = 0;
                                }
                            }
                        }
                    }
                }

                //매펄스마다 솔레노이드 동작 처리
                SolenoidRunning();
                break;

            case MEASURE_AD :
                if(ScanEnable==1 && phase_z_cnt>=1)
                {
                    //UDR1 = 0xEA;     while(!(UCSR1A & 0x20));
                    ad_full_scan[phase_a_cnt] = RD_ADC(scan_ad_ch);
                    ad_full_scan[phase_a_cnt] = (long)ad_full_scan[phase_a_cnt]*763/10000;

                    //ad_full_scan캔된 값의 최대값을 추출
                    if(ad_full_scan[phase_a_cnt] > max_scan_val)
                    {
                        max_scan_val = ad_full_scan[phase_a_cnt];
                    }
                    //크랙 데이터 삽입 :: 0000 0000 0000 0000
                    //                    1000 0000 0000 0000 :: 크랙신호
                    //                    0100 0000 0000 0000 :: 오물란 신호
                    crack_dot_ch = 0x01 << scan_ad_ch;
                    crackValue = EDI_CH0;

                    if((crackValue & crack_dot_ch) == crack_dot_ch)
                    {
                        ACD_DATA_BUF[0] |= (0x01<<crack_dot_ch);
                        crackCHKCNT[lcnt] = 0;
                    }

                    if(((ACD_DATA_BUF[SYS_INFO.ACD_CHK_POS]>>scan_ad_ch) & 0x01)==0x01)
                    {
                        ad_full_scan[phase_a_cnt] |= 0x8000;
                    }

                    dotValue = EDI_CH1;
                    if((dotValue & crack_dot_ch) == crack_dot_ch)
                    {
                        ad_full_scan[phase_a_cnt] |= 0x4000;
                    }


                    //최대값이 최소한 소란 중량이상의 값이면 로드셀에 계란이 탑재된것으로 인식하고 스캔 종료
                    if(max_scan_val > MAX_SCAN_REF && ScanStopEnable==0)
                    {
                        max_scan_cnt++;
                        //UDR1 = max_scan_cnt;     while(!(UCSR1A & 0x20));
                        //UDR1 = 0xED;     while(!(UCSR1A & 0x20));
                        if(max_scan_cnt > 20)
                        {
                            //UDR1 = 0xEE;     while(!(UCSR1A & 0x20));
                            //ScanStopEnable=1;
                            ScanStopEnable=1;
                            max_scan_cnt = 0;
                            cur_z_phase_cnt = phase_z_cnt;
                        }
                    }

                    /*if(phase_z_cnt>10){
                        MAX_SCAN_REF = 1000;
                    }
                    */
                    //엔코더 a상펄스가 z인터벌보다 크거나 같고, 스캔 종료시점인경우 장치 정지
                    //측정된 데이터 전송 시작
                    if(ScanStopEnable==1)
                    {
                        //UDR1 = 0xEB;     while(!(UCSR1A & 0x20));
                        //UDR1 = cur_z_phase_cnt;     while(!(UCSR1A & 0x20));
                        //UDR1 = phase_z_cnt;     while(!(UCSR1A & 0x20));
                        //if(phase_a_cnt>= SYS_INFO.z_encoder_interval || phase_z_cnt > 1){
                        if(cur_z_phase_cnt < phase_z_cnt)
                        {
                        //if(phase_a_cnt==359){
                            //UDR1 = 0xEB;     while(!(UCSR1A & 0x20));
                            ScanStopEnable = 2;
                            cur_z_phase_cnt = phase_z_cnt;
                        }
                    }

                    else if(ScanStopEnable==2)
                    {
                        //UDR1 = 0xEC;     while(!(UCSR1A & 0x20));
                        if(cur_z_phase_cnt < phase_z_cnt)
                        {
                        //if(phase_a_cnt==359){
                            ScanEnable = 0;
                            modRunning = MACHINE_STOP;
                            ScanStopEnable = 0;
                            //datalen = sizeof(ad_full_scan);
                            datalen = sizeof(ad_full_scan);
                            TxBuffer[0] = 0x02;
                            TxBuffer[1] = (datalen+2)>>8;             //실제데이터 이외 COMMAND 2byte 포함
                            TxBuffer[2] = (datalen+2) & 0xFF;
                            TxBuffer[3] = 0x10;
                            TxBuffer[4] = 0x0A + scan_ad_ch;
                            memcpy(&(TxBuffer[5]), &(ad_full_scan[0]), datalen);
                            TxBuffer[5+datalen] = 0x03;
                            TxEnable = 1;   txcnt = 1;  TxLength = datalen+6;   UDR1 = TxBuffer[0];
                            plc_prt_value &= ~MACHINE_START;
                            PLC_CON = plc_prt_value;
                            led_buz_value &= ~LED_RUN_STOP;
                            LED_BUZ = led_buz_value;
                        }
                    }

                    else
                    {
                        if(phase_z_cnt > 50)
                        {
                        ScanEnable = 0; modRunning = MACHINE_STOP;
                        TxBuffer[0] = 0x02;
                        TxBuffer[1] = 0x00;             //실제데이터 이외 COMMAND 2byte 포함
                        TxBuffer[2] = 0x02;
                        TxBuffer[3] = 0x10;
                        TxBuffer[4] = 0xFF;
                        TxBuffer[5] = 0x03;
                        TxEnable = 1;   txcnt = 1;  TxLength = datalen+6;   UDR1 = TxBuffer[0];

                        plc_prt_value &= ~MACHINE_START;
                        PLC_CON = plc_prt_value;
                        led_buz_value &= ~LED_RUN_STOP;
                        LED_BUZ = led_buz_value;
                        }

                        else
                        {
                        //UDR1 = phase_z_cnt;     while(!(UCSR1A & 0x20));
                        //UDR1 = 0xEC;     while(!(UCSR1A & 0x20));
                        }
                    }
                }

                //if(UDR1 == 0xA5){
                if(StopCMD==1)
                {
                    ScanEnable = 0; modRunning = MACHINE_STOP;
                    StopCMD = 0;
                    /*TxBuffer[0] = 0x02;
                    TxBuffer[1] = 0x00;             //실제데이터 이외 COMMAND 2byte 포함
                    TxBuffer[2] = 0x02;
                    TxBuffer[3] = 0x10;
                    TxBuffer[4] = 0x05;
                    TxBuffer[5] = 0x03;
                    TxEnable = 1;   txcnt = 1;  TxLength = datalen+6;   UDR1 = TxBuffer[0];
                    */
                    plc_prt_value &= ~MACHINE_START;
                    PLC_CON = plc_prt_value;
                }
                break;

            case SOLENOID_TEST :
                if(GradingPosition <= phase_a_cnt && phase_a_cnt < grading_end_pulse)
                {
                    //등급 분류::240pulse
                    cal_cnt = phase_a_cnt - GradingPosition;
                    WeightGrading(cal_cnt);
                }

                //매펄스마다 솔레노이드 동작 처리
                SolenoidRunning();
                break;

            case EMERGENCY_STOP :
                break;
        }

        //z상 LED가 on상태에서 100msec지연후 led off
        if(z_led_flag==1 && (phase_a_cnt>100))
        {
            z_led_flag = 0;
            led_buz_value &= ~LED_ENCODER_Z;
        }
        //old_a_cnt = phase_a_cnt;
        phase_a_cnt++;

        /*if(phase_a_cnt>360){
            phase_a_cnt=0;
            z_led_flag = 0;
            led_buz_value &= ~LED_ENCODER_Z;
        } */

        LED_BUZ = led_buz_value;
    }
    else
    {
        //메인모터 역회전에 따른 엔코더 Reverse인 경우
        //A상 카운터를 빼줌.

        if(modRunning==ENCODER_CHK)
        {
            if(phase_a_cnt>0)
            {
                phase_a_cnt--;
            }
            else if(phase_a_cnt==0)
            {
                phase_a_cnt=359;
            }

            A_TX_DATA[0] = 0x02;
            A_TX_DATA[1] = 0x00;
            A_TX_DATA[2] = 0x04;
            A_TX_DATA[3] = 0xE1;
            A_TX_DATA[4] = 0x01;
            A_TX_DATA[5] = phase_a_cnt >> 8 ;
            A_TX_DATA[6] = phase_a_cnt;
            A_TX_DATA[7] = 0x03;

            memcpy(&TxBuffer[0],&A_TX_DATA[0],sizeof(A_TX_DATA));
            //if(COMM_SET_Position!=phase_a_cnt){
                TxEnable = 1;   txcnt = 1;  TxLength = 8;   UDR1 = TxBuffer[0];
            //}
        }

    }
}

// USART0 Receiver interrupt service routine
interrupt [USART1_RXC] void usart1_rx_isr(void)
{
    unsigned char rxd;

    rxd = UDR1;

    switch(COM_MOD)
    {
        case COM_STX :
            if(rxd==0x02)
            {
                COM_MOD = COM_LEN;
            }
            else if(rxd==0xA5)
            {
                //version 3.4.2
                //구동중 정지 명령 수신의 경우
                //    이벤트 발생으로 처리해서 정지하도록 하고,
                //    슬라이드모터가 기동후 정지되면 장비 기동 신호를 OFF
                //정지상태에서 정지명령 수신의 경우
                //    정지상태로 모든 플래그 셋팅하고,
                //    장비 기동 신호를 off
                if(MACHINE_STATE==1)
                {
                    //StopEnable = 1;
                    EVENT_ENABLE = 1;
                    SpeedAdjEnable = 1;
                    accel_rdy = 0;
                    deaccel_rdy = 1;
                    StopCMD = 1;
                    if(debugMode==1)
                    {
                       UDR1 =0xF2;            while(!(UCSR1A & 0x20));
                    }
                }
                else if(MACHINE_STATE==0)
                {
                    StopEnable = 0;
                    StopCMD = 0;
                    plc_prt_value &= ~MACHINE_START;
                    plc_prt_value |= EVENT_STOP;
                    PLC_CON = plc_prt_value;
                    led_buz_value &= ~LED_RUN_STOP;
                    LED_BUZ = led_buz_value;
                     if(debugMode==1){
                        UDR1 =0xF3;            while(!(UCSR1A & 0x20));
                     }
                }
            }
            break;

        case COM_LEN :
            RxLength = rxd;        COM_MOD = COM_DAT;
            break;

        case COM_DAT :
            RxBuffer[revcnt++] = rxd;
            if(RxLength<=revcnt)
            {
                COM_MOD = COM_ETX;
            }
            break;

        case COM_ETX :
            if(rxd==0x03)
            {
                COM_MOD = COM_STX;
                revcnt=0;
                COM_REV_ENABLE = 1;
            }
            break;
    }
}

// USART1 Receiver interrupt service routine
interrupt [USART1_TXC] void usart1_tx_isr(void)
{
    if(TxEnable)
    {
        if(txcnt<TxLength)
        {
            UDR1 = TxBuffer[txcnt++];
            A_CNT_TX_HOLD = 1;
        }
        else
        {
            TxEnable = 0;   txcnt = 0;      A_CNT_TX_HOLD = 0;
        }
    }
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    // Reinitialize Timer 0 value
    //TCNT0=0xF1;
    // Place your code here

}

// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{

    long avrtotal=0;
    unsigned int readvalue=0;

    // Place your code here
    TCNT1H = 0x00;
    TCNT1L = 0x00;

    switch(TimerMode)
    {
        case tmrADC :
            readvalue = RD_ADC(reformCH);
            avrtotal = reformTotal + ((long)readvalue*763)/10000;                     //평균합계(reformTotal)와 현재값을 합산
            reformTotal -= (long)reform_ADC[adcnt];                       //평균합계에서 직전 평균값을 뺀다.
            reform_ADC[adcnt] = (unsigned int)(avrtotal / (avr_loop_cnt+1));        //

            reformVoltage = (long)reform_ADC[adcnt];
            reformTotal += (long)reform_ADC[adcnt++];
            adcnt %= avr_loop_cnt;


            if(reformVoltage >= zero_value[reformCH])
            {
                diffVoltage = reformVoltage - zero_value[reformCH];
                //Positive Value
                reformSigned = 0;
            }
            else
            {
                 diffVoltage = zero_value[reformCH] - reformVoltage;
                 //Negative Value
                reformSigned = 1;
            }

            reformWeight = ((long)diffVoltage * ConstWeight[reformCH])/1000;
            reformWeight = ((long)reformWeight* 29412)/100000;

            OCR1AH=0x00;        OCR1AL=0x4E;        //5msec /1024 prescaler
            TCCR1B = 0x05;
            break;

        case tmrSPEED :
            if(modRunning==NORMAL_RUN || modRunning==SOLENOID_TEST)
            {
                tmrSPEEDCNT++;

                if(AccelStart==1)
                {
                    AccelCount++;
                    if((AccelCount % unit_rising) ==0)
                    { //5msec period interrupt
                        AccelStep++;
                        Sol_Correction_Count = SYS_INFO.correction -(AccelStep*unit_correct);

                        if(AccelStep<init_off_correction)
                        {
                            off_Correction_Count = 0;
                        }
                        else
                        {
                            off_Correction_Count = 0;
                        }

                        if(AccelStep>=SYS_INFO.correction)
                        {
                            AccelStart = 0;                 //가속종료
                            AccelStep = 0;
                            AccelCount=accelStartCount;
                            Sol_Correction_Count = 0;
                        }
                    }
                }

                if(DeAccelStart==1)
                {
                    DeAccelDelay++;
                    if(DeAccelDelay>=DelayTimeCount)
                    {
                    DeAccelCount++;
                    if((DeAccelCount %unit_falling) ==0)
                    {
                        DeAccelStep++;
                        Sol_Correction_Count = DeAccelStep * unit_correct;

                        if(DeAccelStep>(init_off_correction+10))
                        {
                            off_Correction_Count = 0;
                        }
                        else
                        {
                            off_Correction_Count = 0;
                        }

                        if(DeAccelStep>=SYS_INFO.correction)
                        {
                            DeAccelStart = 0;           //감속종료
                            DeAccelStep = deAccelStartCount;
                            DeAccelCount=0;
                            Sol_Correction_Count=SYS_INFO.correction+5;

                            timerstop = 1;
                        }
                    }

                    }
                }

                if(timerstop==0)
                {
                    OCR1AH=0x00;        OCR1AL=0x4E;        //5msec /1024 prescaler
                    TCCR1B = 0x05;
                }
                else
                {
                    TCCR1B = 0x00;
                    TimerMode = tmrNONE;
                }
            }
            break;
        case tmrBUZ :
            led_buz_value &= ~BUZZER_ON;
            LED_BUZ = led_buz_value;
            TCCR1B = 0x00;
            TimerMode = tmrNONE;
            break;
    }
}

//중량 측정 위치에서 측정된 데이터를 최대값, 최소값, 평균값에 의해 보정
void CorrectionData(unsigned char ch)
{
    unsigned int maxdata=0, mindata=10000, avrdata;
    long TotalValue=0;
    unsigned char lcnt;

    //측정된 데이터의 최대값, 최소값, 평균값 구하기
    for(lcnt=0;lcnt<weight_ad_cnt;lcnt++)
    {
        if(voltData[ch][lcnt] >= maxdata) maxdata=voltData[ch][lcnt];
        if(voltData[ch][lcnt] <= mindata) mindata=voltData[ch][lcnt];
        TotalValue += (long)voltData[ch][lcnt];
    }

    avrdata = (unsigned int)(TotalValue / weight_ad_cnt);
    TotalValue = 0;

    //최대값, 최소값을 평균값으로 대체
    for(lcnt=0;lcnt<weight_ad_cnt;lcnt++)
    {
        if(voltData[ch][lcnt] >= maxdata || voltData[ch][lcnt]<=mindata)
        {
            voltData[ch][lcnt] = avrdata;
        }

        TotalValue += (long)voltData[ch][lcnt];
        weight_value[ch] = (TotalValue / weight_ad_cnt);
    }
}

//전압레벨로 변환된 측정값을 실제 무게로 환산
void ConvertWeight(unsigned char ch)
{
    unsigned int iWeight;
    int RWeight;

    //측정된 중량값에서 영점값을 뺀다.
    if(weight_value[ch] >= zero_value[ch])
    {
        iWeight = weight_value[ch] - zero_value[ch];
    }
    else
    {
        iWeight = zero_value[ch]-weight_value[ch];
    }

    old_Zero[ch] = zero_value[ch];

    //1차 계산된 값에 SPAN값을 곱하고, 전압값을 중량으로 변환하기 위한 변환 상수(약 0.0286=100/3500)를 곱하고
    //최종 중량값을 추출
    RWeight = ((long)iWeight * ConstWeight[ch])/1000;
    RWeight = ((long)RWeight*29412 )/100000;


    // 중량연산 결과 모니터링
    if(debugMode==2)
    {

        UDR1 =weight_value[ch]>>8;            while(!(UCSR1A & 0x20));
        UDR1 =weight_value[ch];            while(!(UCSR1A & 0x20));
        UDR1 =zero_value[ch]>>8;            while(!(UCSR1A & 0x20));
        UDR1 =zero_value[ch];            while(!(UCSR1A & 0x20));
        UDR1 =0xDD;            while(!(UCSR1A & 0x20));


        UDR1 =RWeight>>8;            while(!(UCSR1A & 0x20));
        UDR1 =RWeight;            while(!(UCSR1A & 0x20));
        UDR1 =0xDE;            while(!(UCSR1A & 0x20));

        if(ch==5){
            UDR1 =0xDF;            while(!(UCSR1A & 0x20));
        }
    }

    //Offset & Span 계산
    //Offset은 매번 영점 기준 측정후 계산
    //Span은 무게 보정시에만 계산
    //Offset = Z_MeasureValue - Z_Reference
    //SPAN = iWeight / MaxRef ( 측정된값과 100g 기준값의 배율- MaxRef = 4800)
    //추출된 값을 저장
    if(weight_value[ch] >= zero_value[ch])
    {
        ResultWeight[ch] = RWeight;
    }
    else{
        ResultWeight[ch] = RWeight * -1;
    }

}

//측정된 계란을 무게, 솔위치, 파란, 오란 분류
void WeightGrading(unsigned char ch)
{
    unsigned char grade_result=0xFF, k=0;
    int gradeWeight, set_bucket_data=0;
    int testWeight[9] = {700,650,580,500,450,390,0,0,100};
    long eggcnt_sum = 0;

    //ver3.4.1 = 저가형 acd적용을 위한 수정
    unsigned char crackdata;

    testWeight[0] = GRADE_INFO[g_KING].loLimit + 20;
    testWeight[1] = GRADE_INFO[g_SPECIAL].loLimit + 20;
    testWeight[2] = GRADE_INFO[g_BIG].loLimit + 20;
    testWeight[3] = GRADE_INFO[g_MIDDLE].loLimit + 20;
    testWeight[4] = GRADE_INFO[g_SMALL].loLimit + 20;
    testWeight[5] = GRADE_INFO[g_LIGHT].loLimit + 20;

    if(modRunning==NORMAL_RUN)
    {
        gradeWeight = ResultWeight[ch];
    }
    else if(modRunning==SOLENOID_TEST)
    {
        if(SolenoidTestType==0)
        {
            if(ch==0)
            {
                if(TestGrade==5)
                {
                    //ver3.4.1 = 저가형 acd적용을 위한 수정
                    //crackCHKCNT[0] = 100;
                    ACD_DATA_BUF[0] = 0x01;
                    dotCHKCNT[0] = 0;
                }
                else if(TestGrade==6)
                {
                    dotCHKCNT[0] =100;
                    //crackCHKCNT[0] = 0;
                    //ver3.4.1 = 저가형 acd적용을 위한 수정
                    ACD_DATA_BUF[0] = 0x00;
                }
                else
                {
                    gradeWeight = testWeight[TestGrade];
                }
            }
            else
            {
                gradeWeight = 10;
            }
        }
        else if(SolenoidTestType==1)
        {
            if(TestGrade==5)
            {
                //ver3.4.1 = 저가형 acd적용을 위한 수정
                //crackCHKCNT[ch] = 100;
                ACD_DATA_BUF[0] = 0x01<<ch;
            }
            else if(TestGrade==6)
            {
                dotCHKCNT[ch] =100;
            }
            else{
                gradeWeight = testWeight[TestGrade];
            }
        }
    }

    GRADE_DATA.gEWeight[ch] = ResultWeight[ch];

    // if((crackCHKCNT[ch] <= 5) && dotCHKCNT[ch]<= 5){     //크랙이나 오물란 신호가 없으면 :: 5이하이면 무시
    //ver3.4.1 = 저가형 acd적용을 위한 수정
    //SYS_INFO.ACD_CHK_POS =3;
    crackdata = (ACD_DATA_BUF[SYS_INFO.ACD_CHK_POS]>>ch) & 0x01;

    if(debugMode==3)
    {
        UDR1 =ACD_DATA_BUF[0];            while(!(UCSR1A & 0x20));
        UDR1 =ACD_DATA_BUF[1];            while(!(UCSR1A & 0x20));
        UDR1 =ACD_DATA_BUF[2];            while(!(UCSR1A & 0x20));
        UDR1 =ACD_DATA_BUF[3];            while(!(UCSR1A & 0x20));
        UDR1 =ACD_DATA_BUF[SYS_INFO.ACD_CHK_POS];            while(!(UCSR1A & 0x20));
        UDR1 =0xFB;                                          while(!(UCSR1A & 0x20));
    }

    if((crackdata == 0 ) && dotCHKCNT[ch]<= 5)
    {     //크랙이나 오물란 신호가 없으면 :: 5이하이면 무시
        //crackCHKCNT[ch] = 0;
        //crack data reset;
        GRADE_DATA.gECrack[ch]=0;
        ACD_DATA_BUF[SYS_INFO.ACD_CHK_POS] &= ~(0x01<<ch);

        dotCHKCNT[ch] = 0;
        //Grading
        if(gradeWeight >= GRADE_INFO[g_ETC].hiLimit)
        {       //상등외
            grade_result = g_ETC;   GRADE_DATA.gNumber[g_ETC]++;    //등급 저장, 계란 수량 누적
            GRADE_DATA.gWeight[g_ETC] += gradeWeight;
            //인쇄
            if(GRADE_INFO[g_ETC].prttype!=PRT_TYPE_NO)
            {
                if(GRADE_INFO[g_ETC].prtOutCount<GRADE_INFO[g_ETC].prtSetCount || GRADE_INFO[g_ETC].prtSetCount==0) {
                    GRADE_INFO[g_ETC].prtOutCount++;
                    GRADE_DATA.pNumber[g_ETC]++;
                }
                else
                {
                    old_prttype[g_ETC] = GRADE_INFO[g_ETC].prttype;
                    GRADE_INFO[g_ETC].prttype = PRT_TYPE_NO;
                    GRADE_INFO[g_ETC].prtOutCount = 0;
                }
            }
        }
        else if((gradeWeight < GRADE_INFO[g_ETC].hiLimit)&&(gradeWeight >= GRADE_INFO[g_KING].loLimit))
        { //왕란
            grade_result = g_KING;
            GRADE_DATA.gNumber[g_KING]++;
            GRADE_DATA.gWeight[g_KING] += gradeWeight;
            //인쇄
            if(GRADE_INFO[g_KING].prttype!=PRT_TYPE_NO)
            {
                if(GRADE_INFO[g_KING].prtOutCount<GRADE_INFO[g_KING].prtSetCount || GRADE_INFO[g_KING].prtSetCount==0)
                {
                    GRADE_INFO[g_KING].prtOutCount++;
                    GRADE_DATA.pNumber[g_KING]++;
                }
                else
                {
                    old_prttype[g_KING] = GRADE_INFO[g_KING].prttype;
                    GRADE_INFO[g_KING].prttype = PRT_TYPE_NO;
                    GRADE_INFO[g_KING].prtOutCount = 0;
                }
            }
        }
        else if((gradeWeight < GRADE_INFO[g_KING].loLimit)&&(gradeWeight >= GRADE_INFO[g_SPECIAL].loLimit))
        { //특란::왕란 하한보다 작고, 특란 하한보다 크거나 같은 경우
            grade_result = g_SPECIAL;
            GRADE_DATA.gNumber[g_SPECIAL]++;
            GRADE_DATA.gWeight[g_SPECIAL] += gradeWeight;
            //인쇄
            if(GRADE_INFO[g_SPECIAL].prttype!=PRT_TYPE_NO)
            {
                if( GRADE_INFO[g_SPECIAL].prtOutCount<GRADE_INFO[g_SPECIAL].prtSetCount || GRADE_INFO[g_SPECIAL].prtSetCount==0)
                {
                    GRADE_INFO[g_SPECIAL].prtOutCount++;
                    GRADE_DATA.pNumber[g_SPECIAL]++;
                }
                else
                {
                    old_prttype[g_SPECIAL] = GRADE_INFO[g_SPECIAL].prttype;
                    GRADE_INFO[g_SPECIAL].prttype = PRT_TYPE_NO;
                    GRADE_INFO[g_SPECIAL].prtOutCount = 0;
                }
            }
        }
        else if((gradeWeight < GRADE_INFO[g_SPECIAL].loLimit)&&(gradeWeight >=GRADE_INFO[g_BIG].loLimit))
        { //대란::특란 하한보다 작고, 대란 하한보다 크거나 같은 경우
            grade_result = g_BIG;
            GRADE_DATA.gNumber[g_BIG]++;
            GRADE_DATA.gWeight[g_BIG] += gradeWeight;
            //인쇄
            if(GRADE_INFO[g_BIG].prttype!=PRT_TYPE_NO)
            {
                if(GRADE_INFO[g_BIG].prtOutCount<GRADE_INFO[g_BIG].prtSetCount || GRADE_INFO[g_BIG].prtSetCount==0)
                {
                    GRADE_INFO[g_BIG].prtOutCount++;
                    GRADE_DATA.pNumber[g_BIG]++;
                }
                else
                {
                    old_prttype[g_BIG] = GRADE_INFO[g_BIG].prttype;
                    GRADE_INFO[g_BIG].prttype = PRT_TYPE_NO;
                    GRADE_INFO[g_BIG].prtOutCount = 0;
                }
            }
        }
        else if((gradeWeight < GRADE_INFO[g_BIG].loLimit)&&(gradeWeight >= GRADE_INFO[g_MIDDLE].loLimit))
        { //중란::대란 하한보다 작고, 중란 하한보다 크거나 같은 경우
            grade_result = g_MIDDLE;
            GRADE_DATA.gNumber[g_MIDDLE]++;
            GRADE_DATA.gWeight[g_MIDDLE] += gradeWeight;
            //인쇄
            if(GRADE_INFO[g_MIDDLE].prttype!=PRT_TYPE_NO)
            {
                if(GRADE_INFO[g_MIDDLE].prtOutCount<GRADE_INFO[g_MIDDLE].prtSetCount || GRADE_INFO[g_MIDDLE].prtSetCount==0)
                {
                    GRADE_INFO[g_MIDDLE].prtOutCount++;
                    GRADE_DATA.pNumber[g_MIDDLE]++;
                }
                else{
                    old_prttype[g_MIDDLE] = GRADE_INFO[g_MIDDLE].prttype;
                    GRADE_INFO[g_MIDDLE].prttype = PRT_TYPE_NO;
                    GRADE_INFO[g_MIDDLE].prtOutCount = 0;
                }
            }
        }
        else if((gradeWeight < GRADE_INFO[g_MIDDLE].loLimit)&&(gradeWeight >= GRADE_INFO[g_SMALL].loLimit))
        { //소란 :: 중란 하한보다 작고, 소란 하한보다 크거나 같은 경우
            grade_result = g_SMALL;
            GRADE_DATA.gNumber[g_SMALL]++;
            GRADE_DATA.gWeight[g_SMALL] += gradeWeight;
            //인쇄
            if(GRADE_INFO[g_SMALL].prttype!=PRT_TYPE_NO)
            {
                if(GRADE_INFO[g_SMALL].prtOutCount<GRADE_INFO[g_SMALL].prtSetCount || GRADE_INFO[g_SMALL].prtSetCount==0)
                {
                    GRADE_INFO[g_SMALL].prtOutCount++;
                    GRADE_DATA.pNumber[g_SMALL]++;
                }
                else
                {
                    old_prttype[g_SMALL] = GRADE_INFO[g_SMALL].prttype;
                    GRADE_INFO[g_SMALL].prttype = PRT_TYPE_NO;
                    GRADE_INFO[g_SMALL].prtOutCount = 0;
                }
            }
        }
        else if((gradeWeight < GRADE_INFO[g_SMALL].loLimit)&&(gradeWeight >= GRADE_INFO[g_LIGHT].loLimit))
        { //경란 :: 소란 하한보다 작고, 경란 하한보다 크거나 같은 경우
            grade_result = g_LIGHT;
            GRADE_DATA.gNumber[g_LIGHT]++;
            GRADE_DATA.gWeight[g_LIGHT] += gradeWeight;
            //인쇄
            if(GRADE_INFO[g_LIGHT].prttype!=PRT_TYPE_NO)
            {
                if(GRADE_INFO[g_LIGHT].prtOutCount<GRADE_INFO[g_LIGHT].prtSetCount || GRADE_INFO[g_LIGHT].prtSetCount==0)
                {
                    GRADE_INFO[g_LIGHT].prtOutCount++;
                    GRADE_DATA.pNumber[g_LIGHT]++;
                }
                else
                {
                    old_prttype[g_LIGHT] = GRADE_INFO[g_LIGHT].prttype;
                    GRADE_INFO[g_LIGHT].prttype = PRT_TYPE_NO;
                    GRADE_INFO[g_LIGHT].prtOutCount = 0;
                }
            }
        }
        else if( (gradeWeight < GRADE_INFO[g_LIGHT].loLimit) && (gradeWeight >= 100))
        {       //하등외 :: 경란의 하한보다 작고, 10.0g보다 크거나 같은 경우
            grade_result = g_ETC;
            GRADE_DATA.gNumber[g_ETC]++;
            GRADE_DATA.gWeight[g_ETC] += gradeWeight;
            //인쇄
            if(GRADE_INFO[g_ETC].prttype!=PRT_TYPE_NO)
            {
                if(GRADE_INFO[g_ETC].prtOutCount<GRADE_INFO[g_ETC].prtSetCount || GRADE_INFO[g_ETC].prtSetCount==0)
                {
                    GRADE_INFO[g_ETC].prtOutCount++;
                    GRADE_DATA.pNumber[g_ETC]++;
                }
                else
                {
                    old_prttype[g_ETC] = GRADE_INFO[g_ETC].prttype;
                    GRADE_INFO[g_ETC].prttype = PRT_TYPE_NO;
                    GRADE_INFO[g_ETC].prtOutCount = 0;
                }
            }
        }
    }
    else
    {
        if(dotCHKCNT[ch]>5)
        {
            grade_result = g_DOT;
            GRADE_DATA.gNumber[g_DOT]++;
            GRADE_DATA.gWeight[g_DOT] += gradeWeight;
            //version 3.4.2
            //인쇄
            if(GRADE_INFO[g_DOT].prttype!=PRT_TYPE_NO)
            {
                if(GRADE_INFO[g_DOT].prtOutCount<GRADE_INFO[g_DOT].prtSetCount || GRADE_INFO[g_DOT].prtSetCount==0)
                {
                    GRADE_INFO[g_DOT].prtOutCount++;
                    GRADE_DATA.pNumber[g_DOT]++;
                }
                else
                {
                    old_prttype[g_DOT] = GRADE_INFO[g_DOT].prttype;
                    GRADE_INFO[g_DOT].prttype = PRT_TYPE_NO;
                    GRADE_INFO[g_DOT].prtOutCount = 0;
                }
            }

            dotCHKCNT[ch] = 0;
        }
        //ver3.4.1 = 저가형 acd적용을 위한 수정
        crackdata = (ACD_DATA_BUF[SYS_INFO.ACD_CHK_POS]>>ch) & 0x01;
        //if(crackCHKCNT[ch]>5){
        if(crackdata==0x01)
        {

            if(debugMode==3)
            {

                UDR1 =gradeWeight>>8;                           while(!(UCSR1A & 0x20));
                UDR1 =gradeWeight;                              while(!(UCSR1A & 0x20));
                UDR1 =ACD_DATA_BUF[SYS_INFO.ACD_CHK_POS];            while(!(UCSR1A & 0x20));
                UDR1 =0xFE;                                          while(!(UCSR1A & 0x20));
            }
            grade_result = g_CRACK;

            GRADE_DATA.gECrack[ch]=1;

            GRADE_DATA.gNumber[g_CRACK]++;
            GRADE_DATA.gWeight[g_CRACK] += gradeWeight;

            //version 3.4.2
            //인쇄
            if(GRADE_INFO[g_CRACK].prttype!=PRT_TYPE_NO)
            {
                if(GRADE_INFO[g_CRACK].prtOutCount<GRADE_INFO[g_CRACK].prtSetCount || GRADE_INFO[g_CRACK].prtSetCount==0)
                {
                    GRADE_INFO[g_CRACK].prtOutCount++;
                    GRADE_DATA.pNumber[g_CRACK]++;
                }
                else
                {
                    old_prttype[g_CRACK] = GRADE_INFO[g_CRACK].prttype;
                    GRADE_INFO[g_CRACK].prttype = PRT_TYPE_NO;
                    GRADE_INFO[g_CRACK].prtOutCount = 0;
                }
            }
            //version 3.4.1
            ACD_DATA_BUF[SYS_INFO.ACD_CHK_POS] &= ~(0x01<<ch);
            //crackCHKCNT[ch] = 0;
        }
    }
    ////Grading Value Bit Table
    // 0000 | 0000 | 0000 | 0000
    //--------------------------
    //   |      |     |       |-> Solenoid Position || Low Nibble
    //   |      |     |---------> Solenoid Position || High Nibble
    //   |      |---------------> Grade Position
    //   |----------------------> Crack/DOT Info, PRT TYPE || 00:CLean, 01:CRACK(0x8000), 02:DOT(0x4000), 00:NONE, 01:PRT A(0x1000), 02:PRT B(0x2000)

    if(grade_result != 0xFF)
    {
        GRADE_DATA.gTNumber++;
        GRADE_DATA.gTWeight += gradeWeight;

        set_bucket_data = 0;
        //#########################################
        //###  등외란-파란 팩커 공용 사용 설정  ###
        //###  2014.11.24 수정                  ###
        //### 등외란과 파란의 선별수량을 합하여 ###
        //### 파란 팩커의 솔 수량으로 나눠 사용 ###
        //#########################################

        //솔레노이드 위치 설정
        if(GRADE_DATA.gNumber[grade_result]<=0)
        {
            GRADE_DATA.gNumber[grade_result] = 0;
            set_bucket_data = ((GRADE_DATA.gNumber[grade_result]) % GRADE_INFO[grade_result].solenoidnumber);
        }
        else{
            //PackerSharedEnable이 9보다 작으면 특정 등급이하를 파란 팩커에 담음.
            if(PackerSharedEnable!=9)
            {
                if(grade_result<PackerSharedEnable)
                {
                    set_bucket_data = ((GRADE_DATA.gNumber[grade_result]-1) % GRADE_INFO[grade_result].solenoidnumber);
                }
                else
                {
                    eggcnt_sum = 0;
                    for(k=PackerSharedEnable;k<=8;k++)
                    {
                        eggcnt_sum +=  GRADE_DATA.gNumber[k];
                    }

                    if(PackerSharedEnable==8)
                    {
                        eggcnt_sum += GRADE_DATA.gNumber[g_CRACK];
                    }
                    set_bucket_data = (eggcnt_sum-1) % GRADE_INFO[g_CRACK].solenoidnumber;

                    if(debugMode==3)
                    {
                        UDR1 =grade_result;            while(!(UCSR1A & 0x20));
                        UDR1 =set_bucket_data>>8;            while(!(UCSR1A & 0x20));
                        UDR1 =set_bucket_data;            while(!(UCSR1A & 0x20));
                        UDR1 =0xDF;            while(!(UCSR1A & 0x20));
                    }
                }
            }
            else
            {
                set_bucket_data = ((GRADE_DATA.gNumber[grade_result]-1) % GRADE_INFO[grade_result].solenoidnumber);
                if(debugMode==3){
                            UDR1 =set_bucket_data;            while(!(UCSR1A & 0x20));
                            UDR1 =0xDC;            while(!(UCSR1A & 0x20));
                }
            }
        }


        //등급 설정-수정을 요함.
        //#########################################
        //###  등외란-파란 팩커 공용 사용 설정  ###
        //###  2014.11.24 수정                  ###
        //### 등외란과 파란의 선별수량을 합하여 ###
        //### 파란 팩커의 솔 수량으로 나눠 사용 ###
        //#########################################
         if(PackerSharedEnable!=9)
         {
            if(grade_result<PackerSharedEnable)
            {
                set_bucket_data |= (grade_result+1) <<  8;
            }
            else
            {
                set_bucket_data |= (g_CRACK+1) <<  8;
            }
         }
         else
         {
            set_bucket_data |= (grade_result+1) <<  8;
         }


        //인쇄설정
        //19.08.14 인쇄기 다중 모드 지원 작업
        //모드 0~모드7 까지 있으면
        //마킹 신호 출력 + 마킹 모드 신호 출력
        if(GRADE_INFO[grade_result].prttype>PRT_TYPE_NO)
        {
            set_bucket_data |=0x1000;
        }
        /*
        else if(GRADE_INFO[grade_result].prttype==PRT_TYPE_B){
            set_bucket_data |= 0x2000;
        }
        */
        BucketData[MAX_LDCELL-ch-1] = set_bucket_data;
        if(debugMode==3)
        {
            UDR1 =set_bucket_data>>8;            while(!(UCSR1A & 0x20));
            UDR1 =set_bucket_data;            while(!(UCSR1A & 0x20));
            UDR1 =0xDB;            while(!(UCSR1A & 0x20));
        }
    }
}

//선별된 데이터를 전송하기 위한 통신 버퍼 셋팅
void COMM_TX_SET(void)
{
    unsigned int datalen;

    GRADE_DATA.gSpeed = tmrSPEEDCNT;
    GRADE_DATA.gZCount  = phase_z_cnt;

    tmrSPEEDCNT = 0;
    datalen = sizeof(GRADE_DATA);
    TxBuffer[0] = 0x02;
    TxBuffer[1] = (datalen + 2)>>8;
    TxBuffer[2] = (datalen + 2)&0xFF;
    TxBuffer[3] = CMD_GRADEDATA;
    TxBuffer[4] = 0x00;
    memcpy(&(TxBuffer[5]), &GRADE_DATA, datalen);
    TxBuffer[5+datalen] = 0x03;
    TxEnable = 1;   txcnt = 1;  TxLength = datalen+6;   UDR1 = TxBuffer[0];
}

//솔레노이드 출력
void SolenoidRunning(void)
{
    unsigned char icnt, jcnt;
    unsigned char offtime;

    /*********************************************************************/
    /* New Method                                                        */
    /* pocketState = SET이면 솔레노이드 on 카운터 증가                   */
    /*                       솔레노이드 on시간이 지정된 시간이 되면 ON   */
    /*                       솔레노이드 온 이후 off카운터 시작 플래그 ON */
    /* off카운터 플래그 on이면 off카운터 시작                            */
    /*                         off카운터가 지정된 유지 시간이면 솔 off   */
    /*********************************************************************/

    for(icnt=0;icnt<MAX_PACKER;icnt++)
    {
        for(jcnt=0;jcnt<MAX_SOLENOID;jcnt++)
        {
        //for(jcnt=0;jcnt<PACKER_INFO[icnt].solcount;jcnt++){
            if(pocketSTATE[icnt][jcnt]==SET)
            {
                sol_outcnt[icnt][jcnt]++;
                if(SpeedAdjEnable==1)
                {
                    if(sol_outcnt[icnt][jcnt]>=(SOL_INFO[icnt].ontime[jcnt]+Sol_Correction_Count))
                    {
                    //if(sol_outcnt[icnt][jcnt]>=(SOL_INFO[icnt].ontime[jcnt])){
                        if(debugMode==1)
                        {
                            UDR1 =Sol_Correction_Count;            while(!(UCSR1A & 0x20));
                            UDR1 =0xEE;            while(!(UCSR1A & 0x20));
                        }
                        sol_outcnt[icnt][jcnt] = 0;
                        sol_offcnt_on[icnt][jcnt] = 1;
                        pocketSTATE[icnt][jcnt] = CLEAR;

                        //팩커기동신호
                        //if(jcnt==GRADE_INFO[icnt].solenoidnumber-1){
                        if(jcnt==PACKER_INFO[icnt].solcount-1)
                        {
                            HolderState[icnt] = HolderRDY;
                        }
                        do_value[icnt] |= SOL_INFO[icnt].outsignal[jcnt];
                    }
                }
                else if(SpeedAdjEnable==0)
                {
                    //if(sol_outcnt[icnt][jcnt]>=(SOL_INFO[icnt].ontime[jcnt]+Sol_Correction_Count)){

                    if(sol_outcnt[icnt][jcnt]>=(SOL_INFO[icnt].ontime[jcnt]))
                    {
                        sol_outcnt[icnt][jcnt] = 0;
                        sol_offcnt_on[icnt][jcnt] = 1;
                        pocketSTATE[icnt][jcnt] = CLEAR;
                        if(debugMode==1)
                        {
                            //UDR1 =Sol_Correction_Count;            while(!(UCSR1A & 0x20));
                            //UDR1 =0xDD;                            while(!(UCSR1A & 0x20));
                        }
                        //팩커기동신호
                        //if(jcnt==GRADE_INFO[icnt].solenoidnumber-1){
                        if(jcnt==PACKER_INFO[icnt].solcount-1)
                        {
                            HolderState[icnt] = HolderRDY;
                        }
                        do_value[icnt] |= SOL_INFO[icnt].outsignal[jcnt];
                    }
                }
            }

            if(sol_offcnt_on[icnt][jcnt])
            {
                sol_offcnt[icnt][jcnt]++;

                if(sol_offcnt[icnt][jcnt]>=(SOL_INFO[icnt].offtime[jcnt]))
                {
                    do_value[icnt] &= ~SOL_INFO[icnt].outsignal[jcnt];
                    sol_offcnt[icnt][jcnt] = 0;
                    sol_offcnt_on[icnt][jcnt]=0;

                    //홀더 기동신호 출력ON
                    if(jcnt==(PACKER_INFO[icnt].solcount-1))
                    {
                        if(HolderState[icnt] == HolderRDY)
                        {
                            HolderOnTime[icnt] = 0;
                            HolderState[icnt] = HolderON;
                            do_value[icnt] |= HOLDER_ON_SNG;
                        }
                    }
                }
            }
        }

        //홀더 기동신호 일정시간후 off
        if(HolderState[icnt]==HolderON)
        {
            HolderOnTime[icnt]++;
            if(HolderOnTime[icnt] > 10)
            {
                do_value[icnt] &= ~HOLDER_ON_SNG;
                HolderState[icnt] = HolderOFF;
            }
        }
    }

    //인쇄기 A타입 출력 셋팅
    if(PRT_A_OUT==SET)
    {
        prt_a_outcnt++;
        if(prt_a_outcnt>=PRT_INFO[1].ontime)
        {
            prt_a_outcnt = 0;
            PRT_A_OUT=CLEAR;
            prt_a_off_enable =1;
            plc_prt_value |= PRT_A_ON;
            //2019.08.13 update
            //마킹모드 추가 출력
            plc_prt_value |= Marking_MOUT;
        }
    }

    if(prt_a_off_enable==1)
    {
        prt_a_offcnt++;
        if(prt_a_offcnt>=PRT_INFO[1].offtime)
        {
            prt_a_offcnt = 0;
            plc_prt_value &= ~PRT_A_ON;
            plc_prt_value &= ~Marking_MOUT;
            prt_a_off_enable = 0;
        }
    }

    /* ---- ver3.4.5에서 삭제
    //인쇄기 B타입 출력 셋팅
    if(PRT_B_OUT==SET){
        prt_b_outcnt++;
        if(prt_b_outcnt>=PRT_INFO[2].ontime){
            prt_b_outcnt = 0;
            PRT_B_OUT=CLEAR;
            prt_b_off_enable =1;
            plc_prt_value |= PRT_B_ON;
        }
    }

    if(prt_b_off_enable==1){
        prt_b_offcnt++;
        if(prt_b_offcnt>=PRT_INFO[2].offtime){
            prt_b_offcnt = 0;
            plc_prt_value &= ~PRT_B_ON;
            prt_b_off_enable = 0;
        }
    }
    */
    SOL_CH1 = do_value[0];
    SOL_CH2 = do_value[1];
    SOL_CH3 = do_value[2];
    SOL_CH4 = do_value[3];
    SOL_CH5 = do_value[4];
    SOL_CH6 = do_value[5];
    SOL_CH7 = do_value[6];
    PLC_CON = plc_prt_value;
}

//가상 버켓 이동
void MovingBucket(void)
{
    int lcnt;

    for(lcnt=MAX_BUCKET;lcnt>=0;lcnt--)
    {
        if(lcnt != 0 )
        {
            BucketData[lcnt] = BucketData[lcnt-1];
        }
        else
        {
        BucketData[lcnt] = BucketInitValue;
        }
    }
}

//출력할 솔레노이드 위치 설정
void MaskingBucket(void)
{

    unsigned char icnt;
    unsigned int prtchk;
    unsigned char tmpgrade;

    //2014.11.24수정 :: 모든 등급을 인쇄함.
    //PRT Type A Setting
    //2019.08.13 수정 :: 인쇄 모드를 8가지로 구분함.
    //마킹기 신호 체계 == 마킹 신호 + 마킹 모드 선택 신호
    //-----------------------------------------------------
    // Grading Value Bit Table
    // 0000 | 0000 | 0000 | 0000
    //--------------------------
    //   |      |     |       |-> Solenoid Position || Low Nibble
    //   |      |     |---------> Solenoid Position || High Nibble
    //   |      |---------------> Grade Position
    //   |----------------------> Crack/DOT Info, PRT TYPE || 00:CLean, 01:CRACK(0x8000), 02:DOT(0x4000), 00:NONE, 01:PRT A(0x1000), 02:PRT B(0x2000)
    prtchk = (BucketData[ PRT_INFO[PRT_TYPE_A].startpocketnumber ]>>12)&0x0003;
    tmpgrade = (BucketData[ PRT_INFO[PRT_TYPE_A].startpocketnumber ] >> 8) & 0x000F;
    if(prtchk == 0x0001)
    {
       PRT_A_OUT = SET;
       Marking_MOUT = Marking_MOUT_SNG[GRADE_INFO[tmpgrade].prttype-1];
       BucketData[ PRT_INFO[PRT_TYPE_A].startpocketnumber ] &= 0x0FFF;
    }

    //PRT Type B Setting
    /*
    prtchk = (BucketData[ PRT_INFO[PRT_TYPE_B].startpocketnumber ]>>12)&0x0003;
    if(prtchk == 0x0002){   PRT_B_OUT = SET;    BucketData[ PRT_INFO[PRT_TYPE_B].startpocketnumber ] &= 0x0FFF;  }
    */

    //각 스테이션마다 솔레노이드 ID와 비교, 값이 같으면 출력 셋
    for(icnt = 0; icnt <MAX_PACKER;icnt++)
    {
        if((BucketData[ PACKER_INFO[icnt].startpocketnumber-5 ] & 0x0FFF) == SOL_INFO[icnt].sol_id[5] )
        {
            pocketSTATE[icnt][5] = SET;
            BucketData[PACKER_INFO[icnt].startpocketnumber-5 ] = BucketInitValue;
        }

        if((BucketData[ PACKER_INFO[icnt].startpocketnumber-4 ] & 0x0FFF) == SOL_INFO[icnt].sol_id[4] )
        {
            pocketSTATE[icnt][4] = SET;
            BucketData[ PACKER_INFO[icnt].startpocketnumber-4 ] = BucketInitValue;
        }

        if((BucketData[ PACKER_INFO[icnt].startpocketnumber-3 ] & 0x0FFF) == SOL_INFO[icnt].sol_id[3] )
        {
            pocketSTATE[icnt][3] = SET;
            BucketData[ PACKER_INFO[icnt].startpocketnumber-3 ] = BucketInitValue;
        }

        if((BucketData[ PACKER_INFO[icnt].startpocketnumber-2 ] & 0x0FFF) == SOL_INFO[icnt].sol_id[2] )
        {
            pocketSTATE[icnt][2] = SET;
            BucketData[ PACKER_INFO[icnt].startpocketnumber-2 ] = BucketInitValue;
        }

        if((BucketData[ PACKER_INFO[icnt].startpocketnumber-1 ] & 0x0FFF) == SOL_INFO[icnt].sol_id[1] )
        {
            pocketSTATE[icnt][1] = SET;
            BucketData[ PACKER_INFO[icnt].startpocketnumber-1 ] = BucketInitValue;
        }

        if((BucketData[ PACKER_INFO[icnt].startpocketnumber-0 ] & 0x0FFF) == SOL_INFO[icnt].sol_id[0] )
        {
            pocketSTATE[icnt][0] = SET;
            BucketData[ PACKER_INFO[icnt].startpocketnumber-0 ] = BucketInitValue;
        }

    }
}

void LoadParameter(void)
{
    unsigned char icnt;

    //unsigned int  sol_id[MAX_SOLENOID] = {0x0000,0x0001,0x0002,0x0003,0x0004,0x0005};
    //unsigned int  sol_packer[MAX_PACKER] = {0x0400,0x0100,0x0600,0x0200,0x0500,0x0300,0x0700};
    //unsigned int  sol_ontime[MAX_SOLENOID] = {24,32,38,44,50,56};
    //unsigned int  sol_offtime[MAX_SOLENOID] = {10,16,22,28,34,40};
    //unsigned int  sol_ontime[MAX_SOLENOID] = {7,11,15,19,23,27};
    //unsigned int  sol_offtime[MAX_SOLENOID] = {50,50,50,50,50,50};
    //unsigned int  startpocketnumber[MAX_PACKER] = {19,29,47,56,69,78,95,104};
    unsigned int  iconstvalue[MAX_LDCELL]={294,294,294,294,294,294};
    //unsigned int grade_hilimit[MAX_GRADE]={850,679,599,519,479,419,0,0,851};
    //unsigned int grade_lolimit[MAX_GRADE]={680,600,520,480,420,320,0,0,321};

    GET_USR_INFO_DATA(GRADE_INFO_DATA);
    GET_USR_INFO_DATA(SOL_INFO_DATA);
    GET_USR_INFO_DATA(PACKER_INFO_DATA);
    GET_USR_INFO_DATA(LDCELL_INFO_DATA);
    GET_USR_INFO_DATA(MEASURE_INFO_DATA);
    GET_USR_INFO_DATA(PRT_INFO_DATA);
    GET_USR_INFO_DATA(SYS_INFO_DATA);


    for(icnt=0;icnt<MAX_LDCELL;icnt++)
    {
        if(LDCELL_INFO[icnt].span==0 || LDCELL_INFO[icnt].span==0xFF)
        {
            ConstWeight[icnt] = iconstvalue[icnt];
            LDCELL_INFO[icnt].span = ConstWeight[icnt];
        }
        else
        {
            ConstWeight[icnt] = LDCELL_INFO[icnt].span;
        }
        //로딩 초기 영점값을 강제 설정해줌.
        //영점을 후단에서 측정함에 따라 최초 실행시 0으로 설정되어 -31g이 1회 잡힘.
        //zero_value[icnt]=1400;
    }

    if(SYS_INFO.z_encoder_interval!=360 || SYS_INFO.z_encoder_interval!=600)
    {
        SYS_INFO.bucket_ref_pulse_cnt = 60;
        SYS_INFO.z_encoder_min_interval= 60;
        SYS_INFO.z_encoder_interval = 360;
    }

    //왕란 등급 상한값이 55g이하로 설정되어있으면 등외 상한값보다 0.1g작게 설정되도록 함.
    if(GRADE_INFO[0].hiLimit<550)
    {
        GRADE_INFO[0].hiLimit = GRADE_INFO[g_ETC].hiLimit -1;
    }


}

void SaveParameter(void)
{
    //초기값 메모리 저장
    PUT_USR_INFO_DATA(GRADE_INFO_DATA);
    PUT_USR_INFO_DATA(SOL_INFO_DATA);
    PUT_USR_INFO_DATA(PACKER_INFO_DATA);
    PUT_USR_INFO_DATA(LDCELL_INFO_DATA);
    PUT_USR_INFO_DATA(MEASURE_INFO_DATA);
    PUT_USR_INFO_DATA(PRT_INFO_DATA);
    PUT_USR_INFO_DATA(SYS_INFO_DATA);
}

void ETC_PARAMETER_SETTING(void){
    //ETC Parameter Initialize
    weight_ad_end_pulse = MEASURE_INFO.ad_start_pulse  + MEASURE_INFO.duringcount;
    weight_cal_end_pulse = weight_ad_end_pulse + MAX_LDCELL;

    zero_ad_end_pulse = MEASURE_INFO.zeroposition + ZeroMeasurePulse;
    zero_cal_end_pulse = zero_ad_end_pulse + MAX_LDCELL;

    correct_data_end_pulse = weight_cal_end_pulse + MAX_LDCELL;

    ConvertPosition = correct_data_end_pulse + 2;                                 //재정의 필요
    convert_end_pulse = ConvertPosition + MAX_LDCELL;
    GradingPosition =  340;                                     //Fixed Value-최소한 330펄스이후에 분류작업
    grading_end_pulse = GradingPosition+MAX_LDCELL;

    crackchk_end_pulse = MEASURE_INFO.crackchecktime + 30;

    //2014.03.10 :: 수정사항
    //보정단계를 보정값과 동일하게 :: 50보정이면 50단계
    //보정시간 단위 : 50보정이면
    unit_correct = SYS_INFO.correction / SYS_INFO.correction;
    unit_rising = (SYS_INFO.risingTime / SYS_INFO.correction)/timer_period;
    unit_falling = (SYS_INFO.fallingTime / SYS_INFO.correction)/timer_period;

    //감속보정 지연
    DelayTimeCount = SYS_INFO.DeAccelDelayTime / 5;
    deAccelStartCount = SYS_INFO.DeAccelDelayCount;

    //파란 측정 시간이 0이면 파란, 오란 측정안함.
    if(MEASURE_INFO.crackchecktime == 0)
    {
        Crack_Dot_Chk_Enable = 0;
    }
}

void Initialize_SYSTEM(void)
{
    unsigned char icnt, rtn, id_value, direction_chk, jcnt;
    unsigned int lcnt;

    //Load Parameter

    //Bucket Clear
    for(lcnt = 0;lcnt<MAX_BUCKET;lcnt++)
    {
        BucketData[lcnt] = BucketInitValue;
    }

    //Flash memory check
    SPI_Init();
    rtn = GetDeviceID();        //Memory Device ID Check
    if(rtn)
    {    //Device ID Check OK :: Load Data
        LoadParameter();
        //Initailize_PARAMETER();
        //SaveParameter();

        if(SYS_INFO.chkCODE!=MEM_CHK_CODE)
        {
            Initailize_PARAMETER();
        }
    }
    else
    {       //Device ID Check Fail :: 공장 초기값으로 데이터 로드
        Initailize_PARAMETER();
    }

    //측정점, 영점, 분류위치등 타이밍 셋팅
    ETC_PARAMETER_SETTING();

    //Controller ID Setting
    //ID Value 0 then CONTROLLER #1 and REMOTE CONTROLL
    //ID Value 1 then CONTROLLER #2 and REMOTE CONTROLL
    //ID Value 2 then CONTROLLER #1 and AUTO RUN
    //ID Value 3 then CONTROLLER #2 and AUTO RUN
    id_value = (~MACHINE_ID1 <<1) | ~MACHINE_ID0;

    if(id_value == 0 || id_value == 2)
    {
        CONTROLLER_ID =  0x01;
    }
    else
    {
        CONTROLLER_ID =  0x02;
    }

    if(id_value == 2 || id_value ==3)
    {
        ControllerRunMethod = AUTO_RUN_MODE;
    }
    else
    {
        ControllerRunMethod = MANUAL_RUN_MODE;
    }

    //#######################################################
    //### 2014.11.28 :: 파란팩커에 특정 등급을 같이 받기  ###
    //#######################################################
    PackerSharedEnable = PACKER_INFO[8].gradetype;

    //#######################################################

    //엔코더 방향 설정 :: 선별기 좌방향인 경우(상지농장) 정회전시 B상이 Low
    //                    선별기 우방향인 경우(공장, 알찬농장) 정회전시 B상이 High
    //파란기 입력 단자의 최상위 비트(D7)이 '1' 이면 우방향 (D7 단자 GND접속) ==>B상을 High체크
    //파란기 입력 단자의 최상위 비트(D7)이 '0' 이면 좌방향 (D7 단자 V24접속) ==>B상을 Low체크
    direction_chk = EDI_CH0 & 0x80;
    if(direction_chk == 0x00)
    {
        CW_DIR = 0;
    }
    else if(direction_chk==0x80)
    {
        CW_DIR = 1;
    }



    //로드셀 기준 영점값 취득
    for(jcnt=0;jcnt<MAX_LDCELL;jcnt++)
    {
        reformTotal = 0;    reformVoltage = 0;  adcnt = 0;
        for(icnt = 0;icnt<240;icnt++)
        {
            if(icnt>=avr_loop_cnt)
            {
                reformTotal -= reform_ADC[adcnt];
            }
            reform_ADC[adcnt] = RD_ADC(jcnt);
            reformTotal += (long)reform_ADC[adcnt++];
            adcnt %= avr_loop_cnt;
            ref_zero_value[jcnt]=(reformTotal / avr_loop_cnt)*763/10000;
        }
        zero_value[jcnt] = ref_zero_value[jcnt];
        old_Zero[jcnt] = zero_value[jcnt];

    }


    //초기화 완료 부저
    led_buz_value |= BUZZER_ON;     LED_BUZ = led_buz_value;     delay_ms(150);
    led_buz_value &= ~BUZZER_ON;    LED_BUZ = led_buz_value;     delay_ms(80);
    for(icnt=0;icnt<1;icnt++)
    {
        led_buz_value |= BUZZER_ON;     LED_BUZ = led_buz_value;     delay_ms(50);
        led_buz_value &= ~BUZZER_ON;    LED_BUZ = led_buz_value;     delay_ms(80);
    }

    //초기 파워 SYSTEM 동작 LED 온
    led_buz_value |= LED_INIT_OK;
    LED_BUZ = led_buz_value;

    //초기 PLC OFF 신호 출력
    plc_prt_value |= EVENT_STOP;
    PLC_CON = plc_prt_value;

    #asm("sei");
}

void BuzzerOn(void)
{
    led_buz_value |= BUZZER_ON;
    LED_BUZ = led_buz_value;
    TimerMode = tmrBUZ;
    TCNT1H=0x00;        TCNT1L=0x00;
    OCR1AH=0x0C;        OCR1AL=0x35;
    TCCR1B = 0x05;
}

void Reform_Weight(void)
{
    unsigned char done=1;
    unsigned int icnt, jcnt, kcnt;
    unsigned int readvalue;
    long avrtotal;

    TxBuffer[0] = 0x02;
    TxBuffer[1] = 0x00;
    TxBuffer[2] = 0x02;
    TxBuffer[3] = CMD_REFORM_WEIGHT;
    TxBuffer[4] = 0x01;
    TxBuffer[5] = 0x03;
    TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];
    COM_REV_ENABLE = 0;


    for(jcnt=0;jcnt<MAX_LDCELL;jcnt++)
    {
        reformTotal = 0;    reformVoltage = 0;  adcnt = 0;
        for(icnt = 0;icnt<240;icnt++)
        {
            /*if(icnt>=avr_loop_cnt){
                reformTotal -= reform_ADC[adcnt];
            }
            reform_ADC[adcnt] = RD_ADC(jcnt);
            reformTotal += (long)reform_ADC[adcnt++];
            adcnt %= avr_loop_cnt;
            zero_value[jcnt]=(reformTotal / avr_loop_cnt)*763/10000;
            */

            readvalue = RD_ADC(jcnt);

            if(icnt ==0)
            {                                       //평균 초기값을 최초값으로 설정
                for(kcnt = 0 ;kcnt<avr_loop_cnt;kcnt++)
                {
                    reform_ADC[kcnt] = readvalue;
                    reformTotal += (long)readvalue;
                }
            }

            avrtotal = reformTotal + (long)readvalue;                     //평균합계(reformTotal)와 현재값을 합산
            reformTotal -= (long)reform_ADC[adcnt];                       //평균합계에서 직전 평균값을 뺀다.
            reform_ADC[adcnt] = (unsigned int)(avrtotal / (avr_loop_cnt+1));        //

            zero_value[jcnt] = ((long)reform_ADC[adcnt] * 763) / 10000;
            reformTotal += reform_ADC[adcnt++];

            adcnt %= avr_loop_cnt;
        }
    }

    BuzzerOn();
    delay_ms(200);

    while(done)
    {
        if(COM_REV_ENABLE)
        {
            switch(RxBuffer[0])
            {
                case CMD_REFORM_START :
                    TCCR1B = 0x00;
                    TxBuffer[0] = 0x02;
                    TxBuffer[1] = 0x00;
                    TxBuffer[2] = 0x02;
                    TxBuffer[3] = CMD_REFORM_START;
                    TxBuffer[4] = 0x01;
                    TxBuffer[5] = 0x03;
                    TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];

                    while(TxEnable)
                    {
                    }

                    BuzzerOn();
                    delay_ms(200);

                    led_buz_value |= LED_RUN_STOP;
                    LED_BUZ = led_buz_value;
                    TCCR1B = 0x00;

                    reformTotal=0; adcnt=0;
                    reformCH = RxBuffer[1];

                    for(kcnt = 0 ;kcnt<avr_loop_cnt;kcnt++)
                    {
                        reform_ADC[kcnt] = zero_value[reformCH];
                        reformTotal += (long)reform_ADC[kcnt];
                    }


                    /*for(icnt=0;icnt<24;icnt++){
                        reform_ADC[icnt] = 0;
                    }
                    reformCH = RxBuffer[1];
                    */
                    TimerMode =  tmrADC;
                    TCNT1H = 0x00;      TCNT1L = 0x00;
                    OCR1AH=0x01;        OCR1AL=0x38;        //20msec /1024 prescaler
                    TCCR1B = 0x05;
                    break;

                case CMD_REFORM_STOP :
                    TCNT1H = 0x00;      TCNT1L = 0x00;
                    TCCR1B = 0x00;

                    BuzzerOn();
                    led_buz_value &= ~LED_RUN_STOP;
                    LED_BUZ = led_buz_value;
                    delay_ms(100);
                    TxBuffer[0] = 0x02;
                    TxBuffer[1] = 0x00;
                    TxBuffer[2] = 0x02;
                    TxBuffer[3] = CMD_REFORM_STOP;
                    TxBuffer[4] = 0x01;
                    TxBuffer[5] = 0x03;
                    TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];
                    break;

                case CMD_REFORM_SET : //0xF2
                //case CMD_LDCELLINFO : //0x80
                    TCCR1B = 0x00;

                    switch(RxBuffer[1])
                    {
                        case 0x01 :     //SAVE DATA
                            //LDCELL_INFO[RxBuffer[2]].span = (RxBuffer[3] * 256) + RxBuffer[4];
                            ConstWeight[reformCH] = (RxBuffer[3] * 256) + RxBuffer[4];
                            LDCELL_INFO[reformCH].span = ConstWeight[reformCH];
                            PUT_USR_INFO_DATA(LDCELL_INFO_DATA);
                            break;

                        case 0x02 :     //INIT DATA
                            //LDCELL_INFO[RxBuffer[2]].span = 1000;
                            //ConstWeight[reformCH] = 286;
                            ConstWeight[reformCH] = 1000;
                            LDCELL_INFO[reformCH].span = ConstWeight[reformCH];
                            PUT_USR_INFO_DATA(LDCELL_INFO_DATA);
                            break;
                    }

                    BuzzerOn();
                    delay_ms(200);

                    TimerMode =  tmrADC;
                    TCNT1H = 0x00;      TCNT1L = 0x00;
                    OCR1AH=0x00;        OCR1AL=0x1F;        //2msec /1024 prescaler
                    TCCR1B = 0x05;
                    break;

                case CMD_REFORM_DATA :
                    TxBuffer[0] = 0x02;     TxBuffer[1] = 0x00;     TxBuffer[2]= 11;      TxBuffer[3] = CMD_REFORM_DATA;     TxBuffer[4] = reformCH;
                    TxBuffer[5] = reformSigned;
                    TxBuffer[6] = reformVoltage >> 8;       TxBuffer[7] = reformVoltage;
                    TxBuffer[8] = reformWeight >> 8;                TxBuffer[9] = reformWeight;
                    TxBuffer[10] = zero_value[reformCH] >> 8;        TxBuffer[11] = zero_value[reformCH];
                    TxBuffer[12] = ConstWeight[reformCH] >> 8;        TxBuffer[13] = ConstWeight[reformCH];
                    TxBuffer[14] = 0x03;

                    TxEnable = 1;   TxLength = 15;   txcnt = 1;      UDR1 = TxBuffer[0];
                    break;

                case CMD_REFORM_ZERO :
                    zero_value[RxBuffer[1]] = reformVoltage;
                    ref_zero_value[RxBuffer[1]] = zero_value[RxBuffer[1]];
                    BuzzerOn();

                    delay_ms(200);

                    TimerMode =  tmrADC;
                    TCNT1H = 0x00;      TCNT1L = 0x00;
                    OCR1AH=0x00;        OCR1AL=0x1F;        //2msec /1024 prescaler
                    TCCR1B = 0x05;
                    break;

                case CMD_REFORM_EXIT :
                    TxBuffer[0] = 0x02;
                    TxBuffer[1] = 0x00;
                    TxBuffer[2] = 0x02;
                    TxBuffer[3] = CMD_REFORM_EXIT;
                    TxBuffer[4] = 0x01;
                    TxBuffer[5] = 0x03;
                    TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];
                    TCCR1B = 0x00;
                    TimerMode = tmrNONE;

                    BuzzerOn();
                    delay_ms(200);

                    done = 0;
                    break;
            }
            COM_REV_ENABLE = 0;
        }
    }

    BuzzerOn();
}

void ExtPort_TEST(unsigned char port, unsigned char pindata, unsigned char outtype, unsigned char packerpos)
{
    unsigned char outdata, lcnt;

    if(port == 0xFF)
    {
        if(pindata == 0x0a)
        {
            //솔레노이드 작동
            for(lcnt=0;lcnt<6;lcnt++)
            {
                outdata = 0x01 << lcnt;
                do_value[packerpos] |= outdata;
                switch(packerpos){
                    case 0: SOL_CH1 = do_value[0];  break;
                    case 1: SOL_CH2 = do_value[1];  break;
                    case 2: SOL_CH3 = do_value[2];  break;
                    case 3: SOL_CH4 = do_value[3];  break;
                    case 4: SOL_CH5 = do_value[4];  break;
                    case 5: SOL_CH6 = do_value[5];  break;
                    case 6: SOL_CH7 = do_value[6];  break;
                }
                led_buz_value |= BUZZER_ON;
                LED_BUZ = led_buz_value;
                delay_ms(100);

                do_value[packerpos] &= ~outdata;
                switch(packerpos)
                {
                    case 0: SOL_CH1 = do_value[0];  break;
                    case 1: SOL_CH2 = do_value[1];  break;
                    case 2: SOL_CH3 = do_value[2];  break;
                    case 3: SOL_CH4 = do_value[3];  break;
                    case 4: SOL_CH5 = do_value[4];  break;
                    case 5: SOL_CH6 = do_value[5];  break;
                    case 6: SOL_CH7 = do_value[6];  break;
                }
                led_buz_value &= ~BUZZER_ON;
                LED_BUZ = led_buz_value;
                delay_ms(100);
            }
            //팩커 기동
            outdata = 0x80;
            do_value[packerpos] |= outdata;
            switch(packerpos)
            {
                case 0: SOL_CH1 = do_value[0];  break;
                case 1: SOL_CH2 = do_value[1];  break;
                case 2: SOL_CH3 = do_value[2];  break;
                case 3: SOL_CH4 = do_value[3];  break;
                case 4: SOL_CH5 = do_value[4];  break;
                case 5: SOL_CH6 = do_value[5];  break;
                case 6: SOL_CH7 = do_value[6];  break;
            }
            delay_ms(100);

            do_value[packerpos] &= ~outdata;
            switch(packerpos)
            {
                case 0: SOL_CH1 = do_value[0];  break;
                case 1: SOL_CH2 = do_value[1];  break;
                case 2: SOL_CH3 = do_value[2];  break;
                case 3: SOL_CH4 = do_value[3];  break;
                case 4: SOL_CH5 = do_value[4];  break;
                case 5: SOL_CH6 = do_value[5];  break;
                case 6: SOL_CH7 = do_value[6];  break;
            }
            delay_ms(100);
        }
        else
        {
            outdata = (0x01<<pindata);

            if(outtype ==1)
            {
                do_value[packerpos] |= outdata;
            }
            else if(outtype==0)
            {
                do_value[packerpos] &= ~outdata;
            }

            switch(packerpos)
            {
                case 0 :
                    SOL_CH1 = do_value[0];
                    break;
                case 1 :
                    SOL_CH2 = do_value[1];
                    break;
                case 2 :
                    SOL_CH3 = do_value[2];
                    break;
                case 3 :
                    SOL_CH4 = do_value[3];
                    break;
                case 4 :
                    SOL_CH5 = do_value[4];
                    break;
                case 5 :
                    SOL_CH6 = do_value[5];
                    break;
                case 6 :
                    SOL_CH7 = do_value[6];
                    break;
            }
        }
    }
    else if(port==0x03)
    {
        if(outtype==1)
        {
            plc_prt_value |= Mark_M1;
            PLC_CON = plc_prt_value;
        }
        else if(outtype==0)
        {
            plc_prt_value &= ~Mark_M1;
            PLC_CON = plc_prt_value;
        }
    }
    else if(port==0x04)
    {
        if(outtype==1)
        {
            plc_prt_value |= Mark_M2;
            PLC_CON = plc_prt_value;
        }
        else if(outtype==0){
            plc_prt_value &= ~Mark_M2;
            PLC_CON = plc_prt_value;
        }
    }
    else if(port==0x05)
    {
        if(outtype==1)
        {
            plc_prt_value |= Mark_M3;
            PLC_CON = plc_prt_value;
        }
        else if(outtype==0){
            plc_prt_value &= ~Mark_M3;
            PLC_CON = plc_prt_value;
        }
    }

    else if(port==0x06)
    {
        if(outtype==1)
        {
            plc_prt_value |= Mark_M4;
            PLC_CON = plc_prt_value;
        }
        else if(outtype==0){
            plc_prt_value &= ~Mark_M4;
            PLC_CON = plc_prt_value;
        }
    }

    else if(port==0x07)
    {
        if(outtype==1)
        {
            plc_prt_value |= Mark_M5;
            PLC_CON = plc_prt_value;
        }
        else if(outtype==0){
            plc_prt_value &= ~Mark_M5;
            PLC_CON = plc_prt_value;
        }
    }
        else if(port==0x08)
    {
        if(outtype==1)
        {
            plc_prt_value |= Mark_M6;
            PLC_CON = plc_prt_value;
        }
        else if(outtype==0){
            plc_prt_value &= ~Mark_M6;
            PLC_CON = plc_prt_value;
        }
    }
        else if(port==0x09)
    {
        if(outtype==1)
        {
            plc_prt_value |= Mark_M7;
            PLC_CON = plc_prt_value;
        }
        else if(outtype==0){
            plc_prt_value &= ~Mark_M7;
            PLC_CON = plc_prt_value;
        }
    }

}

void MACHINE_DATA_CLEAR(void)
{
    unsigned int icnt;

    for(icnt=0;icnt<MAX_BUCKET;icnt++)
    {
        BucketData[icnt] = BucketInitValue;
    }

    for(icnt=0;icnt<MAX_PACKER;icnt++)
    {
        GRADE_DATA.gNumber[icnt] = 0;
        GRADE_DATA.gWeight[icnt] = 0;
        GRADE_DATA.pNumber[icnt] = 0;

        GRADE_INFO[icnt].prtOutCount=0;
    }
    GRADE_DATA.gTNumber = 0;
    GRADE_DATA.gTWeight = 0;
    GRADE_DATA.gSpeed = 0;
    GRADE_DATA.gZCount = 0;
    phase_z_cnt = 0;

    tmrSPEEDCNT = 0;
}

void LED_START(void)
{
    unsigned int jcnt = 0;

    for(jcnt=0;jcnt<10;jcnt++)
    {
        if((jcnt%2)==0)
        {
            LED_BUZ = 0x40;          delay_ms(50);
            LED_BUZ = 0x01;          delay_ms(50);
            LED_BUZ = 0x20;          delay_ms(50);
            LED_BUZ = 0x02;          delay_ms(50);
            LED_BUZ = 0x10;          delay_ms(50);
            LED_BUZ = 0x04;          delay_ms(50);
            LED_BUZ = 0x08;          delay_ms(50);

        }
        else{
            LED_BUZ = 0x08;          delay_ms(50);
            LED_BUZ = 0x04;          delay_ms(50);
            LED_BUZ = 0x10;          delay_ms(50);
            LED_BUZ = 0x02;          delay_ms(50);
            LED_BUZ = 0x20;          delay_ms(50);
            LED_BUZ = 0x01;          delay_ms(50);
            LED_BUZ = 0x40;          delay_ms(50);
        }
    }
 }

   unsigned char hi_cmd, lo_cmd, done = 1;
    unsigned int dbufstart, lcnt, jcnt, oddbuf, evenbuf, bufpos=0;



    //로드셀 앰프 전원인가후 대기시간
    Initialize_REG();
    Initialize_GPIO();

    //Solenoid Port Initialize
    SOL_CH1 = 0;
    SOL_CH2 = 0;
    SOL_CH3 = 0;
    SOL_CH4 = 0;
    SOL_CH5 = 0;
    SOL_CH6 = 0;
    SOL_CH7 = 0;
    PLC_CON = 0;
    LED_BUZ = 0;
    //led_buz_value &= ~BUZZER_ON;
    //LED_BUZ = led_buz_value;
    delay_ms(2000);
    //로드셀 앰프 전원 인가후 로드셀 앰프 워밍업 대기 시간 약 1.4초
    //자체 제작 앰프 특성
    for(jcnt=0;jcnt<40;jcnt++){
        if((jcnt%2)==0){
            LED_BUZ = 0x40;          delay_ms(50);
            LED_BUZ = 0x20;          delay_ms(50);
            LED_BUZ = 0x10;          delay_ms(50);
            LED_BUZ = 0x08;          delay_ms(50);
            LED_BUZ = 0x04;          delay_ms(50);
            LED_BUZ = 0x02;          delay_ms(50);
            LED_BUZ = 0x01;          delay_ms(50);
        }
        else{
            LED_BUZ = 0x01;          delay_ms(50);
            LED_BUZ = 0x02;          delay_ms(50);
            LED_BUZ = 0x04;          delay_ms(50);
            LED_BUZ = 0x08;          delay_ms(50);
            LED_BUZ = 0x10;          delay_ms(50);
            LED_BUZ = 0x20;          delay_ms(50);
            LED_BUZ = 0x40;          delay_ms(50);
        }
    }

    LED_BUZ = led_buz_value;

    Initialize_SYSTEM();

    //Auto Running Mode
    if(ControllerRunMethod == AUTO_RUN_MODE){
        tmrSPEEDCNT = 0;
        led_buz_value |= LED_RUN_STOP;
        LED_BUZ = led_buz_value;

        BuzzerOn();
        delay_ms(200);

        modRunning = NORMAL_RUN;
        TimerMode = tmrSPEED;
        plc_prt_value |= MACHINE_START;
        PLC_CON = plc_prt_value;
        //Timer Start
        OCR1AH=0x00;        OCR1AL=0x4E;        //20msec /1024 prescaler
        TCCR1B = 0x05;

        while(done);
    }

    while(1){
        if(modRunning==MACHINE_STOP || modRunning==NORMAL_RUN || modRunning==SOLENOID_TEST || modRunning==ENCODER_CHK){
            if(COM_REV_ENABLE){
                hi_cmd = RxBuffer[0] & 0xF0;
                lo_cmd = RxBuffer[0] & 0x0F;
                switch(RxBuffer[0]){
                    case CMD_START : //0x10
                        switch(RxBuffer[1]){
                            case 0x01 : case 0x02: case 0x03 : case 0x04 : //Machine Start
                                if(RxBuffer[1]==0x01){
                                    debugMode = 0;
                                }
                                else if(RxBuffer[1]==0x02){
                                    debugMode = 1;
                                }
                                else if(RxBuffer[1]==0x03){
                                    debugMode = 2;
                                }
                                else if(RxBuffer[1]==0x04){
                                    debugMode = 3;
                                }

                                tmrSPEEDCNT = 0;
                                TxBuffer[0] = 0x02;
                                TxBuffer[1] = 0x00;
                                TxBuffer[2] = 0x02;
                                TxBuffer[3] = CMD_START;
                                TxBuffer[4] = 0x01;
                                TxBuffer[5] = 0x03;
                                TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];
                                led_buz_value |= LED_RUN_STOP;
                                LED_BUZ = led_buz_value;

                                BuzzerOn();
                                delay_ms(200);

                                modRunning = NORMAL_RUN;
                                TimerMode = tmrSPEED;
                                plc_prt_value |= MACHINE_START;
                                PLC_CON = plc_prt_value;
                                //Timer Start
                                OCR1AH=0x00;        OCR1AL=0x4E;        //20msec /1024 prescaler
                                TCCR1B = 0x05;
                                //modRunning = MACHINE_RDY;
                                break;
                            case 0x10 :
                            	//파란검출 비율이 일정이상인 경우 인터락 출력
                                BuzzerOn();
                                delay_ms(200);

                                plc_prt_value |= INTER_LOCK_ON;
                                PLC_CON = plc_prt_value;
                                InterLockCnt = 0;
                                InterLockON = 1;
                                break;
                            case 0x0A : case 0x0B: case 0x0C: case 0x0D: case 0x0E: case 0x0F:  //Measure Test
                                //modRunning = MACHINE_RDY;
                                led_buz_value |= LED_RUN_STOP;
                                LED_BUZ = led_buz_value;

                                TxBuffer[0] = 0x02;
                                TxBuffer[1] = 0x00;
                                TxBuffer[2] = 0x02;
                                TxBuffer[3] = CMD_START;
                                TxBuffer[4] = RxBuffer[1];
                                TxBuffer[5] = 0x03;
                                TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];

                                BuzzerOn();
                                delay_ms(200);

                                for(lcnt=0;lcnt<600;lcnt++){
                                    ad_full_scan[lcnt] = 0;
                                }

                                modRunning = MEASURE_AD;
                                scan_ad_ch = RxBuffer[1] - 0x0A;
                                cur_z_phase_cnt =0; phase_a_cnt = 0;   phase_z_cnt=0;    max_scan_val=0;       max_scan_cnt=0;
                                plc_prt_value |= MACHINE_START;
                                PLC_CON = plc_prt_value;

                                break;
                            case 0x05 :                 //MACHINE STOP
                                EVENT_ENABLE = 1;
                                SpeedAdjEnable = 1;
                                accel_rdy = 0;
                                deaccel_rdy = 1;
                                break;
                            case 0xB0 :                 //세척기 ON
                                BuzzerOn();
                                delay_ms(200);
                                plc_prt_value |= WASHER_ON;
                                PLC_CON = plc_prt_value;
                                break;
                            case 0xB1 :                 //세척기 OFF
                                BuzzerOn();
                                delay_ms(200);
                                plc_prt_value &= ~WASHER_ON;
                                PLC_CON = plc_prt_value;
                                break;
                            case 0xC0 :                 //브로와  ON
                                BuzzerOn();
                                delay_ms(200);
                                plc_prt_value |= BROWA_ON;
                                PLC_CON = plc_prt_value;
                                break;
                            case 0xC1 :                 //브로와 OFF
                                BuzzerOn();
                                delay_ms(200);
                                plc_prt_value &= ~BROWA_ON;
                                PLC_CON = plc_prt_value;
                                break;
                            case 0xA0 :     //작업 내용 Clear
                                MACHINE_DATA_CLEAR();

                                for(lcnt=0;lcnt<9;lcnt++){
                                    if(old_prttype[lcnt] != PRT_TYPE_NO){
                                        GRADE_INFO[lcnt].prttype = old_prttype[lcnt];
                                    }
                                }

                                TxBuffer[0] = 0x02;
                                TxBuffer[1] = 0x00;
                                TxBuffer[2] = 0x02;
                                TxBuffer[3] = CMD_START;
                                TxBuffer[4] = 0x0F;
                                TxBuffer[5] = 0x03;
                                TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];
                                BuzzerOn();
                                break;
                            //솔레노이드 셋팅 시험 명령 :: 로드셀 1개만 가상 데이터 입력하여 시험
                            //팩커별 첫번째 포켓 위치 셋팅시 사용
                            case 0xE0 : case 0xE1 : case 0xE2 : case 0xE3 : case 0xE4 : case 0xE5 : case 0xE6 : case 0xE7 : case 0xE8 :
                                SolenoidTestType = 0;
                                TestGrade = RxBuffer[1] - 0xE0;

                                MACHINE_DATA_CLEAR();
                                led_buz_value |= LED_RUN_STOP;
                                LED_BUZ = led_buz_value;

                                TxBuffer[0] = 0x02;
                                TxBuffer[1] = 0x00;
                                TxBuffer[2] = 0x02;
                                TxBuffer[3] = CMD_START;
                                TxBuffer[4] = RxBuffer[1];
                                TxBuffer[5] = 0x03;
                                TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];

                                BuzzerOn();
                                delay_ms(200);

                                modRunning = SOLENOID_TEST;
                                phase_z_cnt=0;
                                TimerMode = tmrSPEED;
                                plc_prt_value |= MACHINE_START;
                                PLC_CON = plc_prt_value;
                                //Timer Start
                                OCR1AH=0x00;        OCR1AL=0x4E;        //20msec /1024 prescaler
                                TCCR1B = 0x05;

                                break;
                            //솔레노이드 셋팅 시험 명령 :: 로드셀 6개 모두 가상 데이터 입력해서 사용
                            //팩커별 솔레노이드 ON/OFF타임 설정시 사용
                            case 0xF0 : case 0xF1 : case 0xF2 : case 0xF3 : case 0xF4 : case 0xF5 : case 0xF6 : case 0xF7 : case 0xF8 :
                                SolenoidTestType = 1;
                                TestGrade = RxBuffer[1] - 0xF0;

                                MACHINE_DATA_CLEAR();
                                led_buz_value |= LED_RUN_STOP;
                                LED_BUZ = led_buz_value;

                                TxBuffer[0] = 0x02;
                                TxBuffer[1] = 0x00;
                                TxBuffer[2] = 0x02;
                                TxBuffer[3] = CMD_START;
                                TxBuffer[4] = RxBuffer[1];
                                TxBuffer[5] = 0x03;
                                TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];

                                BuzzerOn();
                                delay_ms(200);

                                modRunning = SOLENOID_TEST;
                                phase_z_cnt=0;
                                TimerMode = tmrSPEED;
                                plc_prt_value |= MACHINE_START;
                                PLC_CON = plc_prt_value;
                                //Timer Start
                                OCR1AH=0x00;        OCR1AL=0x4E;        //20msec /1024 prescaler
                                TCCR1B = 0x05;
                                break;
                        }
                        break;
                    case CMD_SYSINFO : //0x20 :: 시스템 일반 정보, 측정 관련 정보 송수신
                        switch(RxBuffer[1]){
                            case 0x01 :     //SAVE  DATA
                                SYS_INFO.risingTime = RxBuffer[2] * 256;
                                SYS_INFO.risingTime |= RxBuffer[3];
                                SYS_INFO.fallingTime = RxBuffer[4] * 256;
                                SYS_INFO.fallingTime |= RxBuffer[5];
                                SYS_INFO.correction = RxBuffer[6] * 256;
                                SYS_INFO.correction |= RxBuffer[7];
                                SYS_INFO.stopcount = RxBuffer[8] * 256;
                                SYS_INFO.stopcount |= RxBuffer[9];
                                MEASURE_INFO.ad_start_pulse =RxBuffer[10] * 256;
                                MEASURE_INFO.ad_start_pulse |= RxBuffer[11];
                                MEASURE_INFO.duringcount = RxBuffer[12] * 256;
                                MEASURE_INFO.duringcount |= RxBuffer[13];
                                MEASURE_INFO.zeroposition = RxBuffer[14] * 256;
                                MEASURE_INFO.zeroposition |= RxBuffer[15];
                                MEASURE_INFO.crackchecktime =RxBuffer[16] * 256;
                                MEASURE_INFO.crackchecktime |= RxBuffer[17];
                                MEASURE_INFO.DotCheckTime = RxBuffer[18] * 256;
                                MEASURE_INFO.DotCheckTime |= RxBuffer[19];
                                SYS_INFO.z_encoder_interval = RxBuffer[20] * 256;
                                SYS_INFO.z_encoder_interval |= RxBuffer[21] ;
                                SYS_INFO.DeAccelDelayCount = RxBuffer[22] * 256;
                                SYS_INFO.DeAccelDelayCount |= RxBuffer[23];
                                SYS_INFO.DeAccelDelayTime = RxBuffer[24] * 256;
                                SYS_INFO.DeAccelDelayTime |= RxBuffer[25];
                                SYS_INFO.ACD_CHK_POS = RxBuffer[26];

                                //Save the Flash Memory
                                PUT_USR_INFO_DATA(MEASURE_INFO_DATA);
                                PUT_USR_INFO_DATA(SYS_INFO_DATA);

                                ETC_PARAMETER_SETTING();

                                BuzzerOn();
                                break;
                            case 0x02 :     //LOAD DATA
                                TxBuffer[0] = 0x02;
                                TxBuffer[1] = 0;
                                TxBuffer[2] = 27;
                                TxBuffer[3] = 0x20;
                                TxBuffer[4] = 0x02;
                                TxBuffer[5] = SYS_INFO.risingTime >> 8;
                                TxBuffer[6] = SYS_INFO.risingTime & 0xFF;
                                TxBuffer[7] = SYS_INFO.fallingTime >> 8;
                                TxBuffer[8] = SYS_INFO.fallingTime & 0xFF;
                                TxBuffer[9] = SYS_INFO.correction >> 8;
                                TxBuffer[10] = SYS_INFO.correction & 0xFF;
                                TxBuffer[11] = SYS_INFO.stopcount >> 8;
                                TxBuffer[12] = SYS_INFO.stopcount & 0xFF;
                                TxBuffer[13] = MEASURE_INFO.ad_start_pulse >> 8;
                                TxBuffer[14] = MEASURE_INFO.ad_start_pulse & 0xFF;
                                TxBuffer[15] = MEASURE_INFO.duringcount >> 8;
                                TxBuffer[16] = MEASURE_INFO.duringcount & 0xFF;
                                TxBuffer[17] = MEASURE_INFO.zeroposition >> 8;
                                TxBuffer[18] = MEASURE_INFO.zeroposition & 0xFF;
                                TxBuffer[19] = MEASURE_INFO.crackchecktime >> 8;
                                TxBuffer[20] = MEASURE_INFO.crackchecktime & 0xFF;
                                TxBuffer[21] = MEASURE_INFO.DotCheckTime >> 8;
                                TxBuffer[22] = MEASURE_INFO.DotCheckTime & 0xFF;
                                TxBuffer[23] = SYS_INFO.z_encoder_interval >> 8 ;
                                TxBuffer[24] = SYS_INFO.z_encoder_interval & 0xFF;
                                TxBuffer[25] = SYS_INFO.DeAccelDelayCount >> 8 ;
                                TxBuffer[26] = SYS_INFO.DeAccelDelayCount & 0xFF;
                                TxBuffer[27] = SYS_INFO.DeAccelDelayTime >> 8 ;
                                TxBuffer[28] = SYS_INFO.DeAccelDelayTime & 0xFF;
                                TxBuffer[29] = SYS_INFO.ACD_CHK_POS;

                                TxBuffer[30] = 0x03;

                                TxEnable = 1;   txcnt = 1;  TxLength = 31;   UDR1 = TxBuffer[0];
                                BuzzerOn();
                                break;
                              case 0x00 :     //INIT DATA
                                break;
                        }
                        break;
                    case CMD_SOLINFO : //0x30 :: 솔레노이드 ON/ OFF타임, 팩커별 솔레노이드 시작 위치, 인쇄기 위치, 인쇄기 ON, OFF타임
                        switch(RxBuffer[1]){
                            case 0x01 :     //SAVE DATA

                                dbufstart = 2;

                                //###  Solenoid On Time  ###
                                for(lcnt = 0;lcnt<=7;lcnt++){
                                    for(jcnt=0; jcnt<=5; jcnt++){
                                        oddbuf = dbufstart +  (jcnt * 2) + 1;
                                        evenbuf = dbufstart + (jcnt * 2);

                                        SOL_INFO[lcnt].ontime[jcnt] = RxBuffer[evenbuf];             //High Byte
                                        SOL_INFO[lcnt].ontime[jcnt] <<= 8;
                                        SOL_INFO[lcnt].ontime[jcnt] |= RxBuffer[oddbuf];             //Low Byte
                                    }
                                    dbufstart = oddbuf+1;
                                }

                                dbufstart = oddbuf+1;
                                //###########################
                                //###  Solenoid OFF Time  ###
                                //###########################
                                for(lcnt = 0;lcnt<=7;lcnt++){
                                    for(jcnt=0; jcnt<=5; jcnt++){
                                        oddbuf = dbufstart +  (jcnt * 2) + 1;
                                        evenbuf = dbufstart +  (jcnt * 2);

                                        SOL_INFO[lcnt].offtime[jcnt] = RxBuffer[evenbuf];
                                        SOL_INFO[lcnt].offtime[jcnt] <<= 8;                          //High Byte
                                        SOL_INFO[lcnt].offtime[jcnt] |= RxBuffer[oddbuf];            //Low Byte
                                    }
                                     dbufstart = oddbuf+1;
                                }

                                dbufstart = oddbuf+1;
                                //########################################
                                //###  Solenoid Start Bucket Position  ###
                                //########################################
                                for(lcnt = 0;lcnt<=7;lcnt++){
                                    oddbuf = dbufstart + (lcnt * 2) + 1;
                                    evenbuf = dbufstart + (lcnt * 2);

                                    PACKER_INFO[lcnt].startpocketnumber = RxBuffer[evenbuf];           //High Byte
                                    PACKER_INFO[lcnt].startpocketnumber <<= 8;
                                    PACKER_INFO[lcnt].startpocketnumber |= RxBuffer[oddbuf];           //Low Byte
                                }

                                dbufstart = oddbuf+1;
                                //###################################
                                //###  PRT Start Bucket Position  ###
                                //###################################
                                PRT_INFO[1].startpocketnumber  = RxBuffer[dbufstart];
                                PRT_INFO[1].startpocketnumber  <<= 8;
                                PRT_INFO[1].startpocketnumber  |= RxBuffer[dbufstart+1];

                                PRT_INFO[2].startpocketnumber  = RxBuffer[dbufstart+2];
                                PRT_INFO[2].startpocketnumber  <<= 8;
                                PRT_INFO[2].startpocketnumber  |= RxBuffer[dbufstart+3];

                                dbufstart = dbufstart+4;
                                //#########################
                                //###  PRT ON/OFF TIME  ###
                                //#########################
                                PRT_INFO[1].ontime  = RxBuffer[dbufstart];
                                PRT_INFO[1].ontime  <<= 8;
                                PRT_INFO[1].ontime  |= RxBuffer[dbufstart+1];
                                PRT_INFO[1].offtime  = RxBuffer[dbufstart+2];
                                PRT_INFO[1].offtime  <<= 8;
                                PRT_INFO[1].offtime  |= RxBuffer[dbufstart+3];

                                PRT_INFO[2].ontime  = RxBuffer[dbufstart+4];
                                PRT_INFO[2].ontime  <<= 8;
                                PRT_INFO[2].ontime  |= RxBuffer[dbufstart+5];
                                PRT_INFO[2].offtime  = RxBuffer[dbufstart+6];
                                PRT_INFO[2].offtime  <<= 8;
                                PRT_INFO[2].offtime  |= RxBuffer[dbufstart+7];

                                //Flash Memory Write
                                //PUT_USR_INFO_DATA(GRADE_INFO_DATA);
                                PUT_USR_INFO_DATA(SOL_INFO_DATA);
                                PUT_USR_INFO_DATA(PACKER_INFO_DATA);
                                //PUT_USR_INFO_DATA(LDCELL_INFO_DATA);
                                //PUT_USR_INFO_DATA(MEASURE_INFO_DATA);
                                PUT_USR_INFO_DATA(PRT_INFO_DATA);
                                //PUT_USR_INFO_DATA(SYS_INFO_DATA);

                                BuzzerOn();
                                break;
                            case 0x02 :     //LOAD DATA
                                TxBuffer[0] = 0x02;
                                TxBuffer[3] = 0x30;
                                TxBuffer[4] = 0x02;

                                dbufstart = 5;

                                //###########################
                                //###  Solenoid ON Time  ###
                                //###########################
                                for(lcnt = 0;lcnt<=7;lcnt++){
                                    for(jcnt=0; jcnt<=5; jcnt++){
                                        oddbuf = dbufstart +  (jcnt * 2) + 1;
                                        evenbuf = dbufstart +  (jcnt * 2);

                                        TxBuffer[evenbuf] = SOL_INFO[lcnt].ontime[jcnt] >> 8;             //High Byte
                                        TxBuffer[oddbuf] = SOL_INFO[lcnt].ontime[jcnt] & 0xFF;           //Low Byte
                                    }
                                    dbufstart = oddbuf+1;
                                }

                                dbufstart = oddbuf+1;
                                //###########################
                                //###  Solenoid OFF Time  ###
                                //###########################
                                for(lcnt = 0;lcnt<=7;lcnt++){
                                    for(jcnt=0; jcnt<=5; jcnt++){
                                        oddbuf = dbufstart +  (jcnt * 2) + 1;
                                        evenbuf = dbufstart + (jcnt * 2);

                                        TxBuffer[evenbuf] = SOL_INFO[lcnt].offtime[jcnt] >> 8;             //High Byte
                                        TxBuffer[oddbuf] = SOL_INFO[lcnt].offtime[jcnt] & 0xFF;           //Low Byte
                                    }
                                    dbufstart = oddbuf+1;
                                }

                                dbufstart = oddbuf+1;
                                //'########################################
                                //'###  Solenoid Start Bucket Position  ###
                                //'########################################
                                for(lcnt = 0;lcnt<=7;lcnt++){
                                    oddbuf = dbufstart + (lcnt * 2) + 1;
                                    evenbuf = dbufstart + (lcnt * 2);

                                    TxBuffer[evenbuf] = PACKER_INFO[lcnt].startpocketnumber >> 8;             //High Byte
                                    TxBuffer[oddbuf] = PACKER_INFO[lcnt].startpocketnumber & 0xFF;           //Low Byte
                                }

                                dbufstart = oddbuf+1;
                                //###################################
                                //###  PRT Start Bucket Position  ###
                                //###################################
                                TxBuffer[dbufstart] = PRT_INFO[1].startpocketnumber >> 8;
                                TxBuffer[dbufstart + 1] = PRT_INFO[1].startpocketnumber & 0xFF;
                                TxBuffer[dbufstart + 2] = PRT_INFO[2].startpocketnumber >> 8;
                                TxBuffer[dbufstart + 3] = PRT_INFO[2].startpocketnumber & 0xFF;

                                dbufstart = dbufstart + 4;
                                //#########################
                                //###  PRT ON/OFF TIME  ###
                                //#########################
                                TxBuffer[dbufstart] = PRT_INFO[1].ontime >> 8;
                                TxBuffer[dbufstart+1] = PRT_INFO[1].ontime & 0xFF;
                                TxBuffer[dbufstart+2] = PRT_INFO[1].offtime >> 8;
                                TxBuffer[dbufstart+3] = PRT_INFO[1].offtime & 0xFF;

                                TxBuffer[dbufstart+4] = PRT_INFO[2].ontime >> 8;
                                TxBuffer[dbufstart+5] = PRT_INFO[2].ontime & 0xFF;
                                TxBuffer[dbufstart+6] = PRT_INFO[2].offtime >> 8;
                                TxBuffer[dbufstart+7] = PRT_INFO[2].offtime & 0xFF;

                                dbufstart = dbufstart + 8;
                                //###########################
                                //###  ETX & Data Length  ###
                                //###########################
                                TxBuffer[1] = (dbufstart-3) >> 8;
                                TxBuffer[2] = (dbufstart-3) & 0xFF;
                                TxBuffer[dbufstart] = 0x03;

                                TxEnable = 1;   txcnt = 1;  TxLength = dbufstart+1;   UDR1 = TxBuffer[0];
                                BuzzerOn();
                                break;
                            case 0x00 :     //INIT DATA
                                break;
                        }

                        break;
                    case CMD_GRADEINFO : //0x40 :: 등급별 상하한 값, 인쇄수량, 팩커 위치정보, 솔레노이드 갯수, 팩커 난좌형태 설정
                        switch(RxBuffer[1]){
                            case 0x01 :     //SAVE DATA
                                //#######################
                                //###  등급별 상한값  ###
                                //#######################
                                dbufstart = 2;

                                for(lcnt=0;lcnt<=6;lcnt++){
                                    evenbuf = dbufstart + (lcnt * 2);
                                    oddbuf = dbufstart + (lcnt * 2) + 1;
                                    if(lcnt==6){
                                        GRADE_INFO[8].hiLimit = RxBuffer[evenbuf];
                                        GRADE_INFO[8].hiLimit <<= 8;
                                        GRADE_INFO[8].hiLimit |= RxBuffer[oddbuf];
                                    }
                                    else{
                                        GRADE_INFO[lcnt].hiLimit = RxBuffer[evenbuf];
                                        GRADE_INFO[lcnt].hiLimit <<= 8;
                                        GRADE_INFO[lcnt].hiLimit |= RxBuffer[oddbuf];
                                    }
                                }

                                //#######################
                                //###  등급별 하한값  ###
                                //#######################
                                dbufstart = oddbuf + 1;

                                for(lcnt=0;lcnt<=6;lcnt++){
                                    evenbuf = dbufstart + (lcnt * 2);
                                    oddbuf = dbufstart + (lcnt * 2) + 1;
                                    if(lcnt==6){
                                        GRADE_INFO[8].loLimit = RxBuffer[evenbuf];
                                        GRADE_INFO[8].loLimit <<= 8;
                                        GRADE_INFO[8].loLimit |= RxBuffer[oddbuf];
                                    }
                                    else{
                                        GRADE_INFO[lcnt].loLimit = RxBuffer[evenbuf];
                                        GRADE_INFO[lcnt].loLimit <<= 8;
                                        GRADE_INFO[lcnt].loLimit |= RxBuffer[oddbuf];
                                    }
                                }

                                //#########################
                                //###  등급별 인쇄수량  ###
                                //#########################
                                dbufstart = oddbuf + 1;

                                for(lcnt=0;lcnt<=8;lcnt++){
                                    evenbuf = dbufstart + (lcnt * 2);
                                    oddbuf = dbufstart + (lcnt * 2) + 1;

                                    GRADE_INFO[lcnt].prtSetCount = RxBuffer[evenbuf];
                                    GRADE_INFO[lcnt].prtSetCount <<= 8;
                                    GRADE_INFO[lcnt].prtSetCount |= RxBuffer[oddbuf];
                                }

                                //#########################
                                //###  등급별 인쇄형태  ###
                                //#########################
                                dbufstart = oddbuf + 1;

                                for(lcnt=0;lcnt<=8;lcnt++){
                                    evenbuf = dbufstart + lcnt;

                                    GRADE_INFO[lcnt].prttype = RxBuffer[evenbuf];
                                    old_prttype[lcnt] = GRADE_INFO[lcnt].prttype;

                                }

                                //################################
                                //###  팩커별 솔레노이드 수량  ###
                                //################################
                                dbufstart = evenbuf + 1;

                                for(lcnt=0;lcnt<=7;lcnt++){
                                    evenbuf = dbufstart + lcnt;

                                    PACKER_INFO[lcnt].solcount = RxBuffer[evenbuf];
                                }

                                //################################
                                //###  등급별 솔레노이드 수량  ###
                                //################################
                                dbufstart = evenbuf + 1;

                                for(lcnt=0;lcnt<=7;lcnt++){
                                    evenbuf = dbufstart + lcnt;

                                    GRADE_INFO[lcnt].solenoidnumber = RxBuffer[evenbuf];
                                }

                                //#########################
                                //###  팩커별 등급정보  ###
                                //#########################
                                dbufstart = evenbuf + 1;

                                for(lcnt=0;lcnt<=8;lcnt++){
                                    evenbuf = dbufstart + (2 * lcnt);
                                    oddbuf = dbufstart + (2 * lcnt) + 1;

                                    PACKER_INFO[lcnt].gradetype = RxBuffer[evenbuf];
                                    PACKER_INFO[lcnt].gradetype <<= 8;
                                    PACKER_INFO[lcnt].gradetype |= RxBuffer[oddbuf];
                                }

                                //#########################################
                                //###  등외란-파란 팩커 공용 사용 설정  ###
                                //###  2014.11.24 수정                  ###
                                //#########################################
                                PackerSharedEnable = PACKER_INFO[8].gradetype;

                                //##############################
                                //###  팩커별 솔레노이드 ID  ###
                                //##############################
                                dbufstart = oddbuf + 1;

                                for(lcnt=0;lcnt<=7;lcnt++){
                                    for(jcnt=0;jcnt<=5;jcnt++){
                                        evenbuf = dbufstart + (jcnt * 2);
                                        oddbuf = dbufstart + (jcnt * 2) + 1;

                                        SOL_INFO[lcnt].sol_id[jcnt]=RxBuffer[evenbuf];
                                        SOL_INFO[lcnt].sol_id[jcnt]<<=8;
                                        SOL_INFO[lcnt].sol_id[jcnt]|=RxBuffer[oddbuf];
                                    }
                                    dbufstart = oddbuf + 1;
                                }

                                //#####################################
                                //###  팩커별 솔레노이드 출력 신호  ###
                                //#####################################
                                dbufstart = oddbuf + 1;

                                for(lcnt=0;lcnt<=7;lcnt++){
                                    for(jcnt=0;jcnt<=5;jcnt++){
                                        oddbuf = dbufstart + jcnt;
                                        SOL_INFO[lcnt].outsignal[jcnt] = RxBuffer[oddbuf];
                                    }
                                    dbufstart = oddbuf + 1;
                                }

                                //Data Save Flash Memory
                                PUT_USR_INFO_DATA(GRADE_INFO_DATA);
                                PUT_USR_INFO_DATA(SOL_INFO_DATA);
                                PUT_USR_INFO_DATA(PACKER_INFO_DATA);

                                BuzzerOn();
                                break;
                            case 0x02 :     //REQ DATA
                                //#######################
                                //###  등급별 상한값  ###
                                //#######################
                                TxBuffer[0] = 0x02;
                                TxBuffer[3] = 0x40;
                                TxBuffer[4] = 0x02;

                                bufpos = 5;
                                if(GRADE_INFO[0].hiLimit<100){
                                    GRADE_INFO[0].hiLimit = GRADE_INFO[8].hiLimit - 1;
                                }

                                for(lcnt=0;lcnt<=6;lcnt++){
                                    evenbuf = bufpos + (lcnt * 2);
                                    oddbuf = bufpos + (lcnt * 2) + 1;
                                    if(lcnt==6){
                                        TxBuffer[evenbuf] = GRADE_INFO[8].hiLimit >>8 ;
                                        TxBuffer[oddbuf] = GRADE_INFO[8].hiLimit & 0xFF;
                                    }
                                    else{
                                        TxBuffer[evenbuf] = GRADE_INFO[lcnt].hiLimit >>8 ;
                                        TxBuffer[oddbuf] = GRADE_INFO[lcnt].hiLimit & 0xFF;
                                    }
                                }

                                //#######################
                                //###  등급별 하한값  ###
                                //#######################
                                bufpos = oddbuf + 1;

                                for(lcnt=0;lcnt<=6;lcnt++){
                                    evenbuf = bufpos + (lcnt * 2);
                                    oddbuf = bufpos + (lcnt * 2) + 1;
                                    if(lcnt==6){
                                        TxBuffer[evenbuf] = GRADE_INFO[8].loLimit >> 8;
                                        TxBuffer[oddbuf] = GRADE_INFO[8].loLimit & 0xFF;
                                    }
                                    else{
                                        TxBuffer[evenbuf] = GRADE_INFO[lcnt].loLimit >> 8;
                                        TxBuffer[oddbuf] = GRADE_INFO[lcnt].loLimit & 0xFF;
                                    }
                                }

                                //#########################
                                //###  등급별 인쇄수량  ###
                                //#########################
                                bufpos = oddbuf + 1;

                                for(lcnt=0;lcnt<=8;lcnt++){
                                    evenbuf = bufpos + (lcnt * 2);
                                    oddbuf = bufpos + (lcnt * 2) + 1;

                                    TxBuffer[evenbuf] = GRADE_INFO[lcnt].prtSetCount >> 8;
                                    TxBuffer[oddbuf] = GRADE_INFO[lcnt].prtSetCount & 0xFF;
                                }

                                //#########################
                                //###  등급별 인쇄형태  ###
                                //#########################
                                bufpos = oddbuf + 1;

                                for(lcnt=0;lcnt<=8;lcnt++){
                                    evenbuf = bufpos + lcnt;

                                    TxBuffer[evenbuf] = GRADE_INFO[lcnt].prttype;
                                }

                                //################################
                                //###  팩커별 솔레노이드 수량  ###
                                //################################
                                bufpos = evenbuf + 1;

                                for(lcnt=0;lcnt<=7;lcnt++){
                                    evenbuf = bufpos + lcnt;

                                    TxBuffer[evenbuf] = PACKER_INFO[lcnt].solcount;
                                }


                                //################################
                                //###  등급별 솔레노이드 수량  ###
                                //################################
                                bufpos = evenbuf + 1;

                                for(lcnt=0;lcnt<=7;lcnt++){
                                    evenbuf = bufpos + lcnt;

                                    TxBuffer[evenbuf]= GRADE_INFO[lcnt].solenoidnumber;
                                }

                                //#########################
                                //###  팩커별 등급정보  ###
                                //#########################
                                bufpos = evenbuf + 1;

                                for(lcnt=0;lcnt<=8;lcnt++){
                                    evenbuf = bufpos + (2 * lcnt);
                                    oddbuf = bufpos + (2 * lcnt) + 1;

                                    TxBuffer[evenbuf] = PACKER_INFO[lcnt].gradetype >> 8;
                                    TxBuffer[oddbuf] = PACKER_INFO[lcnt].gradetype & 0xFF;
                                }

                                //##############################
                                //###  팩커별 솔레노이드 ID  ###
                                //##############################
                                bufpos = oddbuf + 1;

                                for(lcnt=0;lcnt<=7;lcnt++){
                                    for(jcnt=0;jcnt<=5;jcnt++){
                                        evenbuf = bufpos + (jcnt * 2);
                                        oddbuf = bufpos + (jcnt * 2) + 1;

                                        TxBuffer[evenbuf] = SOL_INFO[lcnt].sol_id[jcnt] >> 8;
                                        TxBuffer[oddbuf] = SOL_INFO[lcnt].sol_id[jcnt] & 0xFF;
                                    }
                                    bufpos = oddbuf + 1;
                                }

                                //#####################################
                                //###  팩커별 솔레노이드 출력 신호  ###
                                //#####################################
                                bufpos = oddbuf + 1;

                                for(lcnt=0;lcnt<=7;lcnt++){
                                    for(jcnt=0;jcnt<=5;jcnt++){
                                        oddbuf = bufpos + jcnt;
                                        TxBuffer[oddbuf] = SOL_INFO[lcnt].outsignal[jcnt];
                                    }
                                    bufpos = oddbuf + 1;
                                }

                                //###############################
                                //###  ETX & DATA LENGTH SET  ###
                                //###############################
                                bufpos = oddbuf + 1;
                                TxBuffer[bufpos] = 0x03;

                                //Data Length Setting
                                TxBuffer[1] = (bufpos - 3)>>8;
                                TxBuffer[2] = (bufpos - 3)&0xFF;

                                TxEnable = 1;   txcnt = 1;  TxLength = bufpos+1;   UDR1 = TxBuffer[0];
                                BuzzerOn();
                                break;
                            case 0x00 :     //INIT DATA
                                break;
                        }
                        break;
                    case CMD_ENCODER_CHK ://0xE1 ::엔코더A상 카운터값 표시
                        BuzzerOn();
                        switch(RxBuffer[1]){
                            case 0x01 :     //표시시작
                                BuzzerOn();
                                delay_ms(200);
                                TxEnable = 0;
                                modRunning = ENCODER_CHK;
                                break;
                            case 0x02 :     //표시정지
                                BuzzerOn();
                                delay_ms(200);
                                TxEnable = 0;
                                modRunning =  MACHINE_STOP;
                                break;
                        }
                        break;
                    case CMD_SOLTEST :    //0xB0::솔레노이드, 팩커, 인쇄기 개별 동작 시험
                        switch(RxBuffer[1]){
                            //솔레노이드1번~6번 동작 시험
                            case 0x01 : case 0x02: case 0x03: case 0x04: case 0x05 : case 0x06 :
                                ExtPort_TEST(0xFF, RxBuffer[1]-1,Signal_ON, RxBuffer[2]-1);
                                delay_ms(100);
                                ExtPort_TEST(0xFF, RxBuffer[1]-1,Signal_OFF, RxBuffer[2]-1);
                                delay_ms(100);
                                break;
                            //팩커 기동 신호
                            case 0x07 :
                                ExtPort_TEST(0xFF, RxBuffer[1],Signal_ON, RxBuffer[2]-1);
                                delay_ms(100);
                                ExtPort_TEST(0xFF, RxBuffer[1],Signal_OFF, RxBuffer[2]-1);
                                delay_ms(100);
                                break;
                            //인쇄기 A구동
                            case 0x08 :
                                ExtPort_TEST(0x02, RxBuffer[1]-1,Signal_ON, 0);
                                delay_ms(100);
                                ExtPort_TEST(0x02, RxBuffer[1]-1,Signal_OFF, 0);
                                delay_ms(100);
                                break;
                            //인쇄기 B구동
                            case 0x09 :
                                ExtPort_TEST(0x03, RxBuffer[1]-1,Signal_ON, 0);
                                delay_ms(100);
                                ExtPort_TEST(0x03, RxBuffer[1]-1,Signal_OFF, 0);
                                delay_ms(100);
                                break;
                            //전체 기동 :: 솔레노이드 1번~6번, 팩커 기동
                            case 0x0A :
                                ExtPort_TEST(0xFF, RxBuffer[1],Signal_ON, RxBuffer[2]-1);
                                break;
                        }
                        BuzzerOn();
                        break;
                    case CMD_REFORM_WEIGHT :            //중량 교정 기능
                        Reform_Weight();
                        break;
                    case CMD_LDCELLINFO :  //0x80       //2019.07.02 수정
                        switch(RxBuffer[1]){
                            case 0x01 :     //저장
                                ConstWeight[0] = (RxBuffer[2] * 256) + RxBuffer[3];
                                LDCELL_INFO[0].span = ConstWeight[0];
                                ConstWeight[1] = (RxBuffer[4] * 256) + RxBuffer[5];
                                LDCELL_INFO[1].span = ConstWeight[1];
                                ConstWeight[2] = (RxBuffer[6] * 256) + RxBuffer[7];
                                LDCELL_INFO[2].span = ConstWeight[2];
                                ConstWeight[3] = (RxBuffer[8] * 256) + RxBuffer[9];
                                LDCELL_INFO[3].span = ConstWeight[3];
                                ConstWeight[4] = (RxBuffer[10] * 256) + RxBuffer[11];
                                LDCELL_INFO[4].span = ConstWeight[4];
                                ConstWeight[5] = (RxBuffer[12] * 256) + RxBuffer[13];
                                LDCELL_INFO[5].span = ConstWeight[5];

                                PUT_USR_INFO_DATA(LDCELL_INFO_DATA);
                                break;
                            case 0x02 :     //읽기
                                GET_USR_INFO_DATA(LDCELL_INFO_DATA);

                                TxBuffer[0] = 0x02;
                                TxBuffer[1] = 0x00;
                                TxBuffer[2] = 14;
                                TxBuffer[3] = 0x80;
                                TxBuffer[4] = 0x02;
                                TxBuffer[5] = LDCELL_INFO[0].span >> 8;
                                TxBuffer[6] = LDCELL_INFO[0].span &0xFF;
                                TxBuffer[7] = LDCELL_INFO[1].span >> 8;
                                TxBuffer[8] = LDCELL_INFO[1].span &0xFF;
                                TxBuffer[9] = LDCELL_INFO[2].span >> 8;
                                TxBuffer[10] = LDCELL_INFO[2].span &0xFF;
                                TxBuffer[11] = LDCELL_INFO[3].span >> 8;
                                TxBuffer[12] = LDCELL_INFO[3].span &0xFF;
                                TxBuffer[13] = LDCELL_INFO[4].span >> 8;
                                TxBuffer[14] = LDCELL_INFO[4].span &0xFF;
                                TxBuffer[15] = LDCELL_INFO[5].span >> 8;
                                TxBuffer[16] = LDCELL_INFO[5].span &0xFF;
                                TxBuffer[17] = 0x03;

                                TxEnable = 1;   txcnt = 1;  TxLength = 18;   UDR1 = TxBuffer[0];

                                BuzzerOn();
                                delay_ms(200);
                                break;
                        }
                        BuzzerOn();
                        break;
                    case CMD_COMCHK :         //0xAA        //통신 연결 체크
                        switch(RxBuffer[1]){
                            case 0x55 :
                                TxBuffer[0] = 0x02;
                                TxBuffer[1] = 0x00;
                                TxBuffer[2] = 0x02;
                                TxBuffer[3] = 0xAA;
                                TxBuffer[4] = CONTROLLER_ID;
                                TxBuffer[5] = 0x03;
                                TxEnable = 1;   txcnt = 1;  TxLength = 6;   UDR1 = TxBuffer[0];
                                BuzzerOn();
                                break;
                        }
                        break;
                }
                COM_REV_ENABLE = 0;
            }
        }
    }
}