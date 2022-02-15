----------------------------------------------------------------------------------------------------------	
I. Code setup
----------------------------------------------------------------------------------------------------------

File "F90 files and project" consist of fortran files. 
To ran them properly you need to unpack the data files in the same directory.

----------------------------------------------------------------------------------------------------------	
II. Heterogenity of housueholds
----------------------------------------------------------------------------------------------------------	
You need the following settings to ran:

	1. homogenous_cohort version
			integer, parameter :: bigM = 1
				go to globals.f90 line 136 
				
	2. heterogenous_cohort varsion 
			integer, parameter :: bigM = 30 
				here there is heterogenous in time discount factor (3 types) and productivity (10 types)
				there is also a way to include heterogenity in preferences for leisure if you want to do so you should set bigM  to 120 (compare line 260-268 in data.f90)
				
----------------------------------------------------------------------------------------------------------	
III. Scenario type 
----------------------------------------------------------------------------------------------------------	
You need the following switch settings to ran : 

	1.  _REF1999
			in general you need to go to set_globals.f90 and set 
				switch_cons_equivalent = 1    
				switch_REV = 0                 
				switch_OPD = 0	
			then to specyfie the exact scenario from the list adhust the setting in a following way 
			go to main_cons_eq and choose 
				a) _fast_frule
						cl = 29
						tc_growth  = 0.07_dp 
						up_tc = 0.9_dp 
						switch_priv_share = 1
	
				b) _slow_frule
						cl = 29
						tc_growth  = 0.03_dp!
						up_tc = 0.9_dp 
						switch_priv_share = 1

				c) _standard
						cl = 29
						tc_growth  = 0.050_dp
						up_tc = 0.9_dp 
						switch_priv_share = 1
					 
				d) _pure_dept
					 cl = 15 
					 switch_priv_share = 1
				e) _pure_TC
					 cl = 1 
					 switch_priv_share = 1
				f) _purePAYG_DC
						!closures
					 	cl = 29
						tc_growth  = 0.050_dp
						up_tc = 0.9_dp 
						! pension system 
						switch_priv_share = 0
	
	2.  _REV 
			in general you need to go to set_globals.f90 and set 
				switch_cons_equivalent = 0    
				switch_REV = 1                 
				switch_OPD = 0
			then to specifies the date of the reform go to globals and  modifie the variable first_voting_date:
				a) 2012 -> first_voting_date = 14
				b) 2162 -> first_voting_date = 154
				c) 2192 -> first_voting_date = 174
			go to file main_REV.f90 to pickup closure by putting the right numebre to cl = 0  refers to Fc-FC the main closure in the text
			make sure that frule parametersis set tu a standard values (set_globals.f90):
						tc_growth  = 0.050_dp
						up_tc = 0.9_dp 
	
	3.  _OPD 
			in general you need to go to set_globals.f90 and set 
				switch_cons_equivalent = 0    
				switch_REV = 0                 
				switch_OPD = 1
			then to specifies how often votes take place go to globals and 
				a) k4	-> OPD_dist = 4
				b) k10	-> OPD_dist = 10
				c) k20	-> OPD_dist = 20
				d) k30  -> OPD_dist = 30
			go to file main_OPD.f90 to pickup closure by putting the right numebre to cl = 0  refers to Fc-FC the main closure in the text
			make sure that frule parametersis set tu a standard values (set_globals.f90):
						tc_growth  = 0.050_dp
						up_tc = 0.9_dp 
