* ..\parameters\eppaset.gms

* This file defines the sets and subsets of the EPPA model.

* Regions

SET     R   REGIONS 
/
	USA	United States
	CAN	Canada
	MEX	Mexico
	JPN	Japan
	ANZ	Australia - New Zealand
	EUR	Europe
	ROE	Eastern Europe
	RUS	Russia Plus
	ASI	East Asia
	CHN	China	
	IND	India
	BRA	Brazil
	AFR	Africa
	MES	Middle East
	LAM	Latin America
	REA	Rest of Asia 
        KOR     South Korea
        IDZ     Indonesia
/;

set f factors

/
lnd	"Land"
lab	"Labor"
cap	"Capital"
fix	"Natural resources"
/;

* VJK (Dulles)

* Flag to Dulles changes in agricultural and food demand:

set dulles(r);
dulles(r) = no;

* Subset of regions: for reporting and policy simulation purposes

SET     OECD(R)        /USA, CAN, JPN, EUR, ANZ, kor/;
SET     LDC(R)         /MEX, ROE, RUS, ASI, CHN, IND, BRA, AFR, MES, LAM, REA, kor, idz/;
set     ldc_rich(ldc)  /MEX, BRA, ASI, LAM, kor, idz/;
set     ldc_poor(ldc)  /AFR, IND, REA/;
set     ldc_mes(ldc)   /MES/;

* VJK : transferred sets from Suhail's version for mandate and LUC

SET	EU(R) /EUR, ROE/;
SET	US(R) /USA/;
SET	JPN(R) /JPN/;
SET	RUS(R) /RUS/;
SET	CANE(R)	/AFR, IND, BRA, LAM, MEX, ANZ, REA/;
SET	BEET(R)	/EUR, ROE, USA, RUS, JPN, CHN, MES/;
SET	RAPE(R)	/CAN, EUR, ROE, CHN,  ANZ, IND, USA, AFR, LAM/;
SET	SOY(R)	/USA, CAN, MEX,JPN, ANZ, LAM, BRA, CHN, ASI, IND, AFR, REA, MES, kor, idz/;
SET	PALM(R)	/ AFR, ASI, kor, idz/;
SET	CORNRE(R)  /AFR, CAN, CHN, ROE, EUR, REA, LAM, MEX, ASI, USA, MES, IND, ANZ, RUS, BRA, kor, idz/;
SET	WHEATRE(R) /MEX, MES, LAM, USA, AFR, ANZ, CAN, CHN, ROE, IND, JPN, RUS, EUR, BRA/;

set     usa(r) /usa/;
set     coof(r) /asi/;
        coof(r) = no;

* QJE: eppa5 regions
SET R_E5(R) EPPA5 Regions
/
	USA	United States
	CAN	Canada
	MEX	Mexico
	JPN	Japan
	ANZ	Australia - New Zealand
	EUR	Europe
	ROE	Eastern Europe
	RUS	Russia Plus
	ASI	East Asia
	CHN	China	
	IND	India
	BRA	Brazil
	AFR	Africa
	MES	Middle East
	LAM	Latin America
	REA	Rest of Asia 
/;




* Production sectors

SET     I  SECTORS /
	CROP	Agriculture - crops    
	LIVE	Agriculture - livestock
	FORS	Agriculture - forestry
	FOOD	Food products
	COAL	Coal
	OIL	Crude Oil
	ROIL	Refined Oil
	GAS	Gas
	ELEC	Electricity
	EINT	Energy-intensive Industries
	OTHR	Other Industries
	SERV	Services
	TRAN	Transport
        DWE     Ownership of dwellings
*	CGD	Savings Good 
/;

set     ncl(i) sectors others than crop and live      
        / 
	FORS	Agriculture - forestry
	FOOD	Food products
	COAL	Coal
	OIL	Crude Oil
	ROIL	Refined Oil
	GAS	Gas
	ELEC	Electricity
	EINT	Energy-intensive Industries
	OTHR	Other Industries
	SERV	Services
	TRAN	Transport
        DWE     Ownership of dwellings
        /;

set     cl(i)   sectors of crop and live
        /
        crop    Agriculture - crops    
        live    Agriculture - livestock
        /;

* Subset of production sectors

