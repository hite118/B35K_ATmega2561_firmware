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
    for(jcnt=0;jcnt<40;jcnt++)
	{
        if((jcnt%2)==0)
		{
            LED_BUZ = 0x40;          delay_ms(50);
            LED_BUZ = 0x20;          delay_ms(50);
            LED_BUZ = 0x10;          delay_ms(50);
            LED_BUZ = 0x08;          delay_ms(50);
            LED_BUZ = 0x04;          delay_ms(50);
            LED_BUZ = 0x02;          delay_ms(50);
            LED_BUZ = 0x01;          delay_ms(50);
        }
        else
		{
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
