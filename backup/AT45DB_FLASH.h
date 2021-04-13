////////////////////////////////////////////
// Flash Memory - AT45DB081D (1Mbit)
////////////////////////////////////////////

#define     MEM_CS_EN           {PORTE.2=0;}
#define     MEM_CS_DIS          {PORTE.2=1;}

#define     BUFFER_1_WRITE      0x84
#define     BUFFER_2_WRITE      0x87
#define     Mem_Page_Wr_B1_E    0x83    //Buf1 to MainMemory Page Prog. with Built-in Erase
#define     Mem_Page_Wr_B2_E    0x86    //Buf2 to MainMemory Page Prog. with Built-in Erase
#define     Mem_Page_Wr_B1      0x88    //Buf1 to MainMemory Page Prog. without Built-in Erase
#define     Mem_Page_Wr_B2      0x89    //Buf2 to MainMemory Page Prog. without Built-in Erase
#define     Mem_Page_Through_B1 0x82    //Buf1 to MainMemory Page Prog. Through
#define     Mem_Page_Through_B2 0x85    //Buf2 to MainMemory Page Prog. Through

#define     B1_PageXFER         0x53
#define     B2_PageXFER         0x55

#define     BUFFER_1_READ       0xD1
#define     BUFFER_2_READ       0xD3
#define     Mem_Page_Read       0xD2

#define     PageErase           0x81
#define     BlockErase          0x50
#define     SectorErase         0x7C
#define     ChipErase           0xC7    //0xC7, 0x94, 0x80, 0x9A

/*
#define     GRADE_INFO_DATA         0
#define     SOL_INFO_DATA           1
#define     PACKER_INFO_DATA        2
#define     LDCELL_INFO_DATA        3
#define     MEASURE_INFO_DATA       4
#define     PRT_INFO_DATA           5
#define     SYS_INFO_DATA           6
*/

#define     _AT45DB161

#ifdef      _AT45DB081
    #define     ChipID              0x1F
    #define     ChipType            0x25
    #define     PagePerByte         264
    #define     BUF_SIZE            264
#endif
#ifdef      _AT45DB161
    #define     ChipID              0x1F
    #define     ChipType            0x26
    #define     PagePerByte         528
    #define     BUF_SIZE            528
#endif

unsigned char Data_Buff[BUF_SIZE];

void SPI_Init(void)
{
    //DDRB = 0xF7;
    PORTB = 0x08;
    SPCR = 0x50;
    SPSR |= 0x01; // SPI2X = 1.
}

void SendSPIByte(unsigned char byte)
{
    SPDR = byte;
    while (!(SPSR & 0x80)); // SPIF∞° 1∑Œ µ…∂ß±Ó¡ˆ ¥Î±‚. (SPI ¿¸º€¿Ã øœ∑·µ…∂ß±Ó¡ˆ ¥Î±‚)
    byte = SPDR; // ¥ıπÃƒ⁄µÂ æ∆¥‘. ¿Ã¡Ÿ¿∫ ¡ˆøÏ¡ˆ ∏ª∞Õ.
}

unsigned char GetSPIByte(void)
{
    SPDR = 0x00; // ¥ıπÃƒ⁄µÂ æ∆¥‘. ¿Ã¡Ÿ¿∫ ¡ˆøÏ¡ˆ ∏ª∞Õ.
    while (!(SPSR & 0x80)); // SPIF∞° 1∑Œ µ…∂ß±Ó¡ˆ ¥Î±‚. (SPI ¿¸º€¿Ã øœ∑·µ…∂ß±Ó¡ˆ ¥Î±‚)
    return SPDR;
}

unsigned char GetDeviceID(void)
{
    unsigned char dev_id[6], lcnt;

    MEM_CS_EN;
    SendSPIByte(0x9F);

    for(lcnt=0;lcnt<6;lcnt++)        dev_id[lcnt]=GetSPIByte();
    MEM_CS_DIS;

    if(dev_id[0]==ChipID && dev_id[1]==ChipType)         return 1;
    else                                                 return 0;
}

//////////////////////////////////
//Busy Check
unsigned char Check_Flash_Busy(void)
{
  unsigned char busy_flag;

  MEM_CS_EN;                     //ˆ«csÓ∏?ÒÈ
  SendSPIByte(0xd7);
  SendSPIByte(0xff);       //?ÌÆ??Àﬂ£¨ﬁ≈ÌÆ??Àﬂ?SOÏπıÛ
  busy_flag = SPDR;
  MEM_CS_DIS;                 //ˆ«csÕ‘‹Ù?ÒÈ

  if(busy_flag & 0x80)
      busy_flag = 0;
  else
      busy_flag = 1;

  return busy_flag;
}

