* This file contains a cluster of put files for model reporting. Each put file
* is organized according reporting subject. Modelers can redesign put files for
* their own convenience.

$if %nper_start% == 0 FILE GNP / '%rdir%gnp.put' /;
*FILE GNP / '%rdir%gnp.put' /;
PUT GNP;
GNP.PW =255;
PUT 'SIMULATION:', @20, SYSTEM.TITLE //;
PUT        'DATE:', @20, SYSTEM.DATE //;
PUT        'TIME:', @20, SYSTEM.TIME //;     

PUT //@20, "GNP ACCOUNTING--b$"//;
LOOP(R, PUT "C", PUT @(ORD(R)*11-4), R.TL:<11);
 LOOP(T, PUT / T.TL:<6;
  LOOP(R, PUT @(ORD(R)*11-6), ACA(R,T):11:4
 )
);

PUT //;
LOOP(R, PUT "I", PUT @(ORD(R)*11-4), R.TL:<11);
 LOOP(T, PUT / T.TL:<6;
  LOOP(R, PUT @(ORD(R)*11-6), AIA(R,T):11:4
 )
);
PUT //;
LOOP(R, PUT "G", PUT @(ORD(R)*11-4), R.TL:<11);
 LOOP(T, PUT / T.TL:<6;
  LOOP(R, PUT @(ORD(R)*11-6), AGA(R,T):11:4
 )
);

PUT //;
LOOP(R, PUT "GNP-E", PUT @(ORD(R)*11-4), R.TL:<11);
 LOOP(T, PUT / T.TL:<6;
  LOOP(R, PUT @(ORD(R)*11-6), AGNP(R,T):11:4
 )
);

PUTCLOSE GNP;
*$ontext
* -------------------------------------------------------------------

$if %nper_start% == 0 FILE ccc / '%rdir%ccc.put' /;;
*FILE ccc / '%rdir%ccc.put' /;
PUT CCC;
CCC.PW = 255;
PUT 'SIMULATION:', @20, SYSTEM.TITLE //;
PUT        'DATE:', @20, SYSTEM.DATE //;
PUT        'TIME:', @20, SYSTEM.TIME //;     
PUT //@20, "CONSUMPTION BY GOODS b$"//;
LOOP(i, PUT // i.TL:<4;
LOOP(R, PUT @(ORD(R)*11-4), R.TL :<11);
 LOOP(T, PUT / T.TL:<6;
  LOOP(R, PUT @(ORD(R)*11-6), ACCA(r,i,T):11:4
  )
 )
);

PUT //@20, "CONSUMER GOODS PRICE"//;
LOOP(i, PUT // i.TL:<4;
LOOP(R, PUT @(ORD(R)*11-4), R.TL:<11);
 LOOP(T, PUT / T.TL:<6;
  LOOP(R, PUT @(ORD(R)*11-6), CPC(i,R,T):11:4
  )
 )
);

PUT //@20, "Non-Energy Consumption"//;
LOOP(i, PUT // i.TL:<4;
LOOP(R, PUT @(ORD(R)*11-4), R.TL:<11);
 LOOP(T, PUT / T.TL:<6;
  LOOP(R, PUT @(ORD(R)*11-6), cons_sec(i,R,T):11:4
  )
 )
);

PUT //@20, "Energy Consumption"//;
LOOP(e, PUT // e.TL:<4;
LOOP(R, PUT @(ORD(R)*11-4), R.TL:<11);
 LOOP(T, PUT / T.TL:<6;
  LOOP(R, PUT @(ORD(R)*11-6), cons_ener(e,R,T):11:4
  )
 )
);

PUT //@20, "Private Transport Consumption"//;
LOOP(R, PUT "trn", PUT @(ORD(R)*11-4), R.TL:<11);
 LOOP(T, PUT / T.TL:<6;
  LOOP(R, PUT @(ORD(R)*11-6), cons_tran(R,T):11:4
 )
);

PUTCLOSE CCC;

* -------------------------------------------------------------------

$if %nper_start% == 0 FILE CHM / '%rdir%chm.put' /;;
*FILE CHM / '%rdir%chm.put' /;;
PUT CHM;
CHM.PW = 255;
PUT 'SIMULATION:', @20, SYSTEM.TITLE //;
PUT        'DATE:', @20, SYSTEM.DATE //;
PUT        'TIME:', @20, SYSTEM.TIME //;     

PUT //@20, "CO2 EMISSIONS BY SECTOR MMT"/;
LOOP(REP, PUT // REP.TL:<4;
LOOP(R, PUT @(ORD(R)*11-4), R.TL:<11);
  LOOP(T_CHM, PUT / T_CHM.TL:<6;
    LOOP(R, PUT @(ORD(R)*11-6), CHM97CO2(REP,R,T_CHM):11:4));
  LOOP(T, PUT / T.TL:<6;
   LOOP(R, PUT @(ORD(R)*11-6), CHMCO2(REP,R,T):11:4
   )
 )
);

