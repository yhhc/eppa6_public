* ..\parameters\eppaelas.gms

*This file contains substitution elasticities of CES functions.

SET     LAYER   CES NESTING HIERARCHY

* Top layer Armington (domestic vs foreign bundle):

	/
        SDM    Top layer Armington (domestic vs foreign bundle),
        SMM     Second layer Armington (foreign bundle),
        E_KL    Labor and capital vs energy bundle,
        L_K     labor vs capital,
        NOE_EL  Non-electricity vs electricity (inside energy bundle)
        /;

* Elasticity values for production Sectors.  EPPA4 updated (table 1)

TABLE SELAS(*,layer,r)   INITIAL SUBSTITUTION ELASTICITY MATRIX 

			USA	CAN	MEX	JPN	ANZ	EUR	ROE	RUS	ASI	CHN	IND	BRA	AFR	MES	LAM	REA	KOR	IDZ
CROP	.	SDM	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0
CROP	.	SMM	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0
CROP	.	E_KL	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6
CROP	.	L_K	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
CROP	.	NOE_EL	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
LIVE	.	SDM	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0
LIVE	.	SMM	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0
LIVE	.	E_KL	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6
LIVE	.	L_K	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
LIVE	.	NOE_EL	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
FORS	.	SDM	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0
FORS	.	SMM	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0
FORS	.	E_KL	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6	0.6
FORS	.	L_K	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
FORS	.	NOE_EL	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
FOOD	.	SDM	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0
FOOD	.	SMM	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0
FOOD	.	E_KL	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
FOOD	.	L_K	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
FOOD	.	NOE_EL	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
COAL	.	SDM	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5
COAL	.	SMM	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0
COAL	.	E_KL	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8
COAL	.	L_K	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
COAL	.	NOE_EL	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
OIL	.	SDM	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5
OIL	.	SMM	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0
OIL	.	E_KL	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8
OIL	.	L_K	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
OIL	.	NOE_EL	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
ROIL	.	SDM	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5
ROIL	.	SMM	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0
ROIL	.	E_KL	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8
ROIL	.	L_K	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
ROIL	.	NOE_EL	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
GAS	.	SDM	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5	1.5
GAS	.	SMM	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0
GAS	.	E_KL	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8	0.8
GAS	.	L_K	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
GAS	.	NOE_EL	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
ELEC	.	SDM	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
ELEC	.	SMM	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
ELEC	.	E_KL	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1
ELEC	.	L_K	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
ELEC	.	NOE_EL	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
EINT	.	SDM	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0
EINT	.	SMM	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0
EINT	.	E_KL	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
EINT	.	L_K	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
EINT	.	NOE_EL	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
OTHR	.	SDM	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0
OTHR	.	SMM	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0
OTHR	.	E_KL	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
OTHR	.	L_K	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
OTHR	.	NOE_EL	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
SERV	.	SDM	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0
SERV	.	SMM	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0
SERV	.	E_KL	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
SERV	.	L_K	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
SERV	.	NOE_EL	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
TRAN	.	SDM	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0
TRAN	.	SMM	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0
TRAN	.	E_KL	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
TRAN	.	L_K	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
TRAN	.	NOE_EL	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
DWE	.	SDM	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0	3.0
DWE	.	SMM	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0	5.0
DWE	.	E_KL	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
DWE	.	L_K	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0	1.0
DWE	.	NOE_EL	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5
hh	.	noe_el	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5	0.5

;

selas(g,"noe_el",r)    = selas(g,"noe_el",r)*3; 
selas("hh","noe_el",r) = selas("hh","noe_el",r)*3;

selas(g,"e_kl","usa")  = selas(g,"e_kl","usa")*1.0;
selas(g,"e_kl","can")  = selas(g,"e_kl","can")*1.0; 
selas(g,"e_kl","jpn")  = selas(g,"e_kl","jpn")*1.0; 
selas(g,"e_kl","anz")  = selas(g,"e_kl","anz")*1.0;
selas(g,"e_kl","eur")  = selas(g,"e_kl","eur")*1.0; 
					       	