///////////////////////////////////////
// Set Page
// page_address : page number
// page_offset : buffer number
// count : read data size
void SetPageBuffer1(unsigned int pagenum)
{
   unsigned char tmp[4];


   /*tmp[0] = (unsigned char)(pagenum>>8);
   tmp[0] &= 0x1F;
   tmp[1] = (unsigned char)(pagenum<<1);
   tmp[1] &= 0xFE;
   tmp[2] =0;

   tmp[0] = (pagenum >> 8)&0x0F;
   tmp[1] = pagenum & 0xFF;
   tmp[2] = 0x00;
   */
   #ifdef      _AT45DB161
    pagenum <<= 2;
    tmp[0] = (unsigned char)(pagenum>>8);
    tmp[0] &= 0x3F;
    tmp[1] = (unsigned char)(pagenum & 0xFC);
    tmp[2] =0;
   #else
    pagenum <<= 1;
    tmp[0] = (unsigned char)(pagenum>>8);
    tmp[0] &= 0x1F;
    tmp[1] = (unsigned char)(pagenum & 0xFE);
    tmp[2] =0;
   #endif

   MEM_CS_EN;
   SendSPIByte(0x83);     //CMD
   SendSPIByte(tmp[0]);     //CMD
   SendSPIByte(tmp[1]);     //CMD
   SendSPIByte(tmp[2]);     //CMD
   MEM_CS_DIS;
}

void PageRead(unsigned int pagenum)
{
   unsigned char tmp[4];
   unsigned int i;

   #ifdef      _AT45DB161
    pagenum <<= 2;
    tmp[0] = (unsigned char)(pagenum>>8);
    tmp[0] &= 0x3F;
    tmp[1] = (unsigned char)(pagenum & 0xFC);
    tmp[2] =0;
   #else
    pagenum <<= 1;
    tmp[0] = (unsigned char)(pagenum>>8);
    tmp[0] &= 0x1F;
    tmp[1] = (unsigned char)(pagenum & 0xFE);
    tmp[2] =0;
   #endif

   /*tmp[0] = (pagenum >> 8)&0x0F;
   tmp[1] = pagenum & 0xFF;
   tmp[2] = 0x00;
   */
   MEM_CS_EN;
   SendSPIByte(0xd2);     //CMD
   SendSPIByte(tmp[0]);
   SendSPIByte(tmp[1]);
   SendSPIByte(tmp[2]);
   SendSPIByte(0);
   SendSPIByte(0);
   SendSPIByte(0);
   SendSPIByte(0);

   for(i=0;i<BUF_SIZE;i++)
   {
      Data_Buff[i]=GetSPIByte();
   }
   MEM_CS_DIS;
}

void Chip_Erase(void)
{
   MEM_CS_EN;
   SendSPIByte(0xC7);     //CMD
   SendSPIByte(0x94);     //CMD
   SendSPIByte(0x80);     //CMD
   SendSPIByte(0x9A);     //CMD
   MEM_CS_DIS;

}

//////////////////////////////////////////////////
// Write Buffer
// Write_com : Buffer1 or Buffer2 (COMMAND)
// buffer_offset : Start Address
// byte_count : Buffer Size
void Write_Buff(unsigned char Write_com,unsigned int buffer_offset,unsigned int byte_count)
{
  unsigned int i;

  MEM_CS_EN;                    //ˆ«csÓ∏?ÒÈ
  Write_com = 0x84;
  SendSPIByte(Write_com);  //?bufferÚ¶÷µ
  SendSPIByte(0);          //?ŸÈ?Í»
  SendSPIByte((unsigned char)(buffer_offset>>8));
  SendSPIByte((unsigned char)(buffer_offset & 0xFF));
  for (i=buffer_offset;i<byte_count;i++)               //?byte_count?ÌÆ??Ï˝FLASH Buffer1
     SendSPIByte(Data_Buff[i]);
  MEM_CS_DIS;                                //ˆ«csÕ‘‹Ù?ÒÈ
}



///////////////////////////////////////
// GET User Info Data
void GET_USR_INFO_DATA(unsigned int usrcnt)
{
    PageRead(usrcnt);
    while(Check_Flash_Busy());

    delay_ms(5);

    //Conversion Data
    switch(usrcnt){
        case GRADE_INFO_DATA :
            memcpy(&GRADE_INFO,&(Data_Buff[0]),sizeof(GRADE_INFO));
            break;
        case SOL_INFO_DATA :
            memcpy(&SOL_INFO,&(Data_Buff[0]),sizeof(SOL_INFO));
            break;
        case PACKER_INFO_DATA :
            memcpy(&PACKER_INFO,&(Data_Buff[0]),sizeof(PACKER_INFO));
            break;
        case LDCELL_INFO_DATA :
            memcpy(&LDCELL_INFO,&(Data_Buff[0]),sizeof(LDCELL_INFO));
            break;
        case MEASURE_INFO_DATA :
            memcpy(&MEASURE_INFO,&(Data_Buff[0]),sizeof(MEASURE_INFO));
            break;
        case PRT_INFO_DATA :
            memcpy(&PRT_INFO,&(Data_Buff[0]),sizeof(PRT_INFO));
            break;
        case SYS_INFO_DATA :
            memcpy(&SYS_INFO,&(Data_Buff[0]),sizeof(SYS_INFO));
            break;
        //case BREAK_OUT_DATA :
        //    memcpy(&BREAKOUT_DATA,&(Data_Buff[0]),sizeof(BREAKOUT_DATA));
        //    break;
    }

}

