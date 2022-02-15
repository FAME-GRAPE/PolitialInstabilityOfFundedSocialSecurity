clear all


global directory_data "  " // add here where you print the results form your Fortran
global directory_plots "   " // create a path for STATA to produce the graphs

/* fig 3: The effect of a successful vote against the two-pillar DC \textit{status quo} on pensions and taxes */

global name1 FpolicyScenario
global name2 SpolicyScenario
global name4 TpolicyScenario
global name0 no_policy_change
global first_voting_date = 14
global voting_fq = 10


/* Welfare effects and its decomposition of a vote in 2012 by birth year. */

clear all

set scheme burd 
clear


foreach version in homogenous_cohorts heterogenous_cohorts{

foreach  year of numlist 2012 2192{
global x_begin =`year'-102 
global x_end = `year'+38
*votingdate
	forvalues scenario = 1 (1) 3 { 
		clear
		cd "$directory_data\\`version'\\results\\_REV\\"
		insheet using "`year'\1v`scenario's_fC_fC__x_veil.txt", clear
		replace v1 = 100*v1
		rename v1 overall
		gen Year =_n + 1998 -100


		cd "$directory_plots"
		save `version'_overall_`year', replace
		clear

		cd "$directory_data\\`version'\\results\\_REV\\"
		insheet using "`year'\\`scenario'sfC_fC_xjm_veil_t.txt", clear
		replace v1 = 100*v1
		rename v1 tax
		gen Year =_n + 1998 -100

		cd "$directory_plots"
		merge 1:1 Year using `version'_overall_`year'
		drop _merge
		save `version'_overall_`year', replace
		cd "$directory_data\\`version'\\results\\_REV\\"
		insheet using "`year'\\`scenario'sfC_fC_xjm_veil_b.txt", clear
		replace v1 = 100*v1
		rename v1 pension
		label var pension "benefits and indexation"
		gen Year =_n + 1998 -100

		cd "$directory_plots"
		merge 1:1 Year using `version'_overall_`year'
		drop _merge
		save `version'_overall_`year', replace
		cd "$directory_data\\`version'\\results\\_REV\\"
		insheet using "`year'\\`scenario'sfC_fC_xjm_veil_g.txt", clear
		replace v1 = 100*v1
		rename v1 GE
		label var GE "wage & interest rate"
		gen Year =_n + 1998 -100
		save `version'_overall_`year', replace
		cd "$directory_plots"
		merge 1:1 Year using `version'_overall_`year'
		drop _merge

		label variable Year  "Year of birth"
		tsset Year

								
			twoway (dropline overall Year, lpattern(solid)  msize(tiny) ) ///
			   (dropline tax Year, lpattern(blank) lwidth(vtiny) mstyle(o) mcolor(red) msize(vsmall)) ///
			   (dropline pension Year, lpattern(blank) lwidth(vtiny) msize(small))   ///
			   (dropline GE Year, lpattern(blank) lwidth(vtiny)  msize(vsmall))   ///
			   if Year > `year' -100 & Year < `year' +50, ///
								legend(cols(1) lcolor(none) region(lcolor(none) fcolor(none)) ring(0) position(7) ) ///
								 ytitle("") ylabel(-1.5(0.5)2, angle(0))  xlabel($x_begin (20) $x_end) xline(`year', lcolor(red))
								graph save "$directory_plots\\`version'_eq_decomp`scenario'_`year'.gph", replace
								graph export "$directory_plots\\`version'_eq_decomp`scenario'_`year'.png", replace
						
						
		}
	}
}



clear all

set scheme burd 
clear


foreach version in homogenous_cohorts{
foreach  OPD_dist of numlist 4 10 20 30 {
foreach  year of numlist 2012 2162 2192{
global x_begin =`year'-100
global x_end = `year'-20
*votingdate
	forvalues scenario = 3 (1) 3 { 
		clear
		cd "$directory_data\\`version'\\results\\_OPD\\k`OPD_dist'\\"
		insheet using "`year'\0v`scenario's_fC_fC__x_veil.txt", clear
		replace v1 = 100*v1
		rename v1 overall
		gen Year =_n + 1998 -100


		cd "$directory_plots"
		save `version'_overall_`year', replace
		clear

		cd "$directory_data\\`version'\\results\\_OPD\\k`OPD_dist'\\"
		insheet using "`year'\\`scenario'sfC_fC_xjm_veil_t.txt", clear
		replace v1 = 100*v1
		rename v1 tax
		gen Year =_n + 1998 -100

		cd "$directory_plots"
		merge 1:1 Year using `version'_overall_`year'
		drop _merge
		save `version'_overall_`year', replace
		cd "$directory_data\\`version'\\results\\_OPD\\k`OPD_dist'\\"
		insheet using "`year'\\`scenario'sfC_fC_xjm_veil_b.txt", clear
		replace v1 = 100*v1
		rename v1 pension
		label var pension "benefits and indexation"
		gen Year =_n + 1998 -100

		cd "$directory_plots"
		merge 1:1 Year using `version'_overall_`year'
		drop _merge
		save `version'_overall_`year', replace
		cd "$directory_data\\`version'\\results\\_OPD\\k`OPD_dist'\\"
		insheet using "`year'\\`scenario'sfC_fC_xjm_veil_g.txt", clear
		replace v1 = 100*v1
		rename v1 GE
		label var GE "wage & interest rate"
		gen Year =_n + 1998 -100
		save `version'_overall_`year', replace
		cd "$directory_plots"
		merge 1:1 Year using `version'_overall_`year'
		drop _merge

		label variable Year  "Year of birth"
		tsset Year

								
			twoway (dropline overall Year, lpattern(solid)  msize(tiny) ) ///
			   (dropline tax Year, lpattern(blank) lwidth(vtiny) mstyle(o) mcolor(red) msize(vsmall)) ///
			   (dropline pension Year, lpattern(blank) lwidth(vtiny) msize(small))   ///
			   (dropline GE Year, lpattern(blank) lwidth(vtiny)  msize(vsmall))   ///
			   if Year >= $x_begin & Year <= $x_end , ///
								legend(cols(1) lcolor(none) region(lcolor(none) fcolor(none)) ring(0) position(2)) ///
								 ytitle("") ylabel(-1.5(0.5)2, angle(0))  xlabel($x_begin (20) $x_end) 
								graph save "$directory_plots\\OPD_`version'_eq_decomp`scenario'_k`OPD_dist'_`year'.gph", replace
								graph export "$directory_plots\\OPD_`version'_eq_decomp`scenario'_k`OPD_dist'_`year'.png", replace
						
						
		}
	}
}
}

 //----------------------------------------//
 //               REF 1999                 //
 //----------------------------------------//
 set scheme s1mono
  // Interest rate and growth rate of total wage bill in no policy change scenario.
 foreach version in homogenous_cohorts heterogenous_cohorts{
	foreach var in payg ff  {
	cd "$directory_data\\`version'\\results\\_REF1999\\_standard\\"
	insheet using "base_fC_fC_payroll_trans_`var'.txt", clear
	rename v1 payroll
	replace payroll = payroll*100
	gen Year =_n + 1998
	cd "$directory_plots"
	save `version'_payroll_rbar_`var', replace
	clear

	 cd "$directory_data\\`version'\\results\\_REF1999\\_standard\\"
	insheet using "base_fC_fC_r_bar_trans_`var'.txt", clear
	rename v1 rbar
	replace rbar = rbar*100
	gen Year =_n + 1998
	cd "$directory_plots"
	merge 1:1 Year using `version'_payroll_rbar_`var'
	drop _merge

	tset Year
	twoway (tsline rbar, lpattern(solid) lwidth(medthick) lcolor(black))  ///
		(tsline payroll, lpattern(solid) lwidth(medthick) lcolor(gs12))  ///
		if (Year < 2180 ), ytitle("") legend(ring(0) position(2)cols(1) lcolor(none) region(lcolor(none)) ///
			order(1 "Interst rate" 2 "Payroll growth rate" )) xlabel(2000(20)2180) ylabel(0(2)8)
	graph save "`version'_payroll_intrest_`var'.gph", replace
	graph export "`version'_payroll_intrest_`var'.png", replace	
	}
}

