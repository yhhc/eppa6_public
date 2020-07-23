* eppacoef.gms

*  This file defines parameters needed for intertemporal updating
*  and report writing. (Declaration is not allowed inside dynamic
*  loop). As a result, all parameters here have the time dimension.                                       


* Some capital formation definitions

PARAMETERS

        HOUSAV(R,T)             Household saving
        DEPRY(R,T)              Depreciation allowance
        NEWCAP(R,T)             New capital
        TOTALCAP(R,T)           Total malleable capital   
        ;


* Some energy and carbon statistics.

PARAMETERS

        EEI(G,E,R,T)            Energy demand by production sectors (in heat unit)
        EEIB(bt,E,R,T)          Energy demand by production sectors with backstops (in heat unit)
        EECI(E,R,T)             Energy demand by consumption sectors
        EVEI(E,G,R,T)		Energy demand by industrial sector, by fuel
	TEECI(E,R,T)		Transport energy demand by households in EJ (by energy)
        EEII(G,R,T)             Total energy demand by production (sum over energy types)
        EEIB(bt,E,R,T)           Energy demand by production sectors with backstops (in heat unit)
        EECII(R,T)              Total energy demand by consumption
        PFEECII(E,R,T)          Disaggregated household energy demand
        HOMDD(X,R,T)            Homogenous goods production        
        DHOM(X,R,T)             Homogenous goods consumption
	homex(x,r,t)            homogenous goods exports
	homim(x,r,t)            homogenous goods imports
        CEEI(G,E,R,T)           CO2 emission by fuel, from production sector
        CEEIB(G,E,R,T)          CO2 emission by fuel with backstops, from production sector
        CEECI(E,R,T)            CO2 emission by fuel, from consumption sector
        CEEGI(E,R,T)            CO2 emission by fuel, from government
        CEEVI(E,R,T)            CO2 emission by fuel, from investment
        EIMFLOW(R,E,T)          Energy import, by type
        EEXFLOW(R,E,T)          Energy export, by type
        GLAS(X,R,T)             GAS FIXED FACTOR DEMAND ST ELASTICITY
        EE(R,E,T)               Energy consumption in exajoules
        ee_sector(r,e,g,t)      energy consumption in exajoules by sector
        energy_htrn(r,t)        Energy consumption by household transport in EJ
        ENCROP(BT,R,T)		CONSUMPTION OF ENERGY BY ENERGY CROPS PRODUCTION
        CO2F(R,E,T)             CO2 emissions by energy type by region (million-ton CO2)
        CO2FB(R,E,T)            CO2 emissions from backstop by region 
        TOTCO2(R,T)             Total CO2 emissions in region R (million-ton CO2)
        ;

* Some regional aggregates for reporting

PARAMETERS

        AYA(R,T)                Aggregate output (in current value term)
        ACA(R,T)                Aggregate consumption (in current value)
        AKA(R,T)                Capital supplies (quantities)
        ALA(R,T)                Labor supplies (in efficient unit)
        AFA(I,R,T)              Fixed factor supplies
        AGA(R,T)                Total government expenditure (in current value)
        AIA(R,T)                Total investment (in current value)
        AXA(R,T)                exports (in current value)
        ama(r,t)                imports (in current value)
        ACCA(r,i,T)             Consumption by good (quantities)
        AIIA(R,T)               Investment (quantities)
        AGGA(R,T)               Government expenditure (quantities)
        AIGNP(R,T)              GNP from income side
        AGNP(R,T)               GNP from expenditure side
        rgdp_t(r,t)             real GDP of region r in t
        AGNPPC(R,T)             GNP from expenditure side, per capita
        AEEA(R,T)               Total energy consumption        
        NETFLOW(R,G,T)          Net import flow
        TOT(R,T)                Barter terms of trades
        IMFLOW(R,G,T)           Import flow
        EXFLOW(R,G,T)           Export flow    
       
        d_t(g,r,t)              domestic production index by t
        dv_t(g,v,r,t)           domestic vintage production index by t
        d_dv_t(g,r,t)           total domestic production index by t
        n_e_t(r,t)              nuclear electricity generation by t
        h_e_t(r,t)              hydro electricity generation by t           
        outd_t(g,r,t)           domestic production by t
        en_t(g,r,t)             energy inputs to production by t
        a_t(g,r,t)              Armington good by t

        ;


