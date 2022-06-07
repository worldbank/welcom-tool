/*************************************************************************/
/* WELCOM: TAX Simulation Stata Toolkit  (Version 1.0)               */
/*************************************************************************/
/* Conceived by Dr. Araar Abdelkrim[1] and Dr. Paolo Verme[2]            */
/* World Bank Group (2012-2016)		                                 */
/* 									 */
/* [1] email : aabd@ecn.ulaval.ca                                        */
/* [1] Phone : 1 418 656 7507                                            */
/*									 */
/* [2] email : pverme@worldbank.org                                      */
/*************************************************************************/



cap program drop aprini2_pr
program aprini2_pr
	version 10
	local inis $ini_pra
	global prg_pointer = "main"
	if "`inis'"~="" {
	cap do "`inis'.pr"
	}
	cap macro drop ini_pra
	global tempprj `inis'
end
