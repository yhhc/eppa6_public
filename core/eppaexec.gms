$ontext

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
EPPA 6.0 
Emission Prediction and Policy Analysis (EPPA) Model
.
Massachusetts Institute of Technology
.
http://globalchange.mit.edu
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&



$offtext

*	Set the current time index here as a global environment
*	variable.  It is then carried forward to the loop through
*	the restart file:

$setglobal nper 0

* This file indicates the sequence of execution of the EPPA model. Actual
* execution is controlled by a DOS batch command: "commandfile.bat".

$if %system.filesys% == MSNT $set isUncertainty 0
$ifthen %system.filesys% == UNIX 
$set paramdir ../parameters/
$set datadir ../data/
$else
$set paramdir ..\parameters\
$set datadir ..\data\
$endif



* Sets
$include %paramdir%eppaset.gms

* Economic Data 
$include readgtap.gms

* Check initial balances
$include eppabench.gms

* Parameters for static model (Now include defaultparams.gms in EPPA 5)
* Include the defaultparams always and then override them if %isUncertainty%  (see below)
$include %paramdir%eppaparm.gms

* Parameters for dynamic loop
$include %paramdir%eppacoef.gms

* Include the defaultparams always and then override them if %isUncertainty%  (see below)
*$include %paramdir%defaultparams.gms

* Elasticities
$include %paramdir%eppaelas.gms

* Backstop technologies
$include %paramdir%eppaback.gms

* BAU trends
$include %paramdir%eppatrend.gms
*$include %paramdir%eppatrend_updated.gms

* GHG Inventories and Trends
$include %paramdir%eppaghg.gms

* Parameters for household transport
* $include %paramdir%eppa_htrn.gms

* Divide nuclear and hydro
$include elecpower.gms

* Uncertainty Modification * -UNC-
* $include %paramdir%defaultLPGparams.gms   (Not used right now)
$if %isUncertainty% == 1 $include ../uncertainty/input/coll%runNumber%.gms

* Last static model calibration
$include eppacalib.gms

* Static Model
$include eppacore.gms