AYA(R,T)     = 0;
d_t(g,r,t)   = 0;
dv_t(g,v,r,t)= 0;
d_dv_t(g,r,t)= 0;
n_e_t(r,t)   = 0;
h_e_t(r,t)   = 0;
en_t(g,r,t)  = 0;

* Some world statistics (sum over regional reporting variables)

PARAMETERS

        WYW(T)                  World output 
        WCW(T)                  World comsumption
        WKW(T)                  World capital
        WLW(T)                  World labor
        WEEW(T)                 World energy      
        WEW(T)                  World CO2 emissions
        WfW(T)                  World fossil CO2 emissions
        E_OECD(T)               OECD CO2 emissions
        E_REST(T)               Rest of the world CO2 emissions 
        woil(t)                 international price of oil
        wgas(t)                 international price of gas
        wcoal(t)                international price of coal
        ;

* Some price statistics (simply passes p.l to a variable by t)


PARAMETERS

        OPO(R,T)                International oil price
        GPG(R,T)                International gas price
        DPD(G,R,T)              Domestic price of production good
        APA(G,R,T)              Armington price of production good
        apa_htrn(r,t)           Armington price of HH transportation
* VJK
	APAL(G,R,T)		for calculating the level of PA.l	
	DPDL(G,R,T)		for calulaating the level of PD.l
* end VJK

	APAI_C(G,e,R,T)         INPUT PRICE GROSS OF CARBON TAX by period -- INTERMEDIATE (divided by pu)
	APAF_C(G,R,T)           INPUT PRICE GROSS OF CARBON TAX by period -- final (divided by pu)
        CPC(I,R,T)              Price of Armington good
        PIIP(R,T)               Price of investment output
        PGGP(R,T)               Price of government output
        FPB(G,R,T)              Fixed factor price
        FPT(Grt,R,T)            Fixed factor price for gas by resource type
        FPVT(Grt,R,T)           Fixed factor price for gas by resource type for new vintage
        NFP(R,T)                Fixed factor price for nuclear production
        HFP(R,T)                Fixed factor price for hydro production
        KPB(R,T)                Capital price
        LPB(R,T)                Labor price
        utp(r,t)                consumption price index by period
        kpb_v(g,v,r,t)          Vintaged capital price        
        v_k_t(g,v,r,t)          Vintaged capital stock by period
        kpbb_v(bt,v,r,t)        Vintaged capital price in backstop sector by period
        vb_k_t(bt,v,r,t)        Vintaged capital stock in backstop sector by period

* Some sectoral statistics

        LB(r,g,T)               Sectoral labor demand 
        LBG(R,T)                Government labor demand 
        AAI(G,NE,R,T)           Armington intermediate input fpr extant production
        aai_v(g,ne,v,r,t)       Armington intermediate input for vintage production
        aai_total(g,ne,r,t)     Armington intermediate input for total production
        WIDX(R,T)               Welfare index
        WIDX1(R,T)               Welfare index2
        WIDX2(R,T)               Welfare index3
        WIDX3(R,T)               Welfare index4

        CSM(R,T)                Consumption good output
        GSP(G,R,T)              Armington supply
        eouti_t(e,g,r,t)        eouti by time
        eoutf_t(e,r,t)          eoutf by time
        FB(r,g,T)               Fixed factor demand
        KB(r,g,T)               Sectoral capital demand 
        KBG(R,T)                Government capital demand 

        cons_sec(i,r,t)         final consumption by sector and period
        cons_tran(r,t)          household transportation consumption by period
        cons_ener(e,r,t)        final consumption of energy goods (including GHG tax) by sector and period

