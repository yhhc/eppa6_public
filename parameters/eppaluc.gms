* EPPALUC inputs

* VJK (LUC)
* LUC:
* Consider including export taxes and import tariffs for bio-oil (same as roil):

parameter
TMbio(R)	average IMPORT TARIFF ON roil nd bio-oil
TXbio(R)	average EXPORT TAX roil nd bio-oil
;

TMbio(R)$(SUM(RR, (WTFLOW0(R,RR,"roil")*(1+TX("roil",RR,R))+sum(j,VTWR(j,"roil",RR,R)))))
= SUM(RR, (WTFLOW0(R,RR,"roil")*(1+TX("roil",RR,R))+sum(j,VTWR(j,"roil",RR,R)))*
      TM("roil",RR,R))/
  SUM(RR, (WTFLOW0(R,RR,"roil")*(1+TX("roil",RR,R))+sum(j,VTWR(j,"roil",RR,R))) );

TXbio(R)$(SUM(RR, WTFLOW0(RR,R,"roil"))) = SUM(RR, WTFLOW0(RR,R,"roil")*TX("roil",R,RR))/
					   SUM(RR, WTFLOW0(RR,R,"roil"));

***##### Changes to represent land use changes:

* data below in the File: GTAP_land_data_home_forGTAP5.xls in MIT/Projects/TEM

Table Area_GTAP(r,*) Gtap land cover areas in thousands of hectares (x 1000 ha)
        Fors		SavnGrass	Shrubland	Crop		Live		Built		Other		Total
USA	345284.7	36139.4		42351.4		219299.4	254761		12667.4		33648.8		944152.2
CAN	628543.7	6282		0		56162.1		14689.7		1884.1		284121.3	991682.8
MEX	55640.7		11524.9		21786.1		25694.9		86180.4		740.7		0		201567.7
JPN	30416.5		0		703.5		6316.2		1300.5		1201.2		0		39938
ANZ	62186.8		87141.8		228467.6	38810.6		439018.4	713.9		1367.4		857706.4
EUR	228337.5	13909.9		19822		164842.7	39659.3		7873.4		15401		489846.4
ROE	36559.2		45545.8		35651.1		170255		282125.1	3131.9		32060.7		605328.4
RUS	1082390.6	85358.9		571.3		222739.5	78217.8		4608.1		215573.5	1689459.8
ASI	183152.3	5624.1		0		89544.3		27053.4		1316.6		0		306690.9
CHN	168490.9	37093.3		34780.4		213791.2	357602.6	1566.7		146927.7	960252.9
IND	52709.7		11757.1		7908.1		181516.6	44597.1		809		10073.8		309371.4
BRA	465166.1	82589.5		58424.1		67572.6		177885.8	1207.8		0		852845.9
AFR	414510.7	582603.6	95738.8		176608.8	806430.6	1774.8		911207.4	2988874.2
MES	1320		3927.6		53669.7		22421.5		172545.9	1759.1		271856.7	527500.1
LAM	404617.1	135486.9	50284.3		93709.1		275095.5	1361.4		67600.8		1028154.7
REA	119036.6	16313.9		24666.4		94888.8		203179.5	564.2		48440.7		507090
IDZ	1		1		1		1		1		1		1		1
KOR	1		1		1		1		1		1		1		1
;

Table VFM_GTAP(r,agri)	GTAP land rents for 2001 from GTAP Land Project
        Crop		Live		Fors
USA	35960.8		5059.1		1226
CAN	2813.4		835.1		749.2
MEX	7816.5		754.2		317.1
JPN	7813		571.5		432.5
ANZ	2400.8		1262		170.8
EUR	37834.1		6915.9		1773.3
ROE	7152.9		1391.4		373.1
RUS	3358.8		279.4		248.6
ASI	28392.8		855		522.2
CHN	44567.2		2579.9		1203.3
IND	37452.3		8430.4		443
BRA	2515		927.6		92.4
AFR	7447.4		1461.3		851.2
MES	3573.3		617.7		155.9
LAM	12256.5		4755		185.1
REA	17465.6		2000.7		372.3
KOR	1		1		1
IDZ	1		1		1
*Total	258820.4	38696.2		9116
;

parameter priceland price of land based on GTAP land database;
priceland(r,agri) = 1000*vfm_gtap(r,agri)/area_gtap(r,agri);

display priceland;

Table PLand(r,*) Land rent per ha from GTAP Land data
         Crop 	 Live 	 Fors 
   USA 	 163.98  19.86 	 6.40 
   CAN 	 50.09 	 56.85 	 1.81 
   MEX 	 304.20  8.75 	 9.37 
   JPN 	 1236.9  439.45  17.97 
   ANZ 	 61.86 	 2.87 	 1.04 
   EUR 	 229.52  174.38  10.91 
   ROE 	 42.01 	 4.93 	 8.01 
   RUS 	 15.08 	 3.57 	 0.29 
   ASI 	 317.08  31.60 	 3.64 
   CHN 	 208.46  7.21 	 9.14 
   IND 	 206.33  189.03  10.10 
   BRA 	 37.22 	 5.21 	 0.17 
   AFR 	 42.17 	 1.81 	 4.04 
   MES 	 159.37  3.58 	 34.87 
   LAM 	 130.79  17.28 	 0.59 
   REA 	 184.06  9.85 	 4.79 
   ;