// Political support for two-pillar system (left) and gains from funded pillar (right)


clear all


set scheme burd 
 foreach version in homogenous_cohorts heterogenous_cohorts{
	
cd "$directory_data\\`version'\\results\\_REF1999\\"
insheet using "_standard\base_fC_fC__x_veil.txt", clear
replace v1 = 100*v1
rename v1 overall
gen Year =_n + 1998-100

cd "$directory_plots"
save `version'_overall, replace
clear

cd "$directory_data\\`version'\\results\\_REF1999\\"
insheet using "_purePAYG_DC\base_fC_fC__x_veil.txt", clear
replace v1 = 100*v1
rename v1 PAYG
gen Year =_n + 1998-100

cd "$directory_plots"
merge 1:1 Year using `version'_overall
drop _merge



gen FF = overall - PAYG

label var FF "funded pillar"
save decomp_DC_FF, replace

tsset Year
label var Year "Date of birth"
twoway 	(dropline overall Year, lpattern(solid) msize(tiny) ) ///
		(dropline PAYG Year, lpattern(blank) lwidth(vtiny) lcolor(gs16) msize(vsmall)  msymbol(D)) ///
		(dropline FF Year, lpattern(blank) lwidth(vtiny) lcolor(gs16) msize(vsmall)   msymbol(T))   ///
		if Year <2070 , ///
			legend(cols(1) lcolor(none) region(lcolor(none)) ring(0) position(5)) ///
			ytitle("") xlabel(1900(20)2060) 
						 
		graph save "`version'_eq_decomp_REF.gph", replace
		graph export "`version'_eq_decomp_REF.png", replace
	}	
	
	
set scheme burd
clear

foreach version in homogenous_cohorts heterogenous_cohorts{
	cd "$directory_data\\`version'\\results\\_REF1999\\"
	// standard 
	insheet using "_standard\fC_fC_better.txt", clear
	rename v1 standard
	replace standard = 100*standard
	gen Year =_n + 1997
	label var standard "standard fiscal rule"
	cd "$directory_plots"
	save `version'_standard, replace
	clear
	// slow
	cd "$directory_data\\`version'\\results\\_REF1999\\"
	insheet using "_slow_frule\fC_fC_better.txt", clear
	rename v1 slow
	replace slow = 100*slow
	gen Year =_n + 1997
	label var slow "slow tax adjustment"
	cd "$directory_plots"
	save `version'_slow, replace
	clear

	// fast
	cd "$directory_data\\`version'\\results\\_REF1999\\"
	insheet using "_fast_frule\fC_fC_better.txt", clear
	rename v1 fast
	replace fast = 100*fast
	gen Year =_n + 1997
	label var fast "fast tax adjustment"
	cd "$directory_plots"
	save `version'_fast, replace
	clear

	// tc
	cd "$directory_data\\`version'\\results\\_REF1999\\"
	insheet using "_pure_TC\tc_tc_better.txt", clear
	rename v1 tc
	replace tc = 100*tc
	gen Year =_n + 1997
	label var tc "pure {&tau}{sub:c}"
	cd "$directory_plots"
	save `version'_tc, replace
	clear

	// debt
	cd "$directory_data\\`version'\\results\\_REF1999\\"
	insheet using "_pure_debt\dC_dC_better.txt", clear
	rename v1 debt
	replace debt = 100*debt
	gen Year =_n + 1997
	label var debt "debt"
	cd "$directory_plots"
	save `version'_debt, replace


	// merge files
	merge 1:1 Year using `version'_tc
	drop _merge		
	merge 1:1 Year using `version'_fast
	drop _merge

	merge 1:1 Year using `version'_slow
	drop _merge

	merge 1:1 Year using `version'_standard
	drop _merge

	save support, replace

	twoway		(line standard Year, lcolor(black)) ///
				(line slow Year, lpattern(dot) lwidth(thick)) ///
				(line fast Year, lpattern(dash) lwidth(thick)) ///
				(line tc Year, 	 lpattern(dash_dot)) ///
				(line debt Year, lpattern(dash_dot) lwidth(thick)) ///
				if Year < 2180 & Year > 1998, yline(50) ///
	ytitle("") legend(ring(0) position(5) cols(1) lcolor(none) region(lcolor(none))) xlabel(#10) 

	graph save "`version'_support.gph", replace
	graph export "`version'_support.png", replace
}

//Interest rates (left) and tax rates (right) under the DB and DC social security

set scheme burd
clear

 foreach version in homogenous_cohorts heterogenous_cohorts{
	 foreach var in r_bar tc{
		cd "$directory_data\\`version'\\results\\_REF1999\\"
clear 
				insheet using "_standard\base_fC_fC_`var'_trans_payg.txt"
				
				rename v1 db
				replace db = 100* db
				gen Year = _n + 1998
				
		cd "$directory_plots"		
				save "`version'_`var'_bar",replace 
				clear 
				
		cd "$directory_data\\`version'\\results\\_REF1999\\"		
				insheet using "_standard\base_fC_fC_`var'_trans_ff.txt"
				rename v1 fdc
				replace fdc = 100* fdc
				gen Year = _n + 1998
				
		cd "$directory_plots"	
				
				merge 1:1 Year using "`version'_`var'_bar.dta"
				drop _merge
				save `version'_`var'_bar, replace
				clear
				
		cd "$directory_data\\`version'\\results\\_REF1999\\"		
				insheet using "_purePAYG_DC\base_fC_fC_`var'_trans_ff.txt"
				rename v1 dc
				replace dc = 100* dc
				gen Year = _n + 1998
				
		cd "$directory_plots"	
					
				merge 1:1 Year using "`version'_`var'_bar.dta"
				drop _merge	
				save `version'_`var'_bar, replace
				
			
		twoway (line db Year )  (line  dc Year, lpattern(dot) lwidth(thick))  (line  fdc Year, lpattern(dash)) ///
		if Year <2180, ytitle("") legend(ring(0) position(2)cols(1) lcolor(none) ///
		region(lcolor(none)) order(1 "DB"  2 "DC" 3 "FDC" )) xlabel(2000(20)2180)
		graph save Graph "`version'_`var'_comp.gph", replace
		graph export "`version'_`var'_comp.png", replace
	}
			
}		
//----------------------------------------//
//                  REV                   //
//----------------------------------------//



