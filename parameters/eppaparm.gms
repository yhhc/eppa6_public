* ..\parameters\eppaparm.gms

* This file defines parameters needed for the static model. Some benchmark data,
* noted by x0 in eppadata.gms, are passed to x for endowmnet updating in
* recursive loops. Other parameters are defined from the data to fit model
* specifications.

* Initialization of vintage capital option is also in this file.


*=====================================================================
*       Declare and initialize putty-clay input coefficients, assuming
*       that extant capital has identical characteristics to new 
*       vintage in the base year:

SET     
*        PCLAY(G,R)      Flag for putty-clay capital,
        v               Vintages identified by age /V5,V10,V15,V20/,
        v5(v)           Youngest vintage with rigid coefficients /V5/,
        vintg(g,R)      Pointer to operating vintages
        vintgbs(bt,r)   Backstop technologies with vintage structure
        ;

ALIAS (V,VV);

PARAMETERS

*        X_DE(R,E,G)     Energy input coefficient for extant production
*        X_DF(R,G)       Fixed-factor input coefficient for extant production
*        X_DK(R,G)       Capital input coefficient for extant production
*        X_DL(R,G)       Labor input coefficient for extant production
*        X_K(G,R)        Extant capital endowment

        V_DE(R,E,G,V)   Energy input coefficient for vintage production
        V_DF(R,G,V)     Fixed-factor input coefficient for vintage production
        V_DK(R,G,V)     Capital input coefficient for vintage production
        V_DL(R,G,V)     Labor input coefficient for vintage production
        V_K(G,V,R)      Vintage capital endowment

        vb_da(bt,g,v,r)   Energy input(armington) coefficient for vintaged backstop production
        vb_dh(bt,g,v,r)   Energy input(homogenous) coefficient for vintaged backstop production
        vb_dff(bt,v,r)    Fixed-factor input coefficient for vintaged backstop production
        vb_dk(bt,v,r)     Capital input coefficient for vintaged backstop production
        vb_dl(bt,v,r)     Labor input coefficient for vintaged backstop production
        vb_dc(bt,v,r)     Carbon permit input coefficient for vintaged backstop production
        vb_k(bt,v,r)      Vintage backstop capital endowment fixed
        vb_km(bt,v,r)     Vintage backstop capital endowment malleable
        bin(bt,r)         Total backstop inputs
        vbin(bt,v,r)      Total vintaged backstop inputs
        vbmalshr          Share of vintaged backstop capital that is malleable  

* Vintaged backstop capital output prices by backstop and region
        PPVBK(BT,V,R,T)         Price of vintaged backstop capital - fixed
        VVBK(BT,V,R,T)          Vintaged backstop capital - fixed 
        PPVBKM(BT,V,R,T)        Price of vintaged backstop capital - malleable
        VVBKM(BT,V,R,T)         Vintaged backstop capital - malleable
        TVBK(BT,R,T)            Total vintaged backstop capital 
        VBBOUT(G,VBT,V,R,T)     Vintaged production
        TVBBOUT(G,VBT,R,T)      Total vintaged production
        UNCMARKUP(BT)           A multiplier for uncertainty on markup costs   -UNC-

        CLAY_SHR(G,R)           Benchmark fraction of capital stock which is old
        VINT_SHR(V,R)           SHARE OF BENCHMARK PRODUCTION BY VINTAGE

;


* Parameters for uncertainty  -UNC-
PARAMETER       UNCCH4INDUSTRY(*);
*PARAMETER       ELASHTRN;
*PARAMETER       ELASAGRI;
*       Check the benchmark with the putty-putty model:


PARAMETER	THETA(G,T)        Share of new vintage which is frozen each period
		THETA0(G,R)       Base year share of new vintage which is frozen
		THETAB(BT,T)      Share of backstop capital which is vintaged in each period
;



*       Check the benchmark with the putty-putty model:

*PCLAY(G,R) = NO;        		   
*X_DE(R,E,G) = 0;        		   
*X_DF(R,G) = 0;          		   
*X_DK(R,G) = 0;          		   
*X_DL(R,G) = 0;          		   
*X_K(G,R) = 0;    

