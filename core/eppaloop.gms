$title	Dynamic process of the EPPA model

* ----------- 1. Set or update the global variables and system related variables -----

$setglobal nper_start %nper%
$ifthen %nper% == 0
$setglobal nper 2007
$elseif %nper% == 2007
$eval nper %nper%+3
$setglobal nper %nper%
$else
$eval nper %nper%+5
$setglobal nper %nper%
$endif

* With the above setting, nper will always just a period ahead of nper_start:
nper_start = %nper_start%;
nper = %nper%;

* [tfr] nper and nper_start Now passed on the command line.

$include global.inc

$set console
$If %system.filesys% == UNIX $set console /dev/tty
$If %system.filesys% == DOS $set console con
$If %system.filesys% == MS95 $set console con
$If %system.filesys% == MSNT $set console con
$If "%console%." == "." abort "filesys not recognized"
$if not defined fcon file fcon / '%console%' /;
$If %system.filesys% == MSNT $set runNumber ""
$If %system.filesys% == MSNT $set isUncertainty 0

$set slash \
$if %system.filesys% == UNIX $set slash /

* ---------- This part (2. to 7.) will be activated only if nper_start is zero ---------------
$ifthen %nper_start% == 0

* ----------- 2. Include the case file (done inside eppa.cas) -----------------------------------
*$include eppa.cas

* including scenario-specific case file
$include %csnm%.cas

* ----------- 3. Specify Sectors with vintage structure --------------------------------------
*SET PCGOODS(G) / crop, live, fors, food, ELEC, EINT, OTHR, tran /;
set pcgoods(g) / crop, live, fors, food, ELEC, EINT, tran /;

vintg(pcgoods,r) = yes;
vintgbs(vbt,r)   = yes;

* ----------- 4. Specify initial input coefficient for vintage production --------------------
 
* energy input coefficient for vintage production	
v_de(r,e,g,v)$vintg(g,r)      = (xdp0(r,e,g)+xmp0(r,e,g))/xp0(r,g);      

* fixed-factor input coefficient for vintage production 	     												     
v_df(r,g,v)$vintg(g,r)        = ffactd0(r,g)/xp0(r,g);                     
										     
* capital input coefficient for vintage production  
v_dk(r,g,v)$vintg(g,r)        = kapd0(r,g)/xp0(r,g); 

* labor input coefficient for vintage production	                          											     
v_dl(r,g,v)$vintg(g,r)        = labd(r,g)/xp0(r,g);  

* ----------- 5. Specify initial endowment levels --------------------------------------------

* Base year vintage conditions before the model loop (originally in case files)
* do not confuse these benchmark vintage conditions with those presented within the loop.

*** original setting: start
vint_shr(v,r)$(vins eq 0) = srve(r,"t0")**ord(v)/sum(vv,srve(r,"t0")**ord(vv));
*** original setting: end

*** new setting: start
vint_shr(v,r)$(vins ne 0 and ord(v) le 3) = srvp(r,"t0")**ord(v)/(sum(vv$(ord(vv) le 3),srvp(r,"t0")**ord(vv))+srvp(r,"t0")**4/(1-srve(r,"t0")));                                          
vint_shr(v,r)$(vins ne 0 and ord(v) eq 4) = (srvp(r,"t0")**4/(1-srve(r,"t0")))/(sum(vv$(ord(vv) le 3),srvp(r,"t0")**ord(vv))+srvp(r,"t0")**4/(1-srve(r,"t0")));                                          
*** new setting: end

* benchmark fraction of capital stock which is old
clay_shr(g,r) = theta0(g,r);  

* vintage capital endowment
v_k(g,v,r)$(vintg(g,r)) = clay_shr(g,r)*kapd0(r,g)*vint_shr(v,r);  
                           											     
* vintage backstop capital endowment fixed
vb_k(vbt,v,r)$vintgbs(vbt,r)  = 0.0001;   

* adjust the new vintage capital stock:
* note: kapital(r) is the capital earning (service), and the following will be used to solve the base year
* with the assumed vintage levels.  Note that there is indeed no vbt activated in the base year.
* vbt = {windbio, windgas, ngcc, ngcap, igcap, adv-nucl}

kapital(r)                    = kapital(r) - sum( (g,v), v_k(g,v,r)) 					  
                                           - sum(vbt$(active(vbt,r)$vintgbs(vbt,r)), sum(v, vb_k(vbt,v,r)));  
                                           
kapital0(r)                   = kapital(r);

* reassign the initial values:
d.l(g,r)$vintg(g,r)           = 1 - clay_shr(g,r);
*en.l(g,r)$vintg(g,r)          = 1 - clay_shr(g,r);
dv.l(g,v,r)$vintg(g,r)        = xp0(r,g) * clay_shr(g,r) * vint_shr(v,r);


labor_t(r,"2007")      = labor(r);
kapital_t(r,"2007")    = kapital(r) + sum( (g,v), v_k(g,v,r)) 					   
                                    + sum(vbt$(active(vbt,r)$vintgbs(vbt,r)), sum(v, vb_k(vbt,v,r)));  
                                   
* ffact = ffactd0 is assigned in eppaparm
ffact_t(agri,r,"2007") = ffact(agri,r);
n_r_t(r,"2007")        = n_r(r);

* base year aggregate government expenditure         
grg_t(r,"2007")        = g0(r);
             
* top final demand substitution elasticity by period t     
ddelas("2007",r)       = d_elas(r);  
           
* energy production   
e_prd(ff,r,"2007")     = eprod(ff,r);
             
* output shares by gas resource
*ressh(grt,r,"2007")$sum(gtr, ftfact("gas",gtr,r)) 
*                      = ftfact("gas",grt,r)/sum(gtr, ftfact("gas",gtr,r));  

* endogenous instrument to limit nuclear             
*nuclim.fx             = 1;       
      
* initial value of fixed factor supply (ffact)
ini_ffact(ff,r)       = ffact(ff,r);                

* initial value of fixed factor supply by type (ftfact)
*ini_ftfact(ff,grt,r)  = ftfact(ff,grt,r);           

* previous period resource base        
lgasres(grt,r)        = cy_res(r,grt,"gas");

* ---------- 6. Assign backstop resources; GDP growth; and initial values for some parameters -- 

* For backstop technologies (ngcc and ngcap share the same resource supply; and so do igcc and igcap)

bbres("ngcc",r,"2007")     = max(0.00001, bsin("ngcc","ffa",r)*inish("ngcc",r)*outt.l("elec",r));  
bbres("ngcap",r,"2007")    = max(0.00001, bsin("ngcap","ffa",r)*inish("ngcap",r)*outt.l("elec",r));  
bbres("igcc",r,"2007")     = max(0.00001, bsin("igcc","ffa",r)*inish("igcc",r)*outt.l("elec",r));
bbres("igcap",r,"2007")    = max(0.00001, bsin("igcap","ffa",r)*inish("igcap",r)*outt.l("elec",r));
bbres("bioelec",r,"2007")  = max(0.00001, bsin("bioelec","ffa",r)*inish("bioelec",r)*outt.l("elec",r));
bbres("wind",r,"2007")     = max(0.00001, bsin("wind","ffa",r)*inish("wind",r)*outt.l("elec",r));
bbres("solar",r,"2007")    = max(0.00001, bsin("solar","ffa",r)*inish("solar",r)*outt.l("elec",r));
bbres("adv-nucl",r,"2007") = max(0.00001, bsin("adv-nucl","ffa",r)*inish("adv-nucl",r)*outt.l("elec",r));
bbres("windgas",r,"2007")  = max(0.00001, bsin("windgas","ffa",r)*inish("windgas",r)*outt.l("elec",r));
bbres("windbio",r,"2007")  = max(0.00001, bsin("windbio","ffa",r)*inish("windbio",r)*outt.l("elec",r));
bbres("h2",r,"2007")       = max(0.00001, bsin("h2","ffa",r)*inish("h2",r)*(sum(g, eouti.l("roil",g,R))+eoutf.l("roil",r)));
bbres("bio-oil",r,"2007")  = max(0.00001, bsin("bio-oil","ffa",r)*inish("bio-oil",r)*bbioilout.l(r));
					
* For 1st generation biofuels; initial fixed factor supplies are adjusted so the baseline run approximates IEA's 6 degree scenario
bbres("bio-fg",r,"2007")       = bsin("bio-fg","ffa",r)*0.2;
bbres("bio-fg","usa","2007")   = bsin("bio-fg","ffa","usa")*1;
bbres("bio-fg","eur","2007")   = bsin("bio-fg","ffa","eur")*1;
bbres("bio-fg","chn","2007")   = bsin("bio-fg","ffa","chn")*1;
bbres("bio-fg","bra","2007")   = bsin("bio-fg","ffa","bra")*1;

bres("bio-fg",r)           = bbres("bio-fg",r,"2007");

* Read the baseline GDP growth rates 
rgdpgrowth(r,t)$(t.val le 2010) = histrgdp(r,t);
*rgdpgrowth(r,t)$(t.val gt 2010) = (1+argdpgrrate(r,t-1))**5;
rgdpgrowth(r,t)$(t.val gt 2010) = (1+argdpgrrate(r,t-1)*sensitivity("gdpg","%gdpg%",t-1))**5;

* Initial values will be updated after solve
* $ before "if" means the condition will be tested before compilation
* Without $ before "if", the condition will be tested after compilation.
$if %simuv% == 0 gprod_t(r,t)     = 1;
$if %simuv% == 0 co2_ref(t,r)     = 0;
$if %simuv% == 0 ghg_ref(ghg,t,r) = 0;
$if %simuv% == 0 urb_ref(urb,t,r) = 0;

* ---------- 7. Get the bau level of productivity index determined by exogenous gdp ------------
*execute_load$(%simuv% ne 0) "..\core\bau.gdx" gprod_t = gprod_t;

$if not %simuv% == 0 execute_load "..%slash%core%slash%bau.gdx" gprod_t = gprod_t  co2_ref = co2_ref ghg_ref = ghg_ref urb_ref = urb_ref;
$endif

ghg_ref(ghg,t,r)$(ghg_ref(ghg,t,r) le 0.0001) = 0;


* ---------- 8. Model loop begins --------------------------------------------------------------
* Note that nper is only and always a period ahead of nper_start.

