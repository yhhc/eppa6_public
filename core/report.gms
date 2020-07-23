parameter  data         model output;


* the set "time" is a subset of t, and it is used to control the years of output reported
* It is defined in \parameters\eppaset.gms

* Economic indicators:

data("01_GDP (billion US$)",time,r)                  = eps + agnp(r,time)*10;
data("02_Consumption (billion US$)",time,r)          = eps + aca(r,time)*10;
data("03_GDP growth",time,r)                         = eps + ((agnp(r,time+1)/agnp(r,time))**(1/3)-1)$(time.val eq 2007 and agnp(r,time) ne 0)
                                                       +((agnp(r,time+1)/agnp(r,time))**(1/5)-1)$(time.val gt 2007 and time.val le 2095 and agnp(r,time) ne 0)
		                                       +(data("03_GDP growth","2095",r))$(time.val gt 2095);
data("04_Population (million people)",time,r)        = eps + population(r,time)*popgr("%popg%",time)$(ord(time) ne 1)+population(r,time)$(ord(time) eq 1);
data("05_GDP per capita (US$)",time,r)               = eps + agnp(r,time)/population(r,time)*10000;

* GHG emissions:
data("06_CO2_fossil (million ton)",time,r)           = eps + ftotco2(r,time);
data("07_CO2_industrial (million ton)",time,r)       = eps + etotco2(r,time);
data("08_CO2_land use change (million ton)",time,r)  = eps + ctotco2(r,time);
data("09_CH4 (kilo ton)",time,r)                     = eps + tghgky("CH4",r,time)*1;
data("10_N2O (kilo ton)",time,r)                     = eps + tghgky("N2O",r,time)*1;
data("11_PFC (kilo ton)",time,r)                     = eps + tghgky("PFC",r,time)*1;
data("12_SF6 (kilo ton)",time,r)                     = eps + tghgky("SF6",r,time)*1;
data("13_HFC (kilo ton)",time,r)                     = eps + tghgky("HFC",r,time)*1;
data("14_CO2eq_total (million ton)",time,r)          = eps + ftotco2(r,time) + etotco2(r,time) + ctotco2(r,time) + sum(ghg,tghgky(ghg,r,time)*gwp(ghg)*44/12)/1000;
                                                           
* Primary energy use:
data("15_coal (EJ)",time,r)                         = eps + ee(r,"coal",time) + sum(bt, eeib(bt,"coal",r,time));
data("16_oil (EJ)",time,r)                          = eps + ee(r,"roil",time) + sum(bt, eeib(bt,"roil",r,time));
data("17_gas (EJ)",time,r)                          = eps + ee(r,"gas",time) + sum(bt, eeib(bt,"gas",r,time));
data("18_bioenergy (EJ)",time,r)                    = eps + sum(bt,bbiofuelout(bt,"roil",r,time))+bbbioeleout(r,time)/(ele_pe("usa","2007")*1.003**(max(0,3+5*(ord(time)-2))));
data("19_nuclear (EJ)",time,r)                      = eps + (e_prd_n(r,time)+bbadvnucl_bout(r,time))/(ele_pe("usa","2007")*1.003**(max(0,3+5*(ord(time)-2))));
data("20_hydro (EJ)",time,r)                        = eps + e_prd_h(r,time)/(ele_pe("usa","2007")*1.003**(max(0,3+5*(ord(time)-2))));                     
data("21_renewables (wind&solar) (EJ)",time,r)      = eps + (bbwout(r,time)+bbsolout(r,time))/(ele_pe("usa","2007")*1.003**(max(0,3+5*(ord(time)-2))));

* Electricity production (1 EJ = 1000/3.6 TWh = 277.7778 TWh):
data("22a_coal_no CCS (TWh)",time,r)                = eps + 277.7778*(eleccoal(r,time)+bbigout(r,time));
data("22b_coal_CCS (TWh)",time,r)                   = eps + 277.7778*(bbicsout(r,time));
data("23_oil (TWh)",time,r)                         = eps + 277.7778*(elecoil(r,time));
data("24a_gas_no CCS (TWh)",time,r)                 = eps + 277.7778*(elecgas(r,time)+bbngout(r,time));
data("24b_gas_CCS (TWh)",time,r)                    = eps + 277.7778*(bbncsout(r,time));
data("25_nuclear (TWh)",time,r)                     = eps + 277.7778*(e_prd_n(r,time)+bbadvnucl_bout(r,time));
data("26_hydro (TWh)",time,r)                       = eps + 277.7778*(e_prd_h(r,time));
data("27_renewables (wind&solar) (TWh)",time,r)     = eps + 277.7778*(bbwout(r,time)+bbsolout(r,time));
*data("27a_renewables_wind (TWh)",time,r)           = eps + 277.7778*bbwout(r,time);
*data("27b_renewables_solar (TWh)",time,r)          = eps + 277.7778*bbsolout(r,time);