*SET     NE(I) NON-ENERGY COMMODITIES /crop, live, fors, food, EINT, OTHR, serv, tran, CGD/;
SET     NE(I) NON-ENERGY COMMODITIES                  /crop, live, fors, food, EINT, OTHR, serv, tran, dwe/;
set     nend(ne) non-energy commodities excluding dwe /crop, live, fors, food, EINT, OTHR, serv, tran/;
set     dwe(ne)  ownership of dwellings               /dwe/;
*set     nendf(ne) non-energy commodities excluding dwe and food  /crop, live, fors, EINT, OTHR, serv, tran/;
set     food(ne)  food sector                         /food/;
SET     E(I) ENERGY COMMODITIES                       /COAL, OIL, GAS, ROIL, ELEC/;
SET	NEA(NE) NON-ENERGY COMMODITIES AND NON AGRI   /EINT, OTHR, serv, tran, dwe/;
SET     ENOE(I) NON-ELEC ENERGY COMMODITIES           /COAL, OIL, GAS, ROIL/;
SET     ELEC(I) ELEC ENERGY COMMODITIES               /ELEC/;
SET     NEST(I)  ENERGY NESTING FLAGS                 /
		                                       COAL    a  	   
			   			       OIL     b  
			   			       GAS     c  
			   			       ROIL    d  
			   			       ELEC    e
                                                      /;

SET	KSI(I) CAPITAL-SPECIFIC INDUSTRIES /COAL, OIL, GAS, ROIL, ELEC, EINT/;
SET     X(I) Homogenous goods /OIL/;
*SET     X(I) Homogenous goods /OIL, GAS/;
*SET	CGD(I) /CGD/;
SET     OIL(I) OIL /OIL/;
SET     GAS(I) GAS /GAS/;
set	roil(i) /roil/;
set	coal(i) /coal/;
set	oil_col(enoe) /roil, coal/;
set	refo(e) /roil/;
SET     AGRI(I) Agriculture /crop, live, fors/,
	EINT(I) Energy intensive /eint/;
SET	TRANSFUEL(I)	SECTOR USING FUEL AS TRASNPORTATION /CROP, SERV, TRAN/;
SET     AENOE(I) /COAL, OIL, GAS, ROIL, crop, live, fors, ELEC, EINT/;
SET	VEHIFUELP(E) /ROIL/;
*SET		OTE(NE) /EINT, OTHR/;
SET		AGDEV(R) Agri-consumer developing countries /CHN, IND, REA, BRA, AFR/;

* VJK (LUC)

* LUC: Land use categories

set	AGRIF(I) agriculture food /crop, live, fors, food/;

set     si(i)    subset with income elasticity data /crop, live, food/;

set	lu	land use categories /
	CROP	Crops
	LIVE	Livestock
	FORS	Forestry
	ngrass	Natural grass
	nfors	Natural forest
	other /;

set	rlu	land use categories and backstops for reporting /
	CROP	Crops
	LIVE	Livestock
	FORS	Forestry
	ngrass	Natural grass
	nfors	Natural forest
	other	Other areas	
	wind	wind
	bioelec	bioelectricity
	bio-oil	biofuels
	corne	cornethanol
	wheate	wheatethanol
	sugare	sugarethanol
	beete	beetethanol
	rapeso	rapeseedoil
	palmo	palmoil
	soyo	soyoil
/;

set	rtlu	land use categories and backstops for reporting /
	CROP	Crops
	LIVE	Livestock
	FORS	Forestry
	ngrass	Natural grass
	nfors	Natural forest
	other	Other areas	
	wind	wind
	bioelec	bioelectricity
	bio-oil	biofuels
	corne	cornethanol
	wheate	wheatethanol
	sugare	sugarethanol
	beete	beetethanol
	rapeso	rapeseedoil
	palmo	palmoil
	soyo	soyoil
	tot	total
	/;

* Unharvested areas:
SET	NAT /NFORS, NGRASS/;
SET	NFORS(NAT) /NFORS/;
SET	NGRASS(NAT) /NGRASS/;

alias (lu_,lu), (nat,natt);

* With luc(r) = no, there will be various land productivity growth among regions
* With luc(r) = yes, land productivity growth will be the same among regions
* Set luc(r) = yes for the version of EPPA with land use module (YHC: 20130731 - based on info from Angelo)
set	luc(r)	 Flag to activate land use changes;
luc(r) = no;

* If luc is active, activates also dulles changes
dulles(r)$luc(r) = yes;

* end VJK

*set		CHSER(R);

set		CHSER(R) Countries to increase services /USA, CAN, EUR, MEX, JPN, ANZ,
				ROE, RUS, ASI, LAM, MES, kor, idz/;

SET		FF(I) Extracted Fossil Fuels /OIL,GAS,COAL/;
SET		SS(I,R) Set for sector specific ghg policy;

SS(I,R) = NO;