vintg(g,r) = no;   
v_de(r,e,g,v) = 0; 
v_df(r,g,v) = 0;   
v_dk(r,g,v) = 0;   
v_dl(r,g,v) = 0;   
v_k(g,v,r) = 0;    
       		   
vintgbs(bt,r) = no;
vb_k(bt,v,r)      = 0;
vb_km(bt,v,r)     = 0;
vb_da(bt,g,v,r)   = 0;
vb_dh(bt,g,v,r)   = 0;
vb_dff(bt,v,r)    = 0;
vb_dk(bt,v,r)     = 0;
vb_dl(bt,v,r)     = 0;
bin(bt,r)         = 0;
vbin(bt,v,r)      = 0;
vbmalshr	  = 0;

**---------------------------------------------------------------------------


*---------------------------------------------------------------------
*       DECLARE PARAMETERS FOR THE SINGLE-PERIOD SUBMODEL:
*---------------------------------------------------------------------

PARAMETER       
                LABOR(R)          LABOR SUPPLY (EFFICIENCY UNITS)
                KAPITAL(R)        CAPITAL SUPPLY
                FFACT(G,R)        FIXED FACTOR SUPPLIES (CURRENT PERIOD)
*		FTFACT(G,GRT,R)   FIXED FACTOR SUPPLIES by type (CURRENT PERIOD)
*		FVTFACT(G,GRT,R)  FIXED FACTOR SUPPLIES by type (new vintage)
                PFBAR(G,R)        LAGGED VALUE OF FIXED-FACTOR RELATIVE PRICE
                STOCK(G,R)        STOCK DEMAND
                GOVDEM(R)         GOVERNMENT DEMAND
                XINVEST0(R)       EXOGENOUS INVESTMENT;

* Energy bundle: (mid-layer in CES, cannot copy from data directly)

PARAMETER       EN0(G,R)          Production
                ENC0(R)           Consumption
                ENG0(R)           Government
                ENI0(R)           Investment;

* CO2 definitions:

PARAMETER       CCOEF(E,R)
                CARBON(R);


* AGGREGATES AND PRODUCTIONS.

PARAMETERS
                LABD(R,G)       LABOR DEMAND
                KAPD(R,G)       CAPITAL DEMAND
                FFACTD(R,G)     FIXED FACTOR DEMAND
                ENE(G,R)        TOTAL SECTORAL ENERGY DEMAND(?)
                KEK(G,R)        CAPITAL-ENERGY SUPPLY(?) 
                EUSE(E,R)       energy use in monetary unit (10 billion dollar)
                EUSEP(E,G,R)    intermediate usage (domestic plus import)
                EUSEF(E,R)
                EPROD(I,R)      Base year volume of energy output (EJ)

                EUSE0(E,R)      energy use in monetary unit (10 billion dollar)
                EUSEP0(E,G,R)   intermediate usage (domestic plus import)   
                EUSEF0(E,R)   
                PMX0(G,R,RR)    GROSS MERCHANDISE PRICE
                PMT0(G,R,RR)    GROSS INTERNATIONAL TRANSPORT PRICE
                PI0(G,I,R)      INTERMEDIATE PRICE GROSS OF TAX;

PMX0(I,R,RR) = (1+TX(I,R,RR))*(1+TM(I,R,RR));
PMT0(I,R,RR) = 1+TM(I,R,RR);
PI0(G,I,R) = 1+TI(G,I,R);

*       CONSUMPTION, GOVERNMENT, INVESTMENT AND STOCK BUILDING.

PARAMETERS
                YDS(R)          TOTAL DISPOSABLE INCOME OF RA
                SAVH(R)         HOUSEHOLD SAVINGS
                ENCE(E,R)       ENERGY DEMAND FOR CONSUMPTION 
*                ence0(e,r)      energy demand for consumption before trans adjustment
                GRG(R)          GOVERNMENT EXPENDITURE
                ENGE(R)         GOVERNMENT DEMAND FOR ENERGY BUNDLE
                SAVG(R)         GOVERNMENT SAVINGS
                TRGG(R)         GOVERNMENT'S TRANSFER TO HOUSEHOLD 
                XINVEST(R)
                INVV(R)         TOTAL INVESTMENT
                ENIE(R)         DEMAND FOR ENERGY BUNDLE BY INVESTMENT
                SAVF(R)         NET FOREIGN SAVINGS

