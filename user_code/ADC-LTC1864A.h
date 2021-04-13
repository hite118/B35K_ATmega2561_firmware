/************************************/
/* ADConvertor Function             */
/* ADC Type : LTC1864A              */
/************************************/
/* ADS8344E ADConvertor Control Signal */
#define     ADC_SCK        PORTF
#define     ADC_IN         PINB.6             //adc칩 clock입력 
#define     ADC_CONV       PORTB.7             //adc칩 clock입력 
#define     ADC_OUT        PORTB.5

// New AD Configuration REG.
#define     ADC_CH0_SCK        0x01
#define     ADC_CH1_SCK         0x02
#define     ADC_CH2_SCK         0x04
#define     ADC_CH3_SCK         0x10
#define     ADC_CH4_SCK         0x20
#define     ADC_CH5_SCK         0x40

//unsigned char ADC_EN_CH[6] = {ADC_CH0, ADC_CH1, ADC_CH2, ADC_CH3, ADC_CH4, ADC_CH5 };
unsigned char ADC_SCK_CH[6] = {ADC_CH0_SCK, ADC_CH1_SCK, ADC_CH2_SCK, ADC_CH3_SCK, ADC_CH4_SCK, ADC_CH5_SCK };
/*****************************************/
/* 개별 채널을 ADC시작하고, ADC읽어올 때 */
/*****************************************/
unsigned int OneShot_EachADConv(unsigned char ch){
    unsigned int tmp=0;
    unsigned char clk=0;
    //unsigned char k[16];
    
    //ADC_SCK = ADC_SCK_CH[ch];
    //Enable Chip & Start Conversion    
    ADC_OUT = 1;   
    
    ADC_CONV = 1;//ADC_EN_CH[ch];        
    
    //Delay Conversion Time 
    delay_us(5);
    
    //Disable Chip & Start Conversion    
    ADC_CONV = 0;//ADC_EN_CH[ch];

    //Read Start
    //READ AD VALUE
    /*for(clk=0;clk<16;clk++){
        ADC_SCK &= ~ADC_SCK_CH[ch];
        #asm("nop");  
        tmp |= ADC_IN;
        tmp <<= 1;
        ADC_SCK |= ADC_SCK_CH[ch];         
        #asm("nop");
        #asm("nop");    
    }
    */
    
    for(clk=0;clk<16;clk++){
        ADC_OUT = 0;
        #asm("nop");
        tmp |= ADC_IN;
        tmp <<= 1;
        ADC_OUT = 1;         
        #asm("nop");#asm("nop");
    }
    
    return (tmp & 0xFFFF);      
}


/**********************************/
/* 전체 채널을 ADC시작하게 한 뒤, */
/* 개별 채널의 AD값을 읽어오게 함 */
/**********************************/
/*
unsigned int Each_Read_AD(unsigned char ch){
    unsigned int tmp=0, clk=0;
    
    //변환 완료후 읽기 모드 시작  
    ADC_SEL = ~ADC_EN_CH[ch];        
    
    DCLK = 0;
        
    //READ AD VALUE
    for(clk=0;clk<16;clk++){
        DCLK = 1;
        tmp |= DIN;
        tmp <<= 1;
        DCLK = 0;               
    }
    
    return (tmp & 0xFFFF);      
}
*/