SET GHG GREEN HOUSE GAS POLLUTANTS /CH4, N2O, PFC, SF6, HFC/;
SET LGH(ghg) Long lived gases /pfc,sf6,hfc/; 
SET HFC(GHG) /HFC/;
SET CH4(GHG) /CH4/;
SET N2O(GHG) /N2O/;
SET URB NON_GHG POLLUTANTS /CO, VOC, NOX, SO2, BC, OC, amo/;
set boc(urb) /BC, OC, amo/;
set bc_(urb) /bc, oc/;
set flag(r,i) /jpn.elec/;

set rep reporting set /agr, n_agr/;
 
* Consumption sectors

SET     C /FOODBEV, ENERGY, TRNSPCOMM, OTHER/;

* Time dimension

set     ht 	/1970, 1980, 1990,
		 2000, 2005, 2007, 2010, 2015, 2020,
                 2025, 2030, 2035, 2040, 2045, 2050,
		 2055, 2060, 2065, 2070, 2075, 2080,
		 2085, 2090, 2095, 2100/;

set	htt(ht) /1970, 1980, 1990, 2000/;

set     t(ht)    /2007, 2010, 2015, 2020,
                 2025, 2030, 2035, 2040, 2045, 2050,
		 2055, 2060, 2065, 2070, 2075, 2080,
		 2085, 2090, 2095, 2100/;

set     tb(t)   BASE PERIOD;

* Set of years for which gtap data is available for years prior to the
* +the current base year. This set plus T(ht) should have 22 years in them,
* +as the IGSM "connector" needs 22 period entries. This is only used in eppaemis.gms
* +and eppaput.gms
SET	T_CHM   PRIOR PERIODS FOR IGSM		/1997, 2004/;

* Miscellaneous sets

SET     CO2C(R)  CO2-CONSTRAINED REGIONS (NON-TRADING),
	SCO2C(R)  CO2-CONSTRAINED REGIONS -- SECTORIAL POLICY (NON-TRADING),
	TCO2C(R) TRADABLE CO2-CONTRAINED REGIONS;

SET     SRENC(R) RPS CONSTRAINED REGIONS;

SET	CAPP(R)	SO2 capped regions /USA, JPN, CAN, EUR, ROE, ANZ, CHN, IND/;

SET	GHGK(R) national non-co2 constrained ghg gases,
	GHGKw(R) international non-co2 constrained ghg gases,
	SGHGK(R) sectoral non-co2 constrained ghg gases
        urbn(urb,r) national non-GHG constraints flag
        ;

SET     LBKE(R,I)  LOWER BOUND ON KE OUTPUT
	LBPF(R,I)  LOWER BOUND ON THE PF PRICE;

* VJK : From Suhail's code - 1st generation biofuels
set     bt   BACKSTOP TECHNOLOGIES
                /SOLAR, 
                 SYNF-OIL, 
                 SYNF-GAS, 
                 H2, 
                 WIND, 
                 WINDBIO, 
                 WINDGAS, 
                 BIOELEC, 
                 BIO-OIL,
                 bio-fg, 
                 NGCC, 
                 NGCAP, 
                 IGCC,
                 IGCAP, 
                 ADV-NUCL
*                 CORNE, 
*                 WHEATE, 
*		 SUGARE, 
*                 BEETE, 
*                 RAPESO, 
*                 SOYO, 
*                 PALMO, 
*		 PHEVTRN, 
*                 EVTRN, 
*                 CNGTRN, 
*                 PHEVTRNVIN, 
*                 EVTRNVIN 
                 /,
        LCBT(BT) 
*                /SOLAR, H2, WIND, WINDBIO, WINDGAS, BIOELEC, NGCC, NGCAP, IGCAP, ADV-NUCL, PHEVTRN, EVTRN, CNGTRN /,
                /SOLAR, H2, WIND, WINDBIO, WINDGAS, BIOELEC, NGCC, NGCAP, IGCC, IGCAP, ADV-NUCL, bio-fg, bio-oil/,
        VBT(BT)  VINTAGED BACKSTOP TECHNOLOGIES  
                /NGCC, NGCAP, IGCAP, ADV-NUCL, WINDBIO, WINDGAS, IGCC/,
	SBT(BT)  CARBON STORAGE BACKSTOP TECHNOLOGIES  
                /NGCC, NGCAP, IGCAP/	 
        LNBT(BT) BACKSTOP TECHNOLOGIES DEMANDING LAND 
                /BIOELEC, BIO-OIL/
*                /BIOELEC, BIO-OIL, WIND, CORNE, WHEATE, SUGARE, BEETE, RAPESO, PALMO, SOYO/,
*	BIOFUEL(BT) BACKSTOP TECHNOLOGIES BIO-FUEL 
*                /CORNE, WHEATE, SUGARE, BEETE, RAPESO, PALMO, SOYO/,
*	ETHANOL(BT)
*                /CORNE, WHEATE, SUGARE, BEETE/,
*	BIODIESEL(BT)
*                / RAPESO, PALMO, SOYO/,
*	GRAIN(BT)
*                /CORNE, WHEATE/,
*	soyo(bt) 
*                /soyo/
         
