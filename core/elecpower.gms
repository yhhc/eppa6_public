** 1. tariffs, transport margins, imports, exports

*	convert good x into internationally homogenous goods:
parameter
	tmhom(x,r)	import tariff on homogenous goods
	txhom(x,r)      export tax on homogenous goods
	homm0(x,r)	imports of homogenous goods
	homx0(x,r)	exports of homogenous goods
	tmargin		transport margin
	homt0		value of homogenous goods transport cost
	vhomm0		value of homogenous imports
	vhomx0		value of homogenous exports
	homadj		adjustment for homogenous treatment
	trnadj		transport adjustment for homogenous goods;

* note: wtflow0(r,s,i) = vxmd(i,s,r);
homm0(x,r) = max(0, sum(rr, wtflow0(r,rr,x)*(1+tx(x,rr,r)))                                
				- sum(rr, wtflow0(rr,r,x)*(1+tx(x,r,rr))) );

parameter adj_lng(x,r);

adj_lng(x,r)$(x("gas")) = 0.1*homm0(x,r);
adj_lng("oil",r)        = 0;


homx0(x,r)            = max(0,-sum(rr,wtflow0(r,rr,x)*(1+tx(x,rr,r)))+ sum(rr, wtflow0(rr,r,x)*(1+tx(x,r,rr))));
txhom(x,r)$homx0(x,r) = sum(rr, wtflow0(rr,r,x)*tx(x,r,rr))/sum(rr, wtflow0(rr,r,x));
vhomx0(x,r)           = homx0(x,r)/(1+txhom(x,r));
tmargin(x,r)$sum(rr, wtflow0(r,rr,x)) = 
			sum(rr, sum(j,vtwr(j,x,rr,r)))/sum(rr, wtflow0(r,rr,x)*(1+tx(x,rr,r)));

homt0(x,r)            = tmargin(x,r)*homm0(x,r);
homt0(x,r)            = tmargin(x,r)*homm0(x,r)*10 + adj_lng(x,r);
homt0("oil",r)        = tmargin("oil",r)*homm0("oil",r);
tmhom(x,r)$homm0(x,r) = sum(rr, (wtflow0(r,rr,x)*(1+tx(x,rr,r))+sum(j,vtwr(j,x,rr,r)))*tm(x,rr,r))/						
			 sum(rr, (wtflow0(r,rr,x)*(1+tx(x,rr,r))+sum(j,vtwr(j,x,rr,r))) );

* homt0: value of homogenous goods transport cost; tmhom: tariff on homogenous goods
vhomm0(x,r)           = (homm0(x,r)+homt0(x,r))*(1+tmhom(x,r));
*vhomm0(x,r)$(x("gas")) = (homm0(x,r)+homt0(x,r))*(1+tmhom(x,r)) - adj_lng(x,r);
homadj(x,r)           = a0(r,x) - (xp0(r,x)+vhomm0(x,r)-vhomx0(x,r));
trnadj(x,r)           = homt0(x,r)-sum(rr, sum(j,vtwr(j,x,rr,r)));

display homadj, trnadj;

** 2. separating nuclear power from GTAP's aggregate electricity

* the column "output" is the share of nuclear power out of total generation, provided by David Ramberg (IEA data).
* see IEA "Energy Statistics of OECD Countries" and "Energy Statistics of Non-OECD Countries". 
* the base year for the data is 2007.

* Base on World Nuclear Assocuation: http://world-nuclear.org/info/Country-Profiles/Countries-G-N/Mexico/
* for Mexico, the 2012 nuclear output is 8.8 TWh, but the original output number in the nuclear table will
* give a 2010 output of 0.13 EJ (36TWh).  So, the output number in the nuclear table should be roughly 
* divided by 4 to match the correct output. (YHC: 20131107)

* Indonesia's nuclear power is projected to account for around 1.96% of total electricity output in 2025.
* http://en.wikipedia.org/wiki/Nuclear_power_in_Indonesia
* The original nuclear power share, which is 0.01/100, is way too small to achieve this.  (YHC: 20131112)

* the input structure is from earlier version of EPPA, and it should base on some engineering data and educated guess 
* in some cases it should be adjusted to make sure the input of fossil generation, which is the "residue" of the calculation,
* will remain positive.

table nuclear(r,*)	input and output coefficients for nuclear production

          output   capital  labor  serv	  othr	 fuel	      
