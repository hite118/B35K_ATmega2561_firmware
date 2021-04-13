/************************************/
/* ADConvertor Function             */
/* ADC Type : ADS8344E              */
/************************************/
/* ADS8344E ADConvertor Control Signal */
#define     AD_CS       PORTB.0
#define     DOUT        (int)PINB.4              //adc칩 data출력
#define     DIN         PORTB.5             //adc칩 data입력
#define     BUSY        PINB.6              //adc칩 busy체크
#define     DCLK        PORTB.7             //adc칩 clock입력

/* Definition of AD Channel */
#define     AD_CH0      0
#define     AD_CH1      1
#define     AD_CH2      4
#define     AD_CH3      5
#define     AD_CH4      2
#define     AD_CH5      3
#define     AD_CH6      6
#define     AD_CH7      7

// New AD Configuration REG.
#define     ADC_START    0x80       //Start bit

#define     ADC_CH0      0x00       //AD Channel
#define     ADC_CH1      0x40
#define     ADC_CH2      0x10
#define     ADC_CH3      0x50
#define     ADC_CH4      0x20
#define     ADC_CH5      0x60
#define     ADC_CH6      0x30
#define     ADC_CH7      0x70

#define     ADC_SNG      0x04       //AD SINGLE ENDED MODE
#define     ADC_PD       0x03       //Power Down Mode - 00: power down, 02 :internal clk,
                                    //                  01 :reserved,   03 :no powerdown, external clk

unsigned char _ADC_CH[8]={ADC_CH0, ADC_CH1, ADC_CH2, ADC_CH3, ADC_CH4, ADC_CH5, ADC_CH6, ADC_CH7};

unsigned int RD_ADC(unsigned char ch){
    unsigned char config=0x00, clk, config_bit;
    unsigned int tmp=0;

    //Set ADC REG. config data
    config = ADC_START;
    config |= _ADC_CH[ch];
    config |= ADC_SNG;
    config |= ADC_PD;

    //Enable Chip
    AD_CS = 0;
    //Write Config Table
    for(clk=0;clk<8;clk++){
        DCLK = 0;
        config_bit = config & 0x80;
        if(!config_bit)     DIN = 0;
        else                DIN = 1;
        config <<= 1;
        DCLK = 1;
        #asm("nop");       #asm("nop");
    }

    //Busy Check
    DCLK = 0;   #asm("nop");
    DCLK = 1;   #asm("nop");

    //BUSY CHECK

    //READ AD VALUE
    for(clk=0;clk<16;clk++){
        DCLK = 0;
        tmp <<= 1;
        tmp |= DOUT;
        DCLK = 1;
    }

    AD_CS = 1;
    return (tmp & 0xFFFF);
}