* household transportation input-output coefficients

                owntrn      Output of the household own-supplied transportation sector (household vehicles)                
                purtrn      Output of purchased transportation
                tottrn	    Total output of household transportation, including both purchased plus own-supplied transportation
                tro         Refined oil input to the HH transportation
                toi	    Vehicle fleet rental value as an input to household vehicle transportation
*                trot        Total refined oil use - household vehicles
                tse         Services input to household own-supplied (vehicle) transportation (residual)    
                mvh(r)      Private Purchases of Cars
                es(r)       Own-supply expenditure share
                os(r)       Share of transport usage of refined oil in household sector             
                tefd(e,r)   HH Transport roil use (EJ)
                heusef(e,r)
                teusef(e,r)
                hefd(e,r)   Household energy use EJ
                ftrn(r)     Flag for a carbon policy on HH transport
                hcghg       cghg from non-transport hh activities
                tcghg       cghg from transport hh activities        
                ;


parameters
* parameters from eppaloop
                gres_rev(grt,r)	     gross returns on gas resource
                lgasres(grt,r)	     Previous period resource base
                ini_ffact(ff,r)      initial value of fixed factor supply (ffact)
*                ini_ftfact(ff,grt,r) initial value of fixed factor supply by type (ftfact)
                kapital0(r)          base year non-vintaged capital stock 
                scale(r)             controlling for the k_o ratio
               
* parameters from eppaback
                BRES(BT,R)           Backstop resource supplies
                ;

*------------------------------------------------------------------------
*       ASSIGN BENCHMARK VALUES TO THE PARAMETERS
*------------------------------------------------------------------------

bres(bt,r)      = 0;



* For comparison, add taxes

* In EPPA5, the following three lines are active because there is no value-added tax in EPPA5
* kapd0 and labd0 are assigned in uno_201207.gms from vfm("cap",i,r) and vfm("lab",i,r) in GTAP8, respectively
* In GTAP8, these two vfm parameters do not include value-added tax

*kapd0(r,i) = kapd0(r,i)*(1+tf("cap",i,r));
*kapd0(r,i)$(elec(i)) = kapd0(r,i)*(1+tf("cap",i,r));
*labd0(r,i) = labd0(r,i)*(1+tf("lab",i,r));

ffactd0(r,i) = ffactd0(r,i)*(1+tf("lnd",i,r));
L0(R)    = SUM(I, LABD0(R,I)) + LABDG0(R);

KAPITAL(R) = SUM(G,KAPD0(R,G));
LABOR(R) = L0(R);
FFACT(G,R) = FFACTD0(R,G);
*FTFACT(G,GRT,R)=0;
*FvTFACT(G,GRT,R)=0;
*FTFACT("GAS","CNV",R)= FFACT("GAS",R);
PFBAR(G,R) = 1;
GOVDEM(R) = G0(R);
XINVEST0(R) = INV0(R)-SAVH0(R);
EN0(G,R) = SUM(E, (XDP0(R,E,G)+XMP0(R,E,G))*(1+TI(E,G,R)));

display en0;

alias (e, ee1);

parameter chka1, chka2;

chka1(e,ee1,r) = xdp0(r,e,ee1);
chka2(e,ee1,r) = xmp0(r,e,ee1);

display chka1, chka2;
 

ENC0(R)       = SUM(E,(XDC0(R,E)+XMC0(R,E))*PC0(E,R));
ENG0(R)       = SUM(E,(XDG0(R,E)+XMG0(R,E))*PG0(E,R) ); 
ENI0(R)       = SUM(E,XDI0(R,E)+XMI0(R,E));
EUSE0(E,R)    = sum(G,XDP0(R,E,G)+XMP0(R,E,G))+XDC0(R,E)+XMC0(R,E)            
                  + XDG0(R,E)+XMG0(R,E)+XDI0(R,E)+XMI0(R,E);
                  
EUSEP0(E,G,R) = XDP0(R,E,G) + XMP0(R,E,G);
EUSEF0(E,R)   =  XDC0(R,E) + XMC0(R,E);