afr       1.8499   55	    25	   3	  2	 15            
anz       0.0100   55	    25	   3	  2	 15        
asi       6.9795   55	    25	   3	  2	 15     
bra       2.7744   50	    30	   3	  2	 15   
can      14.6337   55	    20	   6	  4	 15 
chn       1.8678   55	    25	   3	  2	 15      
eur      27.1471   50	    30	   3	  2	 15   
*idz       0.0100   55	    15	   9	  6	 15   
idz       0.5      55	    15	   9	  6	 15 
ind       2.0834   55	    25	   3	  2	 15       
jpn      23.4415   55	    25	   3	  2	 15         
kor      33.5608   55	    10	  10	 10	 15            
lam       1.2560   55	    25	   3	  2	 15          
mes       0.0100   55	    25	   3	  2	 15         		  	         
*mex       4.0510   55	    25	   3	  2	 15                  	  		  	               	  		  	      
mex       1.0000   55	    25	   3	  2	 15   
rea       1.1672   55	    25	   3	  2	 15          	  		  	                     	  		  	    
roe      13.3728   50       30	   3	  2	 15                  	  		              
rus      15.7923   20       30	  30	  5	 15                  	  		              
usa      19.3490   55	    25	   3	  2	 15  	   
;

nuclear(r,"tot") = nuclear(r,"capital")+nuclear(r,"labor")+nuclear(r,"fuel")+nuclear(r,"othr")+nuclear(r,"serv");

parameter
	n_e0(r)		benchmark nuclear electric output,
	n_l0(r)		benchmark labor demand by nuclear sector,
	n_k0(r)		benchmark capital demand by nuclear sector,
	n_r0(r)		benchmark resource (fuel) demand by nuclear sector,
	n_s0(r)		benchmark services demand by nuclear sector,
	n_ot0(r)	benchmark OTHR demand by nuclear sector,
	n_r(r)		current resource demand by nuclear sector;

n_e0(r)	    = 0;
n_l0(r)	    = 0;
n_k0(r)	    = 0;
n_r0(r)	    = 0;
n_s0(r)	    = 0;
n_ot0(r)    = 0;
n_r(r)	    = 0;

n_e0(r)  = (nuclear(r,"output")/100)*xp0(r,"elec");
n_l0(r)  = (nuclear(r,"labor")/nuclear(r,"tot"))*n_e0(r)*(1-td(r,"elec"))/(1+tf("lab","elec",r));
n_k0(r)  = (nuclear(r,"capital")/nuclear(r,"tot"))*n_e0(r)*(1-td(r,"elec"))/(1+tf("cap","elec",r));
n_r0(r)  = (nuclear(r,"fuel")/nuclear(r,"tot"))*n_e0(r)*(1-td(r,"elec"))/(1+tf("cap","elec",r));
n_s0(r)  = (nuclear(r,"serv")/nuclear(r,"tot"))*n_e0(r)*(1-td(r,"elec"))/(1+ti("serv","elec",r));						  
n_ot0(r) = (nuclear(r,"othr")/nuclear(r,"tot"))*n_e0(r)*(1-td(r,"elec"))/(1+ti("othr","elec",r));						  
n_r(r)   = n_r0(r);


*=== Incorporating the hydropower sector within GTAP using IEA data ===*

*Note: input shares sum up to 100
table hydro(r,*)   input and output coefficients for hydro generation

	 output  capital  labor	 serv  othr	RES
afr	15.2670	    55.0   10.0	   3      2	30	  
anz	13.2271     60.0    5.0	   3      2	30
ASI	 4.7491     60.0    5.0	   3      2	30
BRA	75          45.0   15.0	   5      5	30
can	57.5357     40.0   20.0	   8      2	30
CHN	14.5881     55.0   10.0	   3      2	30
EUR	13.7280     45.0   10.0	   9      6	30	
idz      7.9348     60.0    5.0	   3      2	30
IND	14.8160     60.0    5.0	   3      2	30
JPN	 6.5757     60.0    5.0	   3      2	30
kor      0.8525     60.0    5.0	   3      2	30
LAM	51.4706     40.0   20.0	   5      5	30
MES	 3.8659     60.0    5.0	   3      2	30
mex	10.6031     60.0    1.5	   0.5    8	30
REA	33.9434     55.0   10.0	   3      2	30
ROE	17.7443     55.0   10.0	   3      2	30
RUS	17.4707     20.0    9.0	  33      8	30
USA	 5.7730	    60.0    5.0	   3      2	30

*EUR	20.7    55.0    10.0	3	2	30 => kapd becomes negative since n_k + n_r + h_k + h_r is bigger!
*can	66.8    40.0    20.0	8	2	30 => kapd, xdp0("serv","elec"), or xdp0("serv","elec") become negative!
*mex	10.3    36.0    1.5	0.5	32	30 => xdp0 becomes negative!
*BRA	82.8	8.0	42.0	10	10	30 => labd becomes negative since n_l + h_l is bigger! 
*LAM	50.0    32.0    20.0	10	8	30 => xdp0 becomes negative!
;

hydro(r,"tot") = hydro(r,"capital")+hydro(r,"labor")+hydro(r,"serv")+hydro(r,"othr")+hydro(r,"res");