loop(t$((t.val eq %nper%)),

** 8.1 Intermediate controls for the activations of backstop technologies
							  
active("wind",r)     = yes$available("wind",r,t);
active("bioelec",r)  = yes$available("bioelec",r,t);
active("bio-oil",r)  = yes$available("bio-oil",r,t);
active("bio-fg",r)   = yes$available("bio-fg",r,t);
biot                 = 1$available("biotrade","usa",t);
active("solar",r)    = yes$available("solar",r,t);
active("synf-oil",r) = yes$(available("synf-oil",r,t) and rshale(r));
active("synf-gas",r) = yes$available("synf-gas",r,t);
active("h2",r)       = yes$available("h2",r,t);
active("windbio",r)  = yes$available("windbio",r,t);
active("windgas",r)  = yes$available("windgas",r,t);
active("ngcc",r)     = yes$available("ngcc",r,t);
active("ngcap",r)    = yes$available("ngcap",r,t);
active("igcc",r)     = yes$available("igcc",r,t);
active("igcap",r)    = yes$available("igcap",r,t);
active("adv-nucl",r) = yes$available("adv-nucl",r,t);

active("cafe",r)     = yes$available("cafe",r,t);
active("limcoalf",r) = yes$available("limcoalf",r,t);
active("coalmkup",r) = yes$available("coalmkup",r,t);

** 8.2 Activate non-uniform productivity growth rates:
if(vgequ,
nugm=1;

omega_l(r)     = 0.05;
omega_l(oecd)  = 0.01;
omega_k(r)     = 0.025;
omega_k(oecd)  = 0.0;

omega_f("ind") = 0.01;
omega_f("idz") = 0.01;
omega_f("afr") = 0.01;
omega_f("lam") = 0.01;
omega_f("rea") = 0.01;

lprod_f(r)=(1+omega_l(r))**(ord(t)-1);
kprod_f(r)=(1+omega_k(r))**(ord(t)-1);
fprod_f(r)=(1+omega_f(r))**(ord(t)-1);
);

** 8.3 Preference calibration
** initialize parameters
cexp(r,g)      = (xdc0(r,g)+xmc0(r,g));
cexp(r,"tran") = tottrn(r);
** Make sure sum of cstar is zero by correcting income elasticities of other sectors (see note: 7/22/14)
tha(r,t)       = (sum(g,cexp(r,g))-sum(si,eta(r,si)*cexp(r,si)))/(sum(g,eta(r,g)*cexp(r,g))-sum(si,eta(r,si)*cexp(r,si)));
eta(r,g)$(not si(g)) = tha(r,t)*eta(r,g);

** calculate subsistence consumption

**      Step 1: Calculate cstar used in the first two periods
cstar(r,g)     = (1-eta(r,g))*cexp(r,g);

**      Step 2: Starting from the third period (2015), calculate xtel and ytel
texp(r,"2007")                = sum(g,cexp(r,g));
texp(r,t-1)$(t.val ge 2015)   = sum(i,cons_sec(i,r,t-1));
xtel(g,r,t-1)$(t.val ge 2015) = cons_sec(g,r,"2007")*(eta_t(r,g,t-1)*(texp(r,t-1)-texp(r,"2007"))/texp(r,"2007")+1);
ytel(g,r,t-1)$(t.val ge 2015) = sum(i, cons_sec(i,r,t-1))-xtel(g,r,t-1);

**      Step 3: Calculate cstar based on xtel and ytel
cstar(r,g)$(t.val ge 2015)    = xtel(g,r,t-1)-ytel(g,r,t-1)*(xtel(g,r,t-1)-cexp(r,g))
                                /(ytel(g,r,t-1)-(texp(r,"2007")-cexp(r,g)));

**      Step 4: Avoid unreasonable cstar in 2015 caused by the economic downturn in 2010 
cstar(r,g)$(t.val eq 2015)     = cstar_t(r,g,t-1);

** avoid numerical error; put upper bounds for cstar

cstar(r,g)$(abs(cstar(r,g)) lt 0.001) = 0;
cstar(r,"tran") = min(cstar(r,"tran"),tottrn(r)*0.99);
cstar(r,nend)   = min(cstar(r,nend),(xdc0(r,nend)+xmc0(r,nend))*0.99);
cstar(r,dwe)    = min(cstar(r,dwe),(xdc0(r,dwe)+xmc0(r,dwe))*0.99);
cstar(r,e)      = min(cstar(r,e),ence(e,r)*0.99);
cstar(r,"oil")  = 0;

** If 0 is assigned to cstar, there will be no Stone-Geary adjustment
*cstar(r,g) = 0;
cstar_t(r,g,t) = cstar(r,g);

** 8.4 Depletion module: use the longrun resource base after depper (ff={coal, oil, gas})

* fossil fuels production in japan (negligile) remains at the base year level.
  d.fx(ff,"jpn")$(ord(t) ge depper(ff))                = 1;

* ini_ffact is the fixed factor input from gtap; res95 is from table res950 in eppatrend
* the assignment of res95 is done in eppatrend

  fadj(r,ff)$(ord(t) ge depper(ff))                    = fadjt(ff,t,r);			
  radj(r,ff)$(ord(t) ge depper(ff))            	       = radjt(ff,t,r);	

  ffact(ff,r)$(ord(t) ge depper(ff) and eprod(ff,r))   = fadj(r,ff)*ini_ffact(ff,r)*(radj(r,ff)*res95(r,ff)-sum(ts$(ord(ts) lt ord(t)),5*e_prd(ff,r,ts)))
                                                                    /(radj(r,ff)*res95(r,ff)-sum(ts$(ord(ts) lt depper(ff)), 5*e_prd(ff,r,ts)));
   
  ffact(ff,r)$(ord(t) ge depper(ff) and ffactd0(r,ff)) = max(1e-5, ffact(ff,r));
  ffact("gas","jpn")$(ord(t) ge depper("gas"))         = ini_ffact("gas","jpn");
  ffact("gas","chn")$(ord(t) ge depper("gas"))         = ini_ffact("gas","chn");
  ffact("gas","kor")$(ord(t) ge depper("gas"))         = ini_ffact("gas","kor");
  ffact("coal","idz")$(ord(t) ge depper("coal"))       = ini_ffact("coal","idz");

** 8.5 Read productivity index in [simu = 0]
* gprod determined in [simu = 0] becomes given in [simu = 1]
gprod0(r)$(simu ne 0)  = gprod_t(r,t);

** 8.6 Place holder for cost function adjustments

* for china, move from investment-lead growth to consumption-lead growth
*inv0("chn")$(ord(t) ge 2 and ord(t) le 15)       = inv0("chn")-4;
*cons0("chn")$(ord(t) ge 2 and ord(t) le 15)      = cons0("chn")+4;

* Update sectorial markup
mkup(g,r)        = 1;

** 8.7 Update aeei, eind, hefd, tefd, 1st gen biofuels subsidy rates, and bakstop markups and coefficients

* update aeei

lamdae(g,r,t)    = 1$(ord(t) eq 1)
                  +(1*(1+aeeigr(r,g)*sensitivity("aeeg","%aeeg%",t))**3)$(ord(t) eq 2)
                  +(1*((1+aeeigr(r,g)*sensitivity("aeeg","%aeeg%",t))**3)*((1+aeeigr(r,g)*sensitivity("aeeg","%aeeg%",t))**(5*(ord(t)-2))))$(ord(t) ge 3);

lamdae("fd",r,t) = 1$(ord(t) eq 1)
                  +(1*(1+aeeigr(r,"fd")*sensitivity("aeeg","%aeeg%",t))**3)$(ord(t) eq 2)
                  +(1*((1+aeeigr(r,"fd")*sensitivity("aeeg","%aeeg%",t))**3)*((1+aeeigr(r,"fd")*sensitivity("aeeg","%aeeg%",t))**(5*(ord(t)-2))))$(ord(t) ge 3);

aeei(r,g)        = 1/lamdae(g,r,t);	  			  
aeei(r,"fd") 	 = 1/lamdae("fd",r,t);       	  

* update eind, hefd, and tefd to match the latest IEA data (IEA World Energy Outlook, 2012)
eind(e,g,r)      = eind(e,g,r)*eind_adj(e,r,t);				  
hefd(e,r)   	 = hefd(e,r)*eind_adj(e,r,t);         		  
tefd(e,r)   	 = tefd(e,r)*eind_adj(e,r,t);         		   

* read the table for subsidy rate for the 1st generation biofuels, wind, solar, and bioelec
biofgsub(r)      = biofgsub_t(t,r);		      
windsub(r)  	 = windsub_t(t,r);              
solarsub(r) 	 = solarsub_t(t,r);             
bioesub(r)  	 = bioesub_t(t,r);              

* Reset selas(g,"e_kl",r) when having the sensitivity analyses with different substitution elasticities for energy use
selas(g,"e_kl",r)$(t.val eq 2015) = selas(g,"e_kl",r)*sensitivity("sekl","%sekl%","2015");

** 8.8 Specify nuclear and water resources

* nuclear resource
n_r(r) = n_r0(r)*n_r_trend(t,r);

* water resource
h_r(r) = h_r0(r)*h_r_trend(t,r);

* adjust investment and consumption of othr in China:

*xdi0("chn","othr") = xdi0("chn","othr")-50;
*xdc0("chn","othr") = xdc0("chn","othr")+50;
*inv0("chn")        = inv0("chn")-50;
*cons0("chn")       = cons0("chn")+50;

** 8.9  Adjust ghg trend

* co2
* --cement in energy intensive sector; trend adjusted (see cemtrend in eppaghg.gms)
outco2(r,"eint") = outco20(r,"eint")*cemtrend(t,r);

* --deforestation emissions
outco2(r,"crop") = outco20(r,"crop")*deftrend(t,r);
outco2(r,"crop")$(outco2(r,"crop") le 0) = 0;

* methane and n2o:
oghg("ch4",agri,r)     = oghg0("ch4",agri,r)*ch4_agri(t,r);
oghg("n2o",agri,r)     = oghg0("n2o",agri,r)*n2o_agri(t,r);

* fossil (exponential decrease in emissions index from 1 to 0.1)
oghg("ch4",e,r)        = oghg0("ch4",e,r)*1.1165* exp(-0.11* ord(t));

* n2o - eint
oghg("n2o","eint",r)   = oghg0("n2o","eint",r)*n2o_eint(t,r);

* methane (otherind, eint, fd)
oghg("ch4","othr",r)   = oghg0("ch4","othr",r)*ch4_agri(t,r);
oghg("ch4","eint",r)   = oghg0("ch4","eint",r)*ch4_eint(t,r);
oghg("ch4","fd",r)     = oghg0("ch4","fd",r)*ch4_fd(t,r);

* energy intensive:
cghg("sf6",e,"eint",r) = cghg00("sf6",e,"eint",r)*sf6_eint(t,r);
oghg("sf6","eint",r)   = oghg0("sf6","eint",r)*sf6_eint(t,r);
cghg("pfc",e,"eint",r) = cghg00("pfc",e,"eint",r)*pfc_eint(t,r);
oghg("pfc","eint",r)   = oghg0("pfc","eint",r)*pfc_eint(t,r);

* electricity:
cghg("sf6",e,"elec",r) = cghg00("sf6",e,"elec",r)*sf6_elec(t,r);
oghg("sf6","elec",r)   = oghg0("sf6","elec",r)*sf6_elec(t,r);

* other ind:
cghg("hfc",e,"othr",r) = cghg00("hfc",e,"othr",r)*hfc_othr(t,r);
oghg("hfc","othr",r)   = oghg0("hfc","othr",r)*hfc_othr(t,r);
cghg("pfc",e,"othr",r) = cghg00("pfc",e,"othr",r)*pfc_eint(t,r);
oghg("pfc","othr",r)   = oghg0("pfc","othr",r)*pfc_eint(t,r);

* filter out oghg, cghg, and fcghg that are too small and give solver hard time to find a solution
oghg(ghg,g,r)          = oghg(ghg,g,r)$(oghg(ghg,g,r) ge 0.0001)+0$(oghg(ghg,g,r) lt 0.0001);
cghg(ghg,e,g,r)        = cghg(ghg,e,g,r)$(cghg(ghg,e,g,r) ge 0.0001)+0$(cghg(ghg,e,g,r) lt 0.0001);
cghg(ghg,e,"fd",r)     = cghg(ghg,e,"fd",r)$(cghg(ghg,e,"fd",r) ge 0.0001)+0$(cghg(ghg,e,"fd",r) lt 0.0001);
fcghg(ghg,"fd",r)      = fcghg(ghg,"fd",r)$(fcghg(ghg,"fd",r) ge 0.0001)+0$(fcghg(ghg,"fd",r) lt 0.0001);

* os(r) = share of transport usage of refined oil in household sector.  see eppaparm.gms  
tcghg(ghg,"roil","fd",r) = os(r)*cghg(ghg,"roil","fd",r);
hcghg(ghg,"roil","fd",r) = (1-os(r))*cghg(ghg,"roil","fd",r);
tcghg(ghg,"roil","fd",r) = tcghg(ghg,"roil","fd",r)$(tcghg(ghg,"roil","fd",r) ge 0.0001)+0$(tcghg(ghg,"roil","fd",r) lt 0.0001);
hcghg(ghg,"roil","fd",r) = hcghg(ghg,"roil","fd",r)$(hcghg(ghg,"roil","fd",r) ge 0.0001)+0$(hcghg(ghg,"roil","fd",r) lt 0.0001);

* GHGs trend adjustment (see eppatrend.gms)  
oghg_(ghg,g,r)            = (oghg(ghg,g,r)/ghg_adj(r,ghg,t))$(ghg_adj(r,ghg,t) ne 0)      + oghg(ghg,g,r)$(ghg_adj(r,ghg,t) eq 0);
cghg_(ghg,e,g,r)          = (cghg(ghg,e,g,r)/ghg_adj(r,ghg,t))$(ghg_adj(r,ghg,t) ne 0)    + cghg(ghg,e,g,r)$(ghg_adj(r,ghg,t) eq 0);
hcghg_(ghg,e,"fd",r)      = (hcghg(ghg,e,"fd",r)/ghg_adj(r,ghg,t))$(ghg_adj(r,ghg,t) ne 0)+ hcghg(ghg,e,"fd",r)$(ghg_adj(r,ghg,t) eq 0);  
tcghg_(ghg,e,"fd",r)      = (tcghg(ghg,e,"fd",r)/ghg_adj(r,ghg,t))$(ghg_adj(r,ghg,t) ne 0)+ tcghg(ghg,e,"fd",r)$(ghg_adj(r,ghg,t) eq 0);
fcghg_(ghg,"fd",r)        = (fcghg(ghg,"fd",r)/ghg_adj(r,ghg,t))$(ghg_adj(r,ghg,t) ne 0)  + fcghg(ghg,"fd",r)$(ghg_adj(r,ghg,t) eq 0);  

* Avoid no sink errors caused by nearly zero oghg_; pfc lower bound is reduced to keep the original trend
oghg_("sf6","elec",r) = max(oghg_("sf6","elec",r),oghg0("sf6","elec",r)*0.25);
oghg_("sf6","eint",r) = max(oghg_("sf6","eint",r),oghg0("sf6","eint",r)*0.25);
oghg_("sf6","othr",r) = max(oghg_("sf6","othr",r),oghg0("sf6","othr",r)*0.25);
oghg_("pfc","elec",r) = max(oghg_("pfc","elec",r),oghg0("pfc","elec",r)*0.25);
oghg_("pfc","eint",r) = max(oghg_("pfc","eint",r),oghg0("pfc","eint",r)*0.025);
oghg_("pfc","othr",r) = max(oghg_("pfc","othr",r),oghg0("pfc","othr",r)*0.025);

* Urban pollutants trend: the equations are from Mort Webster used in EPPA5

urbtrend("so2",r)         = -0.03; 	    
urbtrend("bc",r)          = -0.03;      
urbtrend("oc",r)          = -0.03;      
urbtrend("voc",r)         = -0.01;      
urbtrend("nox",r)         = -0.01;      
urbtrend("co",r)          = -0.01;      
urbtrend("amo",r)         = -0.015;     

curb(urb,e,g,r)           = curb0(urb,e,g,r)   *(exp(3*(urbtrend(urb,r))*(ord(t)-1))$(t.val le 2007)+exp(5*(urbtrend(urb,r))*(ord(t)-1))$(t.val gt 2007));																   
curb(urb,e,"fd",r) 	  = curb0(urb,e,"fd",r)*(exp(3*(urbtrend(urb,r))*(ord(t)-1))$(t.val le 2007)+exp(5*(urbtrend(urb,r))*(ord(t)-1))$(t.val gt 2007));      														   	   	  																         														   
ourb(urb,g,r)      	  = ourb0(urb,g,r)     *(exp(3*(urbtrend(urb,r))*(ord(t)-1))$(t.val le 2007)+exp(5*(urbtrend(urb,r))*(ord(t)-1))$(t.val gt 2007));      														   
ourb(urb,"fd",r)   	  = ourb0(urb,"fd",r)  *(exp(3*(urbtrend(urb,r))*(ord(t)-1))$(t.val le 2007)+exp(5*(urbtrend(urb,r))*(ord(t)-1))$(t.val gt 2007));      														   
hhurb(urb,t,r)     	  = ourb0(urb,"fd",r)  *(exp(3*(urbtrend(urb,r))*(ord(t)-1))$(t.val le 2007)+exp(5*(urbtrend(urb,r))*(ord(t)-1))$(t.val gt 2007));      														   

* Adjust non-consumption-related urban pollutants trends in AFR:

urbtrend("so2","afr")     = urbtrend("so2","afr")*3; 
urbtrend("bc", "afr")     = urbtrend("bc", "afr")*1;
urbtrend("oc", "afr")     = urbtrend("oc", "afr")*1;
urbtrend("voc","afr")     = urbtrend("voc","afr")*3;
urbtrend("nox","afr")     = urbtrend("nox","afr")*3;
urbtrend("co", "afr")     = urbtrend("co", "afr")*3;
urbtrend("amo","afr")     = urbtrend("amo","afr")*3;

ourb(urb,"crop","afr")    = ourb0(urb,"crop","afr")*(exp(3*(urbtrend(urb,"afr"))*(ord(t)-1))$(t.val le 2007)+exp(5*(urbtrend(urb,"afr"))*(ord(t)-1))$(t.val gt 2007));
ourb(urb,"fors","afr")    = ourb0(urb,"fors","afr")*(exp(3*(urbtrend(urb,"afr"))*(ord(t)-1))$(t.val le 2007)+exp(5*(urbtrend(urb,"afr"))*(ord(t)-1))$(t.val gt 2007));
ourb(urb,"fd","afr")      = ourb0(urb,"fd","afr")  *(exp(3*(urbtrend(urb,"afr"))*(ord(t)-1))$(t.val le 2007)+exp(5*(urbtrend(urb,"afr"))*(ord(t)-1))$(t.val gt 2007));
hhurb(urb,t,"afr")        = ourb0(urb,"fd","afr")  *(exp(3*(urbtrend(urb,"afr"))*(ord(t)-1))$(t.val le 2007)+exp(5*(urbtrend(urb,"afr"))*(ord(t)-1))$(t.val gt 2007));

* Adjust non-consumption-related urban pollutants trends in CHN:

urbtrend("amo","chn")     = urbtrend("amo","chn")*2.0;
urbtrend("voc","chn")     = urbtrend("voc","chn")*1.5;

ourb("amo","crop","chn")  = ourb0("amo","crop","chn")*(exp(3*(urbtrend("amo","chn"))*(ord(t)-1))$(t.val le 2007)+exp(5*(urbtrend("amo","chn"))*(ord(t)-1))$(t.val gt 2007));
hhurb("voc",t,"chn")      = ourb0("voc","fd","chn")  *(exp(3*(urbtrend("voc","chn"))*(ord(t)-1))$(t.val le 2007)+exp(5*(urbtrend("voc","chn"))*(ord(t)-1))$(t.val gt 2007));

* adjust ourb and curb at the regional level so the base year urban pollutants emissions match EDGAR data
* urb_adj is presented in eppatrend

ourb_(urb,g,r)      = (1/urb_adj(r,urb,t))*ourb(urb,g,r);
curb_(urb,e,g,r)    = (1/urb_adj(r,urb,t))*curb(urb,e,g,r);
curb_(urb,e,"fd",r) = (1/urb_adj(r,urb,t))*curb(urb,e,"fd",r);
ourb_(urb,"fd",r)   = (1/urb_adj(r,urb,t))*ourb(urb,"fd",r);

* import tariff adjustment
*tm(g,rr,r)               = tm(g,rr,r)*(1+0.1*(ord(t)-1));

* note: the above parameters are: 1) inputs for ghg_ref (in eppaemis.gms) => gquota => ghglim => activate pghg; 
* and 2) input coefficients for the production blocks in eppacore.  

