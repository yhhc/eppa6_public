* /parameters/eppa_htrn.gms



parameter vfe(r) vehicle fuel economy - new and used /
USA	20.05095245
ASI	19.89583548
CAN	21.44490753
CHN	22.33119943
MEX	16.55279634
IND	28.15419995
JPN	28.78577469
BRA	25.46198341
ANZ	21.70337682
AFR	23.42518325
EUR	27.09193786
MES	15.06821262
ROE	23.9453508
LAM	18.0704837
RUS	23.38882841
REA	21.71352233
/;


* Calculate inputs to household transportation


parameters
$ontext
owntrn      Output of the household own-supplied transportation sector (household vehicles)
owntrn0     Output of the household own-supplied transportation sector in the base year
purtrn      Output of purchased transportation
tottrn	    Total output of household transportation, including both purchased plus own-supplied transportation
tro         Refined oil input to the retail fuel sector, which is used in household vehicle transportation
*trot	    Total refined oil use - household vehicles
toi	    Vehicle fleet rental value as an input to household vehicle transportation
tse         Services input to household own-supplied (vehicle) transportation (residual)
$offtext
ptoi	    Other industries inputs to the manufacturing of the propulsion system
pstot	    Total output of vehicle propulsion technology (4 types)
pstotvin
psivin	    Output of used ICE vehicles
pspvin      Output of used PHEVs
psevin	    Output of used EVs
propfrac    Fraction of vehicle capital expenditures devoted to propulsion system
owntrnvin   Total output of used vehicles produced in the base year
owntrnnew   Total output of new vehicles produced in the base year
owntrntot   Total output of household own-supplied transportation benchmarked on VMT driven in base year
trov        Refined oil input to vintaged household vehicle transport (used vehicles)
ptoiv	    Vintaged propulsion system capital (used vehicles)
toiv        Vintaged non-propulsion system vehicle capital (used vehicles)
tsev        Services required for vintaged vehicle capital (used vehicles)
vmt_0       Vehicle-miles traveled in the base year, in trillions
xbar	    Subsistence level of household transportation activity (for Stone-Geary preferences)
xbar0	    Base year initial value of xbar, by region
tottrn0	    Base year transportation demand
htrne	    Household transportation elasticity
htrnn	    Updated household transport income elasticity to account for rising per capita income
altrn	    Initial share of transport in household consumption
vehstk0     Vehicle stock in base year 
vehstk(r,t)      Vehicle stock by region
trosn	    Refined oil expenditure share
toisn	    Other industries expenditure share
tsesn	    Services expenditure share
ptoisn	    Powertrain capital expenditure share
gdpv
poptr
ceusef      Conventional fuel used by household vehicles
biouse      Bio-oil input to transportation
pcit	    Per capita income threshhold to move to lower income elasticity of demand

;



* Calculation of inputs to household transportation. Propulsion system is assumed to account for 15% of vehicle capital
* expenditures.

owntrn(r) = es(r)*cons0(r);
owntrn0(r) = owntrn(r);

* Allocate transportation expenditures between used vehicles (60%) and new vehicles (40%) on a milest-traveled basis.

owntrnvin(r) = owntrn(r)*0.6;
owntrnnew(r) = owntrn(r)*0.4;

owntrnvin(r) = owntrn(r)*0.0;
owntrnnew(r) = owntrn(r)*1.0;


toi(r) = mvh(r);

propfrac(r) = 0;


toiv(r) = 0;
toi(r) = toi(r) - toiv(r);

ptoi(r) = toi(r)*propfrac(r);
toi(r) = toi(r) - ptoi(r);

ptoiv(r) = toiv(r)*propfrac(r);
toiv(r) = toiv(r) - ptoiv(r);

trot(r) = os(r)*ence("roil",r);
tro(r) = trot(r)*(owntrnnew(r)/owntrn(r));
trov(r) = trot(r)*(owntrnvin(r)/owntrn(r));



*tse(r) = (owntrnnew(r) - tro(r)*pc0("roil",r) - (toi(r) + ptoi(r))*pc0("othr",r))/pc0("serv",r);

*tsev(r) = 0;

*pstot(r) = tro(r)*pc0("roil",r) + ptoi(r)*pc0("othr",r);

