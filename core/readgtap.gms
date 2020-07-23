* ..\core\readgtap.gms

$ontext
Sometimes GAMS has a problem with an empty set. Then one should 
declare a parameter with its dimensions and use $onempty
$offtext

* In current GTAP data the following parameters are empty

$ontext
parameter savg0(r) Government saving;
parameter xdst0(r,g) Stock -- domestic;
parameter xmst0(r,g) Stock -- imported;
parameter labdg0(r) Government employment of labor;
parameter kapdg0(r) Government employment of capital;
parameter xmi0(r,i) Investment demand -- imports;

parameter  agdc(r,t)	domestic consumption of agriculture;
parameter  agmc(r,t)  consumption of agrictural imports;
parameter  eidc(r,t)	domestic consumption of enerint;
parameter  eimc(r,t)  consumption of enerint imports;
parameter  otdc(r,t)	domestic consumption of otherind;
parameter  otmc(r,t)  consumption of otherind imports;
$offtext


* Another way is to declare all parameters

*$include ..%slash%data%slash%eppa5_dec08_gtap7_june09.dat
*$include ..%slash%data%slash%eppa5_aug10_gtap7.dat
*$include ..%slash%data%slash%eppa5_feb10_coal_gtap7.dat

*$include ..\parameters\eppaset.gms


parameters

 savh0(r)	Household saving
 savf0(r)	Foreign savings (capital flows)
 savg0(r)	Government saving
 deprec0(r)	Depreciation
 xdst0(r,i)	Investment -- domestic
 xmst0(r,i)	Investment -- imported
 kstock0(r)	Initial capital stock
 taxh0(r)	Total tax revenue
 trg0(r)	Tax on government purchases
 labdg0(r)	Government employment of labor
 kapdg0(r)	Government employment of capital
 labd0(r,i)	Labor demand
 kapd0(r,i)	Capital earnings
 ffactd0(r,i)	Fixed factor demand
 xdg0(r,i)	Government demand -- domestic
 xmg0(r,i)	Government demand -- imports
 xdi0(r,*)	Investment demand -- domestic
 xmi0(r,*)	Investment demand -- imports
 es0(r,i)	Exports (fob)
 xm0(r,i)	Imports (cif)
 xp0(r,i)	Total production
 xdp0(r,i,j)	Intermediate usage -- domestic
 xmp0(r,i,j)	Intermediate usage -- imports
 xdc0(r,i)	Household demand -- domestic
 xmc0(r,i)	Household demand -- imports
 wtflow0(r,rr,i) World trade flows (fob) -- merchandise
 cons0(r)	Aggregate consumption (gross of tax)
 ptxy0(r,i)	Excise tax revenue
 vst(i,r)	Trade - exports for international transportation
 vtwr(i,j,r,rr)	Trade - Margins for international transportation at world prices
 tf(f,i,r)      Factor tax
 ti(j,i,r)      Intermediate input tax
 tp(i,r)        Tax rate on private demand
 tg(i,r)        Tax rate on government demand
 tx(i,rr,r)     Export tax rate (defined on a net basis)
 tm(i,rr,r)     Import tariff rate
 pg0(i,r)       one plus tg
 pc0            one plus tp
 pf0            one plus tf
 ej_use(i,r)    Total heat consumption (EJ)
 eind(e,i,r)    volume of energy demand (EJ, coverted from mtoe to EJ in uno file)
 efd(e,r)       volume of energy demand - private sector (EJ, coverted from mtoe to EJ in uno file)
 eexp(e,r)      volume of energy trade - sum over destination (export) (EJ, coverted from mtoe to EJ in uno file)
 eimp(e,r)      volume of energy trade - sum over origin (import) (EJ, coverted from mtoe to EJ in uno file)                   

 ;

$ontext

$gdxin '..\data\eppa6data.gdx'
$load savh0 savf0 savg0 deprec0 xdst0 xmst0 kstock0 taxh0 trg0 labdg0
$load kapdg0 labd0 kapd0 ffactd0 xdg0 xmg0 xdi0 xmi0 es0 xm0
$load xp0 xdp0 xmp0 xdc0 xmc0 wtflow0 cons0 ptxy0 vst vtwr
$load tf ti tp tg tx tm pg0 pc0 pf0 ej_use 
$load eind efd eexp eimp 

$offtext

$include %datadir%eppa6data.dat

