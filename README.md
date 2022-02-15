This package provides full replication codes for the paper "Political Instability of Funded Social Security" by R. Beetsma, O. Komada, K. Makarski, J. Tyrowicz, Journal of Economic Dynamics and Control, 2021, https://doi.org/10.1016/j.jedc.2021.104237

You can read more about this paper (slides from talks, etc.) here: https://grape.org.pl/article/political-instability-funded-pension-systems

The package provides
* RAR file with a full respositorium of the F90 files
* ZIP file with a full repositorium of the data files (which should be placed in the same directory as F90 files)
* STATA dofile which generates the full set of results based on computations performed on your computer
(Warning: the full set of results is 6+ GB of results)

To obtain the full results, follow the steps below (you will need to run Fortran simulations several times in configurations described below

-------	
I. Heterogenity of housueholds
-------
The code runs just as well with and without intra-cohort ex ante heterogeneity. The code will take different input files depending on whether you specify homogeneous cohorts or heterogeneous cohorts version. In this paper we assume that intra-cohort ex ante heterogeneity is of the following types: time discounting (3 types) and productivity (10 types), thus, in total, 30 types. 
You need the following settings to run:
1. no intra-cohort heterogeneity 
	```integer, parameter :: bigM = 1 ``` [go to globals.f90 line 136 ]
2. with intra-cohort heterogeneity 
	```integer, parameter :: bigM = 30 ``` [go to globals.f90 line 136 ]
	
There is also a way to include heterogenity in preferences for leisure if you want to do so you should set ```integer, parameter :: bigM = 120 ```  (compare lines 260-268 in data.f90)
				
-------		
II. Scenario type 
-------	
There are three types of scenario to run. The general reform (with a fast fiscal adjustment and with a slow fiscal adjustment). You can also run the codes for one-period-deviation simulations and for the permanent change (welfare effects).

To run these three types of scenarios, you need ot change the settings in set_globals.f90
1. For the general reform (_REF1999) set:

```
switch_cons_equivalent = 1
switch_REV = 0 
switch_OPD = 0 
```
		
2. For the one-period-deviations set: 

```
switch_cons_equivalent = 0
switch_REV = 0 
switch_OPD = 1 
```

Then  specify how often votes take place (globals.f90):
- k4 :  ```OPD_dist = 4```
- k10 : ```OPD_dist = 10```
- k20 :  ```OPD_dist = 20```
- k30 : ```OPD_dist = 30```

Make sure that main_OPD.f90 has the right fiscal closure (cl = 0, which  refers to Fc-FC the main closure in the text), with the fiscal rule parameters (set to standard values in set_globals.f90)

3. For the permanent reform sumulations set:

```
switch_cons_equivalent = 0
switch_REV = 1 
switch_OPD = 0 
```

Then specify the date of the reform set the voting date variable (globals.f90):
- 2012 : ```first_voting_date = 14```
- 2162 : ```first_voting_date = 154```
- 2192 : ```first_voting_date = 174```


Make sure that main_OPD.f90 has the right fiscal closure (cl = 0, which  refers to Fc-FC the main closure in the text), with the fiscal rule parameters (set to standard values in set_globals.f90)

-------		
III. Fiscal closures 
-------	

The main fiscal closure in text is the one which balances between smoothing public debt and adjusting consumption taxes. This fuiscal rule is denoted in the code as Fc-Fc. You can set the values for balancing between debt and tax adjustment by working with the parameters in set_globals.f90:

```
tc_growth  = 0.050_dp
up_tc = 0.9_dp 
```

If you want to check alternative fiscal closures, you can choose from a variety of options in main_cons_eq.f90:
##### _fast_frule

```
cl = 29
tc_growth  = 0.07_dp 
up_tc = 0.9_dp 
switch_priv_share = 1
```
		
#####  _slow_frule

```
cl = 29
tc_growth  = 0.03_dp!
up_tc = 0.9_dp 
switch_priv_share = 1
```

#####  _standard

```
cl = 29
tc_growth  = 0.050_dp
up_tc = 0.9_dp 
switch_priv_share = 1
```

#####  _pure_dept

```
cl = 15 
switch_priv_share = 1
```

#####   _pure_TC

```
cl = 1 
switch_priv_share = 1
```

##### _purePAYG_DC

```
!closures
cl = 29
tc_growth  = 0.050_dp
up_tc = 0.9_dp 
! pension system 
switch_priv_share = 0
```
