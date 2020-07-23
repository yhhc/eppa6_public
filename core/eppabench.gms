* eppabench.gms

* this file checks balances and consistencies of social accounting
* matrices(sams) in base period.

*---------------------------------------------------------------------
*       check the benchmark for consistency
*---------------------------------------------------------------------

parameter
	mktdom(r,i)     domestic market clearance,
	mktexp(r,i)     export - trade flow balance
	mktimp(r,i)     import - trade flow balance
	mktcon(r)       consumptiton goods market,
	incbal(r)       household income balance,
	regbal(r)       regional income balance
	profita(r,i)     profit-cost balance
	mktm(r,i)       import supply and demand
	fxcbal(r)       foreign exchange balance
	oilbal(oil)     oil supply demand balance
	savbal(r,*)     investment-savings balance
	govbal(r)	government budget balance

        ;

* expenditure balance (sam row sum minus sums of the row):

mktdom(r,i) = xp0(r,i)-sum(j,xdp0(r,i,j)) - xdc0(r,i)
		-xdg0(r,i) - xdi0(r,i) - xdst0(r,i) - vst(i,r) - es0(r,i);
display mktdom;

* exports balance: by region and by commodity:

mktexp(r,i) = es0(r,i) - sum(rr, wtflow0(rr,r,i));
display mktexp;

* imports balance: by region and by commodity:

mktimp(r,i) = xm0(r,i) - sum(rr, (wtflow0(r,rr,i)*(1+tx(i,rr,r))+sum(j,vtwr(j,i,rr,r)))*
				(1+tm(i,rr,r)) );
display mktimp;

* consumption balance: consumption total minus sum of production-consumption
*  transform matrix:

mktcon(r) = cons0(r) - sum(i, (xdc0(r,i) + xmc0(r,i))*pc0(i,r));
display mktcon; 

* representative consumer's income and expenditure balance:

incbal(r) = cons0(r)+sum(i, (xdg0(r,i) + xmg0(r,i))*pg0(i,r))
		+sum(i,xdi0(r,i))+sum(i,xmi0(r,i))-sum(g,labd0(r,g))
		-labdg0(r)-sum(g,kapd0(r,g))-kapdg0(r)-sum(g,ffactd0(r,g))
		- taxh0(r)-savf0(r);


display incbal;                

* crude oil supply and demand balance (at global level):

oilbal(oil) = sum(r, xp0(r,oil)-sum(j,xdp0(r,oil,j))
		-xdc0(r,oil)-xdg0(r,oil)-xdi0(r,oil)-xdst0(r,oil) 
		-es0(r,oil));
display oilbal;      


fxcbal(r) = sum((i,rr), wtflow0(rr,r,i)*(1+tx(i,r,rr)))+ sum(i, vst(i,r))-
            sum( (i,rr),(wtflow0(r,rr,i)*(1+tx(i,rr,r))+sum(j,vtwr(j,i,rr,r))) )+ savf0(r);
display fxcbal;

govbal(r) = savg0(r); 

display govbal;

savbal(r,"stk")  = sum(i,xdst0(r,i)+xmst0(r,i));
savbal(r,"inv")  = sum(i,xdi0(r,i)+xmi0(r,i));
savbal(r,"total")= savh0(r) - savg0(r) + savf0(r)
		  - sum(i,xdst0(r,i)+xmst0(r,i)+xdi0(r,i)+xmi0(r,i));
display savbal;


parameter ror(r)  benchmark rate of return;

ror(r) = (kapdg0(r) + sum(i, kapd0(r,i))) / kstock0(r);
display ror;

parameters
  dpe(r)        annual depreciation rate - economic
  dpp(r)        annual depreciation rate - physical
  dpb(r)        annual depreciation rate - backstop fixed factor
  srve(r,*)     single period survival rate - economic
  srvp(r,*)     single period survival rate - physical
  srvb(r,*)     single period survival rate - backstop fixed factor

;   

* John suggested a 0% physical depreciation for each year, and depreciated all at once at the end physically and economically
* YHC: April 2014

dpe(r) = 0.05;
dpp(r) = 0.00;
dpb(r) = 0.01;

srve(r,"t0") = (1-dpe(r))**5;
srvp(r,"t0") = (1-dpp(r))**5;
srvb(r,"t0") = (1-dpb(r))**5;

srve(r,t) = ((1-dpe(r))**3)$(ord(t) eq 1)+((1-dpe(r))**5)$(ord(t) ge 2);
srvp(r,t) = ((1-dpp(r))**3)$(ord(t) eq 1)+((1-dpp(r))**5)$(ord(t) ge 2);
srvb(r,t) = ((1-dpb(r))**3)$(ord(t) eq 1)+((1-dpb(r))**5)$(ord(t) ge 2);

*---------------------------------------------------------------------
*       install parameters for model specification:
*---------------------------------------------------------------------
parameter
	a0(r,i)         benchmark armington output,
	ta(r,g)         benchmark energy tax,
	td(r,g)         benchmark excise tax,
	g0(r)           benchmark public demand,
	gs0(r)          benchmark public supply,
	inv0(r)         benchmark investment 
	l0(r)           benchmark labor supply
	ke0(g,r)        benchmark capital-energy supply
        use0(e,r)       benchmark total energy demand
	popindex(r)     population index;

*a0(r,g)$(not cgd(g))  = xp0(r,g)-es0(r,g)+xm0(r,g)-vst(g,r)-xdi0(r,g);
*a0(r,g)               = xp0(r,g)-es0(r,g)+xm0(r,g)-vst(g,r)-xdi0(r,g)-xmi0(r,g);
a0(r,g)               = xp0(r,g)-es0(r,g)+xm0(r,g)-vst(g,r);
td(r,g)$xp0(r,g)      = ptxy0(r,g) / xp0(r,g);
g0(r)                 = kapdg0(r)+labdg0(r)+sum(g, xdg0(r,g)+xmg0(r,g))+trg0(r);
l0(r)                 = sum(i, labd0(r,i)) + labdg0(r);
inv0(r)               = sum(g, xdi0(r,g)+xmi0(r,g));
*inv0(r)               = sum(g, xdi0(r,g)+xmi0(r,g))-(xdi0(r,"oil")+xmi0(r,"oil"));
ke0(g,r)              = kapd0(r,g)+ffactd0(r,g)+sum(e, (xdp0(r,e,g)+xmp0(r,e,g))*(1+ti(e,g,r)));

display g0,td;

parameter 
einput  flag for energy input

;

einput(e,g,r)$(not oil(g)) = 1$(xdp0(r,e,g)+xmp0(r,e,g));

*       final check: regional income balance

regbal(r) = l0(r)+kapdg0(r)+sum(g,kapd0(r,g)+ffactd0(r,g))+savf0(r)+taxh0(r)		  
            - sum(g, xdst0(r,g)+xmst0(r,g))-g0(r)-inv0(r)-cons0(r)
	 ;

display regbal;


*execute_unload "..\test_eppabench.gdx" 