* regional energy flow balance
* energy production = energy consumption (intermediate and final) - import + export
EPROD(E,R) = SUM(I, EIND(E,I,R))+EFD(E,R)-EIMP(E,R)+EEXP(E,R);
eprod(e,r)$(eprod(e,r) le 0) = 0;

parameter xchk,x2chk;
xchk(e,r)$euse0(e,r) = ej_use(e,r)/euse0(e,r);
x2chk(e,g,r)$eusep0(e,g,r) = eind(e,g,r)/eusep0(e,g,r);
x2chk(e,"fd",r)$eusef0(e,r) = efd(e,r)/eusef0(e,r);
display xchk,x2chk;


parameter pr2chk;
pr2chk(e,g,r)$eind(e,g,r) = eusep0(e,g,r)/eind(e,g,r);
pr2chk(e,"fd",r)$efd(e,r) = eusef0(e,r)/efd(e,r);
pr2chk(e,g,"tot")$(sum(r, eind(e,g,r))) = sum(r, eusep0(e,g,r))/sum(r,eind(e,g,r));
pr2chk(e,"fd","tot")$(sum (r, efd(e,r))) = sum(r,eusef0(e,r))/sum(r,efd(e,r));


display pr2chk;


display eprod;


*eprod("gas","jpn") = 0;
*eprod("oil","jpn") = 0;

*eprod("coal","jpn") = 0;
*eprod("coal","mes") = 0;
*eprod("coal","asi") = 0;
*eprod("coal","mex") = 0;


*       AGGREGATES AND PRODUCTIONS.

        LABD(R,G) = LABD0(R,G);
        KAPD(R,G) = KAPD0(R,G);        
        FFACTD(R,G) = FFACTD0(R,G);
        ENE(G,R) = EN0(G,R);
        EUSE(E,R) = EUSE0(E,R);
        EUSEP(E,G,R) = EUSEP0(E,G,R);
        EUSEF(E,R) = EUSEF0(E,R);
        KEK(G,R) = KE0(G,R); 
*        rgdp0(r) = cons0(r)+inv0(r)+g0(r)									   
*		  + sum((g,rr),(1+tx(g,r,rr))*(1$(wtflow0(rr,r,g) and not gmarket and not x(g)))*wtflow0(rr,r,g)) 
*		  - sum((g,rr),(1+tx(g,rr,r))*(1$(wtflow0(r,rr,g) and not gmarket and not x(g)))*wtflow0(r,rr,g)) 
*		  + sum(x, PWh.l(x)*HOMX0(X,R)*homx.l(x,r))							 
*		  - sum(x, pwh.l(x)*homm0(x,r)*MQHOM_.l(X,R));                                                     



*execute_unload "..\eppaparm.gdx" 

parameter ej_con;
ej_con(e,r)$euse(e,r) = ej_use(e,r)/euse(e,r);
display ej_con;

*       POPULATION INDEX:

        POPINDEX(R) = 1;

*       CONSUMPTION, GOVERNMENT, INVESTMENT AND STOCK BUILDING.

        YDS(R) = CONS0(R);
        SAVH(R) = SAVH0(R);
        ENCE(E,R) = XDC0(R,E)+XMC0(R,E);
*        ence0(e,r) = ence(e,r);
        GRG(R) = G0(R);
        ENGE(R) = ENG0(R);
        SAVG(R) = SAVG0(R);
        TRGG(R) = TRG0(R);
        XINVEST(R) = XINVEST0(R);
        INVV(R) = INV0(R);
        ENIE(R) = ENI0(R);
        SAVF(R) = SAVF0(R);

ACTIVE(BT,R) = NO;

* Private purchases of cars
mvh("USA") =  22.5189;    	       
mvh("CAN") =   2.9064;                 
mvh("MEX") =   0.2175;                 
mvh("JPN") =   4.7019;                 
mvh("ANZ") =   1.3190;                 
mvh("EUR") =  38.9456;                 
mvh("ROE") =   1.2853;                 
mvh("RUS") =   0.8800;                 
mvh("asi") =   1.3149;                 
mvh("kor") =   1.1923;                 
mvh("idz") =   0.5044;                 
mvh("CHN") =   0.3641;                 
mvh("IND") =   0.0672;                 
mvh("AFR") =   1.0635;                 
mvh("MES") =   1.5811;                 
mvh("BRA") =   1.4482;                 
mvh("LAM") =   0.8065;                 
mvh("REA") =   0.2777;          

