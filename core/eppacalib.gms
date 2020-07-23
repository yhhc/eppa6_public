
ghglim(ghg,r)       = 0; 
ghglimg(ghg,g,r)    = 0;
ghglimg(ghg,"fd",r) = 0;
ghgt                = 0;
ghg_gwp             = 0;
ghg_gp(ghg,r)       = 0;
ghg_gw(ghg)         = 0;
scarblim(g,r)       = 0;
biot                = 0;
gmarket             = 0;
fdf(r)              = 0;
ttco2               = 0;
wghgk               = 0;
taxins(r)           = 0;
ctaxf(r)            = 0;
pcarbtarg(r)        = 0;
ntarget             = 1;
*ptarget(g,r)        = 1;
carblim(r)          = 0;
pcarblag            = 0;
*epslon is arbitrary now.
*epslon(e)           = 1; 
*ej_95d is arbitrary now.       
ej_95d(r,e)         = 1;    
*curb is arbitrary now.    
*curb(urb,"roil","elec",r) = 0;  
phi(r)              = 0;
co2tax(e,r)         = 0;
*cj(e,r)             = 1;
*cghg is arbitrary now.
*cghg(ghg,e,g,r)     = 0;        
ghg_gwc(r)          = 0;


*outco2(r,g)         = 0;
*outco2 value is arbitrary now.
*oghg(ghg,g,r)       = 0;
*oghg value is arbitrary now.
*ourb(urb,g,r)       = 0;
*ourb value is arbitrary now.

*elekadj value is arbitrary now.
*fcghg(ghg,"fd",r)   = 0;
*fcghg value is arbitrary now.

* note that the xp0(r,"elec") below doesn't include hydro and nuclear
*d0(r,g)             = xp0(r,g)-es0(r,g)-xdi0(r,g)-vst(g,r)-xmi0(r,g);
*d0(r,g)             = xp0(r,g)-es0(r,g)-xdi0(r,g)-vst(g,r);
d0(r,g)             = xp0(r,g)-es0(r,g)-vst(g,r);
d0(r,"elec")        = d0(r,"elec")+h_e0(r)+n_e0(r);


w0(r)               = cons0(r)+inv0(r);
tcarblim(r)         = 0;
fcarblim(r)         = 0;
urblim(urb,r)       = 0;


* assignment of household transportation input-output coefficients

purtrn(r) = xdc0(r,"tran") + xmc0(r,"tran");

* set the followings to zero since they are replaced by purtrn: 
xdc0(r,"tran")   = 0;
xmc0(r,"tran")   = 0;

* hh's own transportation is extracted from cons0 (aggregate consumption)
* xdc0 may become negative but this simply means imports are needed 
* as long as the demand for armington goods (xdc0 + xmc0) is non-negative, it is fine.

owntrn(r)        = es(r)*cons0(r);
tottrn(r)        = purtrn(r)*pc0("tran",r) + owntrn(r);
tro(r)           = os(r)*ence("roil",r);
toi(r)           = mvh(r);
tse(r)           = (owntrn(r) - tro(r)*pc0("roil",r) - toi(r)*pc0("othr",r))/pc0("serv",r);

ence("roil",r)   = ence("roil",r) - tro(r);
xdc0(r,"roil")   = xdc0(r,"roil") - tro(r);
xdc0(r,"othr")   = xdc0(r,"othr") - toi(r);
xdc0(r,"serv")   = xdc0(r,"serv") - tse(r);

*tefd(e,r)        = 0;
*tefd("roil",r)   = os(r)*efd("roil",r);
heusef(e,r)      = eusef(e,r);
heusef("roil",r) = heusef("roil",r) - tro(r);
teusef(e,r)      = 0;
teusef("roil",r) = tro(r);
ftrn(r) = 1;
* 1 = carbon price on roil in hh transport (usual eppa)
* 0 = no carbon policy in hh transport
*hcghg(ghg,"roil","fd",r) = 0;
*tcghg(ghg,e,"fd",r) = 0;

* Filter out oghg, cghg, and fcghg that are too small and give solver hard time to find a solution
*oghg(ghg,g,r)          = oghg(ghg,g,r)$(oghg(ghg,g,r) ge 0.0001)+0$(oghg(ghg,g,r) lt 0.0001);
*cghg(ghg,e,g,r)        = cghg(ghg,e,g,r)$(cghg(ghg,e,g,r) ge 0.0001)+0$(cghg(ghg,e,g,r) lt 0.0001);
*cghg(ghg,e,"fd",r)     = cghg(ghg,e,"fd",r)$(cghg(ghg,e,"fd",r) ge 0.0001)+0$(cghg(ghg,e,"fd",r) lt 0.0001);
*fcghg(ghg,"fd",r)      = fcghg(ghg,"fd",r)$(fcghg(ghg,"fd",r) ge 0.0001)+0$(fcghg(ghg,"fd",r) lt 0.0001);

* os(r) = Share of transport usage of refined oil in household sector.  See eppaparm.gms  
hcghg(ghg,e,"fd",r)      = cghg(ghg,e,"fd",r);
tcghg(ghg,e,"fd",r)      = 0;
tcghg(ghg,"roil","fd",r) = os(r)*cghg(ghg,"roil","fd",r);
*tcghg(ghg,"roil","fd",r) = tcghg(ghg,"roil","fd",r)$(tcghg(ghg,"roil","fd",r) ge 0.0001)+0$(tcghg(ghg,"roil","fd",r) lt 0.0001);
hcghg(ghg,"roil","fd",r) = hcghg(ghg,"roil","fd",r) - tcghg(ghg,"roil","fd",r);
*hcghg(ghg,"roil","fd",r) = hcghg(ghg,"roil","fd",r)$(hcghg(ghg,"roil","fd",r) ge 0.0001)+0$(hcghg(ghg,"roil","fd",r) lt 0.0001);
*cghg(ghg,"roil","fd",r)  = tcghg(ghg,"roil","fd",r) + hcghg(ghg,"roil","fd",r);
* Note: the above parameters are: 1) inputs for ghg_ref (in eppaemis.gms) => gquota => ghglim => activate pghg; 
* and 2) input coefficients for the production blocks in eppacore.  

* GHG conversion unit (In EPPA5, gu = 1, but since ghg_inv is multiplied by 1000 in EPPA6, gu needs to be 1000 now.)
* Note that in data preparation, the units for pfc, sf6, and hfc are only 1/1000 of ch4 and n2o.
* But this unit issue has been accounted for in EPPA5 in eppaghg.gms, and with "unit = 1000" in the data preparation file ghg.gms,
* all GHGs after eppaghg.gms are in 100 thousdand ton.  However, in eppacore, outco2 is in 100 million ton, this is why we need
* gu(ghg) = 1000, which means that if pghg = 1 for a million ton GHG, then pghg = 1/1000 for a thousand ton GHG.

gu(ghg)       = 1000;
gu(urb)       = 1000;

rgdp0(r) = cons0(r)+inv0(r)+g0(r)									   
		 + sum((g,rr),(1+tx(g,r,rr))*(1$(wtflow0(rr,r,g) and not gmarket and not x(g)))*wtflow0(rr,r,g)) 
		 - sum((g,rr),(1+tx(g,rr,r))*(1$(wtflow0(r,rr,g) and not gmarket and not x(g)))*wtflow0(r,rr,g)) 
		 + sum(x, homx0(x,r))
		 - sum(x, homm0(x,r)) 
		 ;