Parameters
rent_rr		land rent ratio
rcr_pst		ratio crop pasture land rent
rcr_frs		ratio crop forestry land rent
rpst_frs	ratio pasture forestry land rent
rent_r		markup in the conversion from one type to other
;

rent_rr(r,agri,agrii) = priceland(r,agri)/priceland(r,agrii);
rcr_pst(r) = max(0, rent_rr(r,"crop","live")-1);
rcr_frs(r) = max(0, rent_rr(r,"crop","fors")-1);
rpst_frs(r) = max(0, rent_rr(r,"live","fors")-1);

display rent_rr, rcr_pst, rcr_frs, rpst_frs;

* TEM land cover data in KM2 (numbers from Kick: TEM land use data in 2000):
**!! Data below is from EPPA5, need to update:

Table land_tem(r,*) TEM land cover data in KM2
*$ontext
** EPPA5 data
        live	crop	fors	shrb	ngrass	nfors	nshrb	othr	tot
USA	1192177	1866001	564852	32878	987935	1795503	1433569	1196202	9069117
CAN	121121	528091	168486	0	110433	3143757	378213	4640903	9091004
MEX	596177	218711	191123	107710	158254	389452	288172	77658	2027257
JPN	6129	46972	45598	0	0	320133	0	5601	424433
ANZ	3929603	355887	101677	264577	729351	1251305	1730904	357347	8720651
EUR	557537	1423064	595406	8120	239928	1182259	89829	702966	4799109
ROE	2421703	1328500	117207	49611	424369	359194	954999	406340	6061923
RUS	648835	1679784	423639	7712	428122	6165839	1800947	5527077	16681955
*ASI	49986	714357	110946	0	69469	2170407	0	318069	3433234
ASI	22401	321094	127341	0	30464	920132	0	102123	1523559
CHN	1847944	1995123	321068	2118	603081	906316	1153858	2431443	9260951
IND	62523	1770475	341180	4093	128372	687464	36976	183030	3214113
BRA	1210781	746218	477354	770	928591	4616388	33375	513163	8526640
AFR	7442662	1609073	982782	741153	2966967	4621399	1488998	9962009	29815043
MES	1824588	137964	6369	46154	987400	113957	614897	1482996	5214325
LAM	2565892	836984	480526	70653	573959	3148455	767583	1747733	10191785
REA	1352944	859731	72584	167648	863400	1187761	147749	417637	5069454
KOR	1451	20807	8251		1974	59626		6617	98730
IDZ	26639	381831	151428		36227	1094181		121441	1811750
;
land_tem(r,"fors") = land_tem(r,"fors")+land_tem(r,"shrb");
land_tem(r,"nfors") = land_tem(r,"nfors")+land_tem(r,"nshrb");

*$offtext
$ontext
* Preliminar (temporary) EPPA6 land use data
	live	crop	fors	ngrass	nfors	othr	Total
USA	1195708	1866362	1846895	951773	2378684	1064211	9303633
CAN	116226	516488	642768	107840	3450699	4565392	9399413
MEX	618815	227184	373218	129955	671395	14645	2035212
JPN	6796	54089	94265	0	268866	417	424433
ANZ	3948161	363709	465176	683395	3012360	254161	8726962
EUR	579263	1371254	1098000	222918	1180653	501411	4953499
ROE	1709884	1622882	1148581	256015	1032405	305778	6075545
RUS	1416465	1476641	1716287	580334	6484595	5088953	16763275
ASI	22402	321095	127341	30465	920133	102124	1523559
CHN	1883225	1997146	1453258	608927	979764	2411364	9333684
IND	60839	1711866	580793	115986	595385	149244	3214113
BRA	1320175	563357	1261721	954952	4209519	235752	8545476
AFR	8096331	1731532	2296437	2609026	6781260	8498902	30013488
MES	2099121	140727	355602	667964	556304	1408293	5228011
LAM	2554565	1055239	1226461	627197	3504427	1515477	10483366
KOR	1452	20808	8252	1974	59627	6618	98730
IDZ	26639	381832	151429	36227	1094182	121441	1811750
REA	1308706	938508	652303	745124	1094476	331753	5070870
;
$offtext
display land_tem;

* Area units: to convert from km2 to ha multiply by 100

Parameter	area		TEM land cover area in 100 Km2 (10000 ha)
		comparep	compare land rents
		rent_rr2	land rent ratio
		comparevfm	compare land rents;

area(r,"crop") = land_tem(r,"crop")*0.01;
area(r,"live") = (land_tem(r,"live"))*0.01;
area(r,"fors") = (land_tem(r,"fors"))*0.01;
area(r,"ngrass") = (land_tem(r,"ngrass"))*0.01;
area(r,"nfors") = (land_tem(r,"nfors"))*0.01;
area(r,"other") = (land_tem(r,"other"))*0.01;
area(r,"tot") = land_tem(r,"live")+land_tem(r,"crop")+land_tem(r,"fors")+land_tem(r,"ngrass")+land_tem(r,"nfors")+land_tem(r,"other");
area("tot","tot") = sum(r, area(r,"tot"));
area("tot",lu) = sum(r, area(r,lu));