* Backstop production report is by type:
        BBOUT(G,R,T)            Demand for "solar"
        BB1OUT(G,R,T)           Demand for "synf-oil"
        BB2OUT(G,R,T)           Demand for "H2" 
	BB3OUT(G,R,T)           Demand for "SYNF-GAS" 
	BB4OUT(G,R,T)           Demand for "WIND" 
	BB5OUT(G,R,T)           Demand for "BIOMASS" 

* Total electric generation including backstops
        TELECPRD(R,T)           total electric production in EJ

* Backstop production report is by type:
        BBSOLOUT(R,T)           Demand for "solar"
        BBSOILOUT(G,R,T)        Demand for "synf-oil"
        BBH2OUT(G,R,T)          Demand for "H2"
        BBSGASOUT(G,R,T)        Demand for "SYNF-GAS"
        BBWOUT(R,T)             Demand for "WIND"        
	BBWBIOOUT(R,T)          Demand for "WINDBIO"
	BBWGASOUT(R,T)          Demand for "WINDGAS"
        BBBIOELEOUT(R,T)        Demand for "BIOELEC"
*        BBBIGASOUT(G,R,T)	Demand for "BIO-OIL"
        BBICSOUT(R,T)           Demand for "IGCAP"
        bbigout(r,t)            Demand for "IGCC"
        BBNCSOUT(R,T)           Demand for "NGCAP"
        BBNGOUT(R,T)            Demand for "NGCC"
	BBIOFUELOUT(BT,G,R,T)	Demand for "BIOFUEL"

        bio_ex(r,t)             net exports of biofuels by period
        bio_im(r,t)             net imports of biofuels by period
        bio_exq(r,t)            bio_ex times ej_use over euse
        bio_imq(r,t)            bio_im times ej_use over euse
        e_aai(g,e,r,t)          EI by period
        e_acca(e,r,t)           ECI by period
        agy(g,r,t)              domestic output
        coal_gas(r,t)           coal input in coal gasification
        roil_inp(r,t)           EI times eind over eusep          
        ele_eff(r,t)            electric efficiency
        tot_eff(t)              total efficiency
        ele_pe(r,t)             electric efficiency for primary equivalent conversion
        bbadvnucl_bout(r,t)     advanced nuclear output
        elsnucl(r,t)            share of conventional nuclear generation
        elsadvnucl(r,t)         share of advanced nuclear generation

* Nuclear and hydro electric generation:
        NUCL(R,T)               Nuclear electric output
        HYDR(R,T)               Hydro electric output

* Backstop shares of electricity production
        ELSELEC(R,T)            Share from fossil fuels conventional technology
        ELSNUCL(R,T)            Share from nuclear
        ELSHYDRO(R,T)           Share from hydro
        ELSSOL(R,T)             Share from "solar"
        ELSWIND(R,T)            Share from "wind"
	ELSWINDBIO(R,T)         Share from "windbio"
	ELSWINDGAS(R,T)         Share from "windgas"
        ELSBIOELE(R,T)          Share from "bioelec"
        ELSICS(R,T)             Share from "IGCAP"
        ELSNCS(R,T)             Share from "NGCAP"
        ELSNG(R,T)              Share from "NGCC"

* Electricity production by fossil fuel
	ELECCOAL(R,T)		Electricity generation from coal
        ELECGAS(R,T)            Electricity generation from gas
        ELECOIL(R,T)		Electricity generation from refined oil 

* Backstop efficiencies
        EFFNG(R,T)              Fuel efficiency of "NGCC"
        EFFNCS(R,T)             Fuel efficiency of "NGCAP"
        EFFICS(R,T)             Fuel efficiency of "IGCAP"
        
* Vintaged backstop capital output prices by backstop and region
        PPVBK(BT,V,R,T)         Price of vintaged backstop capital - fixed
        VVBK(BT,V,R,T)          Vintaged backstop capital - fixed 
        PPVBKM(BT,V,R,T)        Price of vintaged backstop capital - malleable
        VVBKM(BT,V,R,T)         Vintaged backstop capital - malleable
        TVBK(BT,R,T)            Total vintaged backstop capital 
        VBBOUT(G,VBT,V,R,T)     Vintaged production
        TVBBOUT(G,VBT,R,T)      Total vintaged production

