# mql4-lib-examples

Examples that illustrate the use
of [mql4-lib](https://github.com/dingmaotu/mql4-lib)


## Introduction

This is a repository mainly used for demonstrating the power of the mql4-lib.
The programs here, however, could be very useful for traders. Thus, this library
serves another purpose for sharing free **AND** open source high quality MQL
programs for traders.

I encourage users of the mql4-lib share their code for the benefit of all. Of
course you can keep your secret money-making strategy, but most indicators,
scripts, and EAs do not have the potential of making money on their own. These
tools can be useful as enhancements to MetaTrader, or partially automate some
aspects of trading.

## Installation

You should first install [mql4-lib](https://github.com/dingmaotu/mql4-lib) and
then deploy this project to the `Projects` folder or merge this project to the
MQL4/5 folder. Note that these programs are only tested in MT4. Some of them
will support MT5. As I plan to make the mql4-lib MT5 compatible, most programs
of this repository will support MT5 in the future.

## Example List

1. *ButtonDemo* is an EA that illustrates the structure of a basic UI app. Since
   the UI part of mql4-lib is far from finished, you are advised not to use
   these features in your production EA.

2. *PriceBreakChart* is an implementation of Price Break Chart. It is a
   production ready EA for generating offline charts. It supports tick volume
   and dynamic reloading while changing timeframes.
   
3. *DeMarker* shows the structure of a reusable indicator. I will add an example
   later how to use the DeMarker indicator with a Renko Chart.
   
4. *CsvFile* shows how to use the File System and IO API of mql4-lib to
   read/write CSV files.