* Household transportation
* note that vehicle miles traveled is proportional to the number of vehicles, as in the Outlook version of EPPA5

data("28_number of vehicles (millions)",time,r)     = eps + cons_tran(r,time);
data("29_vehicle miles traveled",time,r)            = eps + cons_tran(r,time);
data("30_miles per gallon",time,r)                  = eps + (cons_tran(r,time)/energy_htrn(r,time))$(energy_htrn(r,time) ne 0);

* Land use
data("31_landuse_Cropland",time,r)                  = eps;
data("32_landuse_Biofuels",time,r)                  = eps;
data("33_landuse_Pasture",time,r)                   = eps;
data("34_landuse_Managed forest",time,r)            = eps;
data("35_landuse_Natural grassland",time,r)         = eps;
data("36_landuse_Natural forest",time,r)            = eps;
data("37_landuse_Other",time,r)                     = eps;

* Air pollutant emissions
data("38_SO2 (Tg)",time,r)                          = eps + sum(rep, chmurb(rep,"SO2",r,time)); 
data("39_NOx (Tg)",time,r)                          = eps + sum(rep, chmurb(rep,"NOX",r,time)); 
data("40_Ammonia (Tg)",time,r)                      = eps + sum(rep, chmurb(rep,"AMO",r,time)); 
data("41_Volatile organic compounds (Tg)",time,r)   = eps + sum(rep, chmurb(rep,"VOC",r,time)); 
data("42_Black carbon (Tg)",time,r)		    = eps + sum(rep, chmurb(rep,"BC", r,time));   
data("43_Organic particulates (Tg)",time,r)	    = eps + sum(rep, chmurb(rep,"OC", r,time));   
data("44_Carbon monoxide (Tg)",time,r)              = eps + sum(rep, chmurb(rep,"CO", r,time));  

* CO2 captured
data("47_CO2 capture and storage (million ton)",time,r)
                                                    = eps + bco2("igcap",r,time)/(1-bsin("igcap","frseq",r))
                                                          + bco2("ngcap",r,time)/(1-bsin("ngcap","frseq",r));
* Prices
data("48a_price_coal",time,r)                       = apa("coal",r,time);
data("48b_price_oil",time,r)                        = apa("oil",r,time);
data("48c_price_gas",time,r)                        = apa("gas",r,time);

* Report starting from the year 2007 rather than 2010 (note the time index is now "t" instead of "time"):

data("106_CO2_fossil (million ton)",t,r)           = eps + ftotco2(r,t);
data("107_CO2_industrial (million ton)",t,r)       = eps + etotco2(r,t);
data("108_CO2_land use change (million ton)",t,r)  = eps + ctotco2(r,t);
data("109_CO2_total (million ton)",t,r)            = eps + ftotco2(r,t)+etotco2(r,t)+ctotco2(r,t);
data("110_CH4 (kilo ton)",t,r)                     = eps + tghgky("CH4",r,t)*1;
data("111_N2O (kilo ton)",t,r)                     = eps + tghgky("N2O",r,t)*1;
data("112_PFC (kilo ton)",t,r)                     = eps + tghgky("PFC",r,t)*1;
data("113_SF6 (kilo ton)",t,r)                     = eps + tghgky("SF6",r,t)*1;
data("114_HFC (kilo ton)",t,r)                     = eps + tghgky("HFC",r,t)*1;
data("115_CO2eq_total (million ton)",t,r)          = eps + ftotco2(r,t) + etotco2(r,t) + ctotco2(r,t) + sum(ghg,tghgky(ghg,r,t)*gwp(ghg)*44/12)/1000;


data("137_SO2 (Tg)",t,r)                          = eps + sum(rep, chmurb(rep,"SO2",r,t)); 
data("138_NOx (Tg)",t,r)                          = eps + sum(rep, chmurb(rep,"NOX",r,t)); 
data("139_Ammonia (Tg)",t,r)                      = eps + sum(rep, chmurb(rep,"AMO",r,t)); 
data("140_Volatile organic compounds (Tg)",t,r)   = eps + sum(rep, chmurb(rep,"VOC",r,t)); 
data("141_Black carbon (Tg)",t,r)		  = eps + sum(rep, chmurb(rep,"BC", r,t));   
data("142_Organic particulates (Tg)",t,r)	  = eps + sum(rep, chmurb(rep,"OC", r,t));   
data("143_Carbon monoxide (Tg)",t,r)              = eps + sum(rep, chmurb(rep,"CO", r,t));  
    
data("45_Food consumption (billion US$)",t,r)     = eps + cons_sec("food",r,t);
data("46_CO2 price (US$ per ton CO2)",t,r)        = eps + cbtax(r,t)$co2c(r) + tcbtax(r,t)$tco2c(r);