* Backstop inputs
        ELECCOAL(R,T)           Coal input to conventional electric sector (EJ)
        ELECGAS(R,T)            Gas input to conventional electric sector (EJ)
        ELECOIL(R,T)            Oil input to electric sector (EJ)

* Backstop CO2 emissions
        BCO2(BT,R,T)            Backstop CO2 emissions

* Vintaging share parameters
        VBT_DL(VBT,V,R,T)
        VBT_DK(VBT,V,R,T)
        VBT_DA(VBT,G,V,R,T)
        VBT_DFF(VBT,V,R,T)
	VBT_EM(VBT,V,R,T)	Fraction of carbon not sequestered
* BioFuel value parameters
	CROPPROD(BT,R,T)	CORN PRODUCTION VALUE
	PCCROP(BT,R,T)		PRICE OF CROP
* BioFuel Mandate parameters
	MAN(R,E)		mandate for biofuels
	GMAN(R)		mandate for biofuels 
	ADB(R)
	NORM10(R,E)		Norm for blending biofuels into conventional fuels
	NNORM10(R)
	BBIOFUELF(E,R,T) Transport biofuels products demand by HH
	BBIOFUELI(E,G,R,T) Intermediate biofuels products demand
	T_BBIOFUELF(E,R,T) for checking eu usgoal
	T_TEFD(E,R,T)
	T_TEUSEF(E,R,T)
	T_EIND(E,G,R,T)
	T_EUSEP(E,G,R,T)
	T_RFS_PRICE(R,T)
	T_NORM10_PRICE(R,E,T)
;

MAN(R,E) = NO;
GMAN(R)	= NO;
ADB(R)	= NO;
NORM10(R,E) = NO;
NNORM10(R) = NO;

parameter biott	flag for first gen biofuel trading;

parameter bio1(r) flag for shadow pricing;

parameter bio3(r) flag for shadow pricing in other sectors than household transportation;

biott = 0;
bio1(r) = 0;
bio3(r) = 0;
* BlendWall parameters
parameter BLENDWALL_NUMER, BLENDWALL_DENOM;
BLENDWALL_NUMER(r) = 0.1;
*! ACG (nov 2011): make blendwall region specific and increase it for Brazil
BLENDWALL_NUMER("BRA") = 0.21;
BLENDWALL_DENOM(r) = 1-BLENDWALL_NUMER(r);
               
PARAMETER CAJUST(R,T);

SET     RUN(T)          PERIODS TO RUN RIGHT NOW;
RUN(T)$(ORD(T) EQ 1) = YES;

* Quota Parameters

PARAMETERS
      TCBTAX(R,T)
      CBTAX(R,T)              IMPLICIT CARBON TAX FROM QUOTA (US dollar per ton CO2)
      CTRATE(R,E,T)           cbtax divieded by epslon
      cquota(r,t)             carbon quota (rather than CO2 quota)
      gquota(ghg,r,t)         non-CO2 GHG gases quota
      sgquota(ghg,*,r,t)      non-CO2 GHG gases quota (sectoral)
      scquota(*,r,t)          carbon quota (sectoral)
      uquota(urb,r,t)         non-GHG gases quota
      SCTAX(g,r,t)            Sector specific carbon price
      FCTAX(R,T)              Carbon price for final demand
      GHGPRICE(GHG,R,T)       Shadow price on ghg gases
      urbprice(urb,r,t)       Shadow price on non-ghg gases
      SGHGP(GHG,G,R,T)        Shadow price on ghg -- by sector
      FGHGP(GHG,R,T)          Shadow price on ghg -- final demand
*      cflag(r)		Flag for cement -- deforestation emissions
*      bioquota(r,t)	Biofuel mandate
*      CCQUOTA(R)
      urb_com(urb,g,t,r)       BAU non-ghg emited from energy consumption by sector
      ptarget(t,r)            carbon price target

