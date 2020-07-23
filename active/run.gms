$title	CONTROL SCRIPT FOR EPPA --- GAMS Code

*	EPPA root directory -- must match file system and have a terminal
*	slash/backslash:

$ifthen %system.filesys%==UNIX 

$set eppaorg ../

$else

$set eppaorg ..\

$endif

$if not set eppaout $set eppaout %eppaorg%

*	Verify that the EPPA root directory exists

$if not dexist "%eppaorg%"       $abort Cannot find EPPA root directory "%eppaorg%".
$if not dexist "%eppaorg%active" $abort Cannot find EPPA active directory "%eppaorg%active".

$set cdir %eppaorg%core
$if not dexist "%cdir%"   $abort Cannot find EPPA core directory "%cdir%".

*	Create listing, log and restart directories if they do not exist:

*	Output directories are created here:

$if not dexist "%eppaout%"		$call mkdir "%eppaout%"
$if not dexist "%eppaout%restart"	$call mkdir "%eppaout%restart"
$if not dexist "%eppaout%lst"		$call mkdir "%eppaout%lst"
$if not dexist "%eppaout%logs"		$call mkdir "%eppaout%logs"
$if not dexist "%eppaout%results"	$call mkdir "%eppaout%results"
*$if not dexist "%eppaout%gdx"		$call mkdir "%eppaout%gdx"
$if not dexist "%eppaout%savepoint"     $call mkdir "%eppaout%savepoint"

*	Case name:

$if not set csnm	$set csnm	v-ref

*       Populaiton growth:

$if not set popg        $set popg       p0

*       Productivity growth:

$if not set prog        $set prog       r0

*       Real GDP growth:

$if not set gdpg        $set gdpg       m

*       AEEI growth:

$if not set aeeg        $set aeeg       m

*       Elasticity of substitution for energy use:

$if not set sekl        $set sekl       m

*	Save file identifier: 

$if not set jid	        $set jid	%csnm%

*	Starting and stopping periods:

$if not set start  $set start  2007
$if not set stop   $set stop   2100
$eval nsolve max(0,%stop%-%start%+1)

$if %nsolve%==0 $abort "Times start=%start% and stop=%stop% are inconsistent";

$ifthen %system.filesys%==UNIX 

*	Unix File Separator:

$set rrdir "%eppaout%results/"
$set rdir "%eppaout%results/%csnm%/"
*COV added csv folder
$set rdirc "%eppaout%results/%csnm%/csv"
$set sdir "%eppaout%savepoint/%csnm%/"
$if not exist "%eppaorg%active/%csnm%.cas"	$abort "Cannot find %eppaorg%active/%csnm%.cas"
$echo $include %eppaorg%active/%csnm%.cas	>%cdir%/%csnm%.cas
$set listfile %eppaout%lst/%csnm%
$set savefile %eppaout%restart/%csnm%
$set logfile  %eppaout%logs/%csnm%
$set gdxfile  %eppaout%results/%csnm%/
$set corefile %eppaout%core/

*COV added csv folder
$if not dexist "%rdirc%" $call mkdir "%rdirc%"

$else

*	Windows File Separator:

$set rrdir "%eppaout%results\"
$set rdir "%eppaout%results\%csnm%\"
*COV added csv folder
$set rdirc "%eppaout%results\%csnm%\csv"
$set sdir "%eppaout%savepoint\%csnm%\"
$if not exist "%eppaorg%active\%csnm%.cas"	$abort "Cannot find %eppaorg%active\%csnm%.cas"
$echo $include %eppaorg%active\%csnm%.cas	>%cdir%\%csnm%.cas
$set listfile %eppaout%lst\%csnm%
$set savefile %eppaout%restart\%csnm%
$set logfile  %eppaout%logs\%csnm%
$set gdxfile  %eppaout%results\%csnm%\
$set corefile %eppaout%core\

$endif

$if not dexist "%rdir%"	$call mkdir "%rdir%"
$if not dexist "%sdir%"	$call mkdir "%sdir%"

set	t	Periods in the model 
	/2007,
	 2010,2015,2020,2025,2030,2035,2040,2045,2050,2055,
	 2060,2065,2070,2075,2080,2085,2090,2095,2100/,

	run(t)	Periods to run;

run(t) = yes$(t.val>=%start% and t.val<=%stop%);

