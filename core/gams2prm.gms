$if not setglobal debug $offlisting offinclude

$hidden   Updated 9/97 (tfr)

*       Skip compilation is there is a pre-existing program error:

$if not errorfree $exit

$version 86

$hidden  gams2prm.gms    Data export to GAMS-readable format (with declaration)
$hidden
$hidden  $...include gams2prm id (name) [description]
$hidden
$hIDDEN  Works for parameters, variables, equations and sets
$hidden
$hidden  First invocation must be outside of a loop or if block.
$hidden
$hidden  Use a blank invocation (without an id) to initialize.
$hidden
$hidden  Output name required for variables or equations, both of
$hidden  which must be specified as level values (.L) or marginals (.M)
$hidden 
$hidden  See gams2txt.gms for a more extensive description of 
$hidden  how global environment variables "epsilon", "zeros" and 
$hidden  "prefix" can control the output.
$hidden 

$if not "%1" == "" $goto start
$if not exist ..\inclib\gams2txt $libinclude gams2txt
$if     exist ..\inclib\gams2txt $batinclude ..\inclib\gams2txt
$exit

$label start

*       See that the item is declared and defined:

$if declared %1    $goto declared
$error Error in gams2prm: identfier %1 is undeclared.
$exit

$label declared
$if defined %1     $goto defined
$error Error in gams2prm: identfier %1 is undefined.
$exit

$label defined

*       Variables and equations are passed as level values
*       or marginals -- we need to handle these differently
*       because we cannot automatically generate output 
*       names and titles:

$if     "%2" == "" $set name %1
$if not "%2" == "" $set name %2
$if not "%3" == "" $set title "'%3'"

$if vartype %1  $goto varequ
$if equtype %1  $goto varequ
$if     "%3" == "" $set title %1.ts
$goto output

$label varequ
$if     "%3" == "" $set title '" "'
$if not a%2 == a $goto output
$error Error in gams2prm: output name required for %1 (variable or equation)
$exit

$label output

$if dimension 0 %1 $goto scalar
$if     settype %1 put 'set %name% ',%title%,'/'/;
$if not settype %1 put 'parameter %name% ',%title%,'/'/;
$goto write

$label scalar
$if     settype %1 put 'set %name% ',%title%,'/'/;
$if not settype %1 put 'scalar %name% ',%title%,'/'/;

$label write
$setargs args

$if not setglobal timestamp $setglobal timestamp yes

$if not %timestamp%==yes $goto gams2txt

put "*=>gams2prm %args%"/;
put "* Called from %system.incparent%, line %system.line%"/;
put "* %system.date% %system.time%"/;

$label gams2txt

$setglobal gams2prm 'yes'
$if not exist ..\inclib\gams2txt.gms $libinclude gams2txt %1
$if     exist ..\inclib\gams2txt.gms $batinclude ..\inclib\gams2txt %1
put '/;'/;
$setglobal gams2prm