///////////////////////////////////////
// PUT User Info Data
void PUT_USR_INFO_DATA(unsigned int usrcnt)
{
    //Conversion Data
    switch(usrcnt){
        case GRADE_INFO_DATA :
            memcpy(&(Data_Buff[0]),&GRADE_INFO,sizeof(GRADE_INFO));
            break;
        case SOL_INFO_DATA :
            memcpy(&(Data_Buff[0]),&SOL_INFO,sizeof(SOL_INFO));
            break;
        case PACKER_INFO_DATA :
            memcpy(&(Data_Buff[0]),&PACKER_INFO,sizeof(PACKER_INFO));
            break;
        case LDCELL_INFO_DATA :
            memcpy(&(Data_Buff[0]),&LDCELL_INFO,sizeof(LDCELL_INFO));
            break;
        case MEASURE_INFO_DATA :
            memcpy(&(Data_Buff[0]),&MEASURE_INFO,sizeof(MEASURE_INFO));
            break;
        case PRT_INFO_DATA :
            memcpy(&(Data_Buff[0]),&PRT_INFO,sizeof(PRT_INFO));
            break;
        case SYS_INFO_DATA :
            memcpy(&(Data_Buff[0]),&SYS_INFO,sizeof(SYS_INFO));
            break;
        //case BREAK_OUT_DATA :
        //    memcpy(&(Data_Buff[0]),&BREAKOUT_DATA,sizeof(BREAKOUT_DATA));
        //    break;
    }

    Write_Buff(BUFFER_1_WRITE,0,PagePerByte);
    while(Check_Flash_Busy());
    SetPageBuffer1(usrcnt);
    while(Check_Flash_Busy());

    #asm("nop");
    #asm("nop");
    #asm("nop");
}
/*
///////////////////////////////////////
// SET System Parameter
void SET_SYS_PARAMETER(void)
{
   strcpyf(SystemInfoData.localID,"W0G");
   strcpyf(SystemInfoData.MPosID,"021");
   strcpyf(SystemInfoData.MechineID,"01");
   SystemInfoData.MechineNumber = 1;
   strcpyf(SystemInfoData.ServerIP,"255.255.255.255");
   strcpyf(SystemInfoData.IP_PORT,"13000");
   strcpyf(SystemInfoData.KEC_ServerIP,"211.112.135.142");
   strcpyf(SystemInfoData.KEC_IP_PORT,"13000");
   strcpyf(SystemInfoData.MY_Phone,"01099009513");
   SystemInfoData.UnitMoney=50;
   strcpyf(SystemInfoData.FullWeight,"13000");
   strcpyf(SystemInfoData.BoxVolumeSize,"85");
   strcpyf(SystemInfoData.FirmWareVer,"1.01");
   ////////////////////////////////////////////
   strcpyf(SystemInfoData.ManagerPass,"1212");
   strcpyf(SystemInfoData.AdminPass,"2424");
   strcpyf(SystemInfoData.ManagerPhone,"01064347810");
   ////////////////////////////////////////////
   SystemInfoData.CloseRdyTime= 150;
   SystemInfoData.HeaterTemp= 2;                //Heating Temp - 2µµ
   SystemInfoData.SoundVolume= 15;               //ªÁøÓµÂ ∫º∑˝
   SystemInfoData.UVLampUsed= 1;
   SystemInfoData.LEDLampUsed= 1;
   SystemInfoData.HeaterUsed= 1;
   SystemInfoData.InDoorUsed= 1;
   SystemInfoData.MotorSpeed = 5;
}

///////////////////////////////////////
// GET System Parameter
void GET_SYS_PARAMETER(void)
{
   PageRead(SysParaPage);
   while(Check_Flash_Busy());

   delay_ms(5);

   memcpy(&SystemInfoData, &(Data_Buff[0]), sizeof(SystemInfoData));
}

///////////////////////////////////////
// PUT System Parameter
void PUT_SYS_PARAMETER(char puttype)
{
   if(puttype==0)   SET_SYS_PARAMETER();

   memcpy(&(Data_Buff[0]), &SystemInfoData, sizeof(SystemInfoData));

   Write_Buff(BUFFER_1_WRITE,0,PagePerByte);
   while(Check_Flash_Busy());
   SetPageBuffer1(SysParaPage);        //System Parameter = Page1
   while(Check_Flash_Busy());
}

*/