;

*parameter cquota(r,t), gquota(ghg,r,t), sgquota(ghg,*,r,t), scquota(*,r,t),uquota;

*cflag(r) = 0; 
cquota(r,t) = 0;
gquota(ghg,r,t)=0;
uquota(urb,r,t)=0;
scquota(g,r,t)=0;
scquota("fd",r,t)=0;
sgquota(ghg,g,r,t)=0;
sgquota(ghg,"fd",r,t)=0;
ptarget(t,r) = 0;

* Parameters which were in eppaloop:

parameters

 labor_t(r,t)       labor supply by t
 kapital_t(r,t)     capital stock by t
 ffact_t(i,r,t)     ffact with time dimenstion
 ftfact_t(grt,r,t)  fixed factor supply for gas by type by t
 fvtfact_t(grt,r,t) fixed factor supply for gas by type for new vintage by t
 grg_t(r,t)         government revenue by t
 bres_t(bt,r,t)     backstop resource supply by t
 n_r_t(r,t)         nuclear resource supply by t
 h_r_t(r,t)         hydro resource supply by t
* co2_ref(t,r)       BAU CO2 emissions trajectory

* sco2_ref(t,g,r)   BAU sectoral co2 emissions trajectory
* fco2_ref(t,r)     BAU final demand co2 emissions trajectory
* ftco2_ref(t,r)    BAU final demand co2 emissions trajectory - HH tran

 ftotco2(r,t)      CO2 total from burning fossil fuels
 ctotco2(r,t)      CO2 total from crop sector
 etotco2(r,t)      CO2 total from eint sector

 ddelas(t,r)       top final demand substitution elasticity by period t
 e_prd(i,r,t)      fossil fuel production in EJ
 e_prd_h(r,t)      hydro electricity production in EJ
 e_prd_n(r,t)      nuclear electricity production in EJ

* ressh(grt,r,t)    Output shares by gas resource
 k_o(r,t)          capital to output ratio

 sco2              sectoral CO2 emissions
 fco2(t,r)         final demand CO2 emissions
 ftco2(t,r)        final demand CO2 emissions - HH tran 
 sectem(i,r,t)     sectoral CO2 emissions - from intermediate energy demand
 houem(r,t)        household CO2 emissions - from final energy demand
 htrnem(r,t)       household CO2 emissions - from household transportation

;
 
 labor_t(r,t)         = 0;
 kapital_t(r,t)       = 0;
 ffact_t(i,r,t)       = 0;
 ftfact_t(grt,r,t)    = 0;
 fvtfact_t(grt,r,t)   = 0;
 grg_t(r,t)           = 0;
 bres_t(bt,r,t)       = 0;
 n_r_t(r,t)           = 0;
 h_r_t(r,t)           = 0;
 ftotco2(r,t)        = 0;
 ctotco2(r,t)        = 0;
 etotco2(r,t)        = 0;

 sco2(t,g,r)         = 0;
 fco2(t,r)           = 0;
 ftco2(t,r)          = 0;

 ddelas(t,r)         = 0;
 e_prd(i,r,t)        = 0;
 k_o(r,t)            = 0;

* From eppatrend.gms

Parameters

	POPULATION(R,T)        POPULATION OF REGION R IN YEAR T (million people)
	LSUPPLY(R,T)           LABOR SUPPLY IN EFFICIENCY UNITS
        gpop(r,t)              population growth rate
        dl_t(g,r,t)            quantity of labor service input to d in period t       
        dk_t(g,r,t)            quantity of capital service input to d in period t
        inv_t(r,t)             activity level of inv in period t
        er(*,t,r)              emissions ratio
        ; 

population(r,t) = 0;
lsupply(r,t)    = 0;
gpop(r,t)       = 0;
dl_t(g,r,t)     = 0;
dk_t(g,r,t)     = 0;
inv_t(r,t)      = 0;
er("co2",t,r)   = 1;
er(ghg,t,r)     = 1;
er(urb,t,r)     = 1;