display area;

* To get the land price for EPPA, examine land cover from TEM country by country:
* For some countries, as CAN, IND and ASI, we assume that TEM area
* with pastures and natural pastures is used to grow livestock, since
* the pasture area is unrealistic small at TEM and them generates a higher price
* for land used to livestock production than land for crops   

area("can","live") = (land_tem("can","live")+land_tem("can","ngrass"))*0.01;
land_tem("can","ngrass") = 0;
area("asi","live") = (land_tem("asi","live")+land_tem("asi","ngrass"))*0.01;
land_tem("asi","ngrass") = 0;
area("ind","live") = (land_tem("ind","live")+land_tem("ind","ngrass"))*0.01;
land_tem("ind","ngrass") = 0;
area("kor","live") = (land_tem("kor","live")+land_tem("kor","ngrass"))*0.01;
land_tem("kor","ngrass") = 0;

area(r,"nfors") = land_tem(r,"nfors")*0.01;
area(r,"ngrass") = land_tem(r,"ngrass")*0.01;

* Assume some fraction of natural areas in USA and ROW are not available for agriculture
* (ex.: Rock Mountains in US, grassland in Mongolia, dry areas in Pakistan and Afghanistan, ...)

parameter	lusearea	land area shares before and after reduce natural areas
		reserv		land removed from EPPA calculation in 10 billions of ha;

lusearea(r,lu,"1") = area(r,lu)/(sum(lu_, area(r,lu_)-area(r,"other")));
lusearea(r,"tot","1") = sum(lu, lusearea(r,lu,"1"));
lusearea(r,"area","1") = (sum(lu_, area(r,lu_)-area(r,"other")));

area("usa","nfors") = 0.4*area("usa","nfors");
area("row","ngrass") = 0.5*area("row","ngrass");

lusearea(r,lu,"2") = area(r,lu)/lusearea(r,"area","1");
lusearea(r,"tot","2") = sum(lu, lusearea(r,lu,"2"));
lusearea(r,lu,"dif") = lusearea(r,lu,"2") - lusearea(r,lu,"1");

reserv("usa","nfors") = 0.6*area("usa","nfors")/0.4*0.000001;
reserv("row","ngrass") = 0.5*area("row","ngrass")/0.5*0.000001;

display lusearea, area;

* Parameters to natural land transformation functions:
* out: output from natural forest relative to traditional forestry sector when 1 new ha of natural is harvested
* inp: ratio natural area rents to harvested area rents 
* nf_f: share of forestry output from natural forests
* ln_sh: share of total area harvested to produce timber from deforestation (not being used)
* all above are calculated in the file: land prices natural x harvested EPPA regions_EPPA5.xls at: MIT/Projects/TEM E EPPA/Land use documentation/Data from Sohnjen
* s_el: elasticity of land supply (calculated in the file: Land supply elasticities_corrected.xls at: MIT/Projects/TEM E EPPA/Land use documentation
* s_el calculations need to be corrected since we rely on historical land use changes from TEM (regional aggregation of EPPA5 is different from EPPA4)
* at this point we just "adapt" the EPPA4 estimates about s_el to EPPA5 regions
* basically: s_el: changes from 1990-1997 in all agricultural land)
* s_el_: changes from 1980-1997 all agricultural land
* s_el_2: changes from 1980-1997, only cropland
* s_el_3: calculated based on FAO deforestation rates from 1990 to 2005 (only forests)
* s_el_4: calculated based on FAO deforestation rates from 1990 to 2005 (forests and other wooded land)
* s_el_5: calculated based on FAO deforestation rates from 1990 to 2005 (forests, land prices deflated)
* some countries are increasing natural forests (reforestation), so we assume elast. = 0.02

*$ontext
table	nat_tran(r,*)
	 out	 inp	 nf_f	s_el	s_el_	s_el_2 s_el_3	s_el_4	s_el_5
USA	 29.38 	 0.16 	 9.87	0.02	0.02	0.05	0.00	0.00	0.00
CAN	 47.04 	 0.16 	 1	0.08	0.31	0.05	0.00	0.00	0.00
MEX	 4.26 	 0.18 	 33.57	0.13	0.38	0.19	0.05	0.04	0.14
JPN	 6.70 	 0.36 	 1	0.02	0.28	0.05	0.00	0.00	0.01
ANZ	 2.07 	 0.45 	 8.87	0.05	0.30	0.30	0.02	0.01	0.06
EUR	 7.72 	 0.02 	 1	0.02	0.02	0.05	0.00	0.00	0.00
ROE	 5.00 	 0.02 	 1	0.02	0.02	0.05	0.02	0.00	0.00
RUS	 69.15 	 0.20 	 1	0.02	0.10	0.05	0.00	0.00	0.00
ASI	 8.79 	 0.62 	 45.19	0.05	0.71	0.64	0.14	0.13	0.39
CHN	 18.67 	 0.06 	 1	0.02	0.23	0.05	0.00	0.00	0.00
IND	 3.26 	 0.22 	 7.22	0.03	0.18	0.06	0.00	0.00	0.00
BRA	 3.67 	 0.19 	 21.11	0.09	0.16	0.7	0.06	0.06	0.16
AFR	 1.11 	 0.335	 48	0.09	0.06	0.36	0.06	0.06	0.18
MES	 1.21 	 0.86 	 1	0.05	0.41	0.26	0.00	0.00	0.00
LAM	 1.54 	 0.47 	 1	0.09	0.26	0.7	0.04	0.00	0.10
REA	 3.74 	 0.71 	 29.60	0.06	0.09	0.21	0.08	0.06	0.22
KOR	 0.01	 0.01	 1	0.02	0.02	0.02	0.02	0.02	0.02
IDZ	 6.49	 0.59	 68.3	0.13	0.35	0.35	0.35	0.35	0.35
;

