* Emissions accounting (million tons)

* epslon(e)     = coefficient of carbon contents (100M tons per EJ); defined in eppaghg.gms
* cj(e,r)       = adjustment factor for epslon
* ee(r,e,t)     = energy consumption in EJ
* eind(e,i,r)   = volume of energy demand (EJ); declared in readgtap.gms
* eind(ec,i,r)  = evd(ec,i,r); note: eind has been converted from mtoe to EJ in the data preparation stage
* evd(ec,i,r)   = evf(ec,i,r)   = volume of input purchases by firms (mtoe) 
* evd(ec,"c",r) = evh(ec,r)     = volume of purchases by households (mtoe)  
* hefd(e,r)     = household energy use (EJ)
* hefd(e,r)     = efd(e,r);
* tefd(e,r)     = household transport roil use (EJ)
* tefd("roil",r)= os(r)*efd("roil",r);

* eusep(e,g,r)  = intermediate usage (domestic plus import); unit: billion US$ 
* eusep(e,g,r)  = eusep0(e,g,r) = xdp0(r,e,g)+xmp0(r,e,g)  

* Convert energy data into preferred units of exajoules and trillion KWH:

*		1 EJ  = 23.88    MTOE
*               1 EJ  = 1/3.6    TKWh       
*		1 EJ  = 9.478E14 BTU
*		1 KWH = 3412     BTU

* CO2 emissions by energy type by region (epslon is multiplied by 100 since we want the unit million tons)
* EE(R,E,T) in eppaloop has already considered energy demand from intermediate, final, final-htrn sources;
* and energy consumptions from both extant and vintage production are considered in EE as well.

* reassign cj(e,r) to 1 in case we don't want to target the IEA emissions (cj is assigned by cj0 in eppaghg):
cj(e,r) = 1; 

CO2F(R,E,T)  = 100*EPSLON(E)*CJ(E,R)*EE(R,E,T)*44/12;

* CO2 emissions by fuel: from intermediate energy demand
CEEI(G,E,R,T)$eusep(e,g,r) = 100*EPSLON(E)*CJ(E,R)*(eind(e,g,r)/eusep(e,g,r))*EOUTI.L(E,G,R)*44/12;

* CO2 emissions by fuel: from final energy demand
CEECI(E,R,T) = 100*EPSLON(E)*CJ(E,R)*(hefd(E,R)/HEUSEF(E,R))$heusef(e,r)*EOUTF.L(E,R)*44/12;

* Sectoral CO2 emissions
*sco2(t,g,r)  = sum(e$eusep(e,g,r), 100*EPSLON(E)*CJ(E,R)*(eind(e,g,r)/eusep(e,g,r))*EOUTI.L(E,G,R));
sco2(t,g,r)  = sum(e$eusep(e,g,r), CEEI(G,E,R,T));

* Final demand CO2 emissions - HH tran
*ftco2_ref(t,r)= 100*EPSLON("roil")*CJ("roil",R)*(tefd("roil",r)/teusef("roil",r))*EOUTHTR.L("roil",r)
*                + (100 * EPSLON("gas") * CJ("gas",R) * ENG_CNG(r)*CNGGAS.L(R))$ACTIVE("CNGTRN",R); 
ftco2(t,r)= 100*EPSLON("roil")*CJ("roil",R)*(tefd("roil",r)/teusef("roil",r))*EOUTHTR.L("roil",r)*44/12;

* Final demand co2 emissions  
*fco2(t,r)= sum(e$heusef(e,r), 100*EPSLON(E)*CJ(E,R)*(hefd(e,r)/heusef(e,r))*EOUTF.L(E,R))+ftco2(t,r);   
fco2(t,r)= sum(e$heusef(e,r), ceeci(e,r,t))+ftco2(t,r);    

* sectoral CO2 emissions - from intermediate energy demand
sectem(i,r,t) = sum(e, ceei(i,e,r,t));

* household CO2 emissions - from final energy demand
houem(r,t) = sum(e, ceeci(e,r,t));

* household CO2 emissions - from household transportation
htrnem(r,t) = ftco2(t,r);   

* CO2 total from crop (deforestation)
*ctotco2(r,t)                    =  100*(outco2(r,"crop")*d.l("crop",r)					  
*                                        +sum(v, (outco2(r,"crop")/xp0(r,"crop"))*dv.l("crop",v,r)))*44/12;									  

ctotco2(r,t) = deforest(t,r);
                                									  
* CO2 total from energy intensive sector (cement)                                 	    

etotco2(r,t)                    =  (100*(outco2(r,"eint")*d.l("eint",r)
                                        +sum(v, (outco2(r,"eint")/xp0(r,"eint"))*dv.l("eint",v,r)))*44/12)$(not cflag(r))

                                   +(100*(d_pcarb.l("eint",r)+d_scarb.l("eint",r)+d_ptcarb.l("eint",r)			     
				        +sum(v,dv_pcarb.l("eint",v,r)+dv_scarb.l("eint",v,r)+dv_ptcarb.l("eint",v,r)))*44/12)$(cflag(r))
                                   ;