* Emissions

Parameters
chm97co2(*,r,t_chm)       CO2 emissions (MMT) for 1997 
chmco2(*,r,t)       CO2 emissions (MMT)
chm97ghg(*,ghg,r,t_chm)   GHG emissions (MMT) for 1997 
chmghg(*,ghg,r,t)   GHG emissions (MMT)
chm97urb(*,urb,r,t_chm)   Urban Emmissions (mmt) for 1997  
chmurb(*,urb,r,t)   Urban Emmissions (mmt)

chmurb1(*,urb,r,t)  urban emissions (mmt)
chmurb2(*,urb,r,t)  urban emissions (mmt)

*fadj(ff,r,t)    adjustment for fossil fuel current period endowment
;

chmurb1("agr",urb,r,t)   = 0;
chmurb1("n_agr",urb,r,t) = 0;

chmurb2("agr",urb,r,t)   = 0;
chmurb2("n_agr",urb,r,t) = 0;

* QJE: equivalents of above for just eppa5 regions
Parameters
chm97co2_e5(*,r_e5,t_chm)       CO2 emissions (MMT) for 1997 for EPPA5 regions
chmco2_e5(*,r_e5,t)             CO2 emissions (MMT) for EPPA5 regions
chm97ghg_e5(*,ghg,r_e5,t_chm)   GHG emissions (MMT) for 1997 for EPPA5 regions
chmghg_e5(*,ghg,r_e5,t)         GHG emissions for EPPA5 regions (MMT)
chm97urb_e5(*,urb,r_e5,t_chm)   Urban Emmissions (mmt) for 1997 for EPPA5 regions
chmurb_e5(*,urb,r_e5,t)         Urban Emmissions (mmt) for EPPA5 regions
;

parameters
gprod_t(r,t)           tfp productivity index by t
gprod_l_t(r,t)         labor productivity index by t
gprod_k_t(r,t)         capital productivity index by t
gprod_f_t(r,t)         land or fixed factor productivity index by t
bbres(bt,r,t)          BAU backstop resource supply
co2_ref(t,r)           BAU CO2 emissions trajectory (million ton CO2)
ghg_ref(ghg,t,r)       BAU non-CO2 GHG emissions trajectory
urb_ref(urb,t,r)       BAU other emissions trajectory
tghgky(ghg,r,t)	       total kyoto-non-co2 ghg gas emissions (thousand ton)
ghgky(ghg,*,r,t)       kyoto-non-co2 ghg gas emissions

urban(urb,*,r,t)       non-ghg gas emissions
turban(urb,r,t)	       total non-ghg gas emissions
co2eq(r,t)	       total co2 equivalent of ghg (mt)

pcafe_t(r,t)           shadow price for cafe limit by period

;