** 8.10 Intermediate controls for emissions permits

* re-initialization of quota before each period's solve
* avoid the previous period non-zero quota is kept for this period when the quota should be zero according to the condition of this period 
carblim(r)                       = 0;
scarblim(g,r)                    = 0;
fcarblim(r)                      = 0;
ghglim(ghg,r)                    = 0;
ghglimg(ghg,g,r)                 = 0;
ghglimg(ghg,"fd",r)              = 0;
urblim(urb,r)                    = 0;

* co2 policy on deforestation and eint (cement) emissions
cflag(r)$cflagf(r,t)             = yes;

* non-tradable permits (national): emissions are measured relative to the 2010 levels:
* avoid the use the projected 2015 levels for comparison since they may change under different growth assumptions
cquota(r,t)$co2cf(r,t)           = (12/44*co2_ref("2010",r)*er("co2",t,r)/100);
gquota(ghg,r,t)$ghgkf(r,t)       = ghg_ref(ghg,"2010",r)*er(ghg,t,r)/100;
uquota(urb,r,t)$urbnf(urb,r,t)   = urb_ref(urb,"2010",r)*er(urb,t,r)/100;
                                  				 
co2c(r)$co2cf(r,t)               = yes;
carblim(r)$co2c(r)               = cquota(r,t);

ghgk(r)$ghgkf(r,t)               = yes;
ghglim(ghg,r)$ghgk(r)            = gquota(ghg,r,t);

urbn(urb,r)$urbnf(urb,r,t)       = yes;
urblim(urb,r)$urbn(urb,r)        = uquota(urb,r,t);

* non-tradable permits(national and sectoral)
* scquota and sgquota are arbitrary, and need to be reassinged according to the project
scquota(g,r,t)$sco2cf(r,t)       = 0.3*12/44*co2_ref("2010",r)*er("co2",t,r)/100;
scquota("fd",r,t)$sco2cf(r,t)    = 0.3*12/44*co2_ref("2010",r)*er("co2",t,r)/100;
sgquota(ghg,g,r,t)$sghgkf(r,t)   = 0.3*ghg_ref(ghg,"2010",r)*er(ghg,t,r)/100;
sgquota(ghg,"fd",r,t)$sghgkf(r,t)= 0.3*ghg_ref(ghg,"2010",r)*er(ghg,t,r)/100;

sco2c(r)$sco2cf(r,t)             = yes;
scarblim(g,r)$(sco2c(r)$ss(g,r)) = scquota(g,r,t);
fcarblim(r)$(sco2c(r)$fdf(r))    = scquota("fd",r,t);

sghgk(r)$sghgkf(r,t)             = yes;
ghglimg(ghg,g,r)$(sghgk(r)$ss(g,r)$((oghg(ghg,g,r) and xp0(r,g)) or sum(e,cghg(ghg,e,g,r)))) = sgquota(ghg,g,r,t);
ghglimg(ghg,"fd",r)$(sghgk(r)$fdf(r)$(sum(e,hcghg(ghg,e,"fd",r)) or sum(e,tcghg(ghg,e,"fd",r)) or fcghg(ghg,"fd",r))) = sgquota(ghg,"fd",r,t);

* tradable permits
cquota(r,t)$tco2cf(r,t)          = 12/44*co2_ref("2010",r)*er("co2",t,r)/100;
gquota(ghg,r,t)$ghgkwf(r,t)      = ghg_ref(ghg,"2010",r)*er(ghg,t,r)/100;

tco2c(r)$tco2cf(r,t)             = yes;
ttco2$(card(tco2c) ge 1)         = 1;  
tcarblim(r)$tco2c(r)             = cquota(r,t);

ghgkw(r)$ghgkwf(r,t)             = yes;
wghgk$(card(ghgkw) ge 1)         = 1;
ghglim(ghg,r)$ghgkw(r)           = gquota(ghg,r,t);

** price target
pcarbtarg(r)                     = ptarget(t,r);
* ctaxf(r)                        = 1;

* price targets (activate when we want to run exogenous GHGs pricing)
pcarb.fx(r)$(co2c(r) and exoc(r,t))              = pcarbtarg(r);
pghg.fx(ghg,r)$(ghglim(ghg,r) and exog(r,t))     = pcarbtarg(r)/gu(ghg)*gwp(ghg);

* The "overall" markup for new coal-fired generation is 1.0816.  See markup calculation.xls.
* Note that we don't want to inflate the energy consumption when markup is applied.
* So here, we use the markup excluding fuel consumption, which is 1.1205.  See markup calculation.xls
emkup("coal",r)$active("coalmkup",r) = 1.1205;

* Coal-fired power in USA and EUR are limited in a fashion such that coal-fired outputs remain at 2010 levels
eid_ghg_up("coal","elec",r)$active("limcoalf",r) = eid_ghg_up_t("coal","elec",r,t);

* cafe standard efficiency requirement
cafelim(r)$active("cafe",r)      = cafelimt(t,r);

** 8.11 Within-loop solve
dv.l(g,v,r)                      = 0;
bv_k.l(vbt,v,r)                  = 0;
ay.l("elec",r)                   = 0;
dv_v.l("elec",v,r)               = 0;
eoutb.l(e,bt,r)                  = 0;
eoutbv.l(e,bt,v,r)               = 0;
tlimc.l(e,g,r)$eid_ghg_up(e,g,r) = 0;
eb.l(bt,r)$active(bt,r)          = 0;
ebv.l(vbt,v,r)$active(vbt,r)     = 0;

lv_v.l(g,v,r)			 = 0;
bv_l.l(bt,v,r)			 = 0;
kv_v.l(g,v,r)			 = 0;
bv_k.l(bt,v,r)			 = 0;
bv_ff.l(bt,v,r)			 = 0;

eppa.iterlim = 12000; 
eppa.workspace = 50;
eppa.optfile = 1;
eppa.savepoint = 1;

