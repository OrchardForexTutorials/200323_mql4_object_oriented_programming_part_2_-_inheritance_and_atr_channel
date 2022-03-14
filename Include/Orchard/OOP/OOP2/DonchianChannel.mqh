/*
 *	CciDonchianChannel.mqh
 *	Copyright 2013-2020, Orchard Forex
 * https://orchardforex.com
 *
 */

#property copyright "Copyright 2013-2020, Orchard Forex"
#property link      "https://orchardforex.com"
#property version   "1.00"
#property strict

#include "ChannelBase.mqh"

class CciDonchianChannel : public CciChannelBase {

private:

	int						mDonchianPeriods;
	
protected:

	virtual void			UpdateValues(int bars, int limit);

public:

	CciDonchianChannel();
	CciDonchianChannel(string symbol, ENUM_TIMEFRAMES timeframe, int donchianPeriods);
	~CciDonchianChannel();
	
	void	Init(int donchianPeriods);

};

CciDonchianChannel::CciDonchianChannel() {

//	Default values
//	donchianPeriods=20

	Init(20);

}

CciDonchianChannel::CciDonchianChannel(string symbol, ENUM_TIMEFRAMES timeframe, int donchianPeriods)
		:	CciChannelBase(symbol, timeframe) {

	Init(donchianPeriods);
	
}

CciDonchianChannel::~CciDonchianChannel() {

}

void		CciDonchianChannel::Init(int donchianPeriods) {
	
	mDonchianPeriods			=	donchianPeriods;
	
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
void		CciDonchianChannel::UpdateValues(int bars, int limit) {

	int	lim	=	0;
	for (int i = limit-1; i>=0; i--) {
		lim		=	(bars-i)>=mDonchianPeriods ? mDonchianPeriods : (bars-i);		//	To handle bars before the length of the channel
		mChannelHigh[i]	=	iHigh(mSymbol, mTimeframe, iHighest(mSymbol, mTimeframe, MODE_HIGH, lim, i));
		mChannelLow[i]		=	iLow(mSymbol, mTimeframe, iLowest(mSymbol, mTimeframe, MODE_LOW, lim, i));
		mChannelMid[i]		=	(mChannelHigh[i]+mChannelLow[i])/2;
	}
	
	mPrevCalculated		=	bars;																		//	Reset our position in the array
	
}