* Used fleet outputs in base year
$ontext
psivin(r) = trov(r)*pc0("roil",r) + ptoiv(r)*pc0("othr",r);
pstotvin(r) = psivin(r);
pspvin(r) = 1;
psevin(r) = 1;
$offtext

xdc0(r,"tran") = 0;
xmc0(r,"tran") = 0;
*$offtext
tottrn(r) = purtrn(r)*pc0("tran",r) + owntrnnew(r) + owntrnvin(r);
*$offtext

*display owntrn, tro, toi, tse, ptoi, trov, toiv, tsev, ptoiv;

* Set subsistence level of household transportation activity.

xbar0(r) = 0;
xbar(r) = xbar0(r);

owntrn0(r) = owntrn(r);

altrn(r) = (owntrn0(r)/cons0(r));

display altrn;

* Household transportation elasticity
htrne(r) = 1.0;
htrne("USA") = 0.70;
htrne("EUR") = 0.70;
htrne("JPN") = 0.675;
htrne("LAM") = 1;
htrne("ROE") = 0.85;
htrne("CHN") = 1.125;
htrne("ANZ") = 0.70;
htrne("BRA") = 1;
htrne("AFR") = 0.70;
htrne("REA") = 1;
htrne("IND") = 1;
htrne("MES") = 1;
htrne("ASI") = 0.70;
htrne("kor") = 0.70;
htrne("idz") = 0.70;
htrne("CAN") = 0.70;
htrne("MEX") = 1;
htrne("RUS") = 0.70;

htrnn(r) = htrne(r);


* Define per-capita income threshhold for implementing lower VMT elasticity value.

pcit(r) = 7.5;

xbar(r) = altrn(r)*cons0(r)*(1-htrne(r))/((1-altrn(r))*htrne(r));

* To use per-capita income to drive growth of VMT.

parameter constr, a_hat, b_hat, gdpv0, poptr0;

vehstk0("USA") = 200.9;
vehstk0("EUR") = 215.6;
vehstk0("JPN") = 76.3;
vehstk0("LAM") = 11;
vehstk0("ROE") = 27.8;
vehstk0("CHN") = 26.4;
vehstk0("ANZ") = 14.9;
vehstk0("BRA") = 20.8;
vehstk0("AFR") = 6.9;
vehstk0("REA") = 13.9;
vehstk0("IND") = 17.4;
vehstk0("MES") = 6.8;
vehstk0("ASI") = 21.9;
vehstk0("CAN") = 18.2;
vehstk0("MEX") = 16.7;
vehstk0("RUS") = 20;

* adjust roil if HH transport is not carbon constrained

parameter ftrn(r) Flag for a carbon policy on HH transport;

* 1 = carbon price on roil in HH transport (usual EPPA)
* 0 = no cabon policy in HH transport

ftrn(r) = 1;

* VJK - added ethanol and biodiesel numbers from Suhail's code.

*===================================
parameter eugoal1  actual EU ethanol consumption gross rate;
parameter eugoal2  actual EU biodiesel consumption gross rate;
parameter usgoal1   actual US ethanol consumption (billion gal);
parameter usgoal2   actual US biodiesel consumption (billion gal);
parameter eugoal1v  actual EU ethanol consumption (billion gal);
parameter eugoal2v  actual EU biodiesel consumption (billion gal);
* ==========================================================================
* ADJUSTMENTS FOR MANDATES ON BIOFUELS
eugoal1(t) = 0;
eugoal2(t) = 0;
usgoal1(t) = 0;
usgoal2(t) = 0;
eugoal1v(t) = 0;
eugoal2v(t) = 0;

* end VJK

* Sharing out expenditures on petroleum-based fuel

parameter heusef(e,r), teusef(e,r);

heusef(e,r) = eusef(e,r);
heusef("roil",r) = heusef("roil",r) - tro(r) - trov(r);
teusef(e,r) = 0;
teusef("roil",r) = tro(r) + trov(r);
*teusef("roil",r) = tro(r);

ceusef(e,r) = 0;
ceusef("roil",r) = teusef("roil",r);

biouse(e,r) = 0;