$if exist "%sdir%%nper%.gdx" execute_loadpoint '%sdir%%nper%.gdx';
$include EPPA.GEN

SOLVE EPPA USING MCP;
option solprint = on;

** 8.12 Alternative solve
* try alternative options (path.op2) if we fail to solve:

if (eppa.modelstat ne 1, eppa.optfile = 2;
$include EPPA.GEN
SOLVE EPPA USING MCP;
option solprint = on;
);


*	Save this file for the next time we run EPPA:
$ifthen %system.filesys%==UNIX 
$if set sdir execute 'cp eppa_p.gdx "%sdir%%nper%.gdx"';

$else
$if set sdir execute 'copy eppa_p.gdx "%sdir%%nper%.gdx"';
$endif

** 8.13 Gradually adjustment of existing gaps (subsidies, stock buildings and trade deficit/surplus)

* phase out subsidies in energy sectors after 2004

td(r,"coal")$(td(r,"coal") lt 0) = (td(r,"coal")*0.9**ord(t))$(ord(t) le 10)+0$(ord(t) gt 10);
td(r,"oil")$(td(r,"oil") lt 0)   = (td(r,"oil")*0.9**ord(t))$(ord(t) le 10)+0$(ord(t) gt 10);
td(r,"gas")$(td(r,"gas") lt 0)   = (td(r,"gas")*0.9**ord(t))$(ord(t) le 10)+0$(ord(t) gt 10);

* phase out exogenous investment, trade gap and adjustments for homogenous goods:

savf(r)     = (savf(r)*0.9**ord(t))$(ord(t) le 10)+0$(ord(t) gt 10);
trnadj(x,r) = (trnadj(x,r)*0.9**ord(t))$(ord(t) le 10)+0$(ord(t) gt 10);
homadj(x,r) = (homadj(x,r)*0.9**ord(t))$(ord(t) le 10)+0$(ord(t) gt 10);

** 8.14 Save model outputs
* price indicies (relative to 2007 us$), consumption levels, etc.
opo(r,t)                             = phom.l("oil",r);
gpg(r,t)                             = pd.l("gas",r);
lpb(r,t)                             = pl.l(r);
kpb(r,t)                             = pk.l(r);
kpb_v(g,v,r,t)                       = pkv.l(g,v,r);
kpbb_v(vbt,v,r,t)                    = pvbk.l(vbt,v,r);
v_k_t(g,v,r,t)                       = v_k(g,v,r);
vb_k_t(bt,v,r,t)                     = vb_k(bt,v,r);
fpb(g,r,t)                           = pf.l(g,r);
fpb("roil",r,t)$active("synf-oil",r) = pshale.l(r); 
nfp(r,t)                             = pr.l(r);
hfp(r,t)                             = pr_h.l(r);
dpd(g,r,t)                           = pd.l(g,r);
apa(g,r,t)                           = pa.l(g,r);
apal(g,r,t)                          = pa.l(g,r);		  
dpdl(g,r,t) 		    	     = pd.l(g,r);
apaf_c(e,r,t)                        = paf_c.l(e,r);
apai_c(g,e,r,t)                      = pai_c.l(e,g,r);
cpc(i,r,t)                           = pa.l(i,r)*(1+tp(i,r));
apa_htrn(r,t)                        = ptrn.l(r);

* Make sure the vintaged backstop output is correctly represented
vbout.l(g,vbt,v,r)$(active(vbt,r) and ebv.l(vbt,v,r) eq 0) = 0;                 

* cbtax and tcbtax unit: us$/t-co2
cbtax(r,t)$co2c(r)                   = pcarb.l(r)*100*12/44;
tcbtax(r,t)$tco2c(r)                 = ptcarb.l*100*12/44;
sctax(g,r,t)$(sco2c(r)$ss(g,r))      = scarb.l(g,r)*100*12/44;
fctax(r,t)$(sco2c(r)$fdf(r))         = fcarb.l(r)   ;
woil(t)                              = pwh.l("oil") ;
wgas(t)                              = pwh.l("gas") ;
wcoal(t)                             = pwh.l("coal");
apa("oil",r,t)$(x("oil"))            = woil(t);
apa("gas",r,t)$(x("gas"))            = wgas(t);
apa("coal",r,t)$(x("coal"))          = wcoal(t);
apa("gas",r,t)$(gmarket)             = pd.l("gas",r);
utp(r,t)                             = pu.l(r);
ghgprice(ghg,r,t)$ghgk(r)            = (pghg.l(ghg,r)*100*gu(ghg))$(pghg.l(ghg,r)*100*gu(ghg) ne 100000.000000)+0$(pghg.l(ghg,r)*100*gu(ghg) eq 100000.000000);
ghgprice(ghg,r,t)$ghgkw(r)           = (pghgw.l(ghg)*100*gu(ghg))$(pghgw.l(ghg)*100*gu(ghg) ne 100000.000000)+0$(pghgw.l(ghg)*100*gu(ghg) eq 100000.000000);
urbprice(urb,r,t)                    = (purb.l(urb,r)*100*gu(urb))$(purb.l(urb,r)*100*gu(urb) ne 100000.000000)+0$(purb.l(urb,r)*100*gu(urb) eq 100000.000000);
sghgp(ghg,g,r,t)$(sghgk(r)$ss(g,r))  = sghg.l(ghg,g,r)*100*gu(ghg);
fghgp(ghg,r,t)$(sghgk(r)$fdf(r))     = fghg.l(ghg,r);
ctrate(r,e,t)$(epslon(e))            = cbtax(r,t)*100/(tj_85d(r,e)*epslon(e)); 
consump(r)$(ord(t) eq 1)             = acm.l(r);
widx(r,t)                            = acm.l(r)/consump(r);
cons_sec(ne,r,t)                     = aci.l(ne,r)+cstar(r,ne);
cons_tran(r,t)                       = actr.l(r)+cstar(r,"tran");
cons_sec("tran",r,t)                 = cons_tran(r,t);
cons_ener(e,r,t)                     = ecir.l(e,r)+cstar(r,e);
cons_sec(e,r,t)                      = cons_ener(e,r,t);

pcafe_t(r,t)                         = pcafe.l(r);

* domestic production or input indicies
d_t(g,r,t)                           = d.l(g,r);
dv_t(g,v,r,t)                        = dv.l(g,v,r);
d_dv_t(g,r,t)$(xp0(r,g) ne 0)        = (d_t(g,r,t)*xp0(r,g)+sum(v,dv_t(g,v,r,t)*1))/xp0(r,g);
n_e_t(r,t)                           = n_e.l(r);
h_e_t(r,t)                           = h_e.l(r);
outd_t(g,r,t)                        = d_t(g,r,t)*xp0(r,g)+sum(v$(dv.l(g,v,r) ne 1),dv.l(g,v,r)*1); 
dl_t(g,r,t)                          = dl.l(g,r);
dk_t(g,r,t)                          = dk.l(g,r);
a_t(g,r,t)                           = a.l(g,r);
aca(r,t)        = acm.l(r)+sum(g,cstar(r,g)*(1+tp(g,r))*pcstar.l(g,r)*ccstar.l(g,r))/pu.l(r);
acca(r,ne,t)    = aci.l(ne,r);
* hh transportation includes purchased and private, and cons_ener is the hh non-trans energy consumption                      
acca(r,"tran",t)= cons_tran(r,t);                   
acca(r,e,t)     = cons_ener(e,r,t);           
* total investment values, investment quantities, and investment activity levels 
aia(r,t)        = pinv.l(r)*outi.l(r)/pu.l(r);   
aiia(r,t)       = outi.l(r);  
inv_t(r,t)      = inv.l(r);
piip(r,t)       = pinv.l(r);                
* total government expenditure values, and government expenditure quantities
aga(r,t)        = pg.l(r)*outg.l(r)/pu.l(r);          
agga(r,t)       = outg.l(r);                       
pggp(r,t)       = pg.l(r);                  
* note that we have to take out "trade flow from and to the same region" for axa and ama.
axa(r,t)        = (sum((g,rr),(1+tx(g,r,rr))*pd__.l(g,r)*tflowm__.l(rr,r,g)*wtflow0(rr,r,g))
                  - sum(g,(1+tx(g,r,r))*pd__.l(g,r)*tflowm__.l(r,r,g)*wtflow0(r,r,g))
                  + sum(x, pwh.l(x)*homx0(x,r)*homx.l(x,r)) 
                  + pwo.l*(1*biox.l(r)$((active("bio-oil",r) or active("bio-fg",r))$biot)))/pu.l(r)
                  ;

ama(r,t)        = (sum((g,rr),(1+tx(g,rr,r))*pd__.l(g,rr)*tflowm__.l(r,rr,g)*wtflow0(r,rr,g))
                  - sum(g,(1+tx(g,r,r))*pd__.l(g,r)*tflowm__.l(r,r,g)*wtflow0(r,r,g))
                  + sum(x, pwh.l(x)*homm0(x,r)*mqhom_.l(x,r))  
                  + pwo.l*(1*biom_f.l(r)$((active("bio-oil","usa") or active("bio-fg","usa"))$efd("roil",r)$biot)
                                          +sum(g,1*biom_i.l(g,r)$((active("bio-oil","usa") or active("bio-fg","usa"))$eind("roil",g,r)$biot))))/pu.l(r)		              
                  ;

agnp(r,t)       = aca(r,t)+aia(r,t)+aga(r,t)+axa(r,t)-ama(r,t);
rgdp_t(r,t)     = rgdp.l(r);
homdd(x,r,t)    = homd.l(x,r);
dhom(x,r,t)     = homd.l(x,r)-xqhom.l(x,r)+mvhom.l(x,r);
homex(x,r,t)    = xqhom.l(x,r);
homim(x,r,t)    = mvhom.l(x,r);

bio_ex(r,t)     = bioex.l(r);
bio_im(r,t)     = bioimf.l(r) + sum(i,bioimi.l(i,r));
bio_exq(r,t)    = (ej_use("roil","usa")/euse("roil","usa"))*bio_ex(r,t);
bio_imq(r,t)    = (ej_use("roil","usa")/euse("roil","usa"))*bio_im(r,t);

fb(r,g,t)       = df.l(g,r)+(n_r(r)+h_r(r))$elec(g)+sum(bt$active(bt,r),b_f.l(bt,r))$agri(g);
lb(r,g,t)       = dl.l(g,r)+(nl.l(r)+hl.l(r))$elec(g)+sum(bt$active(bt,r),b_l.l(bt,r))+sum(v, lv_v.l(g,v,r))
                  +(sum((vbt,v)$(active(vbt,r)$vintgbs(vbt,r)), bv_l.l(vbt,v,r))); 
lbg(r,t)        = 0;
kb(r,g,t)       = dk.l(g,r)+(nk.l(r)+hk.l(r))$elec(g)+sum(bt$active(bt,r),b_k.l(bt,r))+ sum(v, kv_v.l(g,v,r))             
                  +(sum((vbt,v)$(active(vbt,r)$vintgbs(vbt,r)), bv_k.l(vbt,v,r))); 
kbg(r,t)        = 0;
gsp(g,r,t)      = outt.l(g,r);
eouti_t(e,g,r,t)= eouti.l(e,g,r);
eoutf_t(e,r,t)  = eoutf.l(e,r);
csm(r,t)        = acm.l(r);
aai(g,ne,r,t)   = ai.l(g,ne,r);
aai_v(g,ne,v,r,t) = ai_v.l(g,ne,v,r);
aai_total(g,ne,r,t) = aai(g,ne,r,t)+sum(v,aai_v(g,ne,v,r,t));
e_aai(g,e,r,t)  = ei.l(g,e,r);
e_acca(e,r,t)   = eci.l(e,r);
agy(g,r,t)      = ay.l(g,r)+(n_eout.l(r)+h_eout.l(r)+bsolout.l(r))$elec(g)+bsgasout_a.l(g,r)
                  +(bwout.l(r)+bbioeleout.l(r)+bngout.l(g,r)+bncsout.l(g,r)+bicsout.l(g,r)+bwbioout.l(g,r)
                  +bwgasout.l(g,r)+badvnucl_bout.l(g,r))$elec(g)
                  +sum(v$v_k(g,v,r),dv_v.l(g,v,r))+(sum((vbt,v)$(vb_k(vbt,v,r)),vbout.l(g,vbt,v,r)))$elec(g);                