*! AG (LUC)
parameter	land_agri(r,t)
		land_back(bt,r,t)
		land_tot(r,t)
		land_shra(r,t)
		land_shrb(bt,r,t)
		plandt			land rents in agricultural areas in the benchmark
		pnlandt			land rents in natural areas in the benchmark
		rlandt(r,*,t)		index for land rents from land use (non discounted) 
		rrlandt(r,*,t)		index for land rents from land use 
		rentl(r,*,t)		index for land rents from land endowments and conversion (non discounted)
		rentll(r,*,t)		index for land rents from land endowments and conversion 
		land0(r,*)		land area in the benchmark in Km2
		land_agrii		land area in agriculture - 10 billions of ha	 
		land_agri_		land rents used in agriculture sector ($bi)
		land_back_		land rents used in backstop technologies ($bi)
		land_nat		natural land area - 10 billions of ha
		rentv00			land rents in natural areas
		land_nat_		rents on natural land area use in the welfare function ($bi)
		land_tot_		total land rents ($bi)
		land_shraa		share of total land in agriculture use
		land_shrbb		share of total land in backstop use
		land_shrn		share of total land in natural areas
		land_shra_		share of total land rents in agriculture use
		land_shrb_		share of total land rents in backstop use
		land_shrn_		share of total land rents in natural areas
		land_chg		percent change in agriculture land
		land_shr(*,r,t)		land shares
		land_area(*,r,t)	land areas
		landtot			reescale land totals to display in 1000ha

		landtot_oth		reescale land totals to display in 1000ha
		landarea		reescale land totals to display in 1000ha
		landareat		display global land use by land type

		landall			land area in all regions in 1000 ha

		land_t_o		land transitions
		land_t_i		land transitions
		
		ffactcrop		ffactd crop
		fprodl			land productivity by land use type

		dflt			agricultural land rents
		dfnlt			natural land rents

		lndprdtvt		land productivity for bio-fuels in odt per ha
		bau_defor		store the raw value of land deforestation function

		rp_lnd		report land parameters
		land_em	emissions from land transformation functions
		land_em2	emissions from land transformation functions
		land_emt	total emissions from land
		land_emt2	total emissions from land
		land_emtt	total emissions from land
		land_emtt2	total emissions from land
		land_em3
		bau_landem
		land_seq	carbon sequestration from land transformation functions 
		land_seq2	carbon sequestration from land transformation functions 
		land_seq3	carbon sequestration from land transformation functions 
		land_seq4	carbon sequestration from land transformation functions 

		land_seqt	total carbon sequestration from land transformation functions 
		land_seqtt	total carbon sequestration from land transformation functions 
		outco2_	emissions from land before
		outco2_t	emissions from land before
		emis_rep	emissions report
		emis_rept	emissions report
		
		land_tran	land transitions
		land_trant	land transitions world
		land_tran_	land transitions
		land_tran_d	land areas recomposition from transitions
		
		l_emis                anualized land emissions
		l_sequ                anualized land sequestration
		l_sequ_past		anualized land sequestration trend due to old forest regrowing
		
		cem_def		emissions from cement & deforestation
		def_only		emissions from deforestation only - exogenous trend
		comp_def		compare deforestation emissions
		comp_em		compare total emissions
		
		carbon_	carbon emissions and prices
		carbon_us	carbon emissions and prices
;

parameters 
rgdp_proj       rgdp projection
eta_t           eta with t dimension
eind_adj(e,r,t) adjustment coefficient for eind hefd and tefd
e_adj(*,r,t)    adjustment coefficient for electricity output to match historical IEA data
;

eind_adj(e,r,t) = 1;
*e_adj is initialize in eppatrend

parameters
biofgprod(r,t)    unadjusted 1st generation biofuel output
bbwprod(r,t)      unadjusted wind-pwr output
bbsolprod(r,t)    unadjusted solar-pwr output
bbbioeleprod(r,t) unadjusted bioelec-pwr output
;

biofgprod(r,t)    = 0;
bbwprod(r,t)      = 0;
bbsolprod(r,t)    = 0;
bbbioeleprod(r,t) = 0;

parameter         
rgdpgrowth(r,t)   real GDP growth index relative to previous period
;

rgdpgrowth(r,t)   = 1;

parameters
ghgky_agr0(ghg,r,t)    unadjusted agricultural ghg emissions
ghgky_n_agr0(ghg,r,t)  unadjusted non-agricultural ghg emissions
;

parameters 
lamdae(*,r,t)    aeei coefficient the larger the more efficient
tlimc_t(e,g,r,t) tlimc by t
;

parameters
vshr(g,r,t)      value share of g in region r in period t
xtel(g,r,t)      imputed x consumption with only income changes
ytel(g,r,t)      imputed non-x consumption with only income changes
texp(r,t)        total expenditure in period t
cstar_t(r,g,t)   cstar in period t
xavg(g,r,t)      average x
texpavg(r,t)     average texp
;

cons_sec(g,r,t) = 0;
xtel(g,r,t)     = 0;
ytel(g,r,t)     = 0;
texp(r,t)       = 0;
eta_t(r,g,t)    = 0;
cstar_t(r,g,t)  = 0;
xavg(g,r,t)     = 0;
texpavg(r,t)    = 0;