//The effect of reducing the funded pillar on pensions and fiscal variables


global name1 FpolicyScenario
global name2 SpolicyScenario
global name4 TpolicyScenario
global name0 no_policy_change

global first_voting_date = 14
global voting_fq = 10


foreach version in homogenous_cohorts heterogenous_cohorts{
	  forvalues i = 1(1)1{
		local reform_date = 1998+$first_voting_date+(`i'-1)*$voting_fq
		foreach var in debt_share tc {
		cd "$directory_data\\`version'\\results\\_REV\\2012\\"
			********* debt_share *************

			global var4 "_fC_fC_REV_`var'_trans_ff"
			
				insheet using "`i'v0s$var4.txt", clear
				rename v1 $name0
				gen Year = _n +1998
				save `version'_`i'v0s$var4 , replace
				clear 
				
				insheet using "`i'v1s$var4.txt", clear
				rename v1 $name1
				gen Year = _n + 1998
				save `version'_`i'v1s$var4, replace
				clear
				
				insheet using "`i'v2s$var4.txt", clear
				rename v1 $name2
				gen Year = _n + 1998
				save `version'_`i'v2s$var4, replace
				clear
				
				insheet using "`i'v3s$var4.txt", clear
				rename v1 $name4
				gen Year = _n + 1998
				save `version'_`i'v4s$var4, replace
						
				
				merge 1:1 Year using "`version'_`i'v1s$var4"
				drop _merge
				tsset Year
				save `version'_merged_`var', replace
				
				merge 1:1 Year using "`version'_`i'v2s$var4"
				drop _merge
				tsset Year
				save `version'_merged_`var', replace
				
				
				merge 1:1 Year using "`version'_`i'v0s$var4"
				drop _merge
				tsset Year
				save `version'_merged_`var', replace
				
				capture drop dif1 dif2 dif3
				
				gen dif1 = ( $name1 - $name0 )*100
				gen dif2 = ( $name2 - $name0 )*100
				gen dif3 = ( $name4 - $name0 )*100
				
				replace $name0 = 100 * $name0 
				replace $name1 = 100 * $name1 
				replace $name2 = 100 * $name2 
				replace $name4 = 100 * $name4 

		 colorpalette burd, locals

				cd "$directory_plots"
				 graph twoway ///
				 (tsline dif1, lcolor(`Bu' ) lpattern(solid) ) ///
				 (tsline dif2, lcolor(`Rd' ) lpattern(dash) ) ///
				 (tsline dif3, lcolor(`Gn' ) lpattern(dot) lwidth(medium))  if Year < 2160, ///
				  ytitle("") legend(ring(0) position(5) cols(1)  lcolor(none) region(lcolor(none))  order(1 "Policy 1" 2 "Policy 2" 3 "Policy 3")) ///
				  xlabel(#10)    
						graph save "`version'_`i'_`var'_dif.gph", replace
						graph export "`version'_`i'_`var'_dif.png", replace


				 graph twoway ///
				 (tsline $name0,  lcolor(`Or' ) lpattern(dot) lwidth(thick)) ///
				 (tsline $name1,  lcolor(`Bu' ) lpattern(solid)) ///
				 (tsline $name2, lcolor(`Rd' ) lpattern(dash) ) ///
				 (tsline $name4, lcolor(`Gn' ) lpattern(dot) lwidth(medium))  if Year < 2160, ///
				  ytitle("") legend(ring(0) position(2) cols(1)  lcolor(none) region(lcolor(none))  order(1 "No policy change" 2 "Policy 1" 3 "Policy 2" 4 "Policy 3")) ///
				  xlabel(#10)    
						graph save "`version'_`i'_`var'.gph", replace
						graph export "`version'_`i'_`var'.png", replace
			}	
}
}


 foreach version in homogenous_cohorts heterogenous_cohorts{
  forvalues i = 1(1)1{
local reform_date = 1998+$first_voting_date+(`i'-1)*$voting_fq
foreach var in avg_benefits {
cd "$directory_data\\`version'\\results\\_REV\\2012\\"
	********* debt_share *************

	global var4 "_fC_fC_REV_`var'_trans_ff"
	
		insheet using "`i'v0s$var4.txt", clear
		rename v1 $name0
		gen Year = _n +1998
		save `version'_`i'v0s$var4 , replace
		clear 
		
		insheet using "`i'v1s$var4.txt", clear
		rename v1 $name1
		gen Year = _n + 1998
		save `version'_`i'v1s$var4, replace
		clear
		
		insheet using "`i'v2s$var4.txt", clear
		rename v1 $name2
		gen Year = _n + 1998
		save `version'_`i'v2s$var4, replace
		clear
		
		insheet using "`i'v3s$var4.txt", clear
		rename v1 $name4
		gen Year = _n + 1998
		save `version'_`i'v4s$var4, replace
				
		
		merge 1:1 Year using "`version'_`i'v1s$var4"
		drop _merge
		tsset Year
		save `version'_merged_`var', replace
		
		merge 1:1 Year using "`version'_`i'v2s$var4"
		drop _merge
		tsset Year
		save `version'_merged_`var', replace
		
		
		merge 1:1 Year using "`version'_`i'v0s$var4"
		drop _merge
		tsset Year
		save `version'_merged_`var', replace
		
		capture drop dif1 dif2 dif3
		
		gen dif1 = ( $name1 / $name0 -1  )*100
		gen dif2 = ( $name2 /$name0 -1 )*100
		gen dif3 = ( $name4 / $name0 -1 )*100
		
				replace $name0 = 100 * $name0 
		replace $name1 = 100 * $name1 
		replace $name2 = 100 * $name2 
		replace $name4 = 100 * $name4 

		cd "$directory_plots"
		 graph twoway ///
		 (tsline dif1, lcolor(`Bu' ) lpattern(solid) ) ///
		 (tsline dif2, lcolor(`Rd' ) lpattern(dash) ) ///
		 (tsline dif3, lcolor(`Gn' ) lpattern(dot) lwidth(medium))  if Year < 2160, ///
		  ytitle("") legend(ring(0) position(5) cols(1)  lcolor(none) region(lcolor(none))  order(1 "Policy 1" 2 "Policy 2" 3 "Policy 3")) ///
		  xlabel(#10)    
				graph save "`version'_`i'_`var'_dif.gph", replace
				graph export "`version'_`i'_`var'_dif.png", replace

		 colorpalette burd, locals
graph twoway ///
		 (tsline $name0,  lcolor(`Or' ) lpattern(dot) lwidth(thick)) ///
		 (tsline $name1,  lcolor(`Bu' ) lpattern(solid)) ///
		 (tsline $name2, lcolor(`Rd' ) lpattern(dash) ) ///
		 (tsline $name4, lcolor(`Gn' ) lpattern(dot) lwidth(medium))  if Year < 2160, ///
		  ytitle("") legend(ring(0) position(2) cols(1)  lcolor(none) region(lcolor(none))  order(1 "No policy change" 2 "Policy 1" 3 "Policy 2" 4 "Policy 3")) ///
		  xlabel(#10)    
				graph save "`version'_`i'_`var'.gph", replace
				graph export "`version'_`i'_`var'.png", replace
	}	
}
}


// Adjustments in the interest rate $r_t$ (left) and the wage rate $w_t$ (right)
// plus
// Adjustments in capital $K_t$ (left) and labor supply $L_t$ (right)
set scheme burd
global name1 FpolicyScenario
global name2 SpolicyScenario
global name4 TpolicyScenario
global name0 no_policy_change

 foreach version in homogenous_cohorts heterogenous_cohorts{
global directory_dataREV2012 "$directory_data\\`version'\\results\\_REV\\2012"
global first_voting_date = 14
global voting_fq = 10
forvalues i = 1(1)1{			
	************************REV_wbar**************************
	foreach var in REV_wbar  {	
	clear
	global var4 "_fC_fC_`var'_trans_ff"
	    cd "$directory_dataREV2012"
		clear all  
		insheet using "`i'v0s$var4.txt", clear
		rename v1 $name0
		gen Year = _n +1998
	cd "$directory_plots"
		save `version'_`i'v0s$var4 , replace
		clear 
		
	cd "$directory_dataREV2012"	
		insheet using "`i'v1s$var4.txt", clear
		rename v1 $name1
		gen Year = _n + 1998
	cd "$directory_plots"
		save `version'_`i'v1s$var4, replace
		clear
		
	cd "$directory_dataREV2012"	
		insheet using "`i'v2s$var4.txt", clear
		rename v1 $name2
		gen Year = _n + 1998
	cd "$directory_plots"	
		save `version'_`i'v2s$var4, replace
		clear
		
	cd "$directory_dataREV2012"	
		insheet using "`i'v3s$var4.txt", clear
		rename v1 $name4
		gen Year = _n + 1998
	cd "$directory_plots"	
		save `version'_`i'v4s$var4, replace
				
		merge 1:1 Year using `version'_`i'v1s$var4
		drop _merge
		tsset Year
		save `version'_merged_big_k, replace
		
		merge 1:1 Year using `version'_`i'v2s$var4
		drop _merge
		tsset Year
		save `version'_merged_big_k, replace
		
		merge 1:1 Year using `version'_`i'v0s$var4
		drop _merge
		tsset Year
		save `version'_merged_big_k, replace

		gen delta1 = $name1/$name0
		gen delta2 = $name2/$name0
		gen delta3 = $name4/$name0
		tsset Year
		
		twoway (tsline delta1, lpattern(solid))  ///
			(tsline delta2, lpattern(dash))  ///
			(tsline delta3, lpattern(dot) lwidth(medium))  ///
			if (Year < 2180 ), ytitle("") legend(ring(0) position(3) cols(1) lcolor(none) region(lcolor(none)) ///
				order(1 "Policy 1" 2 "Policy 2" 3 "Policy 3"  )) ///
			xlabel(#10)  
		
		graph save "`version'_`i'_`var'.gph", replace
		graph export "`version'_`i'_`var'.png", replace
	}
	
}	
}
 
 foreach version in homogenous_cohorts heterogenous_cohorts{
global directory_dataREV2012 "$directory_data\\`version'\\results\\_REV\\2012"
global first_voting_date = 14
global voting_fq = 10
forvalues i = 1(1)1{			
	************************REV_wbar**************************
	foreach var in REV_rbar {	
	clear
	global var4 "_fC_fC_`var'_trans_ff"
	    cd "$directory_dataREV2012"
		clear all  
		insheet using "`i'v0s$var4.txt", clear
		rename v1 $name0
		gen Year = _n +1998
	cd "$directory_plots"
		save `version'_`i'v0s$var4 , replace
		clear 
		
	cd "$directory_dataREV2012"	
		insheet using "`i'v1s$var4.txt", clear
		rename v1 $name1
		gen Year = _n + 1998
	cd "$directory_plots"
		save `version'_`i'v1s$var4, replace
		clear
		
	cd "$directory_dataREV2012 "	
		insheet using "`i'v2s$var4.txt", clear
		rename v1 $name2
		gen Year = _n + 1998
	cd "$directory_plots"	
		save `version'_`i'v2s$var4, replace
		clear
		
	cd "$directory_dataREV2012 "	
		insheet using "`i'v3s$var4.txt", clear
		rename v1 $name4
		gen Year = _n + 1998
	cd "$directory_plots"	
		save `version'_`i'v4s$var4, replace
				
		merge 1:1 Year using `version'_`i'v1s$var4
		drop _merge
		tsset Year
		save `version'_merged_big_k, replace
		
		merge 1:1 Year using `version'_`i'v2s$var4
		drop _merge
		tsset Year
		save `version'_merged_big_k, replace
		
		merge 1:1 Year using `version'_`i'v0s$var4
		drop _merge
		tsset Year
		save `version'_merged_big_k, replace

		gen delta1 = 100*($name1-$name0 )
		gen delta2 = 100*($name2-$name0 )
		gen delta3 = 100*($name4-$name0 )
		tsset Year
		
		twoway (tsline delta1, lpattern(solid))  ///
			(tsline delta2, lpattern(dash))  ///
			(tsline delta3, lpattern(dot) lwidth(medium))  ///
			if (Year < 2180 ), ytitle("") legend(ring(0) position(3)cols(1) lcolor(none) region(lcolor(none)) ///
				order(1 "Policy 1" 2 "Policy 2" 3 "Policy 3"  )) ///
			xlabel(#10)  
		
		graph save "`version'_`i'_`var'.gph", replace
		graph export "`version'_`i'_`var'.png", replace
	}
	
}	
}

// Adjustments in capital $K_t$ (left) and labor supply $L_t$ (right)
set scheme burd
global name1 FpolicyScenario
global name2 SpolicyScenario
global name4 TpolicyScenario
global name0 no_policy_change

 foreach version in homogenous_cohorts heterogenous_cohorts{
global directory_dataREV2012 "$directory_data\\`version'\\results\\_REV\\2012"
global first_voting_date = 14
global voting_fq = 10
forvalues i = 1(1)1{			
	************************REV_wbar**************************
	foreach var in bigK bigL  {	
	clear
	global var4 "_fC_fC_REV_`var'_trans_ff"
	    cd "$directory_dataREV2012"
		clear all  
		insheet using "`i'v0s$var4.txt", clear
		rename v1 $name0
		gen Year = _n +1998
	cd "$directory_plots"
		save `version'_`i'v0s$var4 , replace
		clear 
		
	cd "$directory_dataREV2012"	
		insheet using "`i'v1s$var4.txt", clear
		rename v1 $name1
		gen Year = _n + 1998
	cd "$directory_plots"
		save `version'_`i'v1s$var4, replace
		clear
		
	cd "$directory_dataREV2012"	
		insheet using "`i'v2s$var4.txt", clear
		rename v1 $name2
		gen Year = _n + 1998
	cd "$directory_plots"	
		save `version'_`i'v2s$var4, replace
		clear
		
	cd "$directory_dataREV2012"	
		insheet using "`i'v3s$var4.txt", clear
		rename v1 $name4
		gen Year = _n + 1998
	cd "$directory_plots"	
		save `version'_`i'v4s$var4, replace
				
		merge 1:1 Year using `version'_`i'v1s$var4
		drop _merge
		tsset Year
		save `version'_merged_big_k, replace
		
		merge 1:1 Year using `version'_`i'v2s$var4
		drop _merge
		tsset Year
		save `version'_merged_big_k, replace
		
		merge 1:1 Year using `version'_`i'v0s$var4
		drop _merge
		tsset Year
		save `version'_merged_big_k, replace

		gen delta1 = $name1/$name0
		gen delta2 = $name2/$name0
		gen delta3 = $name4/$name0
		tsset Year
		
		twoway (tsline delta1, lpattern(solid))  ///
			(tsline delta2, lpattern(dash))  ///
			(tsline delta3, lpattern(dot) lwidth(medium))  ///
			if (Year < 2180 ), ytitle("") legend(ring(0) position(2)cols(1) lcolor(none) region(lcolor(none)) ///
				order(1 "Policy 1" 2 "Policy 2" 3 "Policy 3"  )) ///
			xlabel(#10)  
		
		graph save "`version'_`i'_`var'.gph", replace
		graph export "`version'_`i'_`var'.png", replace
	}
	
}	
}
 
// altruism 
clear all

clear
foreach Year in 2012 2192 {
	foreach version in homogenous_cohorts  heterogenous_cohorts {
		foreach altruism_type in e_no_type_inheritance e{
			forvalues scenario = 1 (1) 3 { 
				clear 	
				cd "$directory_data\\`version'\\results\\_REV\\`Year'\\"
				import delimited "1v`scenario's_fC_fC_altruism_sub_brute_forc`altruism_type'.csv", delimiter(";") clear 
				replace support = 100* support
				rename support support_`scenario'
				save altruism_`altruism_type'_`version'_`scenario'_`Year', replace
}

			forvalues scenario = 1 (1) 2 { 
				merge 1:1 altruism using altruism_`altruism_type'_`version'_`scenario'_`Year'
				drop _merge 
			}
	cd "$directory_plots"	
			save `version'_altruism_`altruism_type'_`Year', replace

drop if  altruism >0.98
gen nr =_n
tsset nr
hprescott support_1, stub(HP)
hprescott support_2, stub(HP)
hprescott support_3, stub(HP)
renpfix HP_					
			
			graph twoway ///
						(line support_1 altruism, lpattern(dot) lwidth(medium)) ///
						(line support_2 altruism, lpattern(dash) lwidth(medium)) ///
						(line support_3 altruism, lpattern(solid) lwidth(medium)), ///
						legend(ring(0) position(8) cols(1)  lcolor(none) region(lcolor(none)) order(1 "Policy 1" 2 "Policy 2" 3 "Policy 3") )	ytitle("Political support") xtitle("Altruism") 	yline(50, lcolor(red))
						graph save "`version'_altruism_`altruism_type'_`Year'.gph", replace
						graph export "`version'_altruism_`altruism_type'_`Year'.png", replace
						
									graph twoway ///
						(line support_1_sm_1 altruism, lpattern(dot) lwidth(medium)) ///
						(line support_2_sm_1 altruism, lpattern(dash) lwidth(medium)) ///
						(line support_3_sm_1 altruism, lpattern(solid) lwidth(medium)), ///
						legend(ring(0) position(8) cols(1)  lcolor(none) region(lcolor(none)) order(1 "Policy 1" 2 "Policy 2" 3 "Policy 3") )	ytitle("Political support") xtitle("Altruism") 	yline(50, lcolor(red))
						graph save "HP_`version'_altruism_`altruism_type'_`Year'.gph", replace
						graph export "HP_`version'_altruism_`altruism_type'_`Year'.png", replace
		}
	}
}

/*______________________________________________
|                   Poverty                     |
|______________________________________________ */

* Purpose: enters each directory in dir_list and produces a *.dta file with lifecycle outcomes of subcohorts

set more off
clear all


* declare the number of periods
* CRUCIAL Number has to be in line with 
* yhe number of rows in base_fC_fC_c_j_trans_payg
* devideb by j and sub 
global t = 441 

* declare maximum age 
global j = 80

*declare the number of subcohorts(heterogeneity)
global sub = 30

global directory_data "E:\voting_results_and_code"
global directory_plots "E:\Dropbox (UW)\NCN EMERYT\_Paper_10_political_economy\voting\_graphix\_rev"

	foreach version in heterogenous_cohorts {
clear 
gen TempVar = . 
save c_j_lifecycle, replace
clear 		
		cd "$directory_data\\`version'\\results\\_REV\\2012\\"
		insheet using "base_fC_fC_c_j_trans_payg.txt"
		rename v1 c_db
		gen id = _n
		gen age = 1 + mod(id-1, $j)
		gen sg = ceil(id/($j*$t))
		gen Year = ceil(id/$j) - (sg-1)*$t
		replace Year = Year + 1998
		
		cd "$directory_plots"
		save "`version'_c_j_lifecycle",replace 
		
		clear 
		cd "$directory_data\\`version'\\results\\_REV\\2012\\"
		insheet using "base_fC_fC_c_j_trans_ff.txt"
		rename v1 c_dc
		gen id = _n
		gen sg = 1 + mod(id-1, $sub)
		gen Year = ceil(id/($j*$sub))
		
		gen age = 80+ ceil(id/$sub) - Year*$j
		replace Year = Year + 1998
		cd "$directory_plots"
		merge 1:1 age sg Year using "`version'_c_j_lifecycle.dta"
		drop _merge	
		save `version'_c_j_lifecycle, replace
		
		
        cd "$directory_data\\`version'\\results\\_REV\\2012\\"
		clear 
		insheet using "1v1s_fC_fC_REV_c_j_trans_ff.txt"
		rename v1 c_1rev
		gen id = _n
		gen age = 1 + mod(id-1, $j)
		gen sg = ceil(id/($j*$t))
		gen Year = ceil(id/$j) - (sg-1)*$t
		replace Year = Year + 1998
	    cd "$directory_plots"
		merge 1:1 age sg Year using "`version'_c_j_lifecycle.dta"
		drop _merge
		save `version'_c_j_lifecycle, replace
		
		clear 
		cd "$directory_data\\`version'\\results\\_REV\\2012\\"
		insheet using "1v2s_fC_fC_REV_c_j_trans_ff.txt"
		rename v1 c_2rev
		gen id = _n
		gen age = 1 + mod(id-1, $j)
		gen sg = ceil(id/($j*$t))
		gen Year = ceil(id/$j) - (sg-1)*$t
		replace Year = Year + 1998
        cd "$directory_plots"
		merge 1:1 age sg Year using "`version'_c_j_lifecycle.dta"
		drop _merge
		save `version'_c_j_lifecycle, replace
		
		clear 
		cd "$directory_data\\`version'\\results\\_REV\\2012\\"
		insheet using "1v3s_fC_fC_REV_c_j_trans_ff.txt"
		rename v1 c_3rev
		gen id = _n
		gen age = 1 + mod(id-1, $j)
		gen sg = ceil(id/($j*$t))
		gen Year = ceil(id/$j) - (sg-1)*$t
		replace Year = Year + 1998
        cd "$directory_plots"
		merge 1:1 age sg Year using "`version'_c_j_lifecycle.dta"
		drop _merge
		save `version'_c_j_lifecycle, replace
		
clear
			import excel "$directory_data\\`version'\\results\\subcohorts.xlsx", sheet("Sheet1")		
			gen sg = _n
 
			ren A size
			ren B omega
			ren C phi
			ren D delta
			drop E

			merge m:m sg using "`version'_c_j_lifecycle.dta"
			drop _merge
			order sg age size omega phi delta
			sort sg age Year
			save "`version'_c_j_lifecycle.dta", replace

			clear
			
			cd "$directory_data\\`version'\\results\\_REV\\2012\\"
			insheet using  "N_ij.txt"
			gen id = _n
			ren v1 pop
			capture recast float pop
			gen age = 1 + mod(id-1, $j)
			gen Year = ceil(id/$j)
			replace Year = Year + 1998
			order age Year
			drop id
			cd "$directory_plots"
			merge 1:m age Year using "`version'_c_j_lifecycle.dta"
			drop _merge
			gen weights = round(size*pop)
			gen weights_in = weights*10^7
			
			save "`version'_c_j_lifecycle.dta", replace		

			global var "c_db c_dc c_1rev c_2rev c_3rev "
			
			
			
		foreach var in $var{
			gen mdn_`var' = . 
			forvalues y = 1999(1)2299 {
					summarize `var' if Year == `y' [fweight = weights_in], detail
					replace mdn_`var' = r(p50) if Year == `y' 
				}	
				gen mdn60_`var' = .
				gen poverty_`var' = .
				gen pop_`var' = .				
				replace mdn60_`var' = 0.6*mdn_`var' 
				replace poverty_`var' = 0 if `var' >= mdn60_`var' 
				replace poverty_`var' = 1 if `var'<  mdn60_`var'
				replace pop_`var' = poverty_`var' * weights_in
			}	
			
		    foreach var in $var{	
				gen mdn60_abs_`var' = .
				gen poverty_abs_`var' = .
				gen pop_abs_`var' = .				
				replace mdn60_abs_`var' = 0.6*mdn_`var'[1] 
				replace poverty_abs_`var' = 0 if `var' >= mdn60_abs_`var' 
				replace poverty_abs_`var' = 1 if `var'<  mdn60_abs_`var'
				replace pop_abs_`var' = poverty_abs_`var' * weights_in
			}	
		
			bys Year: egen sum_pop_total = total(weights_in)
			
			foreach var in $var{
				bys Year: egen sum_pop_`var' = total(pop_`var')
				bys Year: gen proc_`var' = sum_pop_`var'/sum_pop_total 
			}
			
			save "`version'_c_j_lifecycle.dta", replace					


			foreach var in $var{
				gen poverty_old_`var' = . 
				gen pop_old_`var' = .				
				replace poverty_old_`var' = 0 if `var' >= mdn60_`var' | age < 45
				replace poverty_old_`var' = 1 if `var' <  mdn60_`var' & age >=45
				replace pop_old_`var' = poverty_old_`var' * weights_in
			}	
			foreach var in $var{
				gen poverty_old_abs_`var' = .
				gen pop_old_abs_`var' = .				
				replace poverty_old_abs_`var' = 0 if `var' >= mdn60_abs_`var' | age < 45
				replace poverty_old_abs_`var' = 1 if `var' <  mdn60_abs_`var' & age >=45
				replace pop_old_abs_`var' = poverty_old_abs_`var' * weights_in
			}	
			
			bys Year : egen sum_pop_old = total(weights_in) if age >= 45
			
			foreach var in $var{
				bys Year: egen sum_pop_old_`var' = total(pop_old_`var')
				bys Year: gen proc_old_`var' = sum_pop_old_`var'/sum_pop_old
			}
			
			save "`version'_c_j_lifecycle.dta", replace					


			foreach var in $var{
				bys Year: egen sum_pop_abs_`var' = total(pop_abs_`var')
				bys Year: gen proc_abs_`var' = sum_pop_abs_`var'/sum_pop_total 
				bys Year: egen sum_pop_old_abs_`var' = total(pop_old_abs_`var')
				bys Year: gen proc_old_abs_`var' = sum_pop_old_abs_`var'/sum_pop_old
			}
			save "`version'_c_j_lifecycle.dta", replace	
			keep Year proc_*
			save poverty_c_j, replace
			duplicates drop
			drop if proc_old_c_db == .
			save poverty_c_j, replace 
			
			
			
			tsset Year
			foreach var of varlist _all {
				hprescott `var', stub(HP)
			}
			
keep Year *sm_1
drop HP_Year_sm_1

renpfix HP_
rensfix _sm_1 

twoway	(line proc_c_db Year, lpattern(solid) lwidth(medium) lcolor(black) )  (line  proc_c_dc Year, lpattern(solid) lwidth(medium) lcolor(gs12)) ///
		(line proc_c_1rev Year, lpattern(dot) lwidth(thick)) ///
		(line proc_c_2rev Year, lpattern(longdash) lwidth(thick)) ///
		(line proc_c_3rev Year, lpattern(shortdash) lwidth(thick)) if Year <2180, ///
 ytitle("") legend(ring(0) position(5) cols(1) lcolor(none) ///
 region(lcolor(none)) order(1 "DB"  2 "FDC" 3 "Policy 1" 4 "Policy 2" 5 "Policy 3"  )) xlabel(2000(20)2180)
graph save Graph "poverty_all_combine.gph", replace
graph export "poverty_all_combine.png", replace

twoway (line proc_abs_c_db Year , lpattern(solid) lwidth(medium) lcolor(black))  ///
(line  proc_abs_c_dc Year, lpattern(solid) lwidth(medium) lcolor(gs12))  ///
(line  proc_abs_c_1rev Year, lpattern(dot) lwidth(thick)) ///  
(line  proc_abs_c_2rev Year, lpattern(longdash) lwidth(thick))  ///
(line  proc_abs_c_3rev Year, lpattern(shortdash) lwidth(thick)) if Year <2180, ///
ytitle("") legend(ring(0) position(5)cols(1) lcolor(none) region(lcolor(none)) ///
order(1 "DB"  2 "FDC" 3 "Policy 1" 4 "Policy 2" 5 "Policy 3"  )) xlabel(2000(20)2180)
graph save Graph "poverty_abs_all_combine.gph", replace
graph export "poverty_abs_all_combine.png", replace

twoway (line proc_old_c_db Year, lpattern(solid) lwidth(medium) lcolor(black) ) ///
	(line  proc_old_c_dc Year, lpattern(solid) lwidth(medium) lcolor(gs12)) ///
	(line  proc_old_c_1rev Year, lpattern(dot) lwidth(thick)) ///
	(line  proc_old_c_2rev Year, lpattern(longdash) lwidth(thick))  ///
	(line  proc_old_c_3rev Year, lpattern(shortdash) lwidth(thick)) if Year <2180, ///
	ytitle("") legend(ring(0) position(8)cols(1) lcolor(none) region(lcolor(none)) ///
	order(1 "DB"  2 "FDC" 3 "Policy 1" 4 "Policy 2" 5 "Policy 3"  )) xlabel(2000(20)2180)
graph save Graph "poverty_old_combine.gph", replace
graph export "poverty_old_combine.png", replace

twoway (line proc_old_abs_c_db Year, lpattern(solid) lwidth(medium) lcolor(black) )  ///
    (line  proc_old_abs_c_dc Year, lpattern(solid) lwidth(medium) lcolor(gs12)) ///
	(line  proc_old_abs_c_1rev Year, lpattern(dot) lwidth(thick))  ///
	(line  proc_old_abs_c_2rev Year, lpattern(longdash) lwidth(thick))  ///
	(line  proc_old_abs_c_3rev Year, lpattern(shortdash) lwidth(thick)) if Year <2180, ///
	ytitle("") legend(ring(0) position(2)cols(1) lcolor(none) region(lcolor(none)) ///
	order(1 "DB"  2 "FDC" 3 "Policy 1" 4 "Policy 2" 5 "Policy 3"  )) xlabel(2000(20)2180)
graph save Graph "poverty_abs_old_combine.gph", replace
graph export "poverty_abs_old_combine.png", replace

}




// plots for heterogenous welfare in REF case 
set scheme burd

global labellessone "mlabel(beta) mlabcolor(black) mlabpos(9) msymbol(t) msize(medium) mcolor(black) "
global labelone		"mlabel(beta) mlabcolor(black) mlabpos(9) msymbol(o) msize(medium) mcolor(black) "
global labelmoreone	"mlabel(beta) mlabcolor(black) mlabpos(9) msymbol(s) msize(medium) mcolor(black) "

foreach version in heterogenous_cohorts {
global x_begin =1999-100
global x_end = 1999+80
*votingdate
		import delimited "$directory_data\\`version'\\results\\_REF1999\\_standard\\fC_fC_x_j.csv",  delimiter(";") clear

gen id = _n
keep if mod(id,80) == 0
replace id = _n
gen beta = 0
replace beta = 0.988 if mod(id,3) == 1
replace beta = 1 if mod(id,3) == 2
replace beta = 1.012 if mod(id,3) == 0

gen omega = 0
forvalues omega = 1(1)10 {
replace omega = `omega' if floor((id-1)/3)+1==mod(`omega',10)
}

replace omega = 10 if omega==0

reshape long v, i(id)

ren v welfare
label variable welfare "compensating variation"

replace welfare = 100* welfare
ren _j birthyear
label variable birthyear  "year of birth"
replace birthyear = birthyear + 1998 -100 -1
 
tsset id birthyear
save "$directory_plots\\`version'_REF_welfare.dta", replace
 *votingdate
		import delimited "$directory_data\\homogenous_cohorts\\results\\_REF1999\\_standard\\fC_fC_x_j.csv",  delimiter(";") clear

gen id = _n
keep if mod(id,80) == 0
reshape long v, i(id)

ren v welfare
label variable welfare "compensating variation"
replace welfare = 100* welfare
ren _j birthyear
label variable birthyear  "year of birth"
replace birthyear = _n+ 1998 -100 -1
gen beta = 0
gen omega = 0

append using "$directory_plots\\`version'_REF_welfare.dta"
	
twoway 	(scatter welfare birthyear if beta<1 & beta>0,  msymbol(th) msize(vsmall) mcolor(navy) jitter(1) )   		///
		(scatter welfare birthyear if beta==1, 			msymbol(oh) msize(vsmall) mcolor(cranberry) jitter(1) ) 		///
		(scatter welfare birthyear if beta>1,  			msymbol(sh) msize(vsmall) mcolor(green) jitter(1) )		 ///
		(line welfare birthyear if beta ==0 , lcolor(black)  lwidth(medium) ) ///
		if birthyear<$x_end & birthyear>=$x_begin, ///
		text(-3 1914 "pensioners", size(small) color(gs8)) ///
		text(10 1948 "cohorts" "remaining" "in DB", size(small) color(gs8)) ///
		text(6 1968 "transitional" "cohorts", size(small) color(gs8)) ///
		text(-3 2010 "actual" "reform", color(cranberry)) ///
		text(10 2002 "cohorts entering" "labor market after" "introduction of DC", size(small) color(gs8) ) ///
		yline(0) xline(1938, lcolor(gs8)) xline(1958, lcolor(gs8)) xline(1979, lcolor(gs8))  xline(1999, lcolor(cranberry) lwidth(medthick))    ///
		xlabel($x_begin (20) $x_end, add) ///
		ytitle("welfare measured as" "% of lifetime consumption") xtitle("Date of birth" ) ///
 		legend(position(5) ring(0) cols(1) region(lcolor(none) color(none)) ///
		order(1 "{&delta}{sub:{&kappa}}= 0.988"  2 "{&delta}{sub:{&kappa}}= 1" ///
		3 "{&delta}{sub:{&kappa}}= 1.012"  4 "no intra-cohort" "heterogeneity" ))	
		
graph save "$directory_plots\\`version'_REF_welfare_line.gph", replace
graph export "$directory_plots\\`version'_REF_welfare_line.png", replace

twoway 	(scatter welfare birthyear if beta<1 & beta>0,  msymbol(th) msize(vsmall) mcolor(gs6) jitter(1) )   		///
		(scatter welfare birthyear if beta==1, 			msymbol(oh) msize(vsmall) mcolor(gs12) jitter(1) ) 		///
		(scatter welfare birthyear if beta>1,  			msymbol(sh) msize(vsmall) mcolor(black) jitter(1) )		 ///
		(line welfare birthyear if beta ==0 , lcolor(black)  lwidth(medium) ) ///
		if birthyear<$x_end & birthyear>=$x_begin, ///
		text(-3 1914 "pensioners", size(small) color(gs8)) ///
		text(10 1948 "cohorts" "remaining" "in DB", size(small) color(gs8)) ///
		text(6 1968 "transitional" "cohorts", size(small) color(gs8)) ///
		text(-3 2010 "actual" "reform", color(cranberry)) ///
		text(10 2002 "cohorts entering" "labor market after" "introduction of DC", size(small) color(gs8) ) ///
		yline(0) xline(1938, lcolor(gs8)) xline(1958, lcolor(gs8)) xline(1979, lcolor(gs8))  xline(1999, lcolor(cranberry) lwidth(medthick))    ///
		xlabel($x_begin (20) $x_end, add) ///
		ytitle("welfare measured as" "% of lifetime consumption") xtitle("Date of birth" ) ///
 		legend(position(5) ring(0) cols(1) region(lcolor(none) color(none)) ///
		order(1 "{&delta}{sub:{&kappa}}= 0.988"  2 "{&delta}{sub:{&kappa}}= 1" ///
		3 "{&delta}{sub:{&kappa}}= 1.012"  4 "no intra-cohort" "heterogeneity" ))		
		
		
graph save "$directory_plots\\`version'_REF_welfare_line_bw.gph", replace
graph export "$directory_plots\\`version'_REF_welfare_line_bw.png", replace
}



		

// plots for heterogenous welfare  in the REV case 
set scheme burd

global labellessone "mlabel(beta) mlabcolor(black) mlabpos(6) msymbol(t) msize(medium) mcolor(black)"
global labelone		"mlabel(beta) mlabcolor(black) mlabpos(3) msymbol(o) msize(medium) mcolor(black)"
global labelmoreone	"mlabel(beta) mlabcolor(black) mlabpos(12) msymbol(s) msize(medium) mcolor(black)"

foreach version in heterogenous_cohorts{
	foreach  year of numlist 2012 2192 {
		global x_begin =`year'-102 
		global x_end = `year'+80
		global ret_yob = `year' -61
		global ret_yob_label = `year' -61 -20
		*votingdate
			forvalues scenario = 1 (1) 3 { 
				import delimited "$directory_data\\`version'\\results\\_REV\\`year'\1v`scenario's_fC_fC_x_j.csv",  delimiter(";") clear
				gen id = _n
				keep if mod(id,80) == 0
				replace id = _n
				gen beta = 0
				replace beta = 0.988 if mod(id,3) == 1
				replace beta = 1 if mod(id,3) == 2
				replace beta = 1.012 if mod(id,3) == 0
				gen omega = 0
					forvalues omega = 1(1)10 {
						replace omega = `omega' if floor((id-1)/3)+1==mod(`omega',10)
					}

		replace omega = 10 if omega==0

		reshape long v, i(id)
		ren v welfare
		label variable welfare "compensating variation"

		replace welfare = 100* welfare
		ren _j birthyear
		label variable birthyear  "year of birth"
		replace birthyear = birthyear + 1998 -100 -1
		 
		tsset id birthyear
		save "$directory_plots\\`version'_`scenario'_`year'_welfare.dta", replace

		twoway 	(scatter welfare birthyear if beta<1, mcolor(red) msymbol(th) msize(vsmall) jitter(1))		(scatter welfare birthyear if omega==5 & beta<1 & beta>0 & birthyear==`year'-60,  $labellessone ) ///
				(scatter welfare birthyear if beta==1, mcolor(blue) msymbol(oh) msize(vsmall) jitter(1))	(scatter welfare birthyear if omega==5 & beta==1 & birthyear==`year'-60,  $labelone ) ///
				(scatter welfare birthyear if beta>1, mcolor(green) msymbol(sh) msize(vsmall) jitter(1))	(scatter welfare birthyear if omega==5 & beta>1 & birthyear==`year'-60, $labelmoreone ) ///
				if birthyear<$x_end  & birthyear>=$x_begin , ///
				xlabel($x_begin (20) $x_end, add) ylabel(-2(1)2) text(-1 $ret_yob_label "pensioners") yline(0) xline ($ret_yob)  ///
				ytitle("welfare measured as" "% of lifetime consumption") xtitle("Date of birth" ) ///
				legend(position(2) ring(0) cols(1) region(lcolor(none) color(none)) ///
				order(1 "{&delta}{sub:{&kappa}}= 0.988"  3 "{&delta}{sub:{&kappa}}= 1" 5 "{&delta}{sub:{&kappa}}= 1.012" ) )

		graph save "$directory_plots\\`version'_`scenario'_`year'_welfare.gph", replace
		graph export "$directory_plots\\`version'_`scenario'_`year'_welfare.png", replace
		
		
				twoway 	(scatter welfare birthyear if beta<1, mcolor(red) msymbol(th) mcolor(gs6) msize(vsmall) jitter(1))	 ///
				(scatter welfare birthyear if beta==1, mcolor(blue) msymbol(oh) mcolor(gs12) msize(vsmall) jitter(1))	 ///
				(scatter welfare birthyear if beta>1, mcolor(green) msymbol(sh) mcolor(black) msize(vsmall) jitter(1))	 ///
				if birthyear<$x_end  & birthyear>=$x_begin , ///
				xlabel($x_begin (20) $x_end, add) ylabel(-2(1)2) text(-1 $ret_yob_label "pensioners") yline(0) xline ($ret_yob)  ///
				ytitle("welfare measured as" "% of lifetime consumption") xtitle("Date of birth" ) ///
				legend(position(2) ring(0) cols(1) region(lcolor(none) color(none)) ///
				order(1 "{&delta}{sub:{&kappa}}= 0.988"  2 "{&delta}{sub:{&kappa}}= 1" 3 "{&delta}{sub:{&kappa}}= 1.012" ) )

		graph save "$directory_plots\\`version'_`scenario'_`year'_welfare_bw.gph", replace
		graph export "$directory_plots\\`version'_`scenario'_`year'_welfare_bw.png", replace
		
		
		}
	}
}



// OPD suppport table 

foreach version in homogenous_cohorts{
clear
gen TempVar = .
save "$directory_plots\\`version'_OPD_support.dta", replace
	foreach  OPD_dist of numlist 4 10 20 30 {
	foreach  year of numlist 2012 2162 2192{
	clear 
	cd "$directory_data\\`version'\\results\\_OPD\\k`OPD_dist'\\"
	insheet using"`year'\0_3_con&bon_support_change_vs_zero.txt", clear
	gen id = _n
	keep if id == 3
	gen year = `year'
	gen k = `OPD_dist'
	
	append using "$directory_plots\\`version'_OPD_support.dta"
	save "$directory_plots\\`version'_OPD_support.dta", replace
	}
}
}

drop TempVar 

reshape wide v1, i(k) j(year)