* CO2 total from backstop technologies
*bco2(bt,r,t)                    = 100*sum(e,epslon(e)*eeib(bt,e,r,t))*44/12;

bco2("ngcc",r,t)$active("ngcc",r)       = 100*epslon("gas")*eeib("ngcc","gas",r,t)*44/12;
bco2("ngcap",r,t)$active("ngcap",r)     = 100*epslon("gas")*eeib("ngcap","gas",r,t)*(1-bsin("ngcap","frseq",r))*44/12; 
bco2("igcc",r,t)$active("igcc",r)       = 100*epslon("coal")*eeib("igcc","coal",r,t)*44/12; 
bco2("igcap",r,t)$active("igcap",r)     = 100*epslon("coal")*eeib("igcap","coal",r,t)*(1-bsin("igcap","frseq",r))*44/12; 
bco2("windgas",r,t)$active("windgas",r) = 100*epslon("gas")*eeib("windgas","gas",r,t)*44/12; 

* CO2 total from burning fossil fuels
ftotco2(r,t) =  SUM(E, CO2F(R,E,T))+sum(bt,bco2(bt,r,t));                                          
totco2(r,t)                     = ftotco2(r,t)+ctotco2(r,t)+etotco2(r,t);

* GHG emissions based on v-ref

ghgky(ghg,g,r,t)$(xp0(r,g) and (simu eq 0))
                                 = 100*((oghg_(ghg,g,r))*d.l(g,r)
                                       +(oghg_(ghg,g,r))/xp0(r,g)*sum(v, dv.l(g,v,r))
                                       +sum(e,(cghg_(ghg,e,g,r))*eid_ghg.l(e,g,r))                                       
                                       );
                                       
ghgky(ghg,"fd",r,t)$(simu eq 0)  = 100*(sum(e,efd_ghg.l(e,r)*hcghg_(ghg,e,"fd",r))
                                       +sum(e,tefd_ghg.l(e,r)*tcghg_(ghg,e,"fd",r))
                                       +z.l(r)*fcghg_(ghg,"fd",r)
                                       );

* GHG emissions based on simulation before GHG policies kick in
ghgky(ghg,g,r,t)$(xp0(r,g) and (simu ne 0) and (not (ghgkf(r,t) or ghgkwf(r,t) or sghgkf(r,t))))
                                 = 100*(oghg_(ghg,g,r)*d.l(g,r)
                                       +oghg_(ghg,g,r)/xp0(r,g)*sum(v, dv.l(g,v,r))
                                       +sum(e,cghg_(ghg,e,g,r)*eid_ghg.l(e,g,r))                                       
                                       );
                                       
ghgky(ghg,"fd",r,t)$(simu ne 0 and (not (ghgkf(r,t) or ghgkwf(r,t) or sghgkf(r,t))))  
                                 = 100*(sum(e,efd_ghg.l(e,r)*hcghg_(ghg,e,"fd",r))
                                       +sum(e,tefd_ghg.l(e,r)*tcghg_(ghg,e,"fd",r))
                                       +z.l(r)*fcghg_(ghg,"fd",r)
                                       );

* GHG emissions based on simulation with GHG policies in effect 
* Note that with GHG policies, GHG emissions and other inputs are in general not Leontief even for vintage production,
* and this is why we should not multiply outputs by emissions coefficients direcly, as we do for the no policy case. 
ghgky(ghg,g,r,t)$(xp0(r,g) and (simu ne 0) and ((ghgkf(r,t) or ghgkwf(r,t) or sghgkf(r,t))))      
                                 = 100*(d_pghg.l(ghg,g,r)+d_pghgw.l(ghg,g,r)+d_sghg.l(ghg,g,r)
                                       +sum(v,dv_pghg.l(ghg,g,v,r)+dv_pghgw.l(ghg,g,v,r)+dv_sghg.l(ghg,g,v,r))
                                       +sum(e,eid_ghg_pghg.l(ghg,e,g,r))
                                       +sum(e,eid_ghg_pghgw.l(ghg,e,g,r))
                                       +sum(e,eid_ghg_sghg.l(ghg,e,g,r))
                                       );
                                 
ghgky(ghg,"fd",r,t)$(simu ne 0 and ((ghgkf(r,t) or ghgkwf(r,t) or sghgkf(r,t))))  
                                 = 100*(sum(e,efd_ghg_pghg.l(ghg,e,r))+sum(e,efd_ghg_pghgw.l(ghg,e,r))+sum(e,efd_ghg_fghg.l(ghg,e,r)))
                                  +100*(sum(e,tefd_ghg_pghg.l(ghg,e,r))+sum(e,tefd_ghg_pghgw.l(ghg,e,r))+sum(e,tefd_ghg_fghg.l(ghg,e,r)))
                                  +100*(z_pghg.l(ghg,r)+z_pghgw.l(ghg,r)+z_fghg.l(ghg,r));

