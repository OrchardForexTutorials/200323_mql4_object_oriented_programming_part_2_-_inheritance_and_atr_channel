/*
 *	CciATRChannel.mqh
 *	Copyright 2013-2020, Orchard Forex
 * https://orchardforex.com
 *
 */

#property copyright "Copyright 2013-2020, Orchard Forex"
#property link      "https://orchardforex.com"
#property version   "1.00"
#property strict

#include "ChannelBase.mqh"

class CciATRChannel : public CciChannelBase {

private:

	int						mAtrPeriods;
	double					mAtrMultiplier;
	int						mMaPeriods;
	ENUM_MA_METHOD			mMaMethod;
	ENUM_APPLIED_PRICE	mMaAppliedPrice;
	
protected:

	virtual void			UpdateValues(int bars, int limit);

public:

	CciATRChannel();
	CciATRChannel(string symbol, ENUM_TIMEFRAMES timeframe, int atrPeriods);
	~CciATRChannel();
	
	void	Init(int atrPeriods);

};

CciATRChannel::CciATRChannel() {

//	Default values
//	atrPeriods=14

	Init(14);

}

CciATRChannel::CciATRChannel(string symbol, ENUM_TIMEFRAMES timeframe, int atrPeriods)
		:	CciChannelBase(symbol, timeframe) {

	Init(atrPeriods);
	
}

CciATRChannel::~CciATRChannel() {

}

void		CciATRChannel::Init(int atrPeriods) {
	
	mAtrPeriods			=	atrPeriods;
	
	mAtrMultiplier		=	1.0;
	mMaPeriods			=	mAtrPeriods;
	mMaMethod			=	MODE_SMA;
	mMaAppliedPrice	=	PRICE_CLOSE;
	
	Update();
	
}



//
//	This is the function definition for an indicator
//
/*
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]) {
*/
void		CciATRChannel::UpdateValues(int bars, int limit) {

	int	lim	=	0;
	for (int i = limit-1; i>=0; i--) {
		lim		=	(bars-i)>=mAtrPeriods ? mAtrPeriods : (bars-i);		//	To handle bars before the length of the channel
		mChannelMid[i]		=	iMA(mSymbol, mTimeframe, lim, 0, mMaMethod, mMaAppliedPrice, i);
		double	atr		=	iATR(mSymbol, mTimeframe, lim, i);
		mChannelHigh[i]	=	mChannelMid[i]+(atr*mAtrMultiplier);
		mChannelLow[i]		=	mChannelMid[i]-(atr*mAtrMultiplier);
	}
	
	mPrevCalculated		=	bars;																		//	Reset our position in the array
	
}