* Here we adjust some elasticities to conciliate TEM and FAO deforestations rates:
* USA: reforestation, all elasticities are low (use s_el)
* CAN: TEM shows deforestation, FAO don't. Trust TEM (use s_el)
* MEX: TEM and FAO give similar rates and similar elasticities (use s_el)
* JPN: TEM and FAO give similar rates and similar elasticities (use s_el)
* ANZ: TEM shows smaller deforestation than FAO, but similar elasticities. Use FAO (use s_el_5). 
* EUR: reforestation, all elasticities are low (use s_el)
* ROE: reforestation, all elasticities are low (use s_el)
* RUS: TEM shows much higher deforestation than FAO. Try a not too low elasticity (use s_el_)
* ASI: TEM and FAO shows very high deforestation (use s_el_)
* CHN: TEM suggests deforestation, FAO reforestation. Trust FAO (use s_el)
* IND: TEM suggests deforestation, FAO reforestation. Trust FAO (use s_el)
* BRA: TEM does not have it; FAO and Brazilian official numbers show high deforestation (use Brazilian elasticity - higher than FAO)
* AFR: TEM and FAO shows very high deforestation, use the highest number (use s_el_2)
* MES: TEM suggest low deforestation, FAO reforestation. Use a small one (use s_el)
* LAM: TEM and FAO shows very high deforestation, use the highest number (use s_el_2)
* REA: FAO shows very high deforestation, use the highest number (use s_el_5)


nat_tran("anz","s_el") = nat_tran("anz","s_el_5");
nat_tran("rus","s_el") = nat_tran("rus","s_el_");
nat_tran("asi","s_el") = nat_tran("asi","s_el_");
*nat_tran("bra","s_el") = 0.24;
nat_tran("bra","s_el") = 0.36;
nat_tran("afr","s_el") = nat_tran("afr","s_el_2");
nat_tran("lam","s_el") = nat_tran("lam","s_el_2");
nat_tran("rea","s_el") = nat_tran("lam","s_el_5");

* Choices to calibrate the model to historical deforestation rates:
nat_tran("mex","s_el") = nat_tran("mex","s_el_");
nat_tran("anz","s_el") = nat_tran("anz","s_el_");
nat_tran("asi","s_el") = nat_tran("asi","s_el")*1.5;
nat_tran("lam","s_el") = nat_tran("lam","s_el")*1.2;
nat_tran("rea","s_el") = nat_tran("rea","s_el")*1.5;
nat_tran("afr","s_el") = nat_tran("afr","s_el")*2;


* Calibrate the share of forest output to calibrate benchmark deforestation rates:

nat_tran("afr","nf_f") = 0.2*nat_tran("afr","nf_f");
nat_tran("mex","nf_f") = 0.25*nat_tran("mex","nf_f");
nat_tran("anz","nf_f") = 0.5*nat_tran("anz","nf_f");
nat_tran("rea","nf_f") = 0.75*nat_tran("rea","nf_f");
nat_tran("asi","nf_f") = 1.5*nat_tran("asi","nf_f");
nat_tran("bra","nf_f") = 1.5*nat_tran("bra","nf_f");
nat_tran("lam","nf_f") = 5*nat_tran("lam","nf_f");

nat_tran(r,"nf_f") = nat_tran(r,"nf_f")/100;

nat_tran("idz","s_el") = nat_tran("idz","s_el_2");

*! Test old numbers for Africa
nat_tran("afr","out") = 6;
nat_tran("afr","inp") = 0.07;
nat_tran("afr","nf_f") = 0.48;
nat_tran("afr","s_el") = 0.36;

*! Correct  numbers for Asia
nat_tran("asi","out") = 14.68;
nat_tran("asi","inp") = 0.35;
nat_tran("asi","nf_f") = 0.8;

*! correct elaticities for other regions
nat_tran("mex","s_el") = 0.3;
nat_tran("rea","s_el") = 0.3;
nat_tran("asi","s_el") = 0.45;

* calibrate Brazil and Africa in different way:
nat_tran("bra","out") = 5;
nat_tran("afr","out") = 5;
nat_tran("bra","s_el") = 0.36;
nat_tran("afr","s_el") = 0.5;
nat_tran("bra","inp") = 0.09;

parameter	defarea	area deforested implied by parameters in 1000ha;
defarea("BRA") = 2800;
defarea("AFR") = 3755;


parameter	aband	control land abandonment in regions where reforestation is happening;
aband(agri,r) = 0;
aband("fors","usa") = 0.01;