*ghgky(ghg,g,r,t)    = ghgky(ghg,g,r,t)   /ghg_adj(r,ghg,t);
*ghgky(ghg,"fd",r,t) = ghgky(ghg,"fd",r,t)/ghg_adj(r,ghg,t);
                                	 
*tghgky(ghg,r,t)                 = sum(g, ghgky(ghg,g,r,t))+ghgky(ghg,"fd",r,t)+sum(biofuel, ghgky(ghg,biofuel,r,t));

tghgky(ghg,r,t)                 = sum(g, ghgky(ghg,g,r,t))+ghgky(ghg,"fd",r,t);

*ghg_ref(ghg,t,r)$(simu eq 0)    = tghgky(ghg,r,t);   

*co2eq(r,t) = totco2(r,t) + sum(ghg, gwp(ghg)*tghgky(ghg,r,t));

* Non-GHG gases accounting

* Non-GHG emissions based on v-ref

urban(urb,g,r,t)$(xp0(r,g) and (simu eq 0))                
                                = 100*(ourb_(urb,g,r)*(d.l(g,r)+sum(v,dv.l(g,v,r)/xp0(r,g)))
                                       +sum(e$(xdp0(r,e,g)+xmp0(r,e,g)),curb_(urb,e,g,r)*(ei.l(g,e,r))/(xdp0(r,e,g)+xmp0(r,e,g)))
                                       +sum(e,sum(v,curb_(urb,e,g,r)*dv.l(g,v,r)/xp0(r,g)))
                                       );

urban(urb,"synf-oil",r,t)$(xp0("usa","elec") and (simu eq 0) and active("synf-oil",r)) 
                                = 100*((curb_(urb,"roil","elec","usa")/xp0("usa","elec")*bsout("synf-oil","oil")*0.20)*eb.l("synf-oil",r));

urban(urb,"synf-gas",r,t)$(xp0("usa","elec") and (simu eq 0) and active("synf-gas",r)) 
                                = 100*((curb_(urb,"coal","elec","usa")/xp0("usa","elec")*bsout("synf-gas","gas")*0.73)*eb.l("synf-gas",r));

* Note that hhurb is from ourb, and the trend of hhurb is exogenously given following Mort's setting (see eppaghg and eppaloop).
urban(urb,"fd",r,t)$(simu eq 0) = 100*(sum(e,curb_(urb,e,"fd",r)*z.l(r))+hhurb(urb,t,r));

 
* Non-GHG emissions based on simulation before non-GHG policies kick in

urban(urb,g,r,t)$(xp0(r,g) and (simu ne 0) and (not urbnf(urb,r,t)))
                                = 100*(ourb_(urb,g,r)*(d.l(g,r)+sum(v,dv.l(g,v,r)/xp0(r,g)))
                                       +sum(e$(xdp0(r,e,g)+xmp0(r,e,g)),curb_(urb,e,g,r)*(ei.l(g,e,r))/(xdp0(r,e,g)+xmp0(r,e,g)))
                                       +sum(e,sum(v,curb_(urb,e,g,r)*dv.l(g,v,r)/xp0(r,g)))
                                       );

urban(urb,"synf-oil",r,t)$(xp0("usa","elec") and (simu ne 0) and (not urbnf(urb,r,t)) and active("synf-oil",r)) 
                                = 100*((curb_(urb,"roil","elec","usa")/xp0("usa","elec")*bsout("synf-oil","oil")*0.20)*eb.l("synf-oil",r));

urban(urb,"synf-gas",r,t)$(xp0("usa","elec") and (simu ne 0) and (not urbnf(urb,r,t)) and active("synf-gas",r)) 
                                = 100*((curb_(urb,"coal","elec","usa")/xp0("usa","elec")*bsout("synf-gas","gas")*0.73)*eb.l("synf-gas",r));

urban(urb,"fd",r,t)$(simu ne 0 and (not urbnf(urb,r,t))) = 100*(sum(e,curb_(urb,e,"fd",r)*z.l(r))+hhurb(urb,t,r));


* Non-GHG emissions based on simulation with non-GHG policies in effect
urban(urb,g,r,t)$(xp0(r,g) and (simu ne 0) and (urbnf(urb,r,t)))                                 
                                = 100*(d_purb.l(urb,g,r)+sum(v,dv_purb.l(urb,g,v,r)));
                                                                              
urban(urb,"synf-oil",r,t)$(xp0("usa","elec") and (simu ne 0) and (urbnf(urb,r,t)) and active("synf-oil",r)) 
                                = 100*(eb_purb.l(urb,"synf-oil",r));

urban(urb,"synf-gas",r,t)$(xp0("usa","elec") and (simu ne 0) and (urbnf(urb,r,t)) and active("synf-gas",r)) 
                                = 100*(eb_purb.l(urb,"synf-gas",r));

