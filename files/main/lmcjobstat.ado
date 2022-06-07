


#delimit ;


capture program drop lmcjobstat;
program define lmcjobstat, eclass;
version 9.2;
syntax varlist(min=1)[, 
HSize(varname) HGroup(varname)  
PCEXP(varname)
XRNAMES(string) 
LAN(string) 
STAT(string)
RTOT(string)
CTOT(string)
UNIT(varname)
];

if ("`unit'" ~= "") {;
forvalues k = 1/$indica {;
local uni`k' = "("+`unit'[`k']+")" ;
};
};



preserve;
capture {;
local lvgroup:value label `hgroup';
if ("`lvgroup'"!="") {;
uselabel `lvgroup' , clear;
qui count;
forvalues i=1/`r(N)' {;
local tem=value[`i'];
local grlab`tem' = label[`i'];
};
};
};



restore;
preserve;
qui tabulate `hgroup', matrow(gn);
svmat int gn;
global indig=r(r);
local indig = $indig;
local indig1 = $indig+1;
tokenize `varlist';
_nargs    `varlist';

tempvar total;
qui gen `total'=0;
local indica1 = $indica+1;


forvalues i=1/`indica1' {;
tempvar Variable EST`i';
qui gen `EST`i''=0;
if (`i' != `indica1') qui replace `total'=`total'+``i'';
};

tempvar denom;
gen `denom' = 0;

if ("`stat'" == "share_tot_pro") {;
forvalues i=1/$indica {;
qui replace `denom' = `denom'+``i'';
};
};

if ("`stat'" == "share_tot_exp") {;
qui replace `denom' = `pcexp';
};

tempvar Variable ;
qui gen `Variable'="";

tempvar _ths;
qui gen  `_ths'=1;
if ( "`hsize'"!="") qui replace `_ths'=`hsize';
cap svy: total;
if ( "`r(settings)'"==", clear") qui svyset _n, vce(linearized);
forvalues k = 1/$indica {;
basicstats ``k'' ,  hsize(`_ths') hgroup(`hgroup') stat(`stat') denom(`denom');
local pos = 1;
forvalues i=1/`indig1' {;
qui replace `EST`k''=  `r(est`i')'  in `pos';
local pos = `pos' + 1;
if "`stat'" == "exp_pcs" | "`stat'" == "exp_pcs2"  {;
qui replace `EST`k''=  `r(pv`i')'   in `pos';
local pos = `pos' + 1;
};
};
};

forvalues i=1/`indig' {;
local kk = gn1[`i'];
if ( "`grlab`kk''" == "") local grlab`kk' = "Group_`kk'";
qui replace `Variable' = "`grlab`kk''" in `i';

};
if ("`rtot'" == "") qui replace `Variable' = "Total"  in `indig1';
if ("`rtot'" ~= "") qui replace `Variable' = "`rtot'" in `indig1';



basicstats `total' ,  hsize(`_ths')  hgroup(`hgroup') stat(`stat') denom(`denom');
local kk1 = $indica+1;
local pos=1;
forvalues i=1/`indig1' {;
qui replace `EST`indica1''=  `r(est`i')'  in `pos';
local pos = `pos' + 1;
if "`stat'" == "exp_pcs" | "`stat'" == "exp_pcs2" {;
qui replace `EST`indica1''=  `r(pv`i')'   in `pos';
local pos = `pos' + 1;
};
};

*list `EST1' `EST2' `EST3' in 1/`indig1';

/****TO DISPLAY RESULTS*****/

local hweight=""; 
cap qui svy: total `1'; 
local hweight=`"`e(wvar)'"';
cap ereturn clear; 

if "`stat'"=="exp_tt"  local tab_tit = "Total expenditures";
if "`stat'"=="exp_pc"  local tab_tit = "Expenditures per capita";
if "`stat'"=="exp_hh"  local tab_tit = "Expenditures per household";
if "`stat'"=="con_tt"  local tab_tit = "Total consumption";
if "`stat'"=="con_pc"  local tab_tit = "Consumption per capita";
if "`stat'"=="con_hh"  local tab_tit = "Consumption per household";
 

if "`stat'"=="exp_tt"  local tab_tit_fr = "Dépenses totale";
if "`stat'"=="exp_pc"  local tab_tit_fr = "Dépenses per capita";
if "`stat'"=="exp_hh"  local tab_tit_fr = "Dépenses per par ménages";
if "`stat'"=="con_tt"  local tab_tit_fr = "Consommation totale";
if "`stat'"=="con_pc"  local tab_tit_fr = "Consommation per capita";
if "`stat'"=="con_hh"  local tab_tit_fr = "Consommation par ménages";

cap drop __compna;
qui gen  __compna=`Variable';

local lng1 = (`indig1');
local lng =  (`indig1');
if "`stat'" == "exp_pcs" | "`stat'" == "exp_pcs2"  local lng = (2*`indig1');
qui keep in 1/`lng';

local dste=0;
local rnam;
forvalues i=1(1)`lng1'  {;
local temn=__compna[`i'];
               local rnam `"`rnam' "`temn'""' ;
if "`stat'" == "exp_pcs" | "`stat'" == "exp_pcs2" 	local rnam `"`rnam' "...P-Value""' ;
};

global rnam `"`rnam'"';
tempname zz;
local lest;
forvalues j = 1/`indica1' {;
local lest `lest' `EST`j'';
};
qui mkmat  `lest' ,   matrix(`zz');

local cnam;

if ("`xrnames'"~="") {;
local xrna  `xrnames';
local xrna : subinstr local xrna " " ",", all ;
local xrna : subinstr local xrna "|" " ", all ;
local count : word count `xrna';
tokenize "`xrna'";
local pos = 1;
forvalues i = 1/`count' {;
	local `i': subinstr local `i' "," " ", all ;
	local cnam `"`cnam' "``i'' `uni`i''""';
	
	
};

};

if ("`xrnames'"=="" ) {;
forvalues j = 1/$indica {;
local tmp "``j''";
local cnam `"`cnam' "`tmp' `uni`i''""';
};
};

if ("`ctot'" == "") local cnam `"`cnam' "Total""';
if ("`ctot'" ~= "") local cnam `"`cnam' "`ctot'""';



matrix rownames `zz' = `rnam' ;
matrix colnames `zz' = `cnam' ;


cap matrix drop _vv _aa gn;
ereturn matrix est = `zz';
restore;

end;