parameter
pland2		land rents per ha based on EPPA land rents and TEM cover (10$bi per 10000 ha x 1000000 = $ per ha)
d_shr		share of output coming from trad. forestry sector
l_shr		share of land used by trad. forestry sector
f_adj		adjustment to other inputs at forestry sector
;

pland2(r,agri) = ffact(agri,r)/area(r,agri)*1000000;
pland2(r,"ngrass")$area(r,"ngrass") = pland2(r,"live")*nat_tran(r,"inp");
pland2(r,"nfors")$area(r,"nfors") = pland2(r,"fors")*nat_tran(r,"inp");

*! Don't allow land rents in ngrass greater than land rents in forestry:
pland2(r,"ngrass")$(pland2(r,"ngrass") gt pland2(r,"fors")) = 0.95*pland2(r,"nfors");

d_shr(r,g) = 1;
d_shr(r,"fors") = 1 - nat_tran(r,"nf_f");
d_shr(r,"fors")$(not luc(r)) = 1;

* Calculate the share of land used by trad. forestry sector given the share of forest output
* from deforestation and the $ output/ha from deforestation relative to traditional forestry sector

l_shr(r,g) = 1;
l_shr(r,"fors") = (d_shr(r,"fors")/nat_tran(r,"nf_f")*nat_tran(r,"out"))/
	((d_shr(r,"fors")/nat_tran(r,"nf_f")*nat_tran(r,"out"))+1);		

l_shr("afr","fors") = 1 - ((defarea("afr")*pland2("afr","fors"))
 /(ffactd("afr","fors")*10000000));
l_shr("bra","fors") = 1 - ((defarea("bra")*pland2("bra","fors"))
 /(ffactd("bra","fors")*10000000));

l_shr(r,g)$(not luc(r)) = 1;

nat_tran("afr","nf_f") = 1 / 
	(( 1 / 
	(((1 / l_shr("afr","fors"))-1)*nat_tran("afr","out"))) + 1);
nat_tran("bra","nf_f") = 1 / 
	(( 1 / 
	(((1 / l_shr("bra","fors"))-1)*nat_tran("bra","out"))) + 1);

d_shr("afr",g) = 1;
d_shr("afr","fors") = 1 - nat_tran("afr","nf_f");
d_shr("afr","fors")$(not luc("afr")) = 1;
d_shr("bra",g) = 1;
d_shr("bra","fors") = 1 - nat_tran("bra","nf_f");
d_shr("bra","fors")$(not luc("bra")) = 1;


display l_shr;

* Define parameters to the natural land transformation functions:

parameter	defarea2	area deforested implied by parameters in 1000ha;
defarea2(r,"fors") = ffactd(r,"fors")*(1-l_shr(r,"fors"))/pland2(r,"fors")*10000000;
defarea2(r,"nfors") = FFACTD(R,"fors")*(1-l_shr(r,"fors"))*nat_tran(r,"inp")/pland2(r,"nfors")*10000000;

display defarea2, defarea;

parameters
lndout		value of natural harvested forestry
otinp		value of other inputs
bench_area	correction factor to match benchmark areas
chknl		check
xp0f		xp0 forest
fffor		fixed factor endowment of natural land conversion
;

fffor(nat,r) = 1;
lndout(r,"nfors") = nat_tran(r,"out")*xp0(r,"fors")/area(r,"fors")*1000000;
lndout(r,"ngrass") = 0;
otinp(r,"nfors") = lndout(r,"nfors") + pland2(r,"fors") - pland2(r,"nfors");
otinp(r,"ngrass") = lndout(r,"ngrass") + pland2(r,"live") - pland2(r,"ngrass");
chknl(r,nat,"wood") = lndout(r,nat);
chknl(r,"nfors","Fland") = pland2(r,"fors");
chknl(r,"nfors","NFland") = pland2(r,"nfors");
chknl(r,"ngrass","Fland") = pland2(r,"live");
chknl(r,"ngrass","NFland") = pland2(r,"ngrass");
chknl(r,nat,"otinp") = otinp(r,nat);
chknl(r,nat,"tot") = chknl(r,nat,"wood") + chknl(r,nat,"Fland") - chknl(r,nat,"NFland") - chknl(r,nat,"otinp");
xp0f(r) = xp0(r,"fors");

* value of other inputs = forestry land rents + timber value from nat. forest - natural forest land rents
otinp(r,"fors") = (FFACTD(R,"fors")*l_shr(r,"fors"))+(xp0(r,"fors")*nat_tran(r,"nf_f"))-
	(FFACTD(R,"fors")*l_shr(r,"fors")*nat_tran(r,"inp"));

bench_area(r) = (FFACTD(R,"fors")*(1-l_shr(r,"fors"))*nat_tran(r,"inp"));
*bench_area(r) = 0;

display chknl, xp0f, lndout;
		
* Fixed Factor = Difference between land rents under harvested and natural forest
FFFOR(NFORS,R) = (FFACTD(R,"FORS")*(1-l_shr(r,"FORS"))-(FFACTD(R,"FORS")*(1-l_shr(r,"FORS"))*nat_tran(r,"inp")));

* old formulation for ngrass transformation -- same as in the JAFIO version
* FFFOR(NGRASS,r) = (xp0(r,"live")*nat_tran(r,"nf_f")*otinp(r,ngrass)*0.00000001);