* VJK : from Suhail (hard number indicates fraction of fuel on energy basis from 1st gen biofuels.

parameters conveusef(e,r), biouse10(e,r), biousep(e,g,r), conveusep(e,g,r);

conveusef(e,r)=0;
conveusef(e,r)=teusef(e,r);
biouse10(e,r)=0.06818*teusef(e,r);

* teuse

biousep(e,g,r)=0;
conveusep(e,g,r)=0;
conveusep(e,g,r)=eusep(e,g,r);

* adjustments for biofuel mandates

parameter cornmax, celtar, cel;
cel(r)=no;
cornmax(r,e)=0;
celtar(r)=0;
*===================================

* end VJK

parameter hefd(e,r) Household energy use EJ, 
	tefd(e,r) HH Transport roil use EJ;

hefd(e,r) = efd(e,r);
tefd(e,r) = 0;
tefd("roil",r) = os(r)*efd("roil",r);
hefd("roil",r) = hefd("roil",r) - tefd("roil",r);

parameter vmt_n;
vmt_n(r) = tefd("roil",r)*(7589556769)*vfe(r)*0.4/1000000000000;

parameter vmt_u;
vmt_u(r) = tefd("roil",r)*(7589556769)*vfe(r)*0.6/1000000000000;

vmt_0(r) = vmt_n(r) + vmt_u(r);

display vmt_0;


parameter convtefd;
convtefd(e,r)=tefd(e,r);

parameter hcghg, tcghg;


tcghg(ghg,e,"fd",r) = 0;


* (temporarily set)
hcghg(ghg,"roil","fd",r) = 0;

display eusep, heusef, hefd, tefd;


parameters
   deltafc(r,t)             Annual percentage change in the fuel consumption in gallons per mile
   deltapop(r,t)            Annual percentage change in the population of a region in a given year
   deltaveh(r,t)            Annual percentage change in the vehicle fleet (for regions with fleet growth greater than population growth)
   lamdahtrn(r,t)		fuel efficiency
   lamdahtrnvin(r,t)	    Updated fuel efficiency for vintaged fleet

* Fuel economy in 2004 (new fuel numbers)

parameter fuec2004(r) /
USA       0.270
CAN       0.321
MEX       0.033
JPN       0.189
ANZ       0.216
EUR       0.275
ROE       0.312
RUS       0.148
ASI       0.167
CHN       0.043
IND       0.004
BRA       0.149
AFR       0.138
MES       0.319
LAM       0.083
REA       0.204
/;

* Fuel economy trend

parameter fect(r,t);

parameter cfe(r);

cfe(r) = no;


* Assumption about the rate of vehicle fuel efficiency improvment - this is no longer used (Valerie).

DELTAFC(R,T) = 0;

*DELTAFC("USA",T) = 0.005;
DELTAFC("USA",T) = 0;

* Fleet grows faster than population in India and China for specified period.

DELTAVEH(R,T) = 0;

* (temporarily deactivate) deltapop(r,t)$population(r,t-1) = ((population(r,t)/population(r,t-1))**(1/5)-1);

deltapop(r,"2007") = 0;

display deltapop;

*== Code added for CNG vehciles
*   Calculate energy per unit of CNG and GHG emissions per unit from CNG use in household demand

PARAMETER
ENG_CNG(r)	Energy per unit of CNG
GHG_CNG(ghg,r)	GHG emissions per unit of CNG;

ENG_CNG(r) =     HEFD("gas",R)/HEUSEF("gas",R);
*ENG_CNG(r) =     HEFD("gas",R)/HEUSEF("gas",R);

GHG_CNG(ghg,r) = HCGHG(GHG,"gas","fd",r)/HEUSEF("gas",R);

*== CNG end

parameter chk_cngg;

chk_cngg("hefd",r) = HEFD("gas",R)/HEUSEF("gas",R);
chk_cngg("ejuse",r) = EJ_USE("gas",R)/EUSE("gas",R);

display chk_cngg;

* Tax on household transport (tpv) to account for short payback period on investment in vehicle efficiency.
* Default : set equal to tp("othr,r)

parameter tpv, tpe, tpf;

*display tp("othr",r);

tpv("othr",r) = tp("othr",r);

* Tax on electricity used in household transport.

tpe("elec",r) = 0;

* Tax on fuel used in household transport.

tpf(e,r) = 0;
* (temporarily deactivate) tpf(e,r) = co2tax(e,r);





execute_unload "..\eppa_htrn.gdx";