es("USA") = 0.104;    	       
es("CAN") = 0.129;                 
es("MEX") = 0.070;                 
es("JPN") = 0.070;                 
es("ANZ") = 0.104;                 
es("EUR") = 0.134;                 
es("ROE") = 0.085;                 
es("RUS") = 0.087;                 
es("asi") = 0.068;                 
es("kor") = 0.068;                 
es("idz") = 0.068;                 
es("CHN") = 0.042;                 
es("IND") = 0.084;                 
es("AFR") = 0.098;                 
es("MES") = 0.053;                 
es("BRA") = 0.09 ;                 
es("LAM") = 0.06 ;                 
es("REA") = 0.06 ;          

* Changed share to make refined oil consumption consistent with forecasted data.
* New shares (10/3/2011) are based on adjustments using estimates from GMID

os("USA") = 0.988;
os("CAN") = 0.921;
os("MEX") = 0.862;
os("JPN") = 0.829;
os("ANZ") = 0.992;
os("EUR") = 0.855;
os("ROE") = 0.388;	
os("RUS") = 0.990;
os("asi") = 0.850;
*os("kor") = 0.850; => tse becomes negative!
os("kor") = 0.8;
*os("idz") = 0.850; => tse becomes negative!
os("idz") = 0.45;
*os("CHN") = 0.995; => tse becomes negative!
os("chn") = 0.85;
*os("IND") = 0.900; => tse becomes negative!
os("ind") = 0.45;
os("AFR") = 0.875;	     
os("MES") = 0.323;	     
os("BRA") = 0.900;	     
os("LAM") = 0.854;
os("REA") = 0.443;

hefd(e,r) = efd(e,r);
*purtrn(r) = xdc0(r,"tran") + xmc0(r,"tran");
tefd("roil",r)   = os(r)*efd("roil",r);
hefd("roil",r)   = (1-os(r))*efd("roil",r);


* The followings are from defaultparams.gms in EPPA 5:

* AGRI is handled differently, which might be wrong, but Sergey was going to look into it (11 Aug 2005)
*ELASAGRI = 0.3;

* Always include this value;  not defined in a table
*ELASHTRN = 0.4;

* ----------------------------------------------------------------------------
*  Vintaging defaults (fraction of capital stock fixed)
* ----------------------------------------------------------------------------
* These values are delcared in eppaparams.gms.  They are modified
* in the coll files by overriding the values.
*
*       Assume that vintaging is carried throughout the horizon:
*

THETA0(G,R)      = 0.3;
THETA0("elec",R) = 0.7;
THETA(G,T)       = 0.3;
THETA("elec",T)  = 0.7;
THETAB(VBT,T)    = 0.7;
VBMALSHR         = 0;

*theta0(g,r)      = 0.3;
*theta(g,t)       = 0.3;

* ----------------------------------------------------------------------------
*  Methane initial inventories by sector
* ----------------------------------------------------------------------------
* These values are used in kyotogas_aaa.gms.  They are modified
* in the coll files by overriding the values.
*
* Typical usage:  ghginv("AGRI",ch4,r)= ghginv("AGRI",ch4,r)*UNCCH4INDUSTRY("AGRI");
*
UNCCH4INDUSTRY(AGRI)       = 1;
UNCCH4INDUSTRY("COAL")     = 1;
UNCCH4INDUSTRY("GAS")      = 1;
UNCCH4INDUSTRY("OIL")      = 1;
UNCCH4INDUSTRY("EINT")     = 1;
UNCCH4INDUSTRY("LANDFILL") = 1;
UNCCH4INDUSTRY("DSEWAGE")  = 1;
UNCCH4INDUSTRY("OTHR")     = 1;
UNCCH4INDUSTRY("FD")       = 1;
UNCCH4INDUSTRY("FOOD")     = 1;