agy(x,r,t)      = homd.l(x,r)+bsoilout.l(x,r)+bsgasout_h.l(x,r);

* energy statistics

* energy production (will be needed in the depletion module)

* -- hydro power output	    	    
e_prd_h(r,t)               = e_adj("e_prd_h",r,t)*(ej_use("elec",r)/euse("elec",r))*h_eout.l(r);

* -- nuclear power output (nucl(r,t) in EPPA5)
e_prd_n(r,t)               = e_adj("e_prd_n",r,t)*(ej_use("elec",r)/euse("elec",r))*n_eout.l(r);

e_prd(e,r,t)               = eprod(e,r)*d.l(e,r);  

* -- conventional fossil-based electricity output  
e_prd("elec",r,t)          = (eprod("elec",r)-e_prd_n(r,"2007")-e_prd_h(r,"2007"))
                               *(ay.l("elec",r)+sum(v, dv_v.l("elec",v,r)))/xp0(r,"elec");  

** -- Brazil's fossil generation share (10.70%) in 2007 comes from IEA WEO 2012 (see worksheet TPED&Gen)
** -- Without this treatment, the original data will give negative values for e_prd. 
e_prd("elec","bra",t)      = (eprod("elec","bra")*0.1070)
                               *(ay.l("elec","bra")+sum(v, dv_v.l("elec",v,"bra")))/xp0("bra","elec");  

e_aai("elec",e,r,t)$(ei.l("elec",e,r) eq 0 and e_prd("elec",r,t) ne 0) = e_aai("elec",e,r,t-1); 

* The following three fossil elec outputs (in EJ) are better approximations compared to the original time-invariant eei proportion approach
* Note that to disaggregate the output in EJ, we still need to convert the "economic quantity" from IO table to physical unit like EJ.
* This is why we need an adjustment factor vtoej(ff,r).

* -- fossil-based electricity output: traditional coal-fired
eleccoal(r,t)              = e_adj("eleccoal",r,t)*((e_prd("elec",r,t)*e_aai("elec","coal",r,t)
                                               /(e_aai("elec","coal",r,t)+e_aai("elec","roil",r,t)+e_aai("elec","gas",r,t)))*vtoej(r,"coal")*sum_e_prd(t,r))
                                               $(e_aai("elec","coal",r,t)+e_aai("elec","roil",r,t)+e_aai("elec","gas",r,t) ne 0)                   
                             ;
* -- fossil-based electricity output: traditional gas-fired
elecgas(r,t)               = e_adj("elecgas",r,t)*((e_prd("elec",r,t)*e_aai("elec","gas",r,t)
                                               /(e_aai("elec","coal",r,t)+e_aai("elec","roil",r,t)+e_aai("elec","gas",r,t)))*vtoej(r,"gas")*sum_e_prd(t,r))
                                               $(e_aai("elec","coal",r,t)+e_aai("elec","roil",r,t)+e_aai("elec","gas",r,t) ne 0)
                             ;
* -- fossil-based electricity output: traditional oil
elecoil(r,t)               = e_adj("elecoil",r,t)*((e_prd("elec",r,t)*e_aai("elec","roil",r,t)
                                               /(e_aai("elec","coal",r,t)+e_aai("elec","roil",r,t)+e_aai("elec","gas",r,t)))*vtoej(r,"oil")*sum_e_prd(t,r))
                                               $(e_aai("elec","coal",r,t)+e_aai("elec","roil",r,t)+e_aai("elec","gas",r,t) ne 0)
                             ;
* -- fossil-based electricity output: IGCAP
bbicsout(r,t)              = eps + (ej_use("elec",r)/euse("elec",r))* (bicsout.l("elec",r) + sum(v$vintgbs("igcap",r), vbout.l("elec","igcap",v,r)));
                                 
* -- fossil-based electricity output: IGCC
bbigout(r,t)               = eps + (ej_use("elec",r)/euse("elec",r))* (bigout.l("elec",r) + sum(v$vintgbs("igcc",r), vbout.l("elec","igcc",v,r)));

* -- fossil-based electricity output: NGCC
bbngout(r,t)               = eps + (ej_use("elec",r)/euse("elec",r))* (bngout.l("elec",r) + sum(v$vintgbs("ngcc",r), vbout.l("elec","ngcc",v,r)));
                                                                                                   
* -- fossil-based electricity output: NGCAP
bbncsout(r,t)              = eps + (ej_use("elec",r)/euse("elec",r))* (bncsout.l("elec",r) + sum(v$vintgbs("ngcap",r), vbout.l("elec","ngcap",v,r)));
                                                
* -- wind power output
bbwprod(r,t)               = eps + (ej_use("elec","usa")/euse("elec","usa"))*bwout.l(r);
bbwout(r,t)                = elec_iea(t,"bbwout",r)$(t.val le 2010)                                                
                             +(elec_iea("2010","bbwout",r)+bbwprod(r,t)-bbwprod(r,"2010"))$(t.val gt 2010 and elec_iea("2010","bbwout",r)+bbwprod(r,t)-bbwprod(r,"2010") ge 0) 
                             +0$(t.val gt 2010 and elec_iea("2010","bbwout",r)+bbwprod(r,t)-bbwprod(r,"2010") lt 0); 

* -- bio electricity output
bbbioeleprod(r,t)          = eps + (ej_use("elec","usa")/euse("elec","usa"))*bbioeleout.l(r);
bbbioeleout(r,t)           = elec_iea(t,"bioelec",r)$(t.val le 2010)                                                
                            +(elec_iea("2010","bioelec",r)+bbbioeleprod(r,t)-bbbioeleprod(r,"2010"))$(t.val gt 2010 and elec_iea("2010","bioelec",r)+bbbioeleprod(r,t)-bbbioeleprod(r,"2010") ge 0) 
                            +0$(t.val gt 2010 and elec_iea("2010","bioelec",r)+bbbioeleprod(r,t)-bbbioeleprod(r,"2010") lt 0); 

*bbbioeleout(r,t)           = eps + (ej_use("elec","usa")/euse("elec","usa"))*bbioeleout.l(r);

* -- advanced nuclear power output
bbadvnucl_bout(r,t)        = eps + (ej_use("elec",r)/euse("elec",r))* (badvnucl_bout.l("elec",r) + sum(v$vintgbs("adv-nucl",r), vbout.l("elec","adv-nucl",v,r)));
			   
* -- windbio output	   
bbwbioout(r,t)             = eps + (ej_use("elec",r)/euse("elec",r))* (bwbioout.l("elec",r) + sum(v$vintgbs("windbio",r), vbout.l("elec","windbio",v,r)));
			   
* -- windgas output	   
bbwgasout(r,t)             = eps + (ej_use("elec",r)/euse("elec",r))* (bwgasout.l("elec",r) + sum(v$vintgbs("windgas",r), vbout.l("elec","windgas",v,r)));

* -- solar power output
bbsolprod(r,t)             = eps + (ej_use("elec",r)/euse("elec",r))*bsolout.l(r);
bbsolout(r,t)              = elec_iea(t,"bbsolout",r)$(t.val le 2010)                                                
                            +(elec_iea("2010","bbsolout",r)+bbsolprod(r,t)-bbsolprod(r,"2010"))$(t.val gt 2010 and elec_iea("2010","bbsolout",r)+bbsolprod(r,t)-bbsolprod(r,"2010") ge 0) 
                            +0$(t.val gt 2010 and elec_iea("2010","bbsolout",r)+bbsolprod(r,t)-bbsolprod(r,"2010") lt 0); 

* -- total electricity output
telecprd(r,t)              = e_prd("elec",r,t)+e_prd_n(r,t)+e_prd_h(r,t)+bbsolout(r,t)+bbwout(r,t)+bbbioeleout(r,t)
                               + bbicsout(r,t)+bbncsout(r,t)+bbngout(r,t)+bbwbioout(r,t)+bbwgasout(r,t)
                               + bbadvnucl_bout(r,t);
 
* eei: energy demand by industrial sector and by fuel; eeci: hh energy demand; eeii: sectoral hh energy demand; 
* eecii: aggregate hh energy demand; pfeecii: disaggregated hh energy demand 
eei(g,e,r,t)$eusep(e,g,r)  = (eind(e,g,r)/eusep(e,g,r))*(ei.l(g,e,r)+sum(v,ei_v.l(g,e,v,r)));
eeci(e,r,t)$heusef(e,r)    = (hefd(e,r)/heusef(e,r))*eci.l(e,r);
eeii(g,r,t)                = sum(e, eei(g,e,r,t));
eecii(r,t)                 = sum(e, eeci(e,r,t));
pfeecii(e,r,t)             = eeci(e,r,t);

coal_gas(r,t)                              = ej_use("coal",r)/euse("coal",r)*(b_a.l("synf-gas","coal",r) + b_h.l("synf-gas","coal",r));
roil_inp(r,t)$eusep("oil", "roil", r)      =  (eind("oil", "roil", r)/eusep("oil", "roil", r)) * ei.l("roil", "oil", r); 
ele_eff(r,t)$(sum(e, eei("elec",e,r,t)))   = (e_prd("elec",r,t))/sum(e, eei("elec",e,r,t));
tot_eff(t)$(sum((e,r), eei("elec",e,r,t))) = sum(r, e_prd("elec",r,t))/sum((e,r), eei("elec",e,r,t));

* Update efficiency to convert to electric renewables to primary equivalents
ele_pe(r,t)$(ord(t) eq 1)                  = ele_eff(r,t);
ele_pe(r,t)$(ord(t) gt 1)                  = max(ele_eff(r,t),ele_pe(r,t-1));

bbsoilout(e,r,t)                           = (ej_use("oil","usa")/euse("oil","usa"))*bsoilout.l(e,r);
bbh2out(e,r,t)                             = (ej_use(e,"usa")/euse(e,"usa"))*bh2out.l(e,r);
bbsgasout(e,r,t)                           = (ej_use("gas","usa")/euse("gas","usa"))*(bsgasout_a.l(e,r)+bsgasout_h.l(e,r));
bbiofuelout("bio-oil","roil",r,t)$(teusef("roil",r)) = (tefd("roil",r)/teusef("roil",r))*bbioilout.l(r);

biofgprod(r,t)$(teusef("roil",r))          = (tefd("roil",r)/teusef("roil",r))*bbiofgout.l(r);
bbiofuelout("bio-fg","roil",r,t)$(teusef("roil",r)) 
                                           = biofgweo(r,t)$(t.val le 2010)
                                            +(biofgweo(r,"2010")+biofgprod(r,t)-biofgprod(r,"2010"))$(t.val gt 2010 and (biofgweo(r,"2010")+biofgprod(r,t)-biofgprod(r,"2010")) ge 0)
                                            +0$(t.val gt 2010 and (biofgweo(r,"2010")+biofgprod(r,t)-biofgprod(r,"2010")) lt 0);
                                            
elselec(r,t)             = e_prd("elec",r,t)/telecprd(r,t);
elsnucl(r,t)             = e_prd_n(r,t)/telecprd(r,t);
elsadvnucl(r,t)          = bbadvnucl_bout(r,t)/telecprd(r,t);
elshydro(r,t)            = e_prd_h(r,t)/telecprd(r,t);
elswind(r,t)             = bbwout(r,t)/telecprd(r,t);
elswindbio(r,t)          = bbwbioout(r,t)/telecprd(r,t);
elswindgas(r,t)          = bbwgasout(r,t)/telecprd(r,t);
elsbioele(r,t)           = bbbioeleout(r,t)/telecprd(r,t);
elssol(r,t)              = bbsolout(r,t)/telecprd(r,t);
elsng(r,t)               = bbngout(r,t)/telecprd(r,t);
elsncs(r,t)              = bbncsout(r,t)/telecprd(r,t);
elsics(r,t)              = bbicsout(r,t)/telecprd(r,t);

** 8.15 Update endowments, technologies, etc. for the next period:

* reassign the benchmark ror to 0.1; and k_o = capital output ratio
ror(r)                   = 0.1;     
k_o(r,t)                 = (kapital_t(r,t)/ror(r))/agnp(r,t);   
 