display fffor, l_shr;

parameter l_fx_el	elasticity of substitution in the fixed factor at natural forest land transformation function
	  alpha_l;

* cost share = fixed factor  / total output (land rents + timber stock value)		
alpha_l(r,t,"nfors") = fffor("nfors",r)/(FFACTD(R,"fors")*(1-l_shr(r,"fors"))+(xp0(r,"fors")*nat_tran(r,"nf_f")));
l_fx_el(r,"nfors") = nat_tran(r,"s_el")/(1-alpha_l(r,"2007","nfors"));
alpha_l(r,t,"ngrass") = alpha_l(r,t,"nfors");
l_fx_el(r,"ngrass") = l_fx_el(r,"nfors");

display alpha_l, l_fx_el;

parameter rep_nft	report natural forest land transformation parameters;
rep_nft(r,"sh_timb") = 1 - d_shr(r,"fors"); 
rep_nft(r,"sh_lnd") = 1 - l_shr(r,"fors");
rep_nft(r,"s_el") = nat_tran(r,"s_el");
rep_nft(r,"l_fx_el") = l_fx_el(r,"nfors");

display rep_nft;

PARAMETER	RENTV		rent value of natural areas (10bi$)
		RENTV0;

rentv(r,nat) = pland2(r,nat)*area(r,nat)/1000000;
RENTV0(R,NAT) = RENTV(R,NAT);

rent_rr2(r,agri,agrii) = pland2(r,agri)/pland2(r,agrii);

comparep(r,"gtap",agri) = pland(r,agri);
comparep(r,"gtap","ppc") = rent_rr(r,"live","crop");
comparep(r,"gtap","pfc") = rent_rr(r,"fors","crop");
comparep(r,"tem",agri) = pland2(r,agri);
comparep(r,"tem","ppc") = rent_rr2(r,"live","crop");
comparep(r,"tem","pfc") = rent_rr2(r,"fors","crop");
comparevfm(r,"gtap",agri) = vfm_gtap(r,agri);
comparevfm(r,"tem",agri) = 10000*ffact(agri,r);

display area, pland2, comparep, comparevfm ;

priceland(r,agri) = pland2(r,agri);
priceland(r,nat) = pland2(r,nat);

pland(r,agri) = priceland(r,agri);
pland(r,nat) = priceland(r,nat) ;

parameter vland	value of land or land price per ha;

vland(r,agri) = pland(r,agri)/0.05/1000;
vland(r,nat) = pland(r,nat)/0.05/1000;

display vland;

* Land value differences:

rent_rr(r,agri,agrii) = vland(r,agri) - vland(r,agrii);
rent_rr(r,agri,nat) = vland(r,agri) - vland(r,nat);
rent_rr(r,nat,agri) = vland(r,nat) - vland(r,agri);

rent_r(r,agri,agrii) = max(0, rent_rr(r,agri,agrii));
rent_r(r,agri,"nfors") = max(0, rent_rr(r,agri,"nfors"));
rent_r(r,agri,"ngrass") = max(0, rent_rr(r,agri,"ngrass"));
rent_r(r,"nfors",agri) = max(0, rent_rr(r,"nfors",agri));
rent_r(r,"ngrass",agri) = max(0, rent_rr(r,"ngrass",agri));

parameter rent_r0;
rent_r0(r,agri,agrii) = rent_r(r,agri,agrii);
rent_r0(r,agri,"nfors") = rent_r(r,agri,"nfors");
rent_r0(r,agri,"ngrass") = rent_r(r,agri,"ngrass");
rent_r0(r,"nfors",agri) = rent_r(r,"nfors",agri);
rent_r0(r,"ngrass",agri) = rent_r(r,"ngrass",agri);

*	Shares of labor, capital and other inputs in the agriculture sectors, to be used in the land use transformation sectors:

parameter	ag_int		share of intermediate inputs in the production function of agriculture
		ag_ene		share of energy inputs in the production funcion of agriculture
		ag_l		share of labor in  the production function of agriculture
		ag_k		share of capital in  the production function of agriculture
		ag_shr		report of shares;

ag_int(r,ne,agri) = (XDP0(R,ne,agri)+XMP0(R,ne,agri))/(sum(ne2, XDP0(R,ne2,agri)+XMP0(R,ne2,agri))+labd(r,agri)+kapd(r,agri)+ene(agri,r) );
ag_ene(r,agri) = ene(agri,r) / (sum(ne2, XDP0(R,ne2,agri)+XMP0(R,ne2,agri))+labd(r,agri)+kapd(r,agri)+ene(agri,r) );
ag_l(r,agri) = labd(r,agri) / (sum(ne2, XDP0(R,ne2,agri)+XMP0(R,ne2,agri))+labd(r,agri)+kapd(r,agri)+ene(agri,r) );
ag_k(r,agri) = kapd(r,agri) / (sum(ne2, XDP0(R,ne2,agri)+XMP0(R,ne2,agri))+labd(r,agri)+kapd(r,agri)+ene(agri,r) );