urban(urb,"fd",r,t)$(simu ne 0 and (urbnf(urb,r,t))) 
                                = 100*(z_purb.l(urb,r))+hhurb(urb,t,r);
                                                              
turban(urb,r,t)                 = sum(g,urban(urb,g,r,t))+urban(urb,"fd",r,t)+sum(bt,urban(urb,bt,r,t));


* Prepare the chm file for the Earth System Model run

chmco2("crop",r,t)              = sum(e, CEEI("crop",E,R,T))+100*(outco2(r,"crop")*d.l("crop",r)+sum(v$(xp0(r,"crop")$V_K("crop",V,R)), (outco2(r,"crop")/xp0(r,"crop"))*dv.l("crop",v,r)));	                                                          
chmco2("live",r,t)              = sum(e, CEEI("live",E,R,T))+100*(outco2(r,"live")*d.l("live",r)+sum(v$(xp0(r,"live")$V_K("live",V,R)), (outco2(r,"live")/xp0(r,"live"))*DV.l("live",V,R)));                          
chmco2("fors",r,t)              = sum(e, CEEI("fors",E,R,T))+100*(outco2(r,"fors")*d.l("fors",r)+sum(v$(xp0(r,"fors")$V_K("fors",V,R)), (outco2(r,"fors")/xp0(r,"fors"))*DV.l("fors",V,R)));

*chmco2("agr",r,t)               = chmco2("crop",r,t) + chmco2("live",r,t) + chmco2("fors",r,t);

chmco2("agr",r,t)               = ctotco2(r,t);
chmco2("n_agr",r,t)             = totco2(r,t)-chmco2("agr",r,t);	                          