* compute the implied scale factor for inv to get reasonable capital levels and capital/output ratios.
* idea: base year (period 1) investment raises the capital service level from kapital0(r)*(1-dpe(r)), 
* which comes from "period 0", to kapital_t(r,"2007").
scale(r)                       = (kapital_t(r,"2007")-kapital0(r)*srve(r,"t0"))/(2.0*ror(r)*inv0(r));

* may need different scale values to account for the absence of vintaging:
scale(r)$(not vintg("elec",r)) = (kapital_t(r,"2007")-kapital0(r)*srve(r,"t0"))/(0.95*ror(r)*inv0(r));

* newcap, which is proportional to investment level, is the "service" coming from investment.
newcap(r,t)                    = (scale(r)*ror(r)*inv0(r))*inv.l(r);

* adjust the new capital formation to equilibrium state: 
newcap(r,t)$(ord(t) le 5)      = 1.10**(6-ord(t))*(scale(r)*ror(r)*inv0(r))*inv.l(r);
newcap("mex",t)$(ord(t) le 5)  = 1.05**(5-ord(t))*(scale("mex")*ror("mex")*inv0("mex"))*inv.l("mex");

totalcap(r,t) = newcap(r,t) + kapital(r)*srve(r,t) - sum(i$vintg(i,r), theta(i,t)*dk.l(i,r)*srve(r,t))
                                                                       - sum(bt$vintgbs(bt,r), thetab(bt,t)*b_k.l(bt,r)*srve(r,t));
                 
* update malleable capital service for the next period
kapital(r)    = totalcap(r,t);

* update labor service (sum of wage income): before productivity adjustment
lsupply(r,t+1) = lsupply(r,t)*gpop(r,t);
labor(r)$(ord(t) eq 1)  = lsupply(r,t+1);
labor(r)$(ord(t) gt 1)  = lsupply(r,t+1)*popgr("%popg%",t+1)*progr("%prog%",t+1);

* update vintage capital stocks

*** original setting for v10, v15, and v20: start
v_k(g,v+1,r)$(vintg(g,r) and vins eq 0) = max(srve(r,t)*dv.l(g,v,r)*v_dk(r,g,v),0.0001);
*** original setting: end

*** new setting for v10, v15, and v20: start
* ord(v) = 1, 2 assign value for v10, v15, respectively; ord(v) = 3 assigns value for v20, and ord(v) = 4 assigns value to nothing:
* Note that v_dk(r,g,"v20") is not used at this moment.
v_k(g,v+1,r)$(vintg(g,r) and ord(v) le 2 and vins ne 0) = max(srvp(r,t)*dv.l(g,v,r)*v_dk(r,g,v),0.0001);
v_k(g,v+1,r)$(vintg(g,r) and ord(v) ge 3 and vins ne 0) = max(srvp(r,t)*dv.l(g,v,r)*v_dk(r,g,v)+srve(r,t)*v_k(g,v+1,r),0.0001);
*** new setting: end

v_k(g,v5,r)$vintg(g,r)  = max(srve(r,t)*theta(g,t)*dk.l(g,r),0.0001);

* vintaged backstops
*** original setting for v10, v15, and v20: start
vb_k(vbt,v+1,r)$(vintgbs(vbt,r) and vins eq 0) = srve(r,t)*bv_k.l(vbt,v,r);
*** original setting: end

*** new setting for v10, v15, and v20: start
* ord(v) = 1, 2 assign value for v10, v15, respectively; ord(v) = 3 assigns value for v20, and ord(v) = 4 assigns value to nothing:
* Note that v_dk(r,g,"v20") is not used at this moment.
vb_k(vbt,v+1,r)$(vintgbs(vbt,r) and ord(v) le 2 and vins ne 0) = srvp(r,t)*bv_k.l(vbt,v,r);
vb_k(vbt,v+1,r)$(vintgbs(vbt,r) and ord(v) ge 3 and vins ne 0) = srvp(r,t)*bv_k.l(vbt,v,r)+srve(r,t)*vb_k(vbt,v+1,r);
*** new setting: end

* Set a lower bound for vb_k to avoid no source errors due to too small vb_k
vb_k(vbt,v5,r)$vintgbs(vbt,r) = max(srve(r,t)*thetab(vbt,t)*(1-vbmalshr)*b_k.l(vbt,r),1e-4);

* update fixed factor supplies:
*  ffact(ff,r)                = ffact(ff,r)*sff.l(ff,r);
* fprod is declared and assigned in eppatrend
ffact(agri,r)              = ffactd0(r,agri)*fprod(r,t+1);
ffact("eint",r)            = ffactd0(r,"eint")*fprod(r,t+1);
ffact("dwe",r)             = ffactd0(r,"dwe")*fprod(r,t+1);

*  ftfact("gas",grt,r)        = ftfact("gas",grt,r)*sff.l("gas",r);


* save the factor endowment levels
labor_t(r,t+1)           = labor(r);
kapital_t(r,t+1)         = kapital(r) + sum((g,v),v_k(g,v,r))
                                      + sum((vbt,v),vb_k(vbt,v,r));
                                     
ffact_t(g,r,t)          = ffact(g,r);
ffact_t(agri,r,t+1)      = ffact(agri,r);
n_r_t(r,t+1)             = n_r(r);
h_r_t(r,t+1)             = h_r(r);

ini_ffact(ff,r)$(ord(t) lt depper(ff)) = ffact(ff,r);

* eouti = intermediate energy demand; eoutf = final energy demand; eouthtr = final energy demand: hh transport
ee(r,e,t) = sum(g$eusep(e,g,r), (eind(e,g,r)/eusep(e,g,r))*eouti.l(e,g,r))
                 + (hefd(e,r)/heusef(e,r))$heusef(e,r)*eoutf.l(e,r)
                 + (tefd(e,r)/teusef(e,r))$teusef(e,r)*eouthtr.l(e,r);

ee_sector(r,e,g,t)$eusep(e,g,r) 
          = (eind(e,g,r)/eusep(e,g,r))*eouti.l(e,g,r);

* energy consumption by household transport (EJ)
energy_htrn(r,t) = (tefd("roil",r)/teusef("roil",r))*eouthtr.l("roil",r);

* energy consumption by backstop sectors (EJ)

* NGCC fossil fuels input
eeib("ngcc","gas",r,t)$(active("ngcc",r)$eusep("gas","elec",r)) = 
            (eind("gas","elec",r)/eusep("gas","elec",r))*(b_a.l("ngcc","gas",r) + b_h.l("ngcc","gas",r) +
            sum(v$vintgbs("ngcc",r), bv_a.l("ngcc",v,"gas",r)) + sum(v$vintgbs("ngcc",r), bv_h.l("ngcc",v,"gas",r)));

* NGCAP fossil fuels input
eeib("ngcap","gas",r,t)$(active("ngcap",r)$eusep("gas","elec",r)) = 
            (eind("gas","elec",r)/eusep("gas","elec",r))*(b_a.l("ngcap","gas",r) + b_h.l("ngcap","gas",r) +
             sum(v$vintgbs("ngcap",r), bv_a.l("ngcap",v,"gas",r)) + sum(v$vintgbs("ngcap",r), bv_h.l("ngcap",v,"gas",r)));
             
* IGCC fossil fuels input
eeib("igcc","coal",r,t)$(active("igcc",r)$eusep("coal","elec",r)) = 
            (eind("coal","elec",r)/eusep("coal","elec",r))*(b_a.l("igcc","coal",r) + b_h.l("igcc","coal",r) +
             sum(v$vintgbs("igcc",r), bv_a.l("igcc",v,"coal",r)) + sum(v$vintgbs("igcc",r), bv_h.l("igcc",v,"coal",r)));

* IGCAP fossil fuels input
eeib("igcap","coal",r,t)$(active("igcap",r)$eusep("coal","elec",r)) = 
            (eind("coal","elec",r)/eusep("coal","elec",r))*(b_a.l("igcap","coal",r) + b_h.l("igcap","coal",r) +
             sum(v$vintgbs("igcap",r), bv_a.l("igcap",v,"coal",r)) + sum(v$vintgbs("igcap",r), bv_h.l("igcap",v,"coal",r)));
             
* WINDGAS fossil fuels input
eeib("windgas","gas",r,t)$(active("windgas",r)$eusep("gas","elec",r)) = 
            (eind("gas","elec",r)/eusep("gas","elec",r))*(b_a.l("windgas","gas",r) + b_h.l("windgas","gas",r) +
             sum(v$vintgbs("windgas",r), bv_a.l("windgas",v,"gas",r)) + sum(v$vintgbs("windgas",r), bv_h.l("windgas",v,"gas",r)));
             
* vintage v+1 inherits the coefficients from vintage v:

*** original setting for v10, v15, and v20: start
v_de(r,e,g,v+1)$(vins eq 0) = v_de(r,e,g,v);
v_df(r,g,v+1)$(vins eq 0)   = v_df(r,g,v);
v_dk(r,g,v+1)$(vins eq 0)   = v_dk(r,g,v);
v_dl(r,g,v+1)$(vins eq 0)   = v_dl(r,g,v);
*** original setting: end

*** new setting for v10, v15, and v20: start
v_de(r,e,g,v+1)$(vintg(g,r) and vins ne 0 and ord(v) le 2) = v_de(r,e,g,v);
v_de(r,e,g,v+1)$(vintg(g,r) and vins ne 0 and ord(v) ge 3) = v_de(r,e,g,v)*(v_k(g,v,r)/(v_k(g,v,r)+srvp(r,t)*v_k(g,v+1,r))) 
                                                           + v_de(r,e,g,v+1)*(srvp(r,t)*v_k(g,v+1,r)/(v_k(g,v,r)+srvp(r,t)*v_k(g,v+1,r)));
v_df(r,g,v+1)$(vintg(g,r) and vins ne 0 and ord(v) le 2)   = v_df(r,g,v);
v_df(r,g,v+1)$(vintg(g,r) and vins ne 0 and ord(v) ge 3)   = v_df(r,g,v)*(v_k(g,v,r)/(v_k(g,v,r)+srvp(r,t)*v_k(g,v+1,r))) 
                                                           + v_df(r,g,v+1)*(srvp(r,t)*v_k(g,v+1,r)/(v_k(g,v,r)+srvp(r,t)*v_k(g,v+1,r)));
v_dk(r,g,v+1)$(vintg(g,r) and vins ne 0 and ord(v) le 2)   = v_dk(r,g,v);
v_dk(r,g,v+1)$(vintg(g,r) and vins ne 0 and ord(v) ge 3)   = v_dk(r,g,v)*(v_k(g,v,r)/(v_k(g,v,r)+srvp(r,t)*v_k(g,v+1,r))) 
                                                           + v_dk(r,g,v+1)*(srvp(r,t)*v_k(g,v+1,r)/(v_k(g,v,r)+srvp(r,t)*v_k(g,v+1,r)));
v_dl(r,g,v+1)$(vintg(g,r) and vins ne 0 and ord(v) le 2)   = v_dl(r,g,v);
v_dl(r,g,v+1)$(vintg(g,r) and vins ne 0 and ord(v) ge 3)   = v_dl(r,g,v)*(v_k(g,v,r)/(v_k(g,v,r)+srvp(r,t)*v_k(g,v+1,r))) 
                                                           + v_dl(r,g,v+1)*(srvp(r,t)*v_k(g,v+1,r)/(v_k(g,v,r)+srvp(r,t)*v_k(g,v+1,r)));

*** new setting: end


* vintage v5 inherits the latest new-vintage coefficients:
v_de(r,e,g,v5)$(ay.l(g,r) ge 0.01) = de.l(e,g,r) / ay.l(g,r);
v_df(r,g,v5)$(ay.l(g,r) ge 0.01)   = df.l(g,r)   / ay.l(g,r);
v_dk(r,g,v5)$(ay.l(g,r) ge 0.01)   = dk.l(g,r)   / ay.l(g,r);
v_dl(r,g,v5)$(ay.l(g,r) ge 0.01)   = dl.l(g,r)   / ay.l(g,r);

* vintaged backstop v+1 inherits the coefficients from vintaged backstop v:

*** original setting for v10, v15, and v20: start
vb_dl(vbt,v+1,r)$(vintgbs(vbt,r) and vins eq 0)   = vb_dl(vbt,v,r);
vb_dk(vbt,v+1,r)$(vintgbs(vbt,r) and vins eq 0)   = vb_dk(vbt,v,r);
vb_da(vbt,g,v+1,r)$(vintgbs(vbt,r) and vins eq 0) = vb_da(vbt,g,v,r);
vb_dh(vbt,g,v+1,r)$(vintgbs(vbt,r) and vins eq 0) = vb_dh(vbt,g,v,r);      
vb_dff(vbt,v+1,r)$(vintgbs(vbt,r) and vins eq 0)  = vb_dff(vbt,v,r);
*** original setting: end