* ----------------------------------------------------------------------------
*  Markup for backstop technologies
* ----------------------------------------------------------------------------
* These values are used in eppaback.gms.  They are modified
* in the coll files by overriding the values.
*
* Typical usage:  BADJST("IGCAP","MEX") = 3.00*UNCCAP("IGCAP")/1.18;
*
UNCMARKUP("IGCAP")    = 1.18;
UNCMARKUP("NGCAP")    = 1.15;
UNCMARKUP("NGCC")     = 0.90;
UNCMARKUP("BIO-OIL")  = 3.8;
UNCMARKUP("BIOELEC")  = 3.8;
UNCMARKUP("SYNF-OIL") = 2.8;
UNCMARKUP("SYNF-GAS") = 3.5;

parameters 
rgdp0(r)    Base year real GDP level of region r
simu        Control for exogenous productivity
gprod0(r)   Current period gprod
consump(r)  first period consumption level (acm) - used in eppaloop
fadj(r,ff)  adjustment for fossil fuel current period endowment
radj(r,ff)  reserve adjustment factor

c0(r)       original sum
shf(r,g)    share shifter
xdc1(r,g)   temporary xdc0
xmc1(r,g)   temporary xmc0
*ence1(e,r)  temporary ence
c1(r)       temporary c0
aeei(r,*)   aeei coefficient

xdi0_(r,g)  original xdi0
xdc0_(r,g)  original xdc0
inv0_(r)    original inv0   
cons0_(r)   original cons0
tp_(g,r)    original tp
pc0_(g,r)   original pc0
;

rgdp0(r)       = 0;
simu           = 0;
gprod0(r)      = 0; 
radj(r,ff)     = 1;
radj(r,"coal") = 2;
radj(r,"oil")  = 2;
radj(r,"gas")  = 2;
fadj(r,ff)     = 1;

c0(r)          = sum(nend,xdc0(r,nend)+xmc0(r,nend))
                 +sum(dwe,xdc0(r,dwe)+xmc0(r,dwe))
*                 +sum(e,ence(e,r))
                ; 
shf(r,g)       = 1;
xdc1(r,g)      = xdc0(r,g)*shf(r,g);
xmc1(r,g)      = xmc0(r,g)*shf(r,g);
*ence1(e,r)     = ence(e,r);
c1(r)          = sum(nend,xdc1(r,nend)+xmc1(r,nend))
                 +sum(dwe,xdc1(r,dwe)+xmc1(r,dwe))
*                 +sum(e,ence1(e,r))
                ;
aeei(r,g)      = 1;
aeei(r,"fd")   = 1;                 
xdi0_(r,g)     = 0;
xdc0_(r,g)     = 0;
inv0_(r)       = 0;
cons0_(r)      = 0;
tp_(g,r)       = 0;
pc0_(g,r)      = 0;

*-----------------------------------------------------------------------------
*       DEFINE SOME PARAMTERS FOR CARBON LIMITS.
*--------------------------------------------------------------------------
PARAMETER

        CJ(E,R)         Adjustment factor for epslon
        TTCO2           Tradable CO2 emission permit flag
        TCARBLIM(R)     Tradable CO2 emission permit (by region)
        SCARBLIM(G,R)   Sectoral carbon limits
        FCARBLIM(R)     Limit on carbon emissions from final demand sector
        CARBLIM(R)      Non-tradable CO2 emisssion permits
        cafelim(r)      cafe standard efficiency requirement
        ;


 TTCO2           = 0;
 TCARBLIM(R)     = 0;
 CARBLIM(R)      = 0;
* CJ(E,R)         = 1;
 SCARBLIM(G,R)   = 0;
 FCARBLIM(R)     = 0;
 cafelim(r)      = 1;

parameters
        pcarbpath       trajectory of carbon taxes
        pghgpath        trajectory of ghg taxes
        pcarbtarg       intra-period carbon tax target
        pghgtarg        intra-period ghg tax target
;


pcarbpath(r,t)          =       0;
pghgpath(ghg,r,t)       =       0;
pcarbtarg(r)            =       0;
pghgtarg(ghg,r)         =       0;

