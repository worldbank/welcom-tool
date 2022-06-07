



VERSION 9.2
SYNCHRONOUS_ONLY

INCLUDE graph_header
POSITION . . 860 500


DIALOG main, label("WELCOM| price change and welfare: direct & indirect effects --> prcwel_ind command") tabtitle("Main")
BEGIN
  DEFINE col0  20
  DEFINE col1 15
  DEFINE col2 50
  DEFINE col3 170
  DEFINE col4 280
  DEFINE col5 400
  
  DEFINE colwd0 55
  DEFINE colwd1 105
  DEFINE colwd2 105
  DEFINE colwd3 80
  

  DEFINE _x _xsetbu
  DEFINE _y _top
  
    GROUPBOX chk_per11  10    10  410 80,                         ///
            label("Dialog box inputs: ")           ///
		   
    TEXT txt_vname11     20    +20    140      .,                 ///  
                  label("Load the inputs:   ")                           
       
    BUTTON  bu_load    140    @     270      .,                 ///
    label("Load") onpush("view dialog aprinid_pr") 
	 
	 
	TEXT  tx_dbsfile     20    +25    140      .,                 ///  
         label("Save the inputs:")                           	  
   
   FILE  dbsamex      140    @     270      .,                    ///
    label ("Browse...")    save option("inisave")                   ///
    filter("MetaFile (*.pr)*.pr*.* (*.*)*.*")   
	
	
	

   GROUPBOX chk_per1  10    +60  410 140,                         ///
           label("Variables of interest: ")                       ///

  
  TEXT     tx_var      20    +20    180      .,                 ///
   label("Welfare*:          ") 
         
  VARNAME  vn_pcexp      210    @     200      .,                 ///
                  
  
		   
 TEXT     tx_var3      20   +30    180      .,                 ///
           label("Household size*:   ")  
 VARNAME  vn_hhs     210    @     200      .,                 ///
           option(hsize)    
 
 TEXT     tx_pl1      20   +30    180      .,                 ///
           label("Poverty line*:   ")  
 VARNAME  vn_pl1      210    @     200      .,                 ///
           option(pline)    
  
  GROUPBOX chk_per7  10    +80  410 80,                         ///
           label("Group variable (by default is the quintiles) ")         
		   
 TEXT     tx_hhg      20   +30    180       .,                 ///
           label("Household group:   ")  
 VARNAME  vn_hhg      210 @     200      .,                 ///
           option(hgroup)  
		   


 TEXT     txt_note1     10    +60    400      .,                 ///  
             label("Note: The (*) indicates a required information.")     
  
 
 /*
TEXT  tx_dbofile     20    +25    60      .,                 ///  
label("Open:")                                  ///	  
            
        
FILE  dboamex      80    @     200      .,                 ///
label ("Browse...")    save option("iniopen")                   ///
filter("MetaFile (*.def)*.def*.* (*.*)*.*") 

BUTTON   bu_open     290 @       70     .,              ///
        label("Load") onpush(program initialize)        ///
        tooltip("Load the dialog box information")
			
*/			  
     
GROUPBOX percentile 440    10    410 120,                      ///
           label("Price change and Well-being model")

   TEXT     txt_meas     450    +25    180      .,                 ///  
             label("Money-metric measurement:")     
  
   COMBOBOX  cb_meas      610    @     230      .,                 ///
              dropdownlist                                          ///
              contents(cb_meas)  values(cb_meas_val) option(meas)  ///
              default(1) onselchangelist(sel_change)
			  
  TEXT    txt_subs      780    +25     80      .,   ///
  label("subst. param.")  
  
  TEXT     txt_model     450    +20    180      .,                  ///  
             label("Consumer model:")     
  
 
 COMBOBOX  cb_model     610    @     160      .,                  ///
              dropdownlist                                           ///
              contents(cb_model)  values(cb_model_val) option(model)  ///
              default(1)  onselchangelist(mod_change) 
  
   TEXT      txt_stm     450    @    180      .,                  ///  
             label("Approximated Measurement:")   
   
   COMBOBOX  cb_stm     610    @     160      .,                  ///
              dropdownlist                                           ///
              contents(cb_stm)  values(cb_stm_val) option(sotm)  ///
              default(1)   			  
 
 EDIT    ed_subs      780    @     60      .,   ///
 option(subs) default(0.6) 
 
 
			
	  
   GROUPBOX parineq 440    +60    460 80,                      ///
           label("Paremeters of inequality indices")

   TEXT     txt_param1     450    +25    170      .,                 ///  
             label("Atkinson index (epsilon):")  
                         
   EDIT    ed_epsilon     650    @     200     .,   ///
   option(epsilon) default(0.5)
   
   TEXT     txt_param2     450    +25    190      .,                 ///  
   label("Generalized Entropy index  (theta):")  
                         
   EDIT    ed_theta     650    @     200     .,   ///
   option(theta) default(0) 
  
		  
				  
				  
  CHECKBOX   chk_gvimp     440    +75    300    .,                   ///
             label("Generate variable of impact on wellbeing.") default(0) option(gvimp)
				  

   DEFINE _x 640
   DEFINE _y 520
     
  INCLUDE _bu_svyset

