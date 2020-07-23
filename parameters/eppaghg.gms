
* ..\parameters\eppaghg.gms

* July 2006. This file replaces the files eppaco2.gms and em_trend_aaa.gms

* Include GHG Inventories and Trends

parameters 
          ch4_a(r,*)  methane read from ghg_inv 
          n2o_a(r,*)  N2O read from ghg_inv
          pfc_a(r,*)  PFC read from ghg_inv
          hfc_a(r,*)  HFC read from ghg_inv
          sf6_a(r,*)  SF6 read from ghg_inv
          so2_a(r,*)  SO2 read from ghg_inv
          nox_a(r,*)  NOx read from ghg_inv
          co_a(r,*)   CO read from ghg_inv
          voc_a(r,*)  VOC read from ghg_inv
          bc_a(r,*,*) black carbon read from ghg_inv
          oc_a(r,*,*) organic carbon read from ghg_inv
          nh3_a(r,*)  NH3 read from ghg_inv
          ghginv      ghg inventory from data files ghg_inv and ghg_trend
          TJ_85D(r,e) Energy transformation coefficients
	  eJ_95D(R,E) Energy transformation coefficient
          ;

$include %datadir%ghg_inv.dat
$include %datadir%ghg_trend.dat

*   The units of measurement for the physical flows are exajoules or trillion kwt.

tj_85d(r,e)          = 1;
ej_95d("usa","roil") = (sum(i,eind("roil",i,"usa"))+efd("roil","usa"))
                       /(sum(i,(xdp0("usa","roil",i)+xmp0("usa","roil",i)))+xdc0("usa","roil")+xmc0("usa","roil"));
			 
ej_95d("usa","oil")  = ej_use("oil","usa")/euse("oil","usa");
ej_95d("usa","COAL") = ej_use("COAL","usa")/euse("COAL","usa");

*Units: Million ton of carbon per terajoule heat contents.
* 24.6 tC/EJ

* Units of Epslon: million metric ton of carbon per exajoule (McFarland)

PARAMETER   EPSLON(E)       COEFFICIENT OF CARBON CONTENTS (100 Million tons carbon per EJ)


	/COAL           0.24686
*	 OIL            0.20730
	 GAS            0.137
	 ROIL	        0.199
	 ELEC           0/;

* Target IEA's CO2 emissions from fossil fuel combustion
* Source: IEA - CO2 Emissions from Fuel Combustion - 2011 Highlights (YHC: 20121012)
* http://www.iea.org/co2highlights/
* Note: crude oil is not combusted 
* ROE, LAM, REA are not adjusted due to insufficient data
* See the calculation for cj0 in the worksheet "emissions_IEA" in eppa6_out.xls

table  cj0(r,e) datasource for cj

	coal	        roil	        gas	        oil
USA	1.007384	0.849026	1.097783	0
CAN	1.160597	0.803679	1.081733	0
MEX	1.045664	1.004840	1.107753	0
JPN	1.021306	0.894968	1.198965	0
ANZ	1.079148	1.116405	1.218898	0
EUR	1.021538	0.760855	1.079630	0
ROE	1.000000	1.000000	1.000000	0
RUS	0.995881	0.459323	1.066316	0
ASI	1.004958	0.542140	1.077016	0
CHN	1.027356	0.870619	1.035231	0
IND	1.004958	0.713865	1.010142	0
BRA	0.901207	0.891451	1.089193	0
AFR	0.790569	0.969103	0.974170	0
MES	0.966738	0.675991	1.077546	0
LAM	1.000000	1.000000	1.000000	0
REA	1.000000	1.000000	1.000000	0
KOR	0.993190	0.529654	1.118444	0
IDZ	1.129931	1.210546	1.020336	0

;


cj(e,r) = cj0(r,e);

* Modeling other gases:
parameter
curb0(urb,*,*,r)	non-greenhouse gases (associated with consumption)
ourb0(urb,*,r)		non-greenhouse gases (associated with production)
cghg0(*,*,r)		greenhouse gases (associated with consumption)
oghg0(*,*,r)		greenhouse gases (associated with production);
	
* Note that the units of pfc, sf6, and hfc are 1/1000 of those for ch4 and n2o (see data preparation).
ghginv(g,"pfc",r)     = pfc_a(r,g)/1000;
ghginv(g,"sf6",r)     = sf6_a(r,g)/1000;
ghginv(g,"hfc",r)     = hfc_a(r,g)/1000;

ghginv("fd","hfc",r)  = hfc_a(r,"fd")/1000;