PUT //@20, "OTHER GHG EMISSIONS BY SECTOR MMT"/;
LOOP(REP, PUT // REP.TL:<4;
LOOP(R, PUT @(ORD(R)*11-4), R.TL:<11);
 LOOP(GHG, PUT / GHG.TL:<6;
  LOOP(T_CHM, PUT / T_CHM.TL:<6;
    LOOP(R, PUT @(ORD(R)*11-6), CHM97GHG(REP,GHG,R,T_CHM):11:4));
  LOOP(T, PUT / T.TL:<6;
   LOOP(R, PUT @(ORD(R)*11-6), CHMGHG(REP,GHG,R,T):11:4
   )
  )
 )
);

PUT //@20, "NON-GHG EMISSIONS BY SECTOR MMT"/;
LOOP(REP, PUT // REP.TL:<4;
LOOP(R, PUT @(ORD(R)*11-4), R.TL:<11);
 LOOP(URB, PUT / URB.TL:<6;
  LOOP(T_CHM, PUT / T_CHM.TL:<6;
    LOOP(R, PUT @(ORD(R)*11-6), CHM97URB(REP,URB,R,T_CHM):11:4));
  LOOP(T, PUT / T.TL:<6;
   LOOP(R, PUT @(ORD(R)*11-6), CHMURB(REP,URB,R,T):11:4
   )
  )
 )
);
PUTCLOSE CHM;


* -------------------------------------------------------------------


*$if %nper_start% ==  0  FILE CHM_E5 / '%rdir%chm_e5.put' /;

* Use the following line if we want to have put files differ in population and productivity growth:
$if %nper_start% ==  0  FILE CHM_E5 / '%rdir%chm_%csnm%_%popg%_%prog%.put' /;
*FILE CHM_E5 / '%rrdir%chm_e5_%csnm%_%popg%_%prog%.put' /;

* Use the following line if we don't need to have put files differ in population and productivity growth:
*$if %nper_start% ==  0  FILE CHM_E5 / '%rdir%chm_e5_%csnm%.put' /;
*FILE CHM_E5 / '%rrdir%chm_e5_%csnm%.put' /;

PUT CHM_E5;
CHM_E5.PW = 255;
PUT 'SIMULATION:', ' EPPA6 -- JP Outlook & BP Pathways' //;
PUT        'DATE:', @20, SYSTEM.DATE //;
PUT        'TIME:', @20, SYSTEM.TIME //;     

PUT //@20, "CO2 EMISSIONS BY SECTOR MMT"/;
LOOP(REP, PUT // REP.TL:<4;
LOOP(R_E5, PUT @(ORD(R_E5)*11-4), R_E5.TL:<11);
	LOOP(T_CHM, PUT / T_CHM.TL:<6;
		LOOP(R_E5, PUT @(ORD(R_E5)*11-6), CHM97CO2_E5(REP,R_E5,T_CHM):11:4));
	LOOP(T, PUT / T.TL:<6;
		LOOP(R_E5, PUT @(ORD(R_E5)*11-6), CHMCO2_E5(REP,R_E5,T):11:4
		)
	)
);

PUT //@20, "OTHER GHG EMISSIONS BY SECTOR MMT"/;
LOOP(REP, PUT // REP.TL:<4;
LOOP(R_E5, PUT @(ORD(R_E5)*11-4), R_E5.TL:<11);
	LOOP(GHG, PUT / GHG.TL:<6;
		LOOP(T_CHM, PUT / T_CHM.TL:<6;
			LOOP(R_E5, PUT @(ORD(R_E5)*11-6), CHM97GHG_E5(REP,GHG,R_E5,T_CHM):11:4));
		LOOP(T, PUT / T.TL:<6;
			LOOP(R_E5, PUT @(ORD(R_E5)*11-6), CHMGHG_E5(REP,GHG,R_E5,T):11:4
			)
		)
	)
);

PUT //@20, "NON-GHG EMISSIONS BY SECTOR MMT"/;
LOOP(REP, PUT // REP.TL:<4;
LOOP(R_E5, PUT @(ORD(R_E5)*11-4), R_E5.TL:<11);
	LOOP(URB, PUT / URB.TL:<6;
		LOOP(T_CHM, PUT / T_CHM.TL:<6;
			LOOP(R_E5, PUT @(ORD(R_E5)*11-6), CHM97URB_E5(REP,URB,R_E5,T_CHM):11:4));
		LOOP(T, PUT / T.TL:<6;
			LOOP(R_E5, PUT @(ORD(R_E5)*11-6), CHMURB_E5(REP,URB,R_E5,T):11:4
			)
		)
	)
);

PUTCLOSE CHM_E5;