* The following parameters were declared in eppacore and are now moved here:
parameters
ghglim(ghg,r)      policy limit on ghg gas emissions
ghglimg(ghg,*,r)   policy limt on ghg gas emissions by sector
ghgt               flag to activate trading among ghg gases 
ghg_gwp            flag for gwp trading
ghg_gp(ghg,r)      flag for ghg trading at gwps
ghg_gw(ghg)        flag for ghg gases traded across regions
scarblim(g,r)      sectoral carbon limit
biot               flag for bio-oil trading
gmarket            flag for regional gas market
fdf(r)             flag for specific final demand ghg constraint
ttco2              flag for tradable co2 emission permit
wghgk              flag to activate cross-country trading of ghg gases
taxins(r)          flag for indogenous tax replacement instrument
ctaxf(r)           control for a fixed carbon price target
*pcarbtarg(r)       intra period carbon target - defined in eppatrend
ntarget            nuclear target in japan relative to 1995
*ptarget(g,r)       target price for fossil fuels
carblim(r)         non-tradable co2 emissions permit   
pcarblag      
*epslon(e)       
ej_95d(r,e)        energy transformation coefficient     
curb(urb,*,*,r)    non-ghg gases (associated with consumption) 
phi(r)             rps constraint
co2tax(e,r)
cj(e,r)            adjustment factor for epslon
*cghg(ghg,e,g,r)   defined in eppaghg.gms
ghg_gwc(r)         flag for regions where ghgs are traded across them

d0(r,g)            domestic supply
outco2(r,g)        trend-adjusted co2 from production -agr and cement
outco20(r,g)	   initial co2 from production
oghg(*,*,r)        greenhouse gases (associated with production)
ourb(urb,*,r)      non-greenhouse gases (associated with production)
*elekadj(g,r)       static parameter giving decline in input shares in electric sector 
fcghg(*,*,r)
gwp(*)             100 year gwp converts to co2 equivalent in 100 tons           
w0(r)              base year welfare index over consumption and saving

tcarblim(r)        tradable co2 emission permit (by region)            
fcarblim(r)        limit on carbon emissions from final demand sector
urblim(urb,r)      Policy limit on non ghg gas emissions
;

*	Initially no limits:
urblim(urb,r)       = 0;
ghglim(ghg,r)       = 0;
ghglimg(ghg,g,r)    = 0;   
ghglimg(ghg,"fd",r) = 0;

parameters

gu(*)              non-CO2 gases conversion unit
cshr(r)            addtional cost share coefficient for cafe standard
;

cshr(r) = 0.01;

parameter
cstar(r,g)         Stone-Geary subsistence consumption
;

cstar(r,g) = 0;

* define a growth differention index
parameter nugm flag for factor productivity differentiation (1 = on);
nugm=0;

parameters
nper        value of nper
nper_start  value of nper_start
;

parameters 
biofgsub(r)  subsidy rates on first generation biofuels
windsub(r)   subsidy rates for wind pwr
solarsub(r)  subsidy rates for solar pwr
bioesub(r)   subsidy rates for bioelec pwr
;

biofgsub(r) = 0;
windsub(r)  = 0;
solarsub(r) = 0;
bioesub(r)  = 0;

parameters

oghg_   adjusted oghg     
cghg_   adjusted cghg 
hcghg_  adjusted hcghg
tcghg_  adjusted tcghg
fcghg_  adjusted fcghg
ourb_   adjusted ourb
curb_   adjusted curb

;

oghg_(ghg,g,r)       = 0;
cghg_(ghg,e,g,r)     = 0; 
hcghg_(ghg,e,"fd",r) = 0;
tcghg_(ghg,e,"fd",r) = 0;
fcghg_(ghg,"fd",r)   = 0;
ourb_(urb,g,r)       = 0;
curb_(urb,e,g,r)     = 0;

parameters
gemkup(e,g,r)  markup on extant sector's energy input
;

gemkup(e,g,r) = 1; 

parameters
emkup(*,r)        markup for fossil generation
mkup(g,r)         markup for sector
eid_ghg_up(e,g,r) upper bound for eid_ghg

;
emkup("coal",r)    = 1;
emkup("gas",r)     = 1;
emkup("roil",r)    = 1;
mkup(g,r)          = 1;
eid_ghg_up(e,g,r) = 0;


parameters 
urbtrend(urb,r) control for the trend of urban pollutants
cexp(r,g)       summation of xdc0 plus xmc0
xa(r,i,g)       adjusted xdp0 plus xmp0
sa(r,i,g)       xa divided by the sum of xdp0 and xmp0
;

urbtrend(urb,r) = 0;
sa(r,i,g)       = 1;