selas(g,"e_kl","mex")  = selas(g,"e_kl","mex")*1.0;
selas(g,"e_kl","rus")  = selas(g,"e_kl","rus")*1.0; 
selas(g,"e_kl","bra")  = selas(g,"e_kl","bra")*1.0; 
selas(g,"e_kl","chn")  = selas(g,"e_kl","chn")*1.0; 
selas(g,"e_kl","ind")  = selas(g,"e_kl","ind")*1.0;
selas(g,"e_kl","asi")  = selas(g,"e_kl","asi")*1.0;
selas(g,"e_kl","kor")  = selas(g,"e_kl","kor")*1.0;
selas(g,"e_kl","idz")  = selas(g,"e_kl","idz")*1.0; 
					       	
selas(g,"e_kl","roe")  = selas(g,"e_kl","roe")*1.0;
selas(g,"e_kl","afr")  = selas(g,"e_kl","afr")*1.0;
selas(g,"e_kl","mes")  = selas(g,"e_kl","mes")*1.0; 
selas(g,"e_kl","lam")  = selas(g,"e_kl","lam")*1.0;
selas(g,"e_kl","rea")  = selas(g,"e_kl","rea")*1.0; 




*SELAS(r,"elec","sdm") = 3;


* FF supply

table esup(g,r)  fixed factor substitution elasticity

	USA	CAN	MEX	JPN	ANZ	EUR	ROE	RUS	ASI	CHN	IND	BRA	AFR	MES	LAM	REA	KOR	IDZ
CROP	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30
LIVE	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30
FORS	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30
COAL	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50
OIL	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50
GAS	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50	0.50
EINT	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30
OTHR	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30
TRAN	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30
DWE	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30	0.30

;


*esup("oil",devlp)  = esup("oil",devlp)*0.6;
*esup("oil",otg20)  = esup("oil",otg20)*1.5;



* Workshop version:
*esup("gas",r)     = 0.65;
*esup("oil",r)     = 0.38;
*esup("coal",r)    = 0.50;
* Workshop version ends

* Energy bundles.
*	Final demand elasticity between energy and non-energy composites:

parameter delas;
delas = 0.25;

* Elasticity between transport consumption and other consumption in final demand
parameter sigtrn;

*sigtrn = 1.0;
sigtrn = 0.5;

* Define time varying elasticities for final energy demand:
*parameter telas;

*telas(t,"prod") = 0.3+0.3*((1/log(22))*log(ord(t)))**2;
*telas(t,"cond") = 0.2+0.3*((1/log(22))*log(ord(t)))**2;

*	Incorporate Supria estimates of demand elasticity

* Arbitrarily updated to new EPPA4 regions (table 2).

parameter d_elas(r)	top final demand substitution elasticity /
	USA		0.65
	CAN		0.65
	MEX		0.55
	JPN		0.69
	EUR		0.62
	ANZ		0.61
	ROE		0.31
	RUS		0.26
	ASI		0.38
	CHN		0.30
	IND		0.25
	BRA		0.35
	AFR		0.25
	MES		0.32
	LAM		0.41
	REA		0.25 /;

*	Incoroporate commodity-variatnt elasticities
parameter d_elase(r)	substitution among energy, 
		  d_elaso(r)	substitution among otherind and enerint
		  d_elasa(r)	substitution between agriculure and the rest;

d_elase(r)=d_elas(r);
d_elaso(r)=d_elas(r);
d_elasa(r)=d_elas(r);

table ESUBE(*,r) Elasticity of substitution between energy inputs

	USA	CAN	MEX	JPN	ANZ	EUR	ROE	RUS	ASI	CHN	IND	BRA	AFR	MES	LAM	REA	KOR	IDZ
CROP	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1
LIVE	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1
FORS	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1
FOOD	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1
COAL	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1
OIL	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1
ROIL	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1
GAS	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1
ELEC	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1
EINT	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1
OTHR	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1
SERV	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1
TRAN	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1
DWE	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1	1
;