* --Convert these parameters to carbon unit for the climate model (consistent with EPPA5's setting)
chmco2("crop",r,t)              = chmco2("crop",r,t) *12/44;            		   
chmco2("live",r,t)              = chmco2("live",r,t) *12/44; 
chmco2("fors",r,t)              = chmco2("fors",r,t) *12/44;  
chmco2("agr",r,t)               = chmco2("agr",r,t)  *12/44;   
chmco2("n_agr",r,t)             = chmco2("n_agr",r,t)*12/44; 

chmghg("agr",ghg,r,t)           = sum(agri, ghgky(ghg,agri,R,T));
chmghg("n_agr",ghg,r,t)         = tghgky(ghg,R,T)-chmghg("agr",ghg,r,t);
chmghg("agr",lgh,r,t)           = 1000*sum(agri,ghgky(lgh,agri,R,T));
chmghg("n_agr",lgh,r,t)         = 1000*tghgky(lgh,R,T)-chmghg("agr",lgh,r,t);
chmurb("agr",urb,r,t)           = sum(agri,urban(urb,agri,R,T));
chmurb("n_agr",urb,r,t)         = turban(urb,R,T)-chmurb("agr",urb,r,t);

* --Convert these parameters to the unit consistent with EPPA5
chmghg("agr",ghg,r,t)           = chmghg("agr",ghg,r,t)  *1/gu(ghg);  
chmghg("n_agr",ghg,r,t)         = chmghg("n_agr",ghg,r,t)*1/gu(ghg);
chmghg("agr",lgh,r,t)           = chmghg("agr",lgh,r,t)  *1/gu(lgh);  
chmghg("n_agr",lgh,r,t)         = chmghg("n_agr",lgh,r,t)*1/gu(lgh);
chmurb("agr",urb,r,t)           = chmurb("agr",urb,r,t)  *1/gu(urb);     
chmurb("n_agr",urb,r,t)         = chmurb("n_agr",urb,r,t)*1/gu(urb);     

* --(kor and idz from asi) Disaggregate chm97co2, chm97ghg, and chm97urb based on the 2007 structures of chmco2, chmghg, and chmurb, respectively
* --For the first period, recalculate the imputed 1997 emissions for kor, idz, and asi

if (ord(t) eq 1,

* ---kor  
chm97co2("crop","kor",t_chm)          = chm97co2("crop","asi",t_chm) *chmco2("crop","kor","2007") /(chmco2("crop","kor","2007") +chmco2("crop","idz","2007") +chmco2("crop","asi","2007") );
chm97co2("live","kor",t_chm)          = chm97co2("live","asi",t_chm) *chmco2("live","kor","2007") /(chmco2("live","kor","2007") +chmco2("live","idz","2007") +chmco2("live","asi","2007") );
chm97co2("fors","kor",t_chm)          = chm97co2("fors","asi",t_chm) *chmco2("fors","kor","2007") /(chmco2("fors","kor","2007") +chmco2("fors","idz","2007") +chmco2("fors","asi","2007") );
chm97co2("agr","kor",t_chm)           = chm97co2("agr","asi",t_chm)  *chmco2("agr","kor","2007")  /(chmco2("agr","kor","2007")  +chmco2("agr","idz","2007")  +chmco2("agr","asi","2007")  );
chm97co2("n_agr","kor",t_chm)         = chm97co2("n_agr","asi",t_chm)*chmco2("n_agr","kor","2007")/(chmco2("n_agr","kor","2007")+chmco2("n_agr","idz","2007")+chmco2("n_agr","asi","2007"));

* ---idz  
chm97co2("crop","idz",t_chm)          = chm97co2("crop","asi",t_chm) *chmco2("crop","idz","2007") /(chmco2("crop","kor","2007") +chmco2("crop","idz","2007") +chmco2("crop","asi","2007") );
chm97co2("live","idz",t_chm)          = chm97co2("live","asi",t_chm) *chmco2("live","idz","2007") /(chmco2("live","kor","2007") +chmco2("live","idz","2007") +chmco2("live","asi","2007") );
chm97co2("fors","idz",t_chm)          = chm97co2("fors","asi",t_chm) *chmco2("fors","idz","2007") /(chmco2("fors","kor","2007") +chmco2("fors","idz","2007") +chmco2("fors","asi","2007") );
chm97co2("agr","idz",t_chm)           = chm97co2("agr","asi",t_chm)  *chmco2("agr","idz","2007")  /(chmco2("agr","kor","2007")  +chmco2("agr","idz","2007")  +chmco2("agr","asi","2007")  );
chm97co2("n_agr","idz",t_chm)         = chm97co2("n_agr","asi",t_chm)*chmco2("n_agr","idz","2007")/(chmco2("n_agr","kor","2007")+chmco2("n_agr","idz","2007")+chmco2("n_agr","asi","2007"));

* ---asi (Note: the following assignments overwrite the old asi values, which also include kor and idz) 
chm97co2("crop","asi",t_chm)          = chm97co2("crop","asi",t_chm) *chmco2("crop","asi","2007") /(chmco2("crop","kor","2007") +chmco2("crop","idz","2007") +chmco2("crop","asi","2007") );
chm97co2("live","asi",t_chm)          = chm97co2("live","asi",t_chm) *chmco2("live","asi","2007") /(chmco2("live","kor","2007") +chmco2("live","idz","2007") +chmco2("live","asi","2007") );
chm97co2("fors","asi",t_chm)          = chm97co2("fors","asi",t_chm) *chmco2("fors","asi","2007") /(chmco2("fors","kor","2007") +chmco2("fors","idz","2007") +chmco2("fors","asi","2007") );
chm97co2("agr","asi",t_chm)           = chm97co2("agr","asi",t_chm)  *chmco2("agr","asi","2007")  /(chmco2("agr","kor","2007")  +chmco2("agr","idz","2007")  +chmco2("agr","asi","2007")  );
chm97co2("n_agr","asi",t_chm)         = chm97co2("n_agr","asi",t_chm)*chmco2("n_agr","asi","2007")/(chmco2("n_agr","kor","2007")+chmco2("n_agr","idz","2007")+chmco2("n_agr","asi","2007"));

* ---kor
chm97ghg("agr",ghg,"kor",t_chm)       = (chm97ghg("agr",ghg,"asi",t_chm)  *chmghg("agr",ghg,"kor","2007")  /(chmghg("agr",ghg,"kor","2007")   +chmghg("agr",ghg,"idz","2007")   +chmghg("agr",ghg,"asi","2007")  ))$(chmghg("agr",ghg,"kor","2007")   +chmghg("agr",ghg,"idz","2007")   +chmghg("agr",ghg,"asi","2007")  ne 0);   
chm97ghg("n_agr",ghg,"kor",t_chm)     = (chm97ghg("n_agr",ghg,"asi",t_chm)*chmghg("n_agr",ghg,"kor","2007")/(chmghg("n_agr",ghg,"kor","2007") +chmghg("n_agr",ghg,"idz","2007") +chmghg("n_agr",ghg,"asi","2007")))$(chmghg("n_agr",ghg,"kor","2007") +chmghg("n_agr",ghg,"idz","2007") +chmghg("n_agr",ghg,"asi","2007")ne 0);
chm97ghg("agr",lgh,"kor",t_chm)       = (chm97ghg("agr",lgh,"asi",t_chm)  *chmghg("agr",lgh,"kor","2007")  /(chmghg("agr",lgh,"kor","2007")   +chmghg("agr",lgh,"idz","2007")   +chmghg("agr",lgh,"asi","2007")  ))$(chmghg("agr",lgh,"kor","2007")   +chmghg("agr",lgh,"idz","2007")   +chmghg("agr",lgh,"asi","2007")  ne 0);
chm97ghg("n_agr",lgh,"kor",t_chm)     = (chm97ghg("n_agr",lgh,"asi",t_chm)*chmghg("n_agr",lgh,"kor","2007")/(chmghg("n_agr",lgh,"kor","2007") +chmghg("n_agr",lgh,"idz","2007") +chmghg("n_agr",lgh,"asi","2007")))$(chmghg("n_agr",lgh,"kor","2007") +chmghg("n_agr",lgh,"idz","2007") +chmghg("n_agr",lgh,"asi","2007")ne 0);
chm97urb("agr",urb,"kor",t_chm)       = (chm97urb("agr",urb,"asi",t_chm)  *chmurb("agr",urb,"kor","2007")  /(chmurb("agr",urb,"kor","2007")   +chmurb("agr",urb,"idz","2007")   +chmurb("agr",urb,"asi","2007")  ))$(chmurb("agr",urb,"kor","2007")   +chmurb("agr",urb,"idz","2007")   +chmurb("agr",urb,"asi","2007")  ne 0);
chm97urb("n_agr",urb,"kor",t_chm)     = (chm97urb("n_agr",urb,"asi",t_chm)*chmurb("n_agr",urb,"kor","2007")/(chmurb("n_agr",urb,"kor","2007") +chmurb("n_agr",urb,"idz","2007") +chmurb("n_agr",urb,"asi","2007")))$(chmurb("n_agr",urb,"kor","2007") +chmurb("n_agr",urb,"idz","2007") +chmurb("n_agr",urb,"asi","2007")ne 0);
											       													      													     
* ---idz										       													      													     
chm97ghg("agr",ghg,"idz",t_chm)       = (chm97ghg("agr",ghg,"asi",t_chm)  *chmghg("agr",ghg,"idz","2007")  /(chmghg("agr",ghg,"kor","2007")   +chmghg("agr",ghg,"idz","2007")   +chmghg("agr",ghg,"asi","2007")  ))$(chmghg("agr",ghg,"kor","2007")   +chmghg("agr",ghg,"idz","2007")   +chmghg("agr",ghg,"asi","2007")  ne 0);   
chm97ghg("n_agr",ghg,"idz",t_chm)     = (chm97ghg("n_agr",ghg,"asi",t_chm)*chmghg("n_agr",ghg,"idz","2007")/(chmghg("n_agr",ghg,"kor","2007") +chmghg("n_agr",ghg,"idz","2007") +chmghg("n_agr",ghg,"asi","2007")))$(chmghg("n_agr",ghg,"kor","2007") +chmghg("n_agr",ghg,"idz","2007") +chmghg("n_agr",ghg,"asi","2007")ne 0);
chm97ghg("agr",lgh,"idz",t_chm)       = (chm97ghg("agr",lgh,"asi",t_chm)  *chmghg("agr",lgh,"idz","2007")  /(chmghg("agr",lgh,"kor","2007")   +chmghg("agr",lgh,"idz","2007")   +chmghg("agr",lgh,"asi","2007")  ))$(chmghg("agr",lgh,"kor","2007")   +chmghg("agr",lgh,"idz","2007")   +chmghg("agr",lgh,"asi","2007")  ne 0);
chm97ghg("n_agr",lgh,"idz",t_chm)     = (chm97ghg("n_agr",lgh,"asi",t_chm)*chmghg("n_agr",lgh,"idz","2007")/(chmghg("n_agr",lgh,"kor","2007") +chmghg("n_agr",lgh,"idz","2007") +chmghg("n_agr",lgh,"asi","2007")))$(chmghg("n_agr",lgh,"kor","2007") +chmghg("n_agr",lgh,"idz","2007") +chmghg("n_agr",lgh,"asi","2007")ne 0);
chm97urb("agr",urb,"idz",t_chm)       = (chm97urb("agr",urb,"asi",t_chm)  *chmurb("agr",urb,"idz","2007")  /(chmurb("agr",urb,"kor","2007")   +chmurb("agr",urb,"idz","2007")   +chmurb("agr",urb,"asi","2007")  ))$(chmurb("agr",urb,"kor","2007")   +chmurb("agr",urb,"idz","2007")   +chmurb("agr",urb,"asi","2007")  ne 0);
chm97urb("n_agr",urb,"idz",t_chm)     = (chm97urb("n_agr",urb,"asi",t_chm)*chmurb("n_agr",urb,"idz","2007")/(chmurb("n_agr",urb,"kor","2007") +chmurb("n_agr",urb,"idz","2007") +chmurb("n_agr",urb,"asi","2007")))$(chmurb("n_agr",urb,"kor","2007") +chmurb("n_agr",urb,"idz","2007") +chmurb("n_agr",urb,"asi","2007")ne 0);

* ---asi (Note: the following assignments overwrite the old asi values, which also include kor and idz) 									       													      													     
chm97ghg("agr",ghg,"asi",t_chm)       = (chm97ghg("agr",ghg,"asi",t_chm)  *chmghg("agr",ghg,"asi","2007")  /(chmghg("agr",ghg,"kor","2007")   +chmghg("agr",ghg,"idz","2007")   +chmghg("agr",ghg,"asi","2007")  ))$(chmghg("agr",ghg,"kor","2007")   +chmghg("agr",ghg,"idz","2007")   +chmghg("agr",ghg,"asi","2007")  ne 0);   
chm97ghg("n_agr",ghg,"asi",t_chm)     = (chm97ghg("n_agr",ghg,"asi",t_chm)*chmghg("n_agr",ghg,"asi","2007")/(chmghg("n_agr",ghg,"kor","2007") +chmghg("n_agr",ghg,"idz","2007") +chmghg("n_agr",ghg,"asi","2007")))$(chmghg("n_agr",ghg,"kor","2007") +chmghg("n_agr",ghg,"idz","2007") +chmghg("n_agr",ghg,"asi","2007")ne 0);
chm97ghg("agr",lgh,"asi",t_chm)       = (chm97ghg("agr",lgh,"asi",t_chm)  *chmghg("agr",lgh,"asi","2007")  /(chmghg("agr",lgh,"kor","2007")   +chmghg("agr",lgh,"idz","2007")   +chmghg("agr",lgh,"asi","2007")  ))$(chmghg("agr",lgh,"kor","2007")   +chmghg("agr",lgh,"idz","2007")   +chmghg("agr",lgh,"asi","2007")  ne 0);
chm97ghg("n_agr",lgh,"asi",t_chm)     = (chm97ghg("n_agr",lgh,"asi",t_chm)*chmghg("n_agr",lgh,"asi","2007")/(chmghg("n_agr",lgh,"kor","2007") +chmghg("n_agr",lgh,"idz","2007") +chmghg("n_agr",lgh,"asi","2007")))$(chmghg("n_agr",lgh,"kor","2007") +chmghg("n_agr",lgh,"idz","2007") +chmghg("n_agr",lgh,"asi","2007")ne 0);
chm97urb("agr",urb,"asi",t_chm)       = (chm97urb("agr",urb,"asi",t_chm)  *chmurb("agr",urb,"asi","2007")  /(chmurb("agr",urb,"kor","2007")   +chmurb("agr",urb,"idz","2007")   +chmurb("agr",urb,"asi","2007")  ))$(chmurb("agr",urb,"kor","2007")   +chmurb("agr",urb,"idz","2007")   +chmurb("agr",urb,"asi","2007")  ne 0);
chm97urb("n_agr",urb,"asi",t_chm)     = (chm97urb("n_agr",urb,"asi",t_chm)*chmurb("n_agr",urb,"asi","2007")/(chmurb("n_agr",urb,"kor","2007") +chmurb("n_agr",urb,"idz","2007") +chmurb("n_agr",urb,"asi","2007")))$(chmurb("n_agr",urb,"kor","2007") +chmurb("n_agr",urb,"idz","2007") +chmurb("n_agr",urb,"asi","2007")ne 0);

);

* assigning above values aggregated to EPPA5 regions in equivalent parameters
if( ord(t) eq 1,

chm97co2_e5(rep, r_e5,t_chm) = chm97co2(rep, r_e5,t_chm);
chm97ghg_e5(rep,ghg, r_e5,t_chm) = chm97ghg(rep,ghg, r_e5,t_chm);
chm97urb_e5(rep, urb, r_e5, t_chm) = chm97urb(rep, urb, r_e5,t_chm);

chm97co2_e5(rep, "asi", t_chm) = chm97co2(rep, "asi", t_chm)+chm97co2(rep, "idz", t_chm)+chm97co2(rep, "kor", t_chm);
chm97ghg_e5(rep,ghg, "asi", t_chm) = chm97ghg(rep,ghg, "asi", t_chm)+chm97ghg(rep,ghg, "idz", t_chm)+chm97ghg(rep,ghg, "kor", t_chm);
chm97urb_e5(rep, urb, "asi", t_chm) = chm97urb(rep, urb, "asi", t_chm)+chm97urb(rep, urb, "idz", t_chm)+chm97urb(rep, urb, "kor", t_chm);

);

*** The following lines are for Snowmass Project: Adjust chmurb_e5 by adjusting chmurb; read RHS to LHS
*$ontext
$if %csnm% == baseline                       execute_load "..%slash%core%slash%chmvref.gdx" chmurb2 = chmurb1;
$if %csnm% == policy_mup $if not %popg% == 0 execute_load "..%slash%core%slash%chmpol.gdx"  chmurb2 = chmurb1;
$if %csnm% == policy_mup $if not %prog% == 0 execute_load "..%slash%core%slash%chmpol.gdx"  chmurb2 = chmurb1;
*
$if %csnm% == baseline chmurb("agr","nox",r,t) = chmurb2("agr","nox",r,t);
$if %csnm% == baseline chmurb("agr","amo",r,t) = chmurb2("agr","amo",r,t);
$if %csnm% == baseline chmurb("agr","voc",r,t) = chmurb2("agr","voc",r,t);
$if %csnm% == baseline chmurb("agr","co",r,t)  = chmurb2("agr","co",r,t) ;
      
$if %csnm% == baseline chmurb("n_agr","nox",r,t) = chmurb2("n_agr","nox",r,t);
$if %csnm% == baseline chmurb("n_agr","amo",r,t) = chmurb2("n_agr","amo",r,t);
$if %csnm% == baseline chmurb("n_agr","voc",r,t) = chmurb2("n_agr","voc",r,t);
$if %csnm% == baseline chmurb("n_agr","co",r,t)  = chmurb2("n_agr","co",r,t) ;
*
$if %csnm% == policy_mup $if not %popg% == p0 chmurb("agr","nox",r,t) = chmurb2("agr","nox",r,t);
$if %csnm% == policy_mup $if not %popg% == p0 chmurb("agr","amo",r,t) = chmurb2("agr","amo",r,t);
$if %csnm% == policy_mup $if not %popg% == p0 chmurb("agr","voc",r,t) = chmurb2("agr","voc",r,t);
$if %csnm% == policy_mup $if not %popg% == p0 chmurb("agr","co",r,t)  = chmurb2("agr","co",r,t) ;     			     		     	        
$if %csnm% == policy_mup $if not %popg% == p0 chmurb("n_agr","nox",r,t) = chmurb2("n_agr","nox",r,t);
$if %csnm% == policy_mup $if not %popg% == p0 chmurb("n_agr","amo",r,t) = chmurb2("n_agr","amo",r,t);
$if %csnm% == policy_mup $if not %popg% == p0 chmurb("n_agr","voc",r,t) = chmurb2("n_agr","voc",r,t);
$if %csnm% == policy_mup $if not %popg% == p0 chmurb("n_agr","co",r,t)  = chmurb2("n_agr","co",r,t) ;
*
$if %csnm% == policy_mup $if not %prog% == r0 chmurb("agr","nox",r,t) = chmurb2("agr","nox",r,t);
$if %csnm% == policy_mup $if not %prog% == r0 chmurb("agr","amo",r,t) = chmurb2("agr","amo",r,t);
$if %csnm% == policy_mup $if not %prog% == r0 chmurb("agr","voc",r,t) = chmurb2("agr","voc",r,t);
$if %csnm% == policy_mup $if not %prog% == r0 chmurb("agr","co",r,t)  = chmurb2("agr","co",r,t) ;     			     		     	        
$if %csnm% == policy_mup $if not %prog% == r0 chmurb("n_agr","nox",r,t) = chmurb2("n_agr","nox",r,t);
$if %csnm% == policy_mup $if not %prog% == r0 chmurb("n_agr","amo",r,t) = chmurb2("n_agr","amo",r,t);
$if %csnm% == policy_mup $if not %prog% == r0 chmurb("n_agr","voc",r,t) = chmurb2("n_agr","voc",r,t);
$if %csnm% == policy_mup $if not %prog% == r0 chmurb("n_agr","co",r,t)  = chmurb2("n_agr","co",r,t) ;
*$offtext
***

chmco2_e5(rep, r_e5, t)       =  chmco2(rep, r_e5, t);	 
chmghg_e5(rep,ghg, r_e5, t)   =  chmghg(rep,ghg, r_e5, t); 
chmurb_e5(rep, urb, r_e5, t)  = chmurb(rep, urb, r_e5, t);

chmco2_e5(rep, "asi", t) = chmco2(rep, "asi", t)+chmco2(rep, "idz", t)+chmco2(rep, "kor", t);
chmghg_e5(rep,ghg, "asi", t)  = chmghg(rep,ghg, "asi", t)+chmghg(rep,ghg, "idz", t)+chmghg(rep,ghg, "kor", t);
chmurb_e5(rep, urb, "asi", t) = chmurb(rep, urb, "asi", t)+chmurb(rep, urb, "idz", t)+chmurb(rep, urb, "kor", t);

chmco2_e5(rep, r_e5, t)       = chmco2_e5(rep, r_e5, t);
chmghg_e5(rep,ghg, r_e5, t)   = chmghg_e5(rep,ghg, r_e5, t);
chmurb_e5(rep, urb, r_e5, t)  = chmurb_e5(rep, urb, r_e5, t);

* Total emissions
co2_ref(t,r)$(simu eq 0)      = totco2(r,t);     	
ghg_ref(ghg,t,r)$(simu eq 0)  = tghgky(ghg,r,t);   
urb_ref(urb,t,r)$(simu eq 0)  = turban(urb,r,t);   

*CO2 equivalent
*co2eq(r,t) = totco2(r,t) + sum(ghg, gwp(ghg)*tghgky(ghg,r,t));

co2eq(r,t) = totco2(r,t) + sum((ghg,rep), 44/12*gwp(ghg)*chmghg(rep,ghg,r,t));

*co2eq(r,t) = totco2(r,t) + sum(rep, gwp("ch4")*chmghg(rep,"ch4",r,t)
*                                  + gwp("n2o")*chmghg(rep,"n2o",r,t)
*                                  + gwp("pfc")*chmghg(rep,"pfc",r,t)/1000					
*                         	  + gwp("sf6")*chmghg(rep,"sf6",r,t)/1000      			
*                         	  + gwp("hfc")*chmghg(rep,"hfc",r,t)/1000);      			