ag_shr(r,ne,agri) = ag_int(r,ne,agri);
ag_shr(r,"ene",agri) = ag_ene(r,agri);
ag_shr(r,"L",agri) = ag_l(r,agri);
ag_shr(r,"K",agri) = ag_k(r,agri);
ag_shr(r,"TOT",agri) = sum(ne, ag_shr(r,ne,agri)) + ag_ene(r,agri) + ag_l(r,agri) + ag_k(r,agri);

display ag_shr, rent_rr, rent_r;

* Parameters for ngrass transformation function:

* Fixed Factor for ngrass: same proportion of fixed factor to total output in nat forest transformation:
FFFOR(NGRASS,r) = vland(r,"live")*alpha_l(r,"2007",ngrass);
* value of other inputs = output - land input - fixed factor (livestock land value - ngrass land value - fffor)
otinp(r,"ngrass") = vland(r,"live") - vland(r,"ngrass") - fffor("ngrass",r);

display fffor, otinp, alpha_l;
* Verify ngrass land transformation function:

parameter ngrass_chk;
ngrass_chk(r,"out") = vland(r,"live");
ngrass_chk(r,"Linp") = vland(r,"ngrass");
ngrass_chk(r,"otinp") = otinp(r,"ngrass");
ngrass_chk(r,"fffor") = fffor("ngrass",r);
ngrass_chk(r,"suminp") = ngrass_chk(r,"linp") +ngrass_chk(r,"otinp") +ngrass_chk(r,"fffor");
ngrass_chk(r,"chk") = ngrass_chk(r,"suminp") - ngrass_chk(r,"out");

display ngrass_chk;

* Create a markup to convert natural areas to fine tunning and avoid too strong or strange conversions

parameter mkpln	markup in land use transformation to represent costs to open and explore new areas
	  mkpl  markup in land use transformation;

mkpln(r,agri,nat) = 1;
mkpl(r,agri,agrii) = 1;

* Science paper:
*mkpl("chn","crop",agrii) = 3;
*mkpl("ind","crop",agrii) = 3;
*mkpl("lam","crop",agrii) = 3;
*mkpl("afr","crop",agrii) = 3;

parameter reporlnd	report land information;
reporlnd(r,agri,"rent/ha") = priceland(r,agri);
reporlnd(r,agri,"area") = area(r,agri);
reporlnd(r,agri,"ffact") = ffact(agri,r);
reporlnd(r,agri,"ha/$") = 1/priceland(r,agri);

display reporlnd;

* Define flags to activate land use transformation functions in eppaloop

parameter	lnd_ch	flag to activate land use transformation among agriculture sectors
		NLND_CH flag to activate land use transformation among natural cover and agriculture sectors
		hlnd_ch flag to activate land use transformation from harvested sectors to natural;

lnd_ch = 0;
NLND_CH(nat,r) = 0;
nlnd_ch("nfors",r) = 1;
hlnd_ch(r) = 0;

* Define which transitions are possible to occur:

Parameter
ltranf	 flag to activate transformation in land use from one activity to other
nltranf  flag to activate transformation in land use from natural to other
lntranf  flag to activate transformation in land use from other to natural
;

* Allow agriculture transitions:
ltranf(r,agri,agrii) = 1;
ltranf(r,agri,agrii)$(rent_rr(r,agri,agrii) eq 1) = 0;
ltranf(r,agri,agri) = 0;
* Allow agriculture abandonment:
nltranf(r,nat,agri) = 1;
* Don't allow converstion from pasture to forests:
ltranf(r,"fors","live") = 0;
nltranf(r,"nfors","live") = 0;
* Natural forest can directly become only harv. forest and natural grass only pasture:
lntranf(r,agri,nat) = 0;
lntranf(r,"fors","nfors") = 1;
lntranf(r,"live","ngrass") = 1;

display ltranf, lntranf;

parameter area_sh(r,*)	share of land use types;
area_sh(r,agri) = area(r,agri)/(sum(agrii, area(r,agrii))+sum(nat, area(r,nat)));
area_sh(r,nat) = area(r,nat)/(sum(agri, area(r,agri))+sum(natt, area(r,natt)));
display area_sh;

* Productivity

parameter npp;
npp(r,agri) = 1;
npp(r,nat) = 1;

parameter	lucwadj	adjustment in the welfare function to account for benchmark deforestation;
lucwadj(r,"nfors") = (FFACTD(R,"fors")*(1-l_shr(r,"fors"))*nat_tran(r,"inp"))


parameter ffact0;
ffact0(agri,r) = ffact(agri,r);

parameter sbt_elas(r,nat);
sbt_elas(r,nfors) = 0;
sbt_elas(r,ngrass) = 0;


*** Here ends most of the LUC code


**!! Adding carbon in vegetation and soil


*** Include carbon in vegetation (g/m2) 
* (need to update numbers for EPPA5 regions, at this point, numbers for
* BRA = LAM, RUS = FSU, ROE = EET, REA = ROW)
* to get ton/ha x 0.01
* to get CO2 x 44/12, but EPPA works with mmt of C

* Table below is the most updated data, and the sum of veg and soilcarb

Table soilcarb(r,*)	carbon in soil from TEM in g per m2
	live 	crop 	fors 	ngrass 	nfors 