* Elasticities between non-elec and elec in cosumption, investment and 
* government.

SCALARS  NOEEC          /1.0/
         NOEEI          /1.0/
         NOEEG          /1.0/;


SCALAR ESUBG Elasticity in government demand /0.5/;

* Multiple gases:
parameter 
sigc     top level elasticity between energy consumption and gases
siggv    Elasticity of substitution for ghg in vintaged sectors 
sigg     Elasticity of substitution for ghg 
sigg0    Elasticity of substitution for ghg 
sigu     top level transformation elasticity between production and urban gases
pnesta   production sectors nest a substitution elasticity   
enesta   energy input to electricity sector nest a substitution elasticity
tnesta   hh transport substitution elasticity between roil and the rest of own-supplied transport
tnests   hh transport top nest elasticity (between purchased and own-supplied)
;

* Initially gases are model as fixed coefficients:
sigc(ghg,e,r) = 0.05;

* Arbitrarily updated to new EPPA4 regions (table 3).


*	These elasticities are based on fitting MAC curves to EPA data
*	CH4:

sigg("ch4","oil",r)   =0.15;
sigg("ch4","coal",r)  =0.3;
sigg("ch4","eint",r)  =0.11;
sigg("ch4","othr",r)  =0.11;
sigg("ch4","serv",r)  =0.11;
sigg("ch4","tran",r)  =0.11;
sigg("ch4","fd",r)    =0.11;
sigg("ch4","gas",r)   =0.15;
sigg("ch4",agri,"usa")=0.05;
sigg("ch4",agri,"jpn")=0.07;
sigg("ch4",agri,"eur")=0.07;
sigg("ch4",agri,"anz")=0.04;
sigg("ch4",agri,"rus")=0.05;
sigg("ch4",agri,"roe")=0.08;
sigg("ch4",agri,"chn")=0.05;
sigg("ch4",agri,"ind")=0.04;
sigg("ch4",agri,"mex")=0.04;
sigg("ch4",agri,"mes")=0.02;
sigg("ch4",agri,"bra")=0.02;
sigg("ch4",agri,"lam")=0.02;
sigg("ch4",agri,"asi")=0.05;
sigg("ch4",agri,"rea")=0.03;

*	The following elasticity values are based on Jochen work
*	N2O:
sigg("n2o",agri,r)=0.04;
sigg("n2o",agri,oecd)=0.04;
sigg("n2o",agri,ldc)=0.02;
sigg("n2o",agri,"rus")=0.04;
sigg("n2o",agri,"roe")=0.04;
sigg("n2o","coal",r)=0;
sigg("n2o","roil",r)=0;
sigg("n2o","eint",r)=1;
*	PFC:
sigg("pfc","eint",r)=0.3;
sigg("pfc","othr",r)=0.3;
*	HFC:
sigg("hfc","othr",r)=0.15;

*	SF6:
sigg("sf6","eint",r)=0.3;
sigg("sf6","elec",r)=0.3;

* For CCSP - double

sigg("sf6",g,r) = 2*sigg("sf6",g,r);
sigg("pfc",g,r) = 2*sigg("pfc",g,r);
sigg("hfc",g,r) = 4*sigg("hfc",g,r);


*sigg("sf6",g,r) = 2*sigg("sf6",g,r);


sigg0(ghg,g,r)=sigg(ghg,g,r);

*	Vintaged sectors:
*siggv("agri",r) = 0.01;
siggv("eint",r) = 0.15;
siggv("othr",r) = 0.15;
siggv("tran",r) = 0.15;
siggv("elec",r) = 0.1;

sigu(g,r)    = 0;
sigu("fd",r) = 0;

* Define elasticity structure for urban gases:

* black carbon and organic carbon elasticities:
parameter
s_bc(g,r) sectoral elasticity of substitution for black and organic carbon;
s_bc(g,r)=0;
s_bc("eint",r)=0.5;