*** new setting for v10, v15, and v20: start
vb_dl(vbt,v+1,r)$(vintgbs(vbt,r) and vins ne 0 and ord(v) le 2)   = vb_dl(vbt,v,r);									   											 
vb_dl(vbt,v+1,r)$(vintgbs(vbt,r) and vins ne 0 and ord(v) ge 3)   = vb_dl(vbt,v,r)*(vb_k(vbt,v,r)/(vb_k(vbt,v,r)+srvp(r,t)*vb_k(vbt,v+1,r))) 		         										 
                                                                  + vb_dl(vbt,v+1,r)*(srvp(r,t)*vb_k(vbt,v+1,r)/(vb_k(vbt,v,r)+srvp(r,t)*vb_k(vbt,v+1,r)));      										 
vb_dk(vbt,v+1,r)$(vintgbs(vbt,r) and vins ne 0 and ord(v) le 2)   = vb_dk(vbt,v,r);									         										 
vb_dk(vbt,v+1,r)$(vintgbs(vbt,r) and vins ne 0 and ord(v) ge 3)   = vb_dk(vbt,v,r)*(vb_k(vbt,v,r)/(vb_k(vbt,v,r)+srvp(r,t)*vb_k(vbt,v+1,r))) 		         										 
                                                                  + vb_dk(vbt,v+1,r)*(srvp(r,t)*vb_k(vbt,v+1,r)/(vb_k(vbt,v,r)+srvp(r,t)*vb_k(vbt,v+1,r)));      										 
vb_da(vbt,g,v+1,r)$(vintgbs(vbt,r) and vins ne 0 and ord(v) le 2) = vb_da(vbt,g,v,r);
vb_da(vbt,g,v+1,r)$(vintgbs(vbt,r) and vins ne 0 and ord(v) ge 3) = vb_da(vbt,g,v,r)*(vb_k(vbt,v,r)/(vb_k(vbt,v,r)+srvp(r,t)*vb_k(vbt,v+1,r))) 
                                                                  + vb_da(vbt,g,v+1,r)*(srvp(r,t)*vb_k(vbt,v+1,r)/(vb_k(vbt,v,r)+srvp(r,t)*vb_k(vbt,v+1,r)));
vb_dh(vbt,g,v+1,r)$(vintgbs(vbt,r) and vins ne 0 and ord(v) le 2) = vb_dh(vbt,g,v,r);
vb_dh(vbt,g,v+1,r)$(vintgbs(vbt,r) and vins ne 0 and ord(v) ge 3) = vb_dh(vbt,g,v,r)*(vb_k(vbt,v,r)/(vb_k(vbt,v,r)+srvp(r,t)*vb_k(vbt,v+1,r))) 
                                                                  + vb_dh(vbt,g,v+1,r)*(srvp(r,t)*vb_k(vbt,v+1,r)/(vb_k(vbt,v,r)+srvp(r,t)*vb_k(vbt,v+1,r)));
vb_dff(vbt,v+1,r)$(vintgbs(vbt,r) and vins ne 0 and ord(v) le 2)  = vb_dff(vbt,v,r);									    											   
vb_dff(vbt,v+1,r)$(vintgbs(vbt,r) and vins ne 0 and ord(v) ge 3)  = vb_dff(vbt,v,r)*(vb_k(vbt,v,r)/(vb_k(vbt,v,r)+srvp(r,t)*vb_k(vbt,v+1,r))) 		          										   
                                                                  + vb_dff(vbt,v+1,r)*(srvp(r,t)*vb_k(vbt,v+1,r)/(vb_k(vbt,v,r)+srvp(r,t)*vb_k(vbt,v+1,r)));      										   
*** new setting: end

* vintaged backstop v5 inherits the coefficients from the new vintage:

vb_dl(vbt,v5,r) = 0;
vb_dk(vbt,v5,r) = 0;
vb_da(vbt,g,v5,r) = 0;
vb_dh(vbt,g,v5,r) = 0;
vb_dff(vbt,v5,r) = 0;

bin(vbt,r)$(active(vbt,r)) = b_k.l(vbt,r) + b_l.l(vbt,r) +
               sum(g,(b_a.l(vbt,g,r))) + sum(g,(b_h.l(vbt,g,r)))+
               b_ff.l(vbt,r);

vb_dk(vbt,v5,r)$(bin(vbt,r) gt 0) = b_k.l(vbt,r)/bin(vbt,r);
vb_dl(vbt,v5,r)$(bin(vbt,r) gt 0) = b_l.l(vbt,r)/bin(vbt,r);
vb_da(vbt,g,v5,r)$(bin(vbt,r) gt 0) =  b_a.l(vbt,g,r)/bin(vbt,r);
vb_dh(vbt,g,v5,r)$(bin(vbt,r) gt 0) =  b_h.l(vbt,g,r)/bin(vbt,r);
vb_dff(vbt,v5,r)$(bin(vbt,r) gt 0) = b_ff.l(vbt,r)/bin(vbt,r);

* update backstop resource
 
fbbp(bt,r,t) = pbf.l(bt,r); 
mvcon(bt,r)$(active(bt,r)) = mvcon(bt,r) + 1$(pbf.l(bt,r) eq 0);

* format: ff(t+1) = alpha*{output(t)-[(1-delta)^5]*output(t-1)} + beta*{output(t)^2-[(1-delta)^5]*output(t-1)^2} + ff(t)*(1-delta)^5  

* NGCC and NGCAP share the same resource supply (YHC: 20150521) and so NGCAP should not appear without a carbon policy
* IGCC and IGCAP share the same resource supply (YHC: 20150630) and so IGCAP should not appear without a carbon policy
* bbres for NGCAP is used only if NGCAP is activated but NGCC is not; the case of bbres for IGCAP follows the same logic.

bbres("ngcc",r,t+1)     = bsin("ngcc","ffa",r)*(ba*(bbngout(r,t)+bbncsout(r,t)-srvb(r,t)*(bbngout(r,t-1)+bbncsout(r,t-1)))
                                              + bb*((bbngout(r,t)+bbncsout(r,t))**2-srvb(r,t)*(bbngout(r,t-1)+bbncsout(r,t-1))**2)) + bbres("ngcc",r,t)*srvb(r,t); 					                         
bbres("igcc",r,t+1)     = bsin("igcc","ffa",r)*(ba*(bbigout(r,t)+bbicsout(r,t)-srvb(r,t)*(bbigout(r,t-1)+bbicsout(r,t-1)))
                                              + bb*((bbigout(r,t)+bbicsout(r,t))**2-srvb(r,t)*(bbigout(r,t-1)+bbicsout(r,t-1))**2)) + bbres("igcc",r,t)*srvb(r,t);

bbres("ngcap",r,t+1)    = bsin("ngcap","ffa",r)*(ba*(bbngout(r,t)+bbncsout(r,t)-srvb(r,t)*(bbngout(r,t-1)+bbncsout(r,t-1)))
                                              + bb*((bbngout(r,t)+bbncsout(r,t))**2-srvb(r,t)*(bbngout(r,t-1)+bbncsout(r,t-1))**2)) + bbres("ngcap",r,t)*srvb(r,t); 					                         
bbres("igcap",r,t+1)    = bsin("igcap","ffa",r)*(ba*(bbigout(r,t)+bbicsout(r,t)-srvb(r,t)*(bbigout(r,t-1)+bbicsout(r,t-1)))
                                              + bb*((bbigout(r,t)+bbicsout(r,t))**2-srvb(r,t)*(bbigout(r,t-1)+bbicsout(r,t-1))**2)) + bbres("igcap",r,t)*srvb(r,t);
                                                                                                                                   
bbres("bioelec",r,t+1)  = bsin("bioelec","ffa",r)*(ba*(bbbioeleout(r,t)-srvb(r,t)*bbbioeleout(r,t-1))+ bb*(bbbioeleout(r,t)**2-srvb(r,t)*bbbioeleout(r,t-1)**2)) + bbres("bioelec",r,t)*srvb(r,t);
bbres("wind",r,t+1)     = bsin("wind","ffa",r)*(ba*(bbwout(r,t)-srvb(r,t)*bbwout(r,t-1))+ bb*(bbwout(r,t)**2-srvb(r,t)*bbwout(r,t-1)**2)) + bbres("wind",r,t)*srvb(r,t);
bbres("solar",r,t+1)    = bsin("solar","ffa",r)*(ba*(bbsolout(r,t)-srvb(r,t)*bbsolout(r,t-1))+ bb*(bbsolout(r,t)**2-srvb(r,t)*bbsolout(r,t-1)**2)) + bbres("solar",r,t)*srvb(r,t);
bbres("adv-nucl",r,t+1) = bsin("adv-nucl","ffa",r)*(ba*(bbadvnucl_bout(r,t)-srvb(r,t)*bbadvnucl_bout(r,t-1))+ bb*(bbadvnucl_bout(r,t)**2-srvb(r,t)*bbadvnucl_bout(r,t-1)**2)) + bbres("adv-nucl",r,t)*srvb(r,t);
bbres("windgas",r,t+1)  = bsin("windgas","ffa",r)*(ba*(bbwgasout(r,t)-srvb(r,t)*bbwgasout(r,t-1))+ bb*(bbwgasout(r,t)**2-srvb(r,t)*bbwgasout(r,t-1)**2)) + bbres("windgas",r,t)*srvb(r,t);
bbres("windbio",r,t+1)  = bsin("windbio","ffa",r)*(ba*(bbwbioout(r,t)-srvb(r,t)*bbwbioout(r,t-1))+ bb*(bbwbioout(r,t)**2-srvb(r,t)*bbwbioout(r,t-1)**2)) + bbres("windbio",r,t)*srvb(r,t);
bbres("h2",r,t+1)       = bsin("h2","ffa",r)*(ba*(bbh2out("oil",r,t)-srvb(r,t)*bbh2out("oil",r,t-1))+ bb*(bbh2out("oil",r,t)**2-srvb(r,t)*bbh2out("oil",r,t-1)**2)) + bbres("h2",r,t)*srvb(r,t);
bbres("bio-oil",r,t+1)  = bsin("bio-oil","ffa",r)*(ba*(bbiofuelout("bio-oil","roil",r,t)-srvb(r,t)*bbiofuelout("bio-oil","roil",r,t-1))+ bb*(bbiofuelout("bio-oil","roil",r,t)**2-srvb(r,t)*bbiofuelout("bio-oil","roil",r,t-1)**2)) + bbres("bio-oil",r,t)*srvb(r,t);

* Set lower bounds of bbres
bbres("ngcc",r,t+1)     = max(0.00001,max(srvb(r,t)*bbres("ngcc",r,t)    ,bbres("ngcc",r,t+1)    ));
bbres("ngcap",r,t+1)    = max(0.00001,max(srvb(r,t)*bbres("ngcap",r,t)   ,bbres("ngcap",r,t+1)   ));
bbres("igcc",r,t+1)     = max(0.00001,max(srvb(r,t)*bbres("igcc",r,t)    ,bbres("igcc",r,t+1)    ));
bbres("igcap",r,t+1)    = max(0.00001,max(srvb(r,t)*bbres("igcap",r,t)   ,bbres("igcap",r,t+1)   ));
bbres("bioelec",r,t+1)  = max(0.00001,max(srvb(r,t)*bbres("bioelec",r,t) ,bbres("bioelec",r,t+1) ));
bbres("wind",r,t+1)     = max(0.00001,max(srvb(r,t)*bbres("wind",r,t)    ,bbres("wind",r,t+1)    ));
bbres("solar",r,t+1)    = max(0.00001,max(srvb(r,t)*bbres("solar",r,t)   ,bbres("solar",r,t+1)   ));
bbres("adv-nucl",r,t+1) = max(0.00001,max(srvb(r,t)*bbres("adv-nucl",r,t),bbres("adv-nucl",r,t+1)));
bbres("windgas",r,t+1)  = max(0.00001,max(srvb(r,t)*bbres("windgas",r,t) ,bbres("windgas",r,t+1) ));
bbres("windbio",r,t+1)  = max(0.00001,max(srvb(r,t)*bbres("windbio",r,t) ,bbres("windbio",r,t+1) ));
bbres("h2",r,t+1)       = max(0.00001,max(srvb(r,t)*bbres("h2",r,t)      ,bbres("h2",r,t+1)      ));
bbres("bio-oil",r,t+1)  = max(0.00001,max(srvb(r,t)*bbres("bio-oil",r,t) ,bbres("bio-oil",r,t+1) ));
		  	      	        		      