;

* end VJK

* backstop subsets
set	igcap(bt)    /igcap/,
	ngcap(bt)    /ngcap/,
	windgas(bt)  /windgas/,
	windbio(bt)  /windbio/,
	nvr(bt)      /wind, bioelec/,
	vr(bt)       /windbio, windgas/,
	ngcc(bt)     /ngcc/,
        igcc(bt)     /igcc/;

set	vrt(vbt)     /windbio, windgas/;

*nvr = non-vintaged renewables
*vr = vintaged renewables

SET     BACKSTOP(T)     PERIODS IN WHICH THE BACKSTOP IS ACTIVE;
SET     ACTIVE(*,R)     FLAG FOR activate a backstop or policy;
SET     SHR SHARE PRODUCTION BY BACKSTOP
                 /10,20,30,40,50,60,70,80,90/;

* VJK : added LUC aliases from Suhail's model.

ALIAS (I,G), (I,J), (G,GG), (NE,NE2), (C,CC), (agri,agrii), (bt,btt);
ALIAS (R,RP), (R,RR), (e,e1);
ALIAS (T,TS);

TB(T) = YES$(ORD(T) EQ 1);

GHGK(R)     = NO;
SGHGK(R)    = NO;
GHGKw(R)    = NO;
urbn(urb,r) = no;

* Program options:

OPTION SOLPRINT = OFF;
OPTION RESLIM = 100000;


* Add for regional gas Aug 05

SET MKT Natural gas markets /NAM, URB, AUS/;

SET     GMAP(R,MKT)   maping gas markets 
        /
	USA.NAM	United States
	CAN.NAM	Canada
	MEX.NAM	Mexico
	JPN.AUS	Japan
	ANZ.AUS	Australia - New Zealand
	EUR.URB	Europe
	ROE.URB	Eurasia
	RUS.AUS	Russia
	ASI.AUS	East Asia
	CHN.AUS	China	
	IND.AUS	India
	BRA.NAM	Brazil
	AFR.URB	Africa
	MES.URB	Middle East
	LAM.NAM	Latin America
	REA.AUS	Rest of the World
        kor.aus S. Korea
        idz.aus Indonesia
        /;

* Define a set for gas resource types:
SET grt gas resource types / cnv conventional, shl shale, tgh tight sands, cbm coal bed methane/;

alias (grt,gtr);

set
co2cf(r,t)     control for co2c - regional CO2 constraint
tco2cf(r,t)    control for tco2c - regions with international CO2 cap-and-trade
sco2cf(r,t)    control for sco2c - regions with sectoral CO2 constraints  
ghgkf(r,t)     control for ghgk - regional ghg constraint
sghgkf(r,t)    control for sghgk - regions with sectoral ghg constraints
ghgkwf(r,t)    control for ghgkw - regions with international GHG cap-and-trade
urbnf(urb,r,t) control for urbn - regions with non-GHG constraint on urb
cflag(r)       flag for deforestation and eint (cement) emissions
cflagf(r,t)    control for cflag - deforestation and eint (cement) emissions

;

co2cf(r,t)     = no;
tco2cf(r,t)    = no;
sco2cf(r,t)    = no;
ghgkf(r,t)     = no;
sghgkf(r,t)    = no;
ghgkwf(r,t)    = no;
urbnf(urb,r,t) = no;
cflag(r)       = no;
cflagf(r,t)    = no;

* the set "time" is used to control the years of output reported
set time(t)  subset of t /2010, 2015, 2020, 2025, 2030, 2035, 2040, 2045, 2050, 2055
                        2060, 2065, 2070, 2075, 2080, 2085, 2090, 2095, 2100/;

set coal_(g) coal_subset of g /coal/;

* set tregion(r) regions with ee adjustment /anz/;

set devlp(r) developed regions /usa, can, eur, anz, jpn/;
set otg20(r) other G20 regions /mex, rus, bra, chn, ind, asi, kor, idz/;
set restw(r) rest of the world /roe, afr, mes, lam, rea/;

* declare the set for Reimer-Hertel sectors
SET     irh  Reimer-Hertel sectors for implementing AIDADS 
/
1_GrainCrops  
2_MeatDairy   
3_OthFoodBev  
4_TextAppar   
5_HousUtils   
6_WRtrade     
7_Mnfcs	      
8_TransComm   
9_FinService  
10_HousOthServ
11_forestry    
/;

alias(irh,jrh);