parameter bsigma(r) Elasticity of substitution for biomass generation;
bsigma(r) = 0.3;

parameter boilsig(r) Fixed factor elasticity for 2nd gen bio-oil;
boilsig(r) = 0.1;

parameter boilffg(r) Fixed factor elasticity for 1st gen bio-oil;
boilffg(r) = 0.1;

* production sector "nest a" elasticities
pnesta(g,r)      = 0;
pnesta(agri,r)   = 0.7;
pnesta("nucl",r) = 0;
pnesta("hydr",r) = 0;

* energy input aggregation for electricity sector "nest a" elasticity
enesta(elec,r)     = 1.5;

* hh transport substitution elasticity between roil and the rest of own-supplied transportation
tnesta(r)      = 1;
tnests(r)      = 0.2;

* Stone-Geary parameters

* see Stone-Geary in eppa6_out
parameter eta(r,g) income elasticity of g;
eta(r,g) = 1;

* Information needed to calculate the income elasticities from AIDADS
* source: worksheet "sum" in implement AIDADS-date.xls
table vdfmplusvifm(irh,i,r)  base year vdfm plus vifm

	                AFR	ANZ	ASI	BRA	CAN	CHN	EUR	 IDZ	IND	JPN	KOR	LAM	MES	MEX	REA	ROE	RUS	USA