* Uncertainty Modification * -UNC-
* Variable: ch4 initial inventories by sector
*
ghginv(AGRI,"ch4",r)  = ch4_a(r,AGRI)*UNCCH4INDUSTRY(AGRI);
ghginv("COAL","ch4",r)= ch4_a(r,"COAL")*UNCCH4INDUSTRY("COAL");
ghginv("GAS","ch4",r) = ch4_a(r,"GAS")*UNCCH4INDUSTRY("GAS");
ghginv("OIL","ch4",r) = ch4_a(r,"OIL")*UNCCH4INDUSTRY("OIL");
ghginv("EINT","ch4",r)= ch4_a(r,"EINT")*UNCCH4INDUSTRY("EINT");
ghginv("OTHR","ch4",r)= ch4_a(r,"OTHR")*UNCCH4INDUSTRY("OTHR");
ghginv("fd","ch4",r)  = ch4_a(r,"fd")*UNCCH4INDUSTRY("fd");
ghginv("food","ch4",r)= ch4_a(r,"food")*UNCCH4INDUSTRY("food");
ghginv("ROIL","ch4",r)= ch4_a(r,"ROIL");

* As in the case for CO2, we scale all quantities by 100 
cghg0("ch4","gas",r) = ghginv("gas","ch4",r)/100;
ghginv("gas","ch4",r)= 0;

ghginv(g,"n2o",r)    = n2o_a(r,g);

cghg0("n2o",enoe,r)  = ghginv(enoe,"n2o",r)/100;
ghginv(enoe,"n2o",r) = 0;

cghg0(ghg,"fd",r)    = ghginv("fd",ghg,r)/100;
oghg0(ghg,g,r)       = ghginv(g,ghg,r)/100;

* non-ghg gases used to trace urban pollution:

* change to EDGAR data

parameter curbe, curb00(urb,*,*,r);

ourb0("so2",g,r)     = so2_a(r,g)/100;
ourb0("nox",g,r)     = nox_a(r,g)/100;
ourb0("co",g,r)      = co_a(r,g)/100;
ourb0("voc",g,r)     = voc_a(r,g)/100;
ourb0("amo",g,r)     = nh3_a(r,g)/100;

* enoe = {coal, oil, roil, gas}
ourb0(urb,enoe,r)    = 0;

curbe("so2",e,r)     = so2_a(r,e)/100; 
curbe("nox",e,r)     = nox_a(r,e)/100; 
curbe("co",e,r)      = co_a(r,e)/100; 
curbe("voc",e,r)     = voc_a(r,e)/100;
curbe("amo",e,r)     = nh3_a(r,e)/100; 

curb00(urb,e,g,r)$(sum(i, eind(e,i,r))+efd(e,r)) 
                     = curbe(urb,e,r)*eind(e,g,r)/(sum(i, eind(e,i,r))+efd(e,r));
                                                
curb00(urb,e,"fd",r)$(sum(i, eind(e,i,r))+efd(e,r)) 
                     = curbe(urb,e,r)*efd(e,r)/(sum(i, eind(e,i,r))+efd(e,r));

$ontext
curb00(urb,e,g,r)$(sum(i, eind(e,i,r))) 
                     = curbe(urb,e,r)*eind(e,g,r)/(sum(i, eind(e,i,r)));
                                                
curb00(urb,e,"fd",r)$(efd(e,r)) 
                     = 0;
$offtext

                                                
curb0(urb,e,g,r)     = curb00(urb,e,g,r);
curb0(urb,e,"fd",r)  = curb00(urb,e,"fd",r);