* For 1st generation biofuels:
bbres("bio-fg",r,t+1)   = (bbres("bio-fg",r,t)*bioff(t+1,r))$biofgprod(r,t)+(bbres("bio-fg",r,t))$(not biofgprod(r,t));

BRES(BT,R)              = BBRES(BT,R,T+1);

* update government expenditure

*grg_t(r,t+1)            = grg_t(r,t)*rgdpgrowth(r,t+1);
grg_t(r,t+1)            = (grg_t(r,t)*agnp(r,t)/agnp(r,t-1))$(ord(t) gt 1)+(grg_t(r,t)*rgdpgrowth(r,t+1))$(ord(t) eq 1);
grg(r)                  = grg_t(r,t+1);

* ADAIDS style update for income elasticity for the next period consumption:
** Calculate income elasticities based on AIDADS demand system;
** Assignments to 11_forestry are simply to avoid numerical errors
** Assignments of max and share recalibration are safeguards to reassure the variable "what" won't be negative

** per capita expenditure (thousand US$ per capita in 1997 price and then divided by 100, which follows Reimer-Hertel (2004))
** 1.246481513 is the GDP deflator to convert 2007 price back to 1997 price (World Bank data)
** price07_e4: need to use the projected sectoral real price levels from EPPA4 (in 1997 price) to interpolate the 2007 price levels 
** Note that the AIDADS implementation lags one period
** Add a lower bound for finalcp of each region to avoid potential numerical errors in some extreme scenarios (YHC: 20150520)

** Step 1: Implement the Reimer-Hertel logic
finalcp(r,t)            = (utp(r,t)*aca(r,t)*10/population(r,t)*1000/1.246481513)/100;
finalcp(r,t)            = max(finalcp(r,t),finalcp(r,"2007")*0.1);
price(irh,r,t)          = sum(i,pa.l(i,r)*vdfmplusvifm(irh,i,r))/sum(i,vdfmplusvifm(irh,i,r))*price07_e4(irh,r);

u(r,t)                  = -9.994879656896 + 1.138117884571*log((finalcp(r,t)*100)) ;
phia(irh,r,t)           = (alpha(irh) + beta(irh)*exp(u(r,t)))/(1 + exp(u(r,t))) ;
what(jrh,r,t)           = gamma(jrh)*price(jrh,r,t)/finalcp(r,t) + phia(jrh,r,t)*(1-sum(irh,price(irh,r,t)*gamma(irh))/finalcp(r,t)) ;	     
what("11_forestry",r,t) = 1;
xhat(irh,r,t)           = what(irh,r,t)*finalcp(r,t)/price(irh,r,t) ;
xhat("11_forestry",r,t) = 1;
mbs(irh,r,t)            = phia(irh,r,t)-(beta(irh)-alpha(irh))
                         *(1/(sum(jrh, (beta(jrh)-alpha(jrh))*log(max(0.00001,xhat(jrh,r,t)-gamma(jrh))))-(1+exp(u(r,t)))**2/exp(u(r,t))));
elas("11_forestry",r,t) = 0;

** Change setting for individual income elasticities (remain constant at 2007 levels or change over time based on AIDADS formalation):
elas(irh,r,t)           = mbs(irh,r,"2007")/what(irh,r,"2007");

** Step 2: If we want to use the 2005 USDA ICP income elasticity data, activate the following three lines:
*elas("1_GrainCrops",r,t) = usda(r,"crop");
*elas("2_MeatDairy", r,t) = usda(r,"live");
*elas("3_OthFoodBev",r,t) = usda(r,"food");

** Step 3: Convert individual income elasticity to aggregated income elasticity
elastot(irh,r,t)$(((finalcp(r,t)-finalcp(r,"2007"))/finalcp(r,"2007"))+(population(r,t)-population(r,"2007"))/population(r,t) ne 0)        
                        = (elas(irh,r,t)*((finalcp(r,t)-finalcp(r,"2007"))/finalcp(r,"2007"))+(population(r,t)-population(r,"2007"))/population(r,t))
                          /(((finalcp(r,t)-finalcp(r,"2007"))/finalcp(r,"2007"))+(population(r,t)-population(r,"2007"))/population(r,t));
** In the base year, no change in population so elastot = elas (note also no change in finalcp so need to avoid division by zero)
elastot(irh,r,t)$(((finalcp(r,t)-finalcp(r,"2007"))/finalcp(r,"2007"))+(population(r,t)-population(r,"2007"))/population(r,t) eq 0)        
                        = elas(irh,r,t);
** Fix the 2010 elastot numbers at the 2007 levels to avoid decreases in consumption levels in 2015 due to 2010 economic downturn 
** Note the one-period lag in income elasticiies implementation
elastot(irh,r,"2010")     = elastot(irh,r,"2007");
elastot("1_GrainCrops","usa","2010") = 0.4;

** Activate the following three lines for the pure Stone-Geary case (constant cstar):
*elastot("1_GrainCrops",r,t) = elastot("1_GrainCrops",r,"2007");
*elastot("2_MeatDairy",r,t)  = elastot("2_MeatDairy",r,"2007"); 
*elastot("3_OthFoodBev",r,t) = elastot("3_OthFoodBev",r,"2007");

** Step 4: Calculate the final consumption value share
* Because only focus on crop, live, and food, no need to worry about hhtran at this moment
vshr(g,r,t)              = pc0(g,r)*cexp(r,g)/sum(i,pc0(i,r)*cexp(r,i));

** Step 5: Make sure Engel's Aggregation holds (assume income elasticities other than crop, live, and fors are the same)
eta(r,g)                = (1-vshr("crop",r,t)*elastot("1_GrainCrops",r,t)
                            -vshr("live",r,t)*elastot("2_MeatDairy",r,t)
                            -vshr("fors",r,t)*elastot("3_OthFoodBev",r,t))
                          /(1-vshr("crop",r,t)-vshr("live",r,t)-vshr("fors",r,t)); 

eta(r,"crop")           = elastot("1_GrainCrops",r,t);
eta(r,"live")           = elastot("2_MeatDairy",r,t);
eta(r,"food")           = elastot("3_OthFoodBev",r,t);

** Step 6 (final step): If we want to go back to a pure CES world, set all income elasticities to one:
*eta(r,g)                = 1;
eta_t(r,g,t)            = eta(r,g);

** Step 7: Update the cost shares of crop and live in food sector: the shares are based on final consumption structure
xa(r,cl,food)    = (xdp0(r,cl,food)+xmp0(r,cl,food))
                    *(cons_sec(cl,r,t)/sum(g,cons_sec(g,r,t)))
                    /(cons_sec(cl,r,"2007")/sum(g,cons_sec(g,r,"2007")));

xa(r,ncl,food)   = (xdp0(r,ncl,food)+xmp0(r,ncl,food))
                    /(sum(i,xdp0(r,i,food)+xmp0(r,i,food))-sum(cl,xdp0(r,cl,food)+xmp0(r,cl,food)))
                    *(sum(i,xdp0(r,i,food)+xmp0(r,i,food))-sum(cl,xa(r,cl,food)));

sa(r,g,food)$((xdp0(r,g,food)+xmp0(r,g,food)) ne 0)      
                 = xa(r,g,food)/(xdp0(r,g,food)+xmp0(r,g,food));  

sa(r,g,food)$((xdp0(r,g,food)+xmp0(r,g,food)) eq 0) = 1;     
                 
sa(r,g,food)$(sa(r,g,food) lt 0)                    = 1;


* If the line below is activated, input shares of the cost function for food will not be changed:
*sa(r,i,g)       = 1;

* Keep track of the level of tax rate instrument for limiting energy use:
tlimc_t(e,g,r,t) = tlimc.l(e,g,r);    

* Lower the fixed factor substitution elasticity for wind power after 2050:
bsf("wind",r)$(t.val ge 2050) = bsf("wind",r)-0.004;
  
** 8.16 Emissions accounting 
$include eppaemis.gms

** 8.17 Save bau productivity 

* save the bau productivity index calculated in eppacore
gprod_t(r,t)$(simu eq 0) = gprod.l(r);
gprod_l_t(r,t)           = lprod_f(r);
gprod_k_t(r,t)           = kprod_f(r);
gprod_f_t(r,t)           = fprod_f(r);
rgdp_proj(r,t)           = rgdp0(r);

* update the targeted real gdp level
rgdp0(r)                 = rgdp0(r)*rgdpgrowth(r,t+1);

* 8.18 Sectoral value-added

sva(g,r,t)		 = pl.l(r)*(dl.l(g,r)+sum(v, lv_v.l(g,v,r))+(nl.l(r)+hl.l(r)+ sum(ebt, b_l.l(ebt,r))+sum((ebt,v), bv_l.l(ebt,v,r)))$elec(g)
										    +(sum(obt, b_l.l(obt,r))+sum((obt,v), bv_l.l(obt,v,r)))$roil(g)	
										    +(sum(gbt, b_l.l(gbt,r))+sum((gbt,v), bv_l.l(gbt,v,r)))$gas(g)
												)
			  +pk.l(r)*(dk.l(g,r)+(nk.l(r)+hk.l(r)+ sum(ebt, b_k.l(ebt,r)))$elec(g)
							      +(sum(obt, b_k.l(obt,r)))$roil(g)	
							      +(sum(gbt, b_k.l(gbt,r)))$gas(g)
												)
			  +sum(v, pkv.l(g,v,r)*kv_v.l(g,v,r))+(sum((vbt,v), pvbk.l(vbt,v,r)*bv_k.l(vbt,v,r)))$(elec(g))
			  +pf.l(g,r)*df.l(g,r)
			  +(sum(ebt, b_f.l(ebt,r)*pf.l("crop",r))+sum(ebt, pbf.l(ebt,r)*b_ff.l(ebt,r))+sum((ebt,v),pbf.l(ebt,r)*bv_ff.l(ebt,v,r)))$(elec(g))
			  +(sum(obt, b_f.l(obt,r)*pf.l("crop",r))+sum(obt, pbf.l(obt,r)*b_ff.l(obt,r))+sum((obt,v),pbf.l(obt,r)*bv_ff.l(obt,v,r)))$(roil(g))
			  +(sum(gbt, b_f.l(gbt,r)*pf.l("crop",r))+sum(gbt, pbf.l(gbt,r)*b_ff.l(gbt,r))+sum((gbt,v),pbf.l(gbt,r)*bv_ff.l(gbt,v,r)))$(gas(g))

			  +(pr.l(r)*df_n.l(r)+pr_h.l(r)*df_n.l(r))$(elec(g))
			  ;


);
* ---------- model loop ends -------------------------------------------------------------------

* ---------- 9. Save bau productivity, backstop resource, and co2 emissions for later use ------

*if (%simuv% eq 0, execute_unload "bau.gdx",gprod_t,co2_ref,ghg_ref,urb_ref;);

$if %simuv% == 0 execute_unload "..%slash%core%slash%bau.gdx" gprod_t = gprod_t  co2_ref = co2_ref ghg_ref = ghg_ref urb_ref = urb_ref;

* The following two lines are for Snowmass Project: LHS is dumped to RHS, which is written to the gdx file.
*$ontext
$if %csnm% == v-ref                                        execute_unload "..%slash%core%slash%chmvref.gdx" chmurb = chmurb1;
$if %csnm% == policy_mup $if %popg% == p0 $if %prog% == r0 execute_unload "..%slash%core%slash%chmpol.gdx" chmurb = chmurb1;
*$offtext

* ---------- 10. Report writing ----------------------------------------------------------------

* include files for report writing: 
* eppaput.gms will be executed every period, and report.gms will be executed only in the end

$include eppaput.gms

*COV add reporting file for csv
*This file is an example of outputs from the model, users should customize it as needed
*Report for csv for each period
$if %system.filesys%==UNIX  $include report_csv.gms


$ifthen %nper% == %stop%
$include report.gms
$endif