END




LIST cb_meas
BEGIN
 Laspeyres Measurement(1st Order Tylor)
 Second Order Tylor Approximation 
 Equivalent Variation Measurement 
 Compensated Variation Measurement 
END

LIST cb_meas_val
BEGIN
 1
 2
 3
 4
END



LIST cb_model
BEGIN
 Cobb-Douglas preferences
 CES preferences
END

LIST cb_model_val
BEGIN
 1
 2
END


LIST cb_stm
BEGIN
 Consumer Surplus
 Equivalent Variation
 Compensated Variation
END

LIST cb_stm_val
BEGIN
 1
 2
 3
END


LIST sel_change
BEGIN
        script sel1
        script sel2
		script sel3
		script sel4
        
END


SCRIPT sel1
BEGIN
        has_sel1.settrue
        has_sel2.setfalse
		has_sel3.setfalse
		has_sel4.setfalse
        program check_sels
END

SCRIPT sel2
BEGIN
        has_sel1.setfalse
        has_sel2.settrue
		has_sel3.setfalse
		has_sel4.setfalse
        program check_sels
END


SCRIPT sel3
BEGIN
        has_sel1.setfalse
        has_sel2.setfalse
		has_sel3.settrue
		has_sel4.setfalse
        program check_sels
END

SCRIPT sel4
BEGIN
        has_sel1.setfalse
        has_sel2.setfalse
		has_sel3.setfalse
		has_sel4.settrue
        program check_sels
END


LIST mod_change
BEGIN
        script mod1
        script mod2   
END


SCRIPT mod1
BEGIN
        has_mod1.settrue
        program check_sels
END

SCRIPT mod2
BEGIN
        has_mod1.setfalse
        program check_sels
END


PROGRAM check_sels
BEGIN
if (has_sel1 ){
call main.txt_subs.hide    
call main.txt_model.hide     
call main.cb_model.hide      
call main.ed_subs.hide
call main.txt_stm.hide
call main.cb_stm.hide  
}

if (has_sel2 ){
call main.txt_subs.hide    
call main.txt_model.hide     
call main.cb_model.hide      
call main.ed_subs.hide
call main.txt_stm.show
call main.cb_stm.show  
}

if (has_sel3 | has_sel4){
   
call main.txt_model.show     
call main.cb_model.show
call main.txt_stm.hide
call main.cb_stm.hide   
if has_mod1{     
call main.ed_subs.hide
call main.txt_subs.hide 
}
if !has_mod1{     
call main.ed_subs.show
call main.txt_subs.show
}
}

END



SCRIPT clear_all
BEGIN
        items_info.cb_scens.setvalue "1"
        items_info.vn_fpsch1.setvalue ""
        items_info.vn_fpsch2.setvalue ""
        items_info.ln_scen3.setvalue ""
		

        main.cb_items.setvalue "1"
        main.en_pr_a1.setvalue ""
        main.vn_item1.setvalue ""
        main.vn_item2.setvalue ""
        main.vn_item3.setvalue ""
        main.vn_item4.setvalue ""
        main.vn_item5.setvalue ""
        main.vn_item6.setvalue ""  
	    main.vn_item7.setvalue ""
        main.vn_item8.setvalue ""
        main.vn_item9.setvalue ""
        main.vn_item10.setvalue "" 
END