*DJR edit for UNIX vs. WIN differences

$ifthen %system.filesys%==UNIX

*Unix commandfile name format
*COV added line for bash file and commented line for bat file
file commandfile /commandfile.sh/; commandfile.lw = 0; commandfile.nw = 0; commandfile.nd = 0; put commandfile;

$else

*Windows commandfile name format
*file	commandfile /commandfile_%csnm%_%popg%_%prog%_%gdpg%_%aeeg%_%sekl%.bat/;  commandfile.lw=0; commandfile.nw=0; commandfile.nd=0; put commandfile;
file	commandfile /commandfile.bat/;  commandfile.lw=0; commandfile.nw=0; commandfile.nd=0; put commandfile;
*file	commandfile /commandfile_%csnm%.bat/;  commandfile.lw=0; commandfile.nw=0; commandfile.nd=0; put commandfile;

$endif

commandfile.pw = 4048;

$set cmdexec 
$set cmdloop 

parameter	nrun	Number of runs,
		irun	Current run;

nrun = card(run);
irun = 1;

*	If the start year is 2007 we start there:

$ifthen.a %system.filesys%==UNIX

*Unix commandfile.sh version
put '#!/bin/bash'/;

*put 'if [ -z "$1" ] ; then'/
*    'mono=1'/
*    'fi'/;

$ifthen.b %start%==2007
  irun = irun + 1;
  nrun = nrun + 1;
  put   '#:bmk'/;
  put 	'echo Running %csnm% benchmark year 1 of ',nrun,''/
	'gams eppaexec cdir="%cdir%" o=%listfile%bmk.lst --rdir="%rdir%" --sdir="%sdir%"',
	  ' s=%savefile%bmk gdx=%gdxfile%bmk lo=3 | tee %logfile%bmk.log'/;
*  put 'if [ $? -ne 0 ]; then'/
*       'exit 1'/
*       'fi'/;
*  put 'if [ -z "$1" ] ; then'/
*       'exit 1'/
*       'fi'/;       
*        'if errorlevel 1 goto end'/;

$endif.b

loop(run(t),
  put   /'#:',t.tl/;
  if (t.val=2007,
    put 'echo Running %csnm%, year ',t.tl,' ',irun,' of ',nrun,''/
        'echo \$setglobal csnm %csnm% > %corefile%global.inc'/
        'echo \$setglobal stop %stop% >> %corefile%global.inc'/
        'echo \$setglobal mono %'1' >> %corefile%global.inc'/
        'echo \$setglobal popg %popg% >> %corefile%global.inc'/
        'echo \$setglobal prog %prog% >> %corefile%global.inc'/
        'echo \$setglobal gdpg %gdpg% >> %corefile%global.inc'/
        'echo \$setglobal aeeg %aeeg% >> %corefile%global.inc'/
        'echo \$setglobal sekl %sekl% >> %corefile%global.inc'/      
        'echo \$setglobal rrdir %rrdir% >> %corefile%global.inc'/
	    'gams eppaloop cdir="%cdir%" o=%listfile%',t.tl,'_%popg%_%prog%_gdpg-%gdpg%_aeeg-%aeeg%_sekl-%sekl%.lst s=%savefile%',t.tl,' --rdir="%rdir%" --sdir="%sdir%"',
	    ' gdx=%gdxfile%',t.tl,' r=%savefile%bmk lo=3 | tee %logfile%',t.tl,'.log'/;

  else
    put 'echo Running %csnm%, year ',t.tl,' ',irun,' of ',nrun,''/
	'echo \$setglobal csnm %csnm% > %corefile%global.inc'/
        'echo \$setglobal stop %stop% >> %corefile%global.inc'/
        'echo \$setglobal mono %'1' >> %corefile%global.inc'/
        'echo \$setglobal popg %popg% >> %corefile%global.inc'/
        'echo \$setglobal prog %prog% >> %corefile%global.inc'/
        'echo \$setglobal gdpg %gdpg% >> %corefile%global.inc'/
        'echo \$setglobal aeeg %aeeg% >> %corefile%global.inc'/
        'echo \$setglobal sekl %sekl% >> %corefile%global.inc'/      
        'echo \$setglobal rrdir %rrdir% >> %corefile%global.inc'/
	    'gams eppaloop cdir="%cdir%" o=%listfile%',t.tl,'_%popg%_%prog%_gdpg-%gdpg%_aeeg-%aeeg%_sekl-%sekl%.lst s=%savefile%',t.tl,' --rdir="%rdir%" --sdir="%sdir%"',
	    ' gdx=%gdxfile%',t.tl,' r=%savefile%',t.te(t-1),' lo=3 | tee %logfile%',t.tl,'.log'/;);
*	put 'if [ $? -ne 0 ]; then'/
*       'exit 1'/
*       'fi'/;      	    
*        'if errorlevel 1 goto end'/;);
  irun = irun + 1;