* Backstop technologies: 
data("201_ngcc (TWh)",time,r)                     = eps + 277.7778*(bbngout(r,time));
data("202_ngcap (TWh)",time,r)                    = eps + 277.7778*(bbncsout(r,time));
data("203_igcap (TWh)",time,r)                    = eps + 277.7778*(bbicsout(r,time));
data("204_bioelec (TWh)",time,r)                  = eps + 277.7778*(bbbioeleout(r,time));
data("205_wind (TWh)",time,r)                     = eps + 277.7778*(bbwout(r,time));
data("206_solar (TWh)",time,r)                    = eps + 277.7778*(bbsolout(r,time));
data("207_adv-nucl (TWh)",time,r)                 = eps + 277.7778*(bbadvnucl_bout(r,time));
data("208_windgas (TWh)",time,r)                  = eps + 277.7778*(bbwgasout(r,time));
data("209_windbio (TWh)",time,r)                  = eps + 277.7778*(bbwbioout(r,time));
data("210_h2 (EJ)",time,r)                        = eps + bbh2out("oil",r,time);
data("211_bio-oil (EJ)",time,r)                   = eps + bbiofuelout("bio-oil","roil",r,time);

* Sectoral value added:
data("301_value_added_CROP (10 bn US$)",time,r)		  = eps + sva("CROP",r,time);
data("302_value_added_LIVE (10 bn US$)",time,r)		  = eps + sva("LIVE",r,time);
data("303_value_added_FORS (10 bn US$)",time,r)		  = eps + sva("FORS",r,time);
data("304_value_added_FOOD (10 bn US$)",time,r)		  = eps + sva("FOOD",r,time);
data("305_value_added_COAL (10 bn US$)",time,r)		  = eps + sva("COAL",r,time);
data("306_value_added_OIL  (10 bn US$)",time,r)		  = eps + sva("OIL",r,time);
data("307_value_added_ROIL (10 bn US$)",time,r)		  = eps + sva("ROIL",r,time);
data("308_value_added_GAS  (10 bn US$)",time,r)		  = eps + sva("GAS",r,time);
data("309_value_added_ELEC (10 bn US$)",time,r)		  = eps + sva("ELEC",r,time);
data("310_value_added_EINT (10 bn US$)",time,r)		  = eps + sva("EINT",r,time);
data("311_value_added_OTHR (10 bn US$)",time,r)		  = eps + sva("OTHR",r,time);
data("312_value_added_SERV (10 bn US$)",time,r)		  = eps + sva("SERV",r,time);
data("313_value_added_TRAN (10 bn US$)",time,r)		  = eps + sva("TRAN",r,time);
data("314_value_added_DWE  (10 bn US$)",time,r)		  = eps + sva("DWE",r,time);

$ontext
* In EPPA5:
amf_rep("23_PE_bio", astep, areg) = sum(bt, bio_prod(bt, areg, astep));
amf_rep("24_PE_bio_ccs", astep, areg) = 0;
bio_prod(bt,r,t) = bbiofuelout(bt,"roil",r,t);
$offtext

*Coal
*Oil
*Biofuels
*Gas
*Nuclear
*Hydro
*Renewables

parameter pivotdata  pivot report data;

pivotdata("output",t)                    = eps+sum(r,agnp(r,t));
pivotdata("consumption",t)               = eps+sum(r,aca(r,t));
pivotdata("population",t)                = eps+sum(r,population(r,t))*popgr("%popg%",t);
pivotdata("fossil energy consumption",t) = eps+sum(r,ee(r,"coal",t)+ee(r,"roil",t)+ee(r,"gas",t));
pivotdata("total energy consumption",t)  = eps+pivotdata("fossil energy consumption",t)+sum(r,e_prd_h(r,t)+e_prd_n(r,t)
                                              +bbadvnucl_bout(r,t)+bbwout(r,t)+ bbwgasout(r,t)+bbwbioout(r,t)
                                              +bbbioeleout(r,t)+bbsolout(r,t));
pivotdata("total CO2",t)                 = eps+sum(r,totco2(r,t));
pivotdata("total CO2e",t)                = eps+sum(r,co2eq(r,t));


