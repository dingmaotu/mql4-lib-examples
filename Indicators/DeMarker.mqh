//+------------------------------------------------------------------+
//| Module: Indicators/DeMarker.mqh                                  |
//| This file is part of the mql4-lib-examples project:              |
//|     https://github.com/dingmaotu/mql4-lib-examples               |
//|                                                                  |
//| Copyright 2017 Li Ding <dingmaotu@hotmail.com>                   |
//|                                                                  |
//| Licensed under the Apache License, Version 2.0 (the "License");  |
//| you may not use this file except in compliance with the License. |
//| You may obtain a copy of the License at                          |
//|                                                                  |
//|     http://www.apache.org/licenses/LICENSE-2.0                   |
//|                                                                  |
//| Unless required by applicable law or agreed to in writing,       |
//| software distributed under the License is distributed on an      |
//| "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,     |
//| either express or implied.                                       |
//| See the License for the specific language governing permissions  |
//| and limitations under the License.                               |
//+------------------------------------------------------------------+
#property strict

#include <Mql/Lang/Mql.mqh>
#include <Mql/Lang/Indicator.mqh>
#include <MovingAverages.mqh>
//+------------------------------------------------------------------+
//| Indicator parameters                                             |
//+------------------------------------------------------------------+
class DeMarkerParam: public AppParam
  {
   ObjectAttr(int,AvgPeriod,AvgPeriod); // SMA Period
  };
//+------------------------------------------------------------------+
//| DeMarker implementation                                          |
//| You can use this indicator in your EA without running it as a    |
//| standalone program                                               |
//+------------------------------------------------------------------+
class DeMarker: public Indicator
  {
private:
   int               m_period;
protected:
   double            ExtMainBuffer[];
   double            ExtMaxBuffer[];
   double            ExtMinBuffer[];
public:
   //--- time series like access when used in an EA
   double            operator[](const int index) {return ExtMainBuffer[ArraySize(ExtMainBuffer)-index-1];}

                     DeMarker(DeMarkerParam *param)
   :m_period(param.getAvgPeriod())
     {
      if(isRuntimeControlled())
        {
         string short_name;
         //--- indicator lines
         SetIndexStyle(0,DRAW_LINE);
         SetIndexBuffer(0,ExtMainBuffer);
         //--- name for DataWindow and indicator subwindow label
         short_name="DeM("+IntegerToString(m_period)+")";
         IndicatorShortName(short_name);
         SetIndexLabel(0,short_name);
         //---
         SetIndexDrawBegin(0,m_period);
        }
     }

   int               main(const int total,
                          const int prev,
                          const datetime &time[],
                          const double &open[],
                          const double &high[],
                          const double &low[],
                          const double &close[],
                          const long &tickVolume[],
                          const long &volume[],
                          const int &spread[])
     {
      //--- check for bars count
      if(total<m_period)
         return(0);
      if(isRuntimeControlled())
        {
         ArraySetAsSeries(ExtMainBuffer,false);
        }
      else
        {
         if(prev!=total)
           {
            ArrayResize(ExtMainBuffer,total,100);
           }
        }
      if(prev!=total)
        {
         ArrayResize(ExtMaxBuffer,total,100);
         ArrayResize(ExtMinBuffer,total,100);
        }
      ArraySetAsSeries(low,false);
      ArraySetAsSeries(high,false);

      int begin=(prev==total)?prev-1:prev;

      for(int i=begin; i<total; i++)
        {
         if(i==0) {ExtMaxBuffer[i]=0.0;ExtMinBuffer[i]=0.0;continue;}
         if(high[i]>high[i-1]) ExtMaxBuffer[i]=high[i]-high[i-1];
         else ExtMaxBuffer[i]=0.0;

         if(low[i]<low[i-1]) ExtMinBuffer[i]=low[i-1]-low[i];
         else ExtMinBuffer[i]=0.0;
        }
      for(int i=begin; i<total; i++)
        {
         if(i<m_period) {ExtMainBuffer[i]=0.0;continue;}
         double smaMax=SimpleMA(i,m_period,ExtMaxBuffer);
         double smaMin=SimpleMA(i,m_period,ExtMinBuffer);
         ExtMainBuffer[i]=smaMax/(smaMax+smaMin);
        }

      //--- OnCalculate done. Return new prev.
      return(total);
     }
  };
//+------------------------------------------------------------------+
