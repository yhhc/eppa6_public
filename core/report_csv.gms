$TITLE Report for csv files

execute 'cd ../results/%csnm%'
execute 'mkdir csv'
*HENRY's data for EPPA workshop

*elec_total elec output (EJ)
execute 'gdxdump ../results/%csnm%/%nper% symb=telecprd  format=csv cdim=y output=../results/%csnm%/csv/telecprd_%nper%.csv';

*elec_hydro pwr output (EJ)
execute 'gdxdump ../results/%csnm%/%nper% symb=e_prd_h format=csv cdim=y output=../results/%csnm%/csv/e_prd_h_%nper%.csv';

*elec_nuclear pwr output (EJ)
execute 'gdxdump ../results/%csnm%/%nper% symb=e_prd_n format=csv cdim=y output=../results/%csnm%/csv/e_prd_n_%nper%.csv';

*elec_coal fired output (EJ)
execute 'gdxdump ../results/%csnm%/%nper% symb=eleccoal format=csv cdim=y output=../results/%csnm%/csv/eleccoal_%nper%.csv';

*elec_gas fired output (EJ)
execute 'gdxdump ../results/%csnm%/%nper% symb=elecgas format=csv cdim=y output=../results/%csnm%/csv/elecgas_%nper%.csv';

*elec_oil fired output (EJ)
execute 'gdxdump ../results/%csnm%/%nper% symb=elecoil format=csv cdim=y output=../results/%csnm%/csv/elecoil_%nper%.csv';

*elec_igcc w/ccs output (EJ)
execute 'gdxdump ../results/%csnm%/%nper% symb=bbicsout format=csv cdim=y output=../results/%csnm%/csv/bbicsout_%nper%.csv';

*elec_ngcc output (EJ)
execute 'gdxdump ../results/%csnm%/%nper% symb=bbngout format=csv cdim=y output=../results/%csnm%/csv/bbngout_%nper%.csv';

*elec_ngcc w/ccs output (EJ)
execute 'gdxdump ../results/%csnm%/%nper% symb=bbncsout format=csv cdim=y output=../results/%csnm%/csv/bbncsout_%nper%.csv';

*elec_wind pwr output (EJ)
execute 'gdxdump ../results/%csnm%/%nper% symb=bbwout format=csv cdim=y output=../results/%csnm%/csv/bbwout_%nper%.csv';

*elec_bio-elec output (EJ)
execute 'gdxdump ../results/%csnm%/%nper% symb=bbbioeleout format=csv cdim=y output=../results/%csnm%/csv/bbbioeleout_%nper%.csv';

*elec_advanced nuclear pwr output (EJ)
execute 'gdxdump ../results/%csnm%/%nper% symb=bbadvnucl_bout format=csv cdim=y output=../results/%csnm%/csv/bbadvnucl_bout_%nper%.csv';

*elec_wind-bio output (EJ)
execute 'gdxdump ../results/%csnm%/%nper% symb=bbwbioout format=csv cdim=y output=../results/%csnm%/csv/bbwbioout_%nper%.csv';

*elec_wind-gas output (EJ)
execute 'gdxdump ../results/%csnm%/%nper% symb=bbwgasout format=csv cdim=y output=../results/%csnm%/csv/bbwgasout_%nper%.csv';

*elec_solar pwr output (EJ)
execute 'gdxdump ../results/%csnm%/%nper% symb=bbsolout format=csv cdim=y output=../results/%csnm%/csv/bbsolout_%nper%.csv';

*econ_gdp (10 billion US$
execute 'gdxdump ../results/%csnm%/%nper% symb=agnp format=csv cdim=y output=../results/%csnm%/csv/agnp_%nper%.csv';

*econ_consumption (10 billion US$)
execute 'gdxdump ../results/%csnm%/%nper% symb=aca format=csv cdim=y output=../results/%csnm%/csv/aca_%nper%.csv';

*econ_investment (10 billion US$)
execute 'gdxdump ../results/%csnm%/%nper% symb=aia format=csv cdim=y output=../results/%csnm%/csv/aia_%nper%.csv';

*econ_government expenditure (10 billion US$
execute 'gdxdump ../results/%csnm%/%nper% symb=aga format=csv cdim=y output=../results/%csnm%/csv/aga_%nper%.csv';

*econ_exports (10 billion US$)
execute 'gdxdump ../results/%csnm%/%nper% symb=axa format=csv cdim=y output=../results/%csnm%/csv/axa_%nper%.csv';

*econ_imports
execute 'gdxdump ../results/%csnm%/%nper% symb=ama format=csv cdim=y output=../results/%csnm%/csv/ama_%nper%.csv';

*energy consumption by fuel type
execute 'gdxdump ../results/%csnm%/%nper% symb=ee format=csv cdim=y output=../results/%csnm%/csv/ee_%nper%.csv';

*emis_total CO2 (million ton
execute 'gdxdump ../results/%csnm%/%nper% symb=totco2 format=csv cdim=y output=../results/%csnm%/csv/totco2_%nper%.csv'

*emis_total CO2e (million ton)
execute 'gdxdump ../results/%csnm%/%nper% symb=co2eq format=csv cdim=y output=../results/%csnm%/csv/co2eq_%nper%.csv'

*COV notes for writing some of the results for MAC
*demopopulation we need to write a parameter in eppaloop we cannot compute anything while using gdxdummp          	        	 	   
*data("demo_population (million people)",r,t)        = population(r,t)*popgr("%popg%",t)$(ord(t) ne 1)+population(r,t)$(ord(t) eq 1);;      	 	   
*ener_total energy consumption (EJ) idem we need to write this parmeter in eppaloop before using gdxdump             	        	 	   

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

  	       
* Without distinguishing scenarios with different population ana productivity growth:
*execute_unload "../results/all_%csnm%.gdx";   		      
execute_unload "../results/all_%csnm%_%popg%_%prog%_gdpg-%gdpg%_aeeg-%aeeg%_sekl-%sekl%.gdx";   		      
      	       