SCRIPT PREINIT
BEGIN
      
        create BOOLEAN has_scen1
        create BOOLEAN has_scen2
        create BOOLEAN has_scen3
		create BOOLEAN has_item0
        create BOOLEAN has_item1
        create BOOLEAN has_item2
        create BOOLEAN has_item3
        create BOOLEAN has_item4
        create BOOLEAN has_item5
        create BOOLEAN has_item6
		create BOOLEAN has_item7
        create BOOLEAN has_item8
        create BOOLEAN has_item9
        create BOOLEAN has_item10
		

		
		create BOOLEAN has_ps1
        create BOOLEAN has_ps2
        create BOOLEAN has_ps3
        create BOOLEAN has_ps4
        create BOOLEAN has_ps5
        create BOOLEAN has_ps6
		create BOOLEAN has_ps7
        create BOOLEAN has_ps8
        create BOOLEAN has_ps9
        create BOOLEAN has_ps10
		create BOOLEAN has_ini
		
		create BOOLEAN has_pr_bui1
		create BOOLEAN has_pr_buf1
		create BOOLEAN has_pr_bui2
		create BOOLEAN has_pr_buf2
		create BOOLEAN has_pr_bui3
		create BOOLEAN has_pr_buf3
		create BOOLEAN has_pr_bui4
		create BOOLEAN has_pr_buf4
		create BOOLEAN has_pr_bui5
		create BOOLEAN has_pr_buf5
		create BOOLEAN has_pr_bui6
		create BOOLEAN has_pr_buf6
		create BOOLEAN has_pr_bui7
		create BOOLEAN has_pr_buf7
		create BOOLEAN has_pr_bui8
		create BOOLEAN has_pr_buf8
		create BOOLEAN has_pr_bui9
		create BOOLEAN has_pr_buf9
		create BOOLEAN has_pr_bui10
		create BOOLEAN has_pr_buf10
		
		create BOOLEAN has_shock1
        create BOOLEAN has_shock2
        create BOOLEAN has_shock3
        create BOOLEAN has_shock4
        create BOOLEAN has_shock5
        create BOOLEAN has_shock6
		
		create BOOLEAN has_cond1
		create BOOLEAN has_cond2
		
	    create BOOLEAN has_add1
		create BOOLEAN has_add2
		
		create BOOLEAN has_sel1
        create BOOLEAN has_sel2
        create BOOLEAN has_sel3
		create BOOLEAN has_sel4
	    create BOOLEAN has_mod1
        create BOOLEAN has_mod2
	    create BOOLEAN has_cond11
		create BOOLEAN has_cond22

		
				
END







PROGRAM POSTINIT_PROGRAM
BEGIN
	put "aprini2d_pr"
	stata hidden
END





INCLUDE items_info_pr_ind
INCLUDE items_info_pr_indeff
INCLUDE tb_options_pr_ind






LIST cb_res
BEGIN
  Households
  Persons
END

LIST cb_res_val
BEGIN
 hh
 per
END


HELP hlp1,   view("help prcwel_ind")
RESET res1
OK ok1,      label("OK")
CANCEL can1, label("Cancel")
SUBMIT sub1, label("Submit")
COPY copy1

PROGRAM initialize
BEGIN
		*put `"dis  asubini tunisia_sum1"'
		stata hidden
END




PROGRAM command
BEGIN
        put "prcwel_ind "
	    require  main.vn_pcexp
        varlist [main.vn_pcexp]

        put " "
     
        beginoptions
		
        optionarg main.vn_hhs
	    optionarg main.vn_pl1
		optionarg main.vn_hhg
		
	
                if !main.cb_meas.isdefault() {
                           optionarg main.cb_meas
                               } 
			
                    optionarg main.cb_model
                 
				 
				 if !main.ed_subs.isdefault() {
                           optionarg main.ed_subs
                 }
				 
	              if !main.cb_stm.isdefault() {
                           optionarg main.cb_stm
                    } 

                        
	 optionarg main.dbsamex
						
				

		optionarg tb_options_pr_ind.fnamex			
		optionarg tb_options_pr_ind.ed_tab    
		
         
		optionarg main.chk_gvimp 
		
		put " "  /program item1_output 
        put " "  /program item2_output 
        put " "  /program item3_output 
        put " "  /program item4_output 
        put " "  /program item5_output 
        put " "  /program item6_output 
		put " "  /program item7_output 
		put " "  /program item8_output 
		put " "  /program item9_output 
		put " "  /program item10_output
		
		put " " /program  var_output
        		   
		
	   optionarg items_info_pr_ind.ed_items
	   optionarg items_info_pr_ind.cb_items
	   optionarg items_info_pr_ind.ed_matpel
	   optionarg items_info_pr_ind.ed_matiel
       
	   
	       optionarg items_info_pr_indeff.dbiom
           optionarg items_info_pr_indeff.cb_nshocks
           
           optionarg items_info_pr_indeff.cb_ioap
           optionarg items_info_pr_indeff.cb_ioap_ad
           optionarg items_info_pr_indeff.cb_ioap_sh
		   optionarg items_info_pr_indeff.ed_np

      
	  
	    put " "  /program shock1_output 
        put " "  /program shock2_output 
        put " "  /program shock3_output 
        put " "  /program shock4_output 
        put " "  /program shock5_output 
        put " "  /program shock6_output 

        put " "  /program ivar_output
		
	   endoptions 
        
        
END
