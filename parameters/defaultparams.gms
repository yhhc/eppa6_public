* AGRI is handled differently, which might be wrong, but Sergey was going to look into it (11 Aug 2005)
ELASAGRI = 0.3;

* Always include this value;  not defined in a table
ELASHTRN = 0.4;



* ----------------------------------------------------------------------------
*  Vintaging defaults (fraction of capital stock fixed)
* ----------------------------------------------------------------------------
* These values are delcared in eppaparams.gms.  They are modified
* in the coll files by overriding the values.
*
*       Assume that vintaging is carried throughout the horizon:
*

THETA0(G,R)      = 0.3;
THETA0("elec",R) = 0.7;
THETA(G,T)       = 0.3;
THETA("elec",T)  = 0.7;
THETAB(VBT,T)    = 0.7;
VBMALSHR         = 0;

* ----------------------------------------------------------------------------
*  Methane initial inventories by sector
* ----------------------------------------------------------------------------
* These values are used in kyotogas_aaa.gms.  They are modified
* in the coll files by overriding the values.
*
* Typical usage:  ghginv("AGRI",ch4,r)= ghginv("AGRI",ch4,r)*UNCCH4INDUSTRY("AGRI");
*
UNCCH4INDUSTRY(AGRI) = 1;
UNCCH4INDUSTRY("COAL") = 1;
UNCCH4INDUSTRY("GAS") = 1;
UNCCH4INDUSTRY("OIL") = 1;
UNCCH4INDUSTRY("EINT") = 1;
UNCCH4INDUSTRY("LANDFILL") = 1;
UNCCH4INDUSTRY("DSEWAGE") = 1;
UNCCH4INDUSTRY("OTHR") = 1;
UNCCH4INDUSTRY("FD") = 1;
UNCCH4INDUSTRY("FOOD") = 1;


* ----------------------------------------------------------------------------
*  Labor productivity growth
* ----------------------------------------------------------------------------
* These values are delcared in a in eppatrend.gms.  They are modified
* in the coll files by overriding the values.
*



* ----------------------------------------------------------------------------
*  Markup for backstop technologies
* ----------------------------------------------------------------------------
* These values are used in eppaback.gms.  They are modified
* in the coll files by overriding the values.
*
* Typical usage:  BADJST("IGCAP","MEX") = 3.00*UNCCAP("IGCAP")/1.18;
*
UNCMARKUP("IGCAP") = 1.18;
UNCMARKUP("NGCAP") = 1.15;
UNCMARKUP("NGCC") = 0.90;
UNCMARKUP("BIO-OIL") = 3.8;
UNCMARKUP("BIOELEC") = 3.8;
UNCMARKUP("SYNF-OIL") = 2.8;
UNCMARKUP("SYNF-GAS") = 3.5;