*  put 'if [ -z "$1" ] ; then'/
*       'exit 1'/
*       'fi'/;
*  put 'if not "%','1"=="" goto end'/;
);

*put 'python mergeCVSpython.py'/

putclose ' #:end'/; 


$else.a

*Windows commandfile.bat version

put '@echo off'/;

put 'if not "%','1"=="" goto %','1'/;

$ifthen.c %start%==2007
  irun = irun + 1;
  nrun = nrun + 1;
  put   ':bmk'/;
  put 	'title Running %csnm% benchmark year (1 of ',nrun,')'/
	'gams eppaexec cdir="%cdir%" o=%listfile%bmk.lst --rdir="%rdir%" --sdir="%sdir%"',
	  ' s=%savefile%bmk gdx=%gdxfile%bmk lo=3 | tee %logfile%bmk.log'/
        'if errorlevel 1 goto end'/;
  put 'if not "%','1"=="" goto end'/;
$endif.c

loop(run(t),
  put   /':',t.tl/;
  if (t.val=2007,
    put 'title Running %csnm%, year ',t.tl,' (',irun,' of ',nrun,')'/
        'echo $setglobal csnm %csnm% > %corefile%global.inc'/
        'echo $setglobal stop %stop% >> %corefile%global.inc'/
*        'echo $setglobal mono %'1' >> %corefile%global.inc'/
        'echo $setglobal popg %popg% >> %corefile%global.inc'/
        'echo $setglobal prog %prog% >> %corefile%global.inc'/
        'echo $setglobal gdpg %gdpg% >> %corefile%global.inc'/
        'echo $setglobal aeeg %aeeg% >> %corefile%global.inc'/
        'echo $setglobal sekl %sekl% >> %corefile%global.inc'/      
        'echo $setglobal rrdir %rrdir% >> %corefile%global.inc'/
	'gams eppaloop cdir="%cdir%" o=%listfile%',t.tl,'_%popg%_%prog%_gdpg-%gdpg%_aeeg-%aeeg%_sekl-%sekl%.lst s=%savefile%',t.tl,' --rdir="%rdir%" --sdir="%sdir%"',
	  ' gdx=%gdxfile%',t.tl,' r=%savefile%bmk lo=3 | tee %logfile%',t.tl,'.log'/
	'if errorlevel 1 goto end'/;
  else
    put 'title Running %csnm%, year ',t.tl,' (',irun,' of ',nrun,')'/
	'echo $setglobal csnm %csnm% > %corefile%global.inc'/
        'echo $setglobal stop %stop% >> %corefile%global.inc'/
*        'echo $setglobal mono %'1' >> %corefile%global.inc'/
        'echo $setglobal popg %popg% >> %corefile%global.inc'/
        'echo $setglobal prog %prog% >> %corefile%global.inc'/
        'echo $setglobal gdpg %gdpg% >> %corefile%global.inc'/
        'echo $setglobal aeeg %aeeg% >> %corefile%global.inc'/
        'echo $setglobal sekl %sekl% >> %corefile%global.inc'/      
        'echo $setglobal rrdir %rrdir% >> %corefile%global.inc'/
	'gams eppaloop cdir="%cdir%" o=%listfile%',t.tl,'_%popg%_%prog%_gdpg-%gdpg%_aeeg-%aeeg%_sekl-%sekl%.lst s=%savefile%',t.tl,' --rdir="%rdir%" --sdir="%sdir%"',
	  ' gdx=%gdxfile%',t.tl,' r=%savefile%',t.te(t-1),' lo=3 | tee %logfile%',t.tl,'.log'/
        'if errorlevel 1 goto end'/;);
  irun = irun + 1;
  put 'if not "%','1"=="" goto end'/;
);

putclose ':end'/; 

$endif.a