parameter

	h_e0(r)		hydro: benchmark output
	h_l0(r)		hydro: benchmark labor input
	h_k0(r)		hydro: benchmark capital input
	h_r0(r)		hydro: benchmark resource (water) input
        h_s0(r)		hydro: serv input	
	h_ot0(r)	hydro: othr input
        h_r(r)		hydro: current resource input
;

h_e0(r)		= 0;
h_l0(r)		= 0;
h_k0(r)		= 0;
h_r0(r)		= 0;
h_s0(r)		= 0;
h_ot0(r)	= 0;
h_r(r)		= 0;

h_e0(r)  = (hydro(r,"output")/100)*xp0(r,"elec");
h_l0(r)  = (hydro(r,"labor")/hydro(r,"tot"))*h_e0(r)*(1-td(r,"elec"))/(1+tf("lab","elec",r));
h_k0(r)  = (hydro(r,"capital")/hydro(r,"tot"))*h_e0(r)*(1-td(r,"elec"))/(1+tf("cap","elec",r));
h_r0(r)  = (hydro(r,"res")/hydro(r,"tot"))*h_e0(r)*(1-td(r,"elec"))/(1+tf("cap","elec",r));
h_s0(r)  = (hydro(r,"serv")/hydro(r,"tot"))*h_e0(r)*(1-td(r,"elec"))/(1+ti("serv","elec",r));						  
h_ot0(r) = (hydro(r,"othr")/hydro(r,"tot"))*h_e0(r)*(1-td(r,"elec"))/(1+ti("othr","elec",r));						  
h_r(r)   = h_r0(r);

* adjust the remaining (fossil fuels) electricity output and input (residual part):

xp0(r,"elec")         = xp0(r,"elec")-n_e0(r)-h_e0(r);
labd(r,"elec")        = labd(r,"elec")-h_l0(r)-n_l0(r);
kapd(r,"elec")        = kapd(r,"elec")-h_k0(r)-h_r0(r)-n_k0(r)-n_r0(r);
xdp0(r,"serv","elec") = xdp0(r,"serv","elec")-h_s0(r)-n_s0(r);
xdp0(r,"othr","elec") = xdp0(r,"othr","elec")-h_ot0(r)-n_ot0(r);


* A CES calibration to a given price supply elasticity for nuclear and hydro:
parameter
	nshare, sigma,neta,hshare,hsigma,heta;
neta(r) = 0.5;
neta("usa")=0.25;
neta("eur")=0.50;
neta("jpn")=1.00;
neta("can")=0.40;
neta("rus")=0.25;
neta("roe")=0.25;
neta("asi")=0.60;
neta("chn")=0.60;
neta("ind")=0.60;
neta("rea")=0.85;

nshare(r)$n_e0(r) = n_r0(r)/( (1-td(r,"elec"))*n_e0(r));
sigma(r)$(1-nshare(r)) = neta(r)*nshare(r)/(1-nshare(r)); 

* Allow higher nuclear to enter relative to the base year level in IDZ, since the base year nuclear output in IDZ is extremely low.
* sigma is the fixed factor elasticity that controls the nuclear penetration. (YHC: 20131112)
*sigma("idz") = sigma("idz")*4;



heta(r)=0.5;
heta("jpn")=0.25;
heta("anz")=0.25;
heta(ldc)=0.75;
heta("ind")=0.95;

hshare(r)$h_e0(r) = h_r0(r)/( (1-td(r,"elec"))*h_e0(r));
hsigma(r)$(1-hshare(r)) = heta(r)*hshare(r)/(1-hshare(r)); 

display sigma,hsigma;

*	Adjust aggregate capital stock to accomodate the resource supply for the 
*   nuclear and hydro sectors:
*$ontext
kapital(r) = kapital(r) - (n_r0(r)+h_r0(r));
*$offtext

parameter wsigma(r) Elasticity of substitution for wind generation
/usa	0.05
can	0.04
mex	0.03
jpn	0.05
eur	0.04
anz	0.04
roe	0.04
rus	0.04
asi	0.02
chn	0.05
ind	0.06
bra	0.03
afr	0.02
mes	0.02
lam	0.04
rea	0.05/;

* Market size of wind, solar, and biomass:
parameter rsize(r) market size in 2010 /
*usa	0.07
usa     0.001
can	0.002
mex	0.002
jpn	0.004
anz	0.002
eur	0.001
roe	0.006
rus	0.001
asi	0.006
chn	0.007
ind	0.002
bra	0.002
afr	0.001
mes	0.002
lam	0.001
rea	0.002

kor     0.06
idz     0.06

/;

parameter fps(r,e) fossil power structure;

fps(r,e) = pi0(e,"elec",r)*(xdp0(r,e,"elec")+xmp0(r,e,"elec"))/
           sum(e1,pi0(e1,"elec",r)*(xdp0(r,e1,"elec")+xmp0(r,e1,"elec")));


