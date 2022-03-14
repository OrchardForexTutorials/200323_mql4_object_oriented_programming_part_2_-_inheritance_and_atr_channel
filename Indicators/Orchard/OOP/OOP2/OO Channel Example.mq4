/*
 *	OO Channel Example.mq4
 *	Copyright 2020, Orchard Forex
 *	https://orchardforex.com
 *
 */

#property copyright "Copyright 2020, Orchard Forex"
#property link      "https://orchardforex.com"
#property version   "1.00"
#property strict

#property indicator_chart_window
#property indicator_buffers 3							//	Added a third buffer for the mid channel

#property indicator_color1			clrWhite			//	Rearranged to put mid channel first
#property indicator_style1			STYLE_DOT		//	And group app properties for each indicator together
#property indicator_type1			DRAW_LINE

#property indicator_color2			clrGreen
#property indicator_style2			STYLE_DASHDOT
#property indicator_type2			DRAW_LINE

#property indicator_color3			clrYellow
#property indicator_style3			STYLE_DASHDOT
#property indicator_type3			DRAW_LINE

#include <Orchard/OOP/OOP2/DonchianChannel.mqh>	//	Including BOTH indicators here
#include <Orchard/OOP/OOP2/ATRChannel.mqh>

enum ENUM_CHANNEL_TYPE {								//	Helps with input of channel type
	CHANNEL_TYPE_DONCHIAN,	// Donchian channel
	CHANNEL_TYPE_ATR			// ATR Channel
};

input			ENUM_CHANNEL_TYPE	InpChannelType	=	CHANNEL_TYPE_DONCHIAN;	//	Channel Type
input    	int   				InpPeriods=20; 									// Channel Periods

double      MidBuffer[];								//	New buffer
double      HiBuffer[];
double      LoBuffer[];

#define		MidInd 0										//	New mid indicator
#define     HiInd  1
#define     LoInd  2

CciChannelBase *Channel;								//	Ony declared as the base class

int OnInit()
{

   SetIndexBuffer(MidInd, MidBuffer);				//	New
   SetIndexLabel(MidInd,"Mid");

   SetIndexBuffer(HiInd, HiBuffer);
   SetIndexLabel(HiInd,"High");

   SetIndexBuffer(LoInd, LoBuffer);
   SetIndexLabel(LoInd,"Low");
   
	switch (InpChannelType) {							//	Create objects from specific child classes
		case CHANNEL_TYPE_DONCHIAN:
				Channel	=	new CciDonchianChannel(_Symbol, (ENUM_TIMEFRAMES)_Period, InpPeriods);
				break;
		case CHANNEL_TYPE_ATR:
				Channel	=	new CciATRChannel(_Symbol, (ENUM_TIMEFRAMES)_Period, InpPeriods);
				break;
		default:
			return(INIT_PARAMETERS_INCORRECT);
	}
				   
   return(INIT_SUCCEEDED);
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{

   int limit=rates_total-prev_calculated;
   if (prev_calculated>0)
      limit++;
   
   for (int i=limit-1; i>=0; i--)
   {
      MidBuffer[i]	=	Channel.Mid(i);		// New
      HiBuffer[i]		=	Channel.High(i);
      LoBuffer[i]		=	Channel.Low(i);
   }
   
   return(rates_total);
}
//+------------------------------------------------------------------+
