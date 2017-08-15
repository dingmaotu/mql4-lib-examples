//+------------------------------------------------------------------+
//| Module: Scripts/CsvFile.mq4                                      |
//| This file is part of the mql4-lib-examples project:              |
//|     https://github.com/dingmaotu/mql4-lib-examples               |
//|                                                                  |
//| Copyright 2015-2017 Li Ding <dingmaotu@hotmail.com>              |
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
#property copyright "Copyright 2017, Li Ding"
#property link      "dingmaotu@hotmail.com"
#property version   "1.00"
#property description "Illustration of the use of Utils/CsvFile class"
#property strict
#include<Mql/Utils/File.mqh>
//+------------------------------------------------------------------+
//| A simplified quote struct                                        |
//+------------------------------------------------------------------+
struct MyStruct
  {
   string            symbol;
   double            close;
   datetime          time;
  };
//+------------------------------------------------------------------+
//| Write simplified `numberOfQutoes` quotes to a csv file           |
//+------------------------------------------------------------------+
void WriteCsv(string path,int numberOfQuotes)
  {
   MqlRates rates[];
   CopyRates(_Symbol,_Period,0,numberOfQuotes,rates);
   CsvFile csv(path,FILE_WRITE); // check csv.valid() to see if the file opens correctly
   for(int i=0; i<ArraySize(rates);i++)
     {
      csv.writeString(_Symbol);
      csv.writeDelimiter();
      csv.writeNumber(rates[i].close);
      csv.writeDelimiter();
      csv.writeDateTime(rates[i].time);
      csv.writeNewline();
     }
// CsvFile destructor automatically closes the file when going out of scope
  }
//+------------------------------------------------------------------+
//| Read simplified quotes to an array                               |
//+------------------------------------------------------------------+
void ReadCsv(string path,MyStruct &a[])
  {
   CsvFile csv(path,FILE_READ);
   for(int i=0; !csv.end(); i++)
     {
      ArrayResize(a,i+1,100);
      a[i].symbol= csv.readString();
      a[i].close = csv.readNumber();
      a[i].time=csv.readDateTime();
     }
  }
//+------------------------------------------------------------------+
//| Write 200 quotes and read them back                              |
//+------------------------------------------------------------------+
void OnStart()
  {
   WriteCsv("MyCsv.csv",200);

   MyStruct a[];
   ReadCsv("MyCsv.csv",a);

//--- ensure we read the correct number of records
   PrintFormat("Expect %d lines, and read %d lines.",200,ArraySize(a));

//--- print them if you like
   for(int i=0; i<ArraySize(a); i++)
     {
      PrintFormat("%s, %f, %s",a[i].symbol,a[i].close,TimeToString(a[i].time));
     }
  }
//+------------------------------------------------------------------+