1_GrainCrops.crop	129.335	4.361	14.156	13.160	4.709	76.861	113.630	 14.552	72.738	22.874	15.138	29.434	29.856	8.562	19.390	36.451	23.564	49.736
1_GrainCrops.food	6.235	0.290	8.576	6.380	0.046	5.052	2.195	 10.284	25.998	16.352	6.598	5.798	2.791	0.190	16.427	0.726	0.032	1.641
2_MeatDairy.food	37.687	13.107	19.716	33.307	18.465	46.613	352.962	 6.110	21.052	30.449	11.898	60.743	22.443	26.282	7.482	40.145	47.266	162.633
2_MeatDairy.live	25.836	1.670	11.185	5.816	1.338	89.313	25.537	 10.344	57.392	5.285	3.084	11.299	11.753	5.732	36.595	26.121	26.064	10.863
3_OthFoodBev.food	91.940	28.050	37.400	50.052	38.451	160.132	654.941	 29.977	73.801	196.432	40.999	84.644	38.441	74.302	32.833	74.058	41.434	326.583
4_TextAppar.crop	1.621	0.072	0.032	0.001	0.306	0.111	0.962	 0.000	0.000	0.304	0.041	0.308	1.573	0.806	0.275	10.335	0.247	0.141
4_TextAppar.live	0.616	0.023	0.002	0.220	0.026	0.010	0.205	 0.069	3.245	0.010	0.021	0.023	0.348	0.000	0.366	0.669	0.236	0.006
4_TextAppar.othr	50.078	9.626	19.047	29.438	15.301	90.330	418.290	 8.305	38.996	51.536	18.599	42.535	23.908	13.479	15.860	25.740	26.442	220.174
5_HousUtils.coal	0.125	0.003	0.000	0.000	0.002	2.256	0.874	 0.000	0.151	0.000	0.082	0.005	0.002	0.000	0.123	0.594	0.165	0.001
5_HousUtils.elec	13.839	7.840	10.978	10.729	11.245	36.469	146.385	 3.902	15.312	43.041	6.348	11.973	26.975	5.852	12.222	29.205	37.553	128.937
5_HousUtils.gas	        1.236	0.670	0.224	0.051	3.107	0.230	30.478	 0.008	0.206	2.497	2.284	0.866	3.867	0.185	1.905	10.468	5.557	30.075
5_HousUtils.othr	6.601	3.434	6.722	6.160	0.441	14.931	93.383	 0.539	0.902	8.868	1.994	6.962	15.404	0.241	1.055	4.103	12.846	48.231
5_HousUtils.serv	15.022	15.591	17.805	23.522	18.654	19.912	241.195	 1.302	4.053	79.653	17.223	10.077	3.576	3.967	2.978	2.496	2.746	334.181
6_Wrtrade.serv	        73.000	139.475	121.149	118.835	172.322	194.405	1828.207 32.995	99.929	554.039	86.181	147.892	75.460	91.292	19.708	112.742	163.020	1591.745
7_Mnfcs.eint	        44.309	18.661	25.963	42.026	23.855	43.522	508.770	 13.189	21.972	61.312	16.369	50.986	43.099	32.487	13.250	52.638	23.405	330.653
7_Mnfcs.othr	        46.398	33.101	49.796	50.309	57.165	104.374	920.636	 14.194	16.581	136.738	49.424	50.179	68.470	34.486	9.075	67.887	48.163	625.034
8_TransComm.oil	        0.012	0.000	0.000	0.000	0.003	0.000	0.018	 0.000	0.000	0.000	0.000	0.001	0.000	0.000	0.000	0.006	0.000	0.000
8_TransComm.othr	3.263	1.481	2.454	3.624	3.643	8.852	42.041	 4.751	3.436	2.109	0.325	4.446	10.063	2.292	0.638	1.993	1.159	37.691
8_TransComm.roil	22.338	7.499	17.303	10.793	11.601	30.569	137.490	 10.770	25.076	41.347	11.882	16.171	32.018	12.933	7.021	11.708	15.849	151.765
8_TransComm.serv	15.181	14.969	12.101	27.023	21.210	33.408	225.344	 3.723	5.578	65.545	22.654	23.455	17.017	21.048	3.854	13.478	6.522	259.992
8_TransComm.tran	36.428	25.046	35.143	46.235	26.230	45.827	420.021	 13.666	74.816	131.206	24.927	60.253	41.486	70.229	26.752	70.587	50.377	144.941
9_FinService.serv	50.227	31.216	30.481	61.027	93.171	63.386	1744.402 9.020	29.179	75.585	28.157	35.169	42.409	117.562	6.638	47.306	40.290	790.693
10_HousOthServ.dwe	30.890	91.852	54.983	81.196	110.790	61.945	402.997	 52.750	54.589	476.584	62.487	85.792	48.246	0.515	15.799	30.391	0.000	1415.508
10_HousOthServ.serv	68.442	77.650	65.696	118.382	104.658	184.095	922.564	 18.151	54.244	385.244	124.859	109.919	55.757	104.435	31.820	54.060	43.965	3049.351
11_forestry.fors	5.597	0.122	0.111	0.479	0.792	0.533	5.749	 0.269	7.270	1.514	0.346	1.481	0.544	0.952	2.047	1.369	0.051	4.550
;

parameter price(irh,r,t)  Armington price with Reimer-Hertel sectors;
* initial value:
price(irh,r,t) = 1;



parameter finalc        HH aggregated final consumption expenditure in billion US$;
* initial value:
finalc(r,"t0") = sum(i,pc0(i,r)*(xdc0(r,i)+xmc0(r,i)))*10; 
finalc(r,t)    = 0; 

parameter finalcp      per capita HH aggregate final consumption expenditure in thousand US$ divided by 100;
finalcp(r,t)   = 0;


parameters 
u(r,t)            AIDADS utility level
what(irh,r,t)     w hat
xhat(irh,r,t)     x hat
phia(irh,r,t)     phi in the AIDADS system
mbs(irh,r,t)      marginal budget share
elas(irh,r,t)     income elasticity with Reimer-Hertel sector
elastot(irh,r,t)  elas converted from individual to aggregated level
tha(r,t)          correction for income elasticities of other sectors
;

u(r,t)          = 0;

parameter alpha(irh)
/ 
1_GrainCrops    0.084 
2_MeatDairy     0.122 
3_OthFoodBev    0.138 
4_TextAppar     0.068 
5_HousUtils     0.035 
6_WRtrade       0.132 
7_Mnfcs	        0.169
8_TransComm     0.115 
9_FinService    0.030 
10_HousOthServ  0.108
11_forestry     0
/;