$ontext
data("elec_total elec output (EJ)",r,t)             = telecprd(r,t);       		        				   
data("elec_hydro pwr output (EJ)",r,time)              = e_prd_h(r,time);              	        	 	   
data("elec_nuclear pwr output (EJ)",r,time)            = e_prd_n(r,time);              	        	 	   
data("elec_coal fired output (EJ)",r,time)     	    = eleccoal(r,time);             	        	 	   
data("elec_gas fired output (EJ)",r,time)     	    = elecgas(r,time);              	        	 	   
data("elec_oil fired output (EJ)",r,time)     	    = elecoil(r,time);              	        	 	   
data("elec_igcc w/ccs output (EJ)",r,time)    	    = bbicsout(r,time);             	        	 	   
data("elec_ngcc output (EJ)",r,time)                   = bbngout(r,time);              	        	 	   
data("elec_ngcc w/ccs output (EJ)",r,time)     	    = bbncsout(r,time);             	        	 	   
data("elec_wind pwr output (EJ)",r,time)      	    = bbwout(r,time);               	        	 	   
data("elec_bio-elec output (EJ)",r,time) 	            = bbbioeleout(r,time);          	        	
data("elec_advanced nuclear pwr output (EJ)",r,time)   = bbadvnucl_bout(r,time);       	       
data("elec_wind-bio output (EJ)",r,time)               = bbwbioout(r,time);            	       
data("elec_wind-gas output (EJ)",r,time)               = bbwgasout(r,time);            	       
data("elec_solar pwr output (EJ)",r,time)              = bbsolout(r,time);             	       

data("econ_gdp (10 billion US$)",r,time)               = agnp(r,time);
data("econ_consumption (10 billion US$)",r,time)       = aca(r,time);
data("econ_investment (10 billion US$)",r,time)        = aia(r,time);
data("econ_government expenditure (10 billion US$)",r,time)   = aga(r,time);		 
data("econ_exports (10 billion US$)",r,time)                  = axa(r,time);  	 
data("econ_imports (10 billion US$)",r,time)                  = ama(r,time);  	 
data("demo_population (million people)",r,time)        = population(r,time)*popgr("%popg%",time)$(ord(time) ne 1)+population(r,time)$(ord(time) eq 1);
data("ener_coal consumption (EJ)",r,time)              = ee(r,"coal",time);
data("ener_gas consumption (EJ)",r,time)               = ee(r,"gas",time);
data("ener_roil consumption (EJ)",r,time)              = ee(r,"roil",time);
data("ener_fossil energy consumption (EJ)",r,time)     = ee(r,"coal",time)+ee(r,"roil",time)+ee(r,"gas",time);
data("ener_total energy consumption (EJ)",r,time)      = ee(r,"coal",time)+ee(r,"roil",time)+ee(r,"gas",time)+e_prd_h(r,time)+e_prd_n(r,time)
	+ bbadvnucl_bout(r,time)+bbwout(r,time)+ bbwgasout(r,time)+bbwbioout(r,time)
	+ bbbioeleout(r,time)+bbsolout(r,time);
data("emis_total CO2 (million ton)",r,time)            = totco2(r,time);
data("emis_total CO2e (million ton)",r,time)           = co2eq(r,time);
$offtext
                                       
* To distinguish outputs from scenarios differ in population growth and productivity growth, use the following two lines:
*execute_unload "..\results\all_%csnm%_%popg%_%prog%.gdx";   		      
*execute 'gdxxrw i=..\results\all_%csnm%_%popg%_%prog%.gdx  o=..\results\mup_%csnm%_%popg%_%prog%.xls par=data  rng=data!a2  cdim=1'; 	

* Without distinguishing scenarios with different population ana productivity growth:
*execute_unload "..\results\all_%csnm%.gdx";   		      
execute_unload "..\results\all_%csnm%_%popg%_%prog%_gdpg-%gdpg%_aeeg-%aeeg%_sekl-%sekl%.gdx";   		      


$ifthen %system.filesys%==UNIX 
*UNIX = do nothing
$else
*COV Only works in DOS (COV)
*execute 'gdxxrw i=..\results\all_%csnm%.gdx  o=..\results\output_%csnm%.xls par=data  rng=data!a2  cdim=0'; 	        		      
*execute 'gdxxrw i=..\results\all_%csnm%.gdx  o=..\results\out_%csnm%.xls par=data  rng=data!a1  cdim=1'; 	
execute 'gdxxrw i=..\results\all_%csnm%_%popg%_%prog%_gdpg-%gdpg%_aeeg-%aeeg%_sekl-%sekl%.gdx  o=..\results\out_%csnm%_%popg%_%prog%_gdpg-%gdpg%_aeeg-%aeeg%_sekl-%sekl%.xls par=data  rng=data!a2  cdim=0'; 	
*execute 'gdxxrw i=..\results\all_%csnm%_%popg%_%prog%_gdpg-%gdpg%_aeeg-%aeeg%_sekl-%sekl%.gdx  o=..\results\out_%csnm%_%popg%_%prog%_gdpg-%gdpg%_aeeg-%aeeg%_sekl-%sekl%.xls par=data  rng=data!a1  cdim=1'; 	


$endif

*execute_unload "..\results\gdp.gdx" agnp;
*execute 'gdxxrw i=..\results\gdp.gdx o=..\results\outlook.xls par=agnp rng=agnp!a2';