AFR	2450	6340	3481	3078	12481
ANZ	2492	7692	1991	3942	3832
ASI	5898	8956	8165	4681	30322
CAN	6712	16343	11691	9490	18039
CHN	5061	7364	10434	8387	6290
ROE	5585	8550	8128	6208	18582
EUR	5593	8933	9305	7399	16727
RUS	3343	11522	10615	10822	13718
BRA	5051	9455	7176	10934	22143
IND	4173	4875	6521	4739	16590
JPN	7266	9029	9767	0	21147
LAM	5051	9455	7176	10934	22143
MES	929	3478	1757	1770	1325
MEX	3257	7572	4100	3942	5839
REA	3537	6504	4599	4795	18739
USA	4370	7646	9491	7673	9499
* Use ASI numbers for IDZ and KOR
IDZ	5898	8956	8165	4681	30322
KOR	5898	8956	8165	4681	30322
;

**!! Table above has some issues to be solved
**!! At this point, we prefer to use land emissions from 
**!! the exogenous deforestation trend

parameter	vstcarb		total veg and soil carbon in vegetation g of carbon per m2
		difcarb		difference in carbon between two vegetation types tons of carbon per ha 
		debtcarb	carbon debt
		credcarb	carbon credit
		debtcarb0
		credcarb0
		credcarb_
		credcarb_0;

soilcarb(r,"rnfors") = soilcarb(r,"nfors");
vstcarb(r,lu) = soilcarb(r,lu);

display vstcarb;

* Define some elasticities in the agricultural production block
* to allow changing it in some scenarios when LUC emissions are considered

parameter 	ellanden	elasticity of substitution between land - energy materials bundle
		ellavalan	elasticity of substitution between land energy material bundle - va;
ellanden(g) = 0.7;
ellavalan(g) = 0.6;

* To convert from g per m2 to ton per ha: multiply by 0.01 (10000 m2 per ha / 1000000 g per ton)

difcarb(r,lu,lu_) = 0.01*(vstcarb(r,lu_) - vstcarb(r,lu));
difcarb(r,"other",lu) = 0;
difcarb(r,lu,"other") = 0;

* Use the same carbon unit as in other EPPA sectors 
* It means that the carbon amount has an order 100 times bigger than
* the dollar amounts (100 Million Carbon x 10 billion dollars)
* So, the land transition functions should have prices 100 times smaller than
* the carbon emissions from those transitions 
* Emissions below in 10 ton per ha x interest rate (to measure flows instead of stocks)

* Average rotation age for ecossystems:

Parameter av_rot, disc_r, disc_r_;
av_rot("USA") =	 55 ;
av_rot("CAN") =	 61 ; 
av_rot("MEX") =	 12 ;
av_rot("JPN") =	 75 ; 
av_rot("ANZ") =	 35 ; 
av_rot("EUR") =	 60 ; 
*av_rot("EET") =	 98 ; 
av_rot("ROE") =	 98 ; 
av_rot("RUS") =	 89 ; 
av_rot("ASI") =	 28 ; 
av_rot("CHN") =	 60 ; 
av_rot("IND") =	 33 ; 
av_rot("IDZ") =	 10 ; 
av_rot("BRA") =	 9 ; 
av_rot("AFR") =	 12 ; 
av_rot("MES") =	 9 ; 
av_rot("LAM") =	 9 ; 
*av_rot("ROW") =	 27 ;
av_rot("REA") =	 27 ; 
av_rot("KOR") = 50;
av_rot(r)$(av_rot(r) lt 31) = 30;
disc_r(r,lu) = 0.04;
disc_r_(r,lu) = 1;
*disc_r(r,nat) = 0.04 - (1/(2*av_rot(r)));

debtcarb(r,lu,lu_)$(difcarb(r,lu,lu_) gt 0) = difcarb(r,lu,lu_)*0.1*0.04;
credcarb(r,lu,lu_)$(difcarb(r,lu,lu_) lt 0) = -difcarb(r,lu,lu_)*0.1*0.04;

debtcarb0(r,lu,lu_) = debtcarb(r,lu,lu_);
credcarb0(r,lu,lu_) = credcarb(r,lu,lu_);
credcarb_(r,lu,lu_) = credcarb(r,lu,lu_);
credcarb_0(r,lu,lu_) = credcarb(r,lu,lu_);

display vstcarb, difcarb, debtcarb, credcarb;

* Flags about carbon from land
set	clnd	flag to activate carbon policy on land use changes;
set	clnd_	flag to activate carbon credits direct to the representative agent;
set	clndf	flag to activate carbon policy only on deforestation
set	clndfsb flag to activate subsidies to keep natural forest;

clnd(r)	= no;	
clnd_(r) = no;
clndf(r) = no;
clndfsb(r,nat) = no;

parameter	clndd		flag to activate carbon credits direct to the representative agent
		carb_for	carbon permits for deforestation
		for_sub		subsidies to keep natural forest;
clndd = 0;
carb_for(r) = 0;
for_sub(r,nat) = 0;

parameter for_quota deforestation quota;
for_quota(r,t) = 0;

*! GHG emissions in biofuel crop sectors:
parameter oghg_bc;
oghg_bc(ghg,r) = oghg(ghg,"crop",r);


parameter lnd_tran0;
lnd_tran0(r,agri,agrii,t) = 0;