parameter beta(irh)
/ 
1_GrainCrops    0.000 
2_MeatDairy     0.026 
3_OthFoodBev    0.032 
4_TextAppar     0.030 
5_HousUtils     0.047 
6_WRtrade       0.238 
7_Mnfcs	        0.099
8_TransComm     0.097 
9_FinService    0.118 
10_HousOthServ  0.313 
11_forestry     0
/;

parameter gamma(irh)
/ 
1_GrainCrops    0.298 
2_MeatDairy     0.000 
3_OthFoodBev    0.142 
4_TextAppar     0.030 
5_HousUtils     0.000 
6_WRtrade       0.078 
7_Mnfcs	        0.002
8_TransComm     0.000 
9_FinService    0.014 
10_HousOthServ  0.086
11_forestry     0
/;

* See worksheet "AIDADS" in eppa6_out.xls
table price07_e4(irh,r)  base year real price levels from EPPA4 with base year 1997

	        USA	CAN	MEX	JPN	ANZ	EUR	ROE	RUS	ASI	CHN	IND	BRA	AFR	MES	LAM	REA	KOR	IDZ
1_GrainCrops	1.026	1.030	1.013	1.000	1.041	1.007	1.060	1.039	1.091	1.046	1.035	1.024	1.001	1.036	1.024	1.044	1.091	1.000
2_MeatDairy	1.026	1.030	1.013	1.000	1.041	1.007	1.060	1.039	1.091	1.046	1.035	1.024	1.001	1.036	1.024	1.044	1.091	1.000
3_OthFoodBev	1.026	1.030	1.013	1.000	1.041	1.007	1.060	1.039	1.091	1.046	1.035	1.024	1.001	1.036	1.024	1.044	1.091	1.000
4_TextAppar	1.026	1.030	1.013	1.000	1.041	1.007	1.060	1.039	1.091	1.046	1.035	1.024	1.001	1.036	1.024	1.044	1.091	1.000
5_HousUtils	1.005	1.021	1.084	1.012	1.004	1.018	1.077	1.000	1.033	1.215	1.067	1.000	1.012	1.089	1.022	1.075	1.033	1.050
6_WRtrade	1.000	1.000	1.000	1.007	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000
7_Mnfcs	        1.003	1.000	1.000	1.000	1.010	1.000	1.002	1.006	1.012	1.002	1.000	1.000	1.011	1.000	1.000	1.007	1.010	1.014
8_TransComm	1.061	1.043	1.040	1.024	1.041	1.032	1.010	1.050	1.065	1.055	1.045	1.036	1.062	1.083	1.049	1.039	1.038	1.096
9_FinService	1.000	1.000	1.000	1.007	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000
10_HousOthServ	1.000	1.000	1.000	1.007	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000	1.000
11_forestry	1.026	1.030	1.013	1.000	1.041	1.007	1.060	1.039	1.091	1.046	1.035	1.024	1.001	1.036	1.024	1.044	1.091	1.000
;

* See worksheet Stone-Geary in eppa6_out.xls
table  usda(r,*)  USDA ICP income elasticities for 2005

	crop	live	food
USA	0.210	0.260	0.346
CAN	0.315	0.369	0.477
MEX	0.440	0.506	0.646
JPN	0.324	0.380	0.492
ANZ	0.380	0.452	0.588
EUR	0.283	0.385	0.503
ROE	0.488	0.563	0.697
RUS	0.443	0.532	0.672
ASI	0.461	0.514	0.641
CHN	0.617	0.654	0.775
IND	0.621	0.660	0.782
BRA	0.517	0.571	0.704
AFR	0.561	0.622	0.752
MES	0.456	0.534	0.666
LAM	0.501	0.562	0.699
REA	0.601	0.644	0.772
KOR	0.428	0.479	0.600
IDZ	0.572	0.621	0.757
;