* The units of bc and oc in ghg_inv.dat are both in Gg (thousand ton) when "unit = 1" in the data preparation
* program ghg.gms.  So, when "unit = 1000", which means the units will be 1/1000 of original ones, the units 
* of bc and oc in ghg_inv.dat will be in "ton".  (See Streets et al., 2001. "Black carbon emissions in China";
* Cao et al., 2006. "Inventory of black carbon and organic carbon emissions from China".  Compare China's numbers 
* in ghg_inv and those in these studies.  (YHC: 20130304)

* Now bc and oc are first divided by 1000 and then by 100, which means their units become "100 thousand tons".
* With these adjustments, all non-CO2 gases including pfc, sf6, and hfc are in "100 thousand ton" after eppaghg.gms

curb0("bc",e,g,r)    = bc_a(r,e,g)/1000/100; 
curb0("oc",e,g,r)    = oc_a(r,e,g)/1000/100; 

curb0("bc",e,"fd",r) = bc_a(r,e,"fd")/1000/100; 
curb0("oc",e,"fd",r) = oc_a(r,e,"fd")/1000/1000; 

*ourb0("bc",g,r)      = bc_a(r,"process",g)/1000/100;
*ourb0("oc",g,r)      = oc_a(r,"process",g)/1000/100;

* The category "biomass" and activity "burning" do not exist in EPPA5, but are presented here:
ourb0("bc",g,r)      = (bc_a(r,"process",g)+bc_a(r,"biomass",g))/1000/100;
ourb0("oc",g,r)      = (oc_a(r,"process",g)+oc_a(r,"biomass",g))/1000/100;
** biomass burning emissions are assigned to crop sector:
*ourb0("bc","crop",r) = ourb0("bc","crop",r)+bc_a(r,"biomass","burning")/1000/100;
*ourb0("oc","crop",r) = ourb0("oc","crop",r)+oc_a(r,"biomass","burning")/1000/100;

* biomass burning emissions are assigned to fors sector:
ourb0("bc","fors",r) = ourb0("bc","fors",r)+bc_a(r,"biomass","burning")/1000/100;
ourb0("oc","fors",r) = ourb0("oc","fors",r)+oc_a(r,"biomass","burning")/1000/100;


ourb0("so2","fd",r)  = so2_a(r,"fd")/100;
ourb0("nox","fd",r)  = nox_a(r,"fd")/100;
ourb0("co","fd",r)   = co_a(r,"fd")/100;
ourb0("voc","fd",r)  = voc_a(r,"fd")/100;
ourb0("amo","fd",r)  = nh3_a(r,"fd")/100;

*ourb0("bc","fd",r)   = bc_a(r,"process","fd")/1000/100;
*ourb0("oc","fd",r)   = oc_a(r,"process","fd")/1000/100;

ourb0("bc","fd",r)   = (bc_a(r,"process","fd")+bc_a(r,"biomass","fd"))/1000/100;
ourb0("oc","fd",r)   = (oc_a(r,"process","fd")+oc_a(r,"biomass","fd"))/1000/100;


* Define parameters to adjust gas contents overtime:
parameters
cghg(*,*,*,r), cghg00(*,*,*,r), fcghg(*,*,r), oghg(*,*,r), curb(urb,*,*,r),ourb(urb,*,r);
 
* Initially assign benchmark values:

cghg00(ghg,e,g,r)$(sum(i, eind(e,i,r))+efd(e,r)) 
                     = cghg0(ghg,e,r)*eind(e,g,r)/(sum(i, eind(e,i,r))+efd(e,r));
                                                
cghg00(ghg,e,"fd",r)$(sum(i, eind(e,i,r))+efd(e,r)) 
                     = cghg0(ghg,e,r)*efd(e,r)/(sum(i, eind(e,i,r))+efd(e,r));
                                                
cghg(ghg,e,g,r)      = cghg00(ghg,e,g,r);
cghg(ghg,e,"fd",r)   = cghg00(ghg,e,"fd",r);
oghg(ghg,g,r)        = oghg0(ghg,g,r);
fcghg(ghg,"fd",r)    = cghg0(ghg,"fd",r);
curb(urb,e,g,r)      = curb0(urb,e,g,r);
curb(urb,e,"fd",r)   = curb0(urb,e,"fd",r);
ourb(urb,g,r)        = ourb0(urb,g,r);
ourb(urb,"fd",r)     = ourb0(urb,"fd",r);

* GWP from IPCC AR5 (YHC: 20140827)

*       AR4     AR5
*CH4	25	28   
*N2O	298	265  
*PFC	7390	6630 
*SF6	22800	23500
*HFC	1430	1300 

PARAMETER GWP(*)   100 year GWP converts to CO2 equivalent
        / CH4   28   
          N2O   265  
          PFC   6630 
          SF6   23500
          HFC   1300/;

* Convert GWP to carbon units:
gwp(ghg) = gwp(ghg)/(44/12);


* CO2 emissions from deforestation in 100m tons (2004) 

* Adjusted for EPPA6  (YHC: 20130410)

parameter	defco20(r)	CO2 from deforestration in 2007 

/	
USA	-0.1421
CAN	-0.0163
MEX	0.0175
JPN	-0.0218
ANZ	0.0058
EUR	-0.0948
ROE	0.0241
RUS	-0.1183
ASI	0.1326
CHN	0.0744
IND	0.0127
BRA	0.3147
AFR	0.3408
MES	0.0129
LAM	0.2719
REA	0.0115
KOR	0.1362
IDZ	0.1424
/;


*	Non-energy fuel emissions and non-fossil fuel emissions (Cement, etc) CO2 Emissions in mmtC/100:
* CDIAC
* disaggregate asi value into three based on d_t("eint",r,t); YHC: 20130325
parameter       cemco20(r)	Benchmark co2 from Cement /
AFR	0.123250001
ANZ	0.01271

*ASI	0.236500002
asi     0.07807045
kor     0.07867006
idz     0.07975950

BRA	0.0468
CAN	0.01885
CHN	1.320610012
EUR	0.333320003
IND	0.176800002
JPN	0.091630001
LAM	0.070750001
MES	0.129170001
MEX	0.04759
REA	0.074510001
ROE	0.100340001
RUS	0.062150001
USA	0.134660001
/;

* US: US EPA GHG 2008

outco20(r,"crop") = defco20(r);
outco20(r,"eint") = cemco20(r);
outco2(r,g)       = outco20(r,g);

*	Relabel and express household urban emissions and so2 caps in million tons:
parameter hhurb	household urban emissions mton;

hhurb(urb,t,r) = ourb(urb,"fd",r);

* put 1997 data for IGSM

$include %datadir%1997_e5.dat
$include %datadir%2004_e5.dat

parameter chm97co2, chm97ghg, chm97urb;

chm97co2("agr",r,"1997")       = ghg_rep_a("co2",r);
chm97co2("n_agr",r,"1997")     = ghg_rep_n("co2",r);
CHM97GHG("agr",GHG,R,"1997")   = ghg_rep_a(ghg,r);
CHM97GHG("n_agr",GHG,R,"1997") = ghg_rep_n(ghg,r);
chm97urb("agr",urb,r,"1997")   = urb_rep_a(urb,r);
chm97urb("n_agr",urb,r,"1997") = urb_rep_n(urb,r);
chm97co2(rep,r,"2004")         = chm2004("co2",r,rep);
CHM97GHG(rep,GHG,R,"2004")     = chm2004(ghg,r,rep);
chm97urb(rep,urb,r,"2004")     = chm2004(urb,r,rep);

* For EPPA6: this file needs to be updated!
* --Deforestation emissions trend for calibrating RCP85 of IPCC has been applied on def_ref_e6; see worksheet outco2_crop in eppa6_out
$include %datadir%cem_def.dat

parameters 
cemtrend(t,r) cem_ref_e5
deftrend(t,r) def_ref_e6
;

cemtrend(t,r) = cem_ref_e5(t,r);
deftrend(t,r) = def_ref_e6(t,r);

* FAO global numbers up to 2015, and then linearly reduce to 0 in 2050.  See "land-use emis in Land-use in EPPA6-L.xls"
table deforest(*,r)

	USA	 CAN	 MEX	JPN	ANZ  	EUR	 ROE	RUS	 ASI	 CHN	 IND	BRA	 AFR	  MES	 LAM	  REA	 KOR	 IDZ     
1997	-373.72	-42.77	46.05	-57.24	15.13	-249.37	63.50	-311.05	356.99	195.81	33.34	827.70	896.52	33.93	715.17	30.29	366.79	357.88
2004	-416.01	-47.60	51.27	-63.72	16.85	-277.58	70.69	-346.25	397.39	217.97	37.11	921.37	997.97	37.77	796.11	33.71	408.31	398.38
2005	-414.13	-47.39	51.04	-63.43	16.77	-276.32	70.37	-344.68	395.58	216.98	36.94	917.20	993.44	37.60	792.50	33.56	406.45	396.57
2007	-357.73	-40.94	44.08	-54.80	14.49	-238.70	60.78	-297.75	333.84	187.44	31.91	792.31	858.18	32.48	684.59	28.99	342.93	358.64
2010	-357.59	-40.92	44.07	-54.77	14.48	-238.60	60.76	-297.63	327.68	187.36	31.90	791.99	857.83	32.47	684.31	28.98	336.55	370.76
2015	-321.62	-36.81	39.64	-49.26	13.03	-214.60	54.65	-267.69	277.37	168.51	28.69	712.32	771.53	29.20	615.47	26.07	283.31	370.19
2020	-275.67	-31.55	33.98	-42.23	11.16	-183.94	46.84	-229.45	243.95	144.44	24.59	610.56	661.32	25.03	527.55	22.34	234.81	319.13
2025	-229.73	-26.29	28.31	-35.19	9.30	-153.29	39.03	-191.21	205.33	120.37	20.49	508.80	551.10	20.86	439.63	18.62	189.74	269.84
2030	-183.78	-21.03	22.65	-28.15	7.44	-122.63	31.23	-152.97	163.81	96.30	16.40	407.04	440.88	16.68	351.70	14.89	151.21	216.90
2035	-137.84	-15.77	16.99	-21.11	5.58	-91.97	23.42	-114.73	122.49	72.22	12.29	305.28	330.66	12.51	263.77	11.17	111.68	164.78
2040	-91.89	-10.52	11.33	-14.07	3.72	-61.31	15.61	-76.48	81.27	48.15	8.20	203.52	220.44	8.34	175.85	7.45	72.72	111.97
2045	-45.95	-5.26	5.66	-7.04	1.86	-30.66	7.81	-38.24	40.51	24.07	4.10	101.76	110.22	4.17	87.93	3.72	35.45	57.02
2050	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
2055	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
2060	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
2065	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
2070	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
2075	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
2080	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
2085	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
2090	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
2095	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00
2100	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00	0.00

;


