


#delimit ;
capture program drop basicgini;
program define basicgini, rclass;
syntax varlist(min=2 max=2) [, HSize(varname)];
preserve; 
tokenize `varlist';
tempvar fw;


local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear; 
qui gen `fw'=`hsize';
if ("`hweight'"~="")    qui replace `fw'=`fw'*`hweight';

qui sort `1' ;
tempvar smw smwy l1smwy ca;
gen `smw'  =sum(`fw');
gen `smwy' =sum(`1'*`fw');
gen `l1smwy'=0;
local mu=`smwy'[_N]/`smw'[_N];
local suma=`smw'[_N];
qui count;
forvalues i=2/`r(N)' { ;
qui replace `l1smwy'=`smwy'[`i'-1]  in `i';
};
gen `ca'=`mu'+`1'*((1.0/`smw'[_N])*(2.0*`smw'-`fw')-1.0) - (1.0/`smw'[_N])*(2.0*`l1smwy'+`fw'*`1'); 
sum `ca' [aw=`fw'], meanonly; 
return scalar gini = `r(mean)'/(2*`mu')*100;
/*


**************************/
local xi = `r(mean)';
tempvar vec_a vec_b vec_c vec_d  theta v1 v2 sv1 sv2;
            qui count;
            qui count;
            local fx=0;
            gen `v1'=`fw'*`1';
            gen `v2'=`fw';
            gen `sv1'=sum(`v1');
            gen `sv2'=sum(`v2') ;
            qui replace `v1'=`sv1'[`r(N)']   in 1;
            qui replace `v2'=`sv2'[`r(N)']   in 1;
			qui replace `v1'=`sv1'[`r(N)']-`sv1'[_n-1]   in 2/`=_N'; 
			qui replace `v2'=`sv2'[`r(N)']-`sv2'[_n-1]   in 2/`=_N';
			gen `theta'=`v1'-`v2'*`1';
			qui replace `theta'=`theta'*(2.0/`suma')  in 1/`=_N'; 
			tempvar fxvar;
			qui gen `fxvar'=sum(`fw'*`1');
			local fx = `fxvar'[`=_N']/`suma';
            qui  gen `vec_a' = `hsize'*((1.0)*`ca'+(`1'-`fx')+`theta'-(1.0)*(`xi'));
            qui  gen `vec_b' =  2*`hsize'*`1';
	
cap drop `theta';
cap drop `v1';
cap drop `v2'; 
cap drop `sv1';
cap drop `sv2'; 
			
qui sort `2' ;
tempvar smw smwy l1smwy ca;
gen `smw'  =sum(`fw');
gen `smwy' =sum(`2'*`fw');
gen `l1smwy'=0;
local mu=`smwy'[_N]/`smw'[_N];
local suma=`smw'[_N];
qui count;
qui replace `l1smwy'=`smwy'[_n-1]  in 2/`=_N';
gen `ca'=`mu'+`2'*((1.0/`smw'[_N])*(2.0*`smw'-`fw')-1.0) - (1.0/`smw'[_N])*(2.0*`l1smwy'+`fw'*`2'); 
sum `ca' [aw=`fw'], meanonly; 
*return scalar gini = `r(mean)'/(2*`mu')*100;
local xi = `r(mean)';

            qui count;
            local fx=0;
            gen `v1'=`fw'*`2';
            gen `v2'=`fw';
            gen `sv1'=sum(`v1');
            gen `sv2'=sum(`v2') ;
            qui replace `v1'=`sv1'[`r(N)']   in 1;
            qui replace `v2'=`sv2'[`r(N)']   in 1;
			qui replace `v1'=`sv1'[`r(N)']-`sv1'[_n-1]   in 2/`=_N'; 
			qui replace `v2'=`sv2'[`r(N)']-`sv2'[_n-1]   in 2/`=_N';
			gen `theta'=`v1'-`v2'*`2';
			qui replace `theta'=`theta'*(2.0/`suma')  in 1/`=_N'; 
			tempvar fxvar;
			qui gen `fxvar'=sum(`fw'*`2');
			local fx = `fxvar'[`=_N']/`suma';
            qui  gen `vec_c' = `hsize'*((1.0)*`ca'+(`2'-`fx')+`theta'-(1.0)*(`xi'));
            qui  gen `vec_d' =  2*`hsize'*`2';			
	       
			qui svy: mean `vec_a' `vec_b'  `vec_c'  `vec_d' ;
			qui nlcom (_b[`vec_a']/_b[`vec_b'] - _b[`vec_c']/_b[`vec_d']) , iterate(10000);
				
tempname aa;
matrix `aa'=r(b);
local dif = el(`aa',1,1);
return scalar dif = `dif'*100;

tempname vv;
matrix `vv'=r(V);
local sdif = el(`vv',1,1)^0.5;
return scalar sdif = `sdif'*100;

qui svydes;
local fr=`r(N_units)'-`r(N_strata)';
local tval = `dif'/`sdif';
local pval = 1-2*(normal(abs(`tval'))-0.5);
if `sdif'==0 local pval = 0; 
return scalar pval = `pval';
		
restore;
end;



capture program drop prjobgini;
program define prjobgini, eclass;
version 9.2;
syntax varlist(min=1)[, 
HSize(varname)
HGroup(varname)
AEHS(varname)   
PCEXP(varname)
XRNAMES(string) 
LAN(string) 
];




preserve;

tokenize `varlist';
_nargs    `varlist';
local indica2 = $indica+2;

tempvar total;
qui gen `total'=0;
tempvar Variable EST1 EST11 EST111  EST1111;
qui gen `EST1'=0;
qui gen `EST11'=0;
qui gen `EST111'=0;
qui gen `EST1111'=0;


forvalues i=1/$indica {;
qui replace `total'=`total'+``i'';
};




tempvar Variable ;
qui gen `Variable'="";

tempvar _ths;
qui gen  `_ths'=1;
if ( "`hsize'"!="") qui replace `_ths'=`hsize';

cap svy: total;
if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);


tempvar apcexp;
gen `apcexp' = `pcexp';

tempvar sliving asliving osliving;
qui gen `sliving' = `pcexp';
qui gen `asliving' = `sliving';
if ("`aehs'" ~= "" ) qui replace `asliving' = `sliving'*`_ths'/`aehs' ;
gen `osliving' = `asliving' ;
basicgini `asliving' `pcexp',  hsize(`_ths');




qui replace `Variable' = "Pre-reform" in 1;
qui replace `EST1'=  `r(gini)'  in 	1;
qui replace `EST11'=  . in 	1;
qui replace `EST111'=  .  in 	1;
qui replace `EST1111'=  .  in 	1;


forvalues k = 1/$indica {;
local j = `k' +1;
tempvar sliving;
tempvar asliving;
qui gen `sliving'  = `pcexp'+``k'';
qui gen `asliving' = `sliving';
if ("`aehs'" ~= "" ) qui replace `asliving' = `sliving'*`_ths'/`aehs' ;
basicgini `asliving' `osliving',  hsize(`_ths');
qui replace `EST1'=  `r(gini)'  in `j';
qui replace `EST11'=  `r(dif)'  in 	`j';
qui replace `EST111'=  `r(sdif)'  in 	`j';
qui replace `EST1111'=  `r(pval)'  in 	`j';



};


tempvar sliving asliving;
qui gen `sliving' = `pcexp'+`total';
qui gen `asliving' = `sliving';
if ("`aehs'" ~= "" ) qui replace `asliving' = `sliving'*`_ths'/`aehs' ;
basicgini  `asliving' `pcexp',  hsize(`_ths') ;


qui replace `EST1'=  `r(gini)'  in `indica2';
qui replace `EST11'=  `r(dif)'  in `indica2';
qui replace `EST111'=  `r(sdif)'  in 	`indica2';
qui replace `EST1111'=  `r(pval)'  in 	`indica2';


qui replace `Variable' = "Post-reform" in `indica2';








/****TO DISPLAY RESULTS*****/

local cnam = "";

					 
if ("`lan'"~="fr")  local cnam `"`cnam' "The Gini index""';
if ("`lan'"~="fr")  local cnam `"`cnam' "Variation in the Gini index""';
if ("`lan'"~="fr")  local cnam `"`cnam' "Standard error""';
if ("`lan'"~="fr")  local cnam `"`cnam' "P_Value""';

if ("`lan'"=="fr")  local cnam `"`cnam' "Indice de Gini""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Variation en Gini""';
if ("`lan'"=="fr")  local cnam `"`cnam' "Erreur type""';
if ("`lan'"=="fr")  local cnam `"`cnam' "P_Value""';



local lng = (`indica2');
qui keep in 1/`lng';

local dste=0;



tempname zz;
qui mkmat   `EST1' `EST11' `EST111' `EST1111',   matrix(`zz');


local inlab = "Initial" ;
local filab = "Final" ;


local rnam;
local rnam `"`rnam' "`inlab'""';
if ("`xrnames'"~="") {;
local xrna  "`xrnames'";
local xrna : subinstr local xrna " " ",", all ;
local xrna : subinstr local xrna "|" " ", all ;
local count : word count `xrna';
tokenize "`xrna'";
forvalues i = 1/`count' {;
	local `i': subinstr local `i' "," " ", all ;
	    local tmp = substr("``i''",1,30);
	    local rnam `"`rnam' "With_Pr_Ch_`tmp'""';
	
};
};

local rnam `"`rnam' "`filab'""';



matrix rownames `zz' = `rnam' ;
matrix colnames `zz' = `cnam' ;


cap matrix drop _vv _aa gn;

ereturn matrix est = `zz';

restore;

end;



