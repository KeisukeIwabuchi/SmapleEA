#property strict
#property version   "1.00"


#include <Template_1.01.mqh>


double Lots        = 0.1; // 取引数量
int    MagicNumber = 123; // ロット数
double TP          = 100; // 損切り(pips)
double SL          = 100; // 利食い(pips)
double Slippage    = 1.0; // スリッページ(pips)
extern double Step = 0.02;
extern double Maximum = 0.2;


int TradeBar = 0;
int Mult = 10;


int OnInit()
{
   TradeBar = Bars;
   Mult = (Digits == 3 || Digits == 5) ? 10 : 1;

   return(INIT_SUCCEEDED);
}


void OnTick()
{
   double buy_pos = getOrderCount(OP_BUY, MagicNumber);
   double sell_pos = getOrderCount(OP_SELL, MagicNumber);

   int entry_signal = getEntrySignal();
   
   if (entry_signal == 1 && buy_pos == 0 && TradeBar != Bars) {
      if (sell_pos > 0) {
         if (Exit(Slippage, MagicNumber) ==false) {
            return;
         }
      }
      if (EntryWithPips(OP_BUY, Lots, Ask, Slippage, SL, TP, COMMENT, MagicNumber)) {
         TradeBar = Bars;
      }
   }
   if (entry_signal == -1 && sell_pos == 0 && TradeBar != Bars) {
      if (buy_pos > 0) {
         if (Exit(Slippage, MagicNumber) ==false) {
            return;
         }
      }
      if (EntryWithPips(OP_SELL, Lots, Bid, Slippage, SL, TP, COMMENT, MagicNumber)) {
         TradeBar = Bars;
      }
   }
}


void OnDeinit(const int reason)
{
   Comment("");
}


int getEntrySignal()
{
   double sar1 = iSAR(_Symbol, 0, Step, Maximum, 1);
   double sar2 = iSAR(_Symbol, 0, Step, Maximum, 2);

   if (sar1 > Close[1] && sar2 < Close[2]) {
      return(1);
   }
   if (sar1 < Close[1] && sar2 > Close[2]) {
      return(-1);
   }

   return(0);
}
