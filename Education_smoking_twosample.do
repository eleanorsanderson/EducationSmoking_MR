 **Code to conduct the two sample MR analysis in "Mendelian Randomisation Analysis of the effect of educational attainment and cognitive ability on smoking"
 
 **uses data on snp exposure and snp outcome associations downloaded from MRbase.
 
 
 
*import the data - downloaded from MR base for all SNPs and combined.
 use twosampledata.dta, clear
 
keep if idoutcome == 962 | idoutcome == 963
label define outcomes 962 "intiation" 963 "cessation"
label var idoutcome outcomes

 **MVMR analysis
 **note these results are log odds ratios so need to be converted into odds ratios
bysort idoutcome: reg betaoutcome betaIQ betaEA [weight = seoutcome^-2], noc
bysort idoutcome: reg betaoutcome betaEA [weight = seoutcome^-2], noc
bysort idoutcome: reg betaoutcome betaIQ [weight = seoutcome^-2], noc

**calculating the Q statistic
reg betaoutcome betaIQ betaEA [aweight = 1/(seoutcome^2)] if idoutcome == 962, noc
*creating the weights
predict fitted, xb
gen double weight = seoutcome^2 + (_b[betaIQ]^2)*(seIQ^2) + (_b[betaEA]^2)*(seEA^2) 

reg betaoutcome betaIQ betaEA [aweight = 1/(seoutcome^2)] if idoutcome == 963, noc
predict fitted2, xb
replace fitted = fitted2 if idoutcome == 963
replace weight = seoutcome^2 + (_b[betaIQ]^2)*(seIQ^2) + (_b[betaEA]^2)*(seEA^2)  if idoutcome == 963

gen double Qtop = (betaoutcome - fitted)^2
gen Qsnp = Qtop/weight
bysort idoutcome: egen Q = sum(Qtop/weight)
tab Q


preserve

keep if idoutcome == 962
gen n = _n
twoway (scatter Qsnp n, mcolor(black) msize(small)), ytitle(Contribution to Q statistic) yscale(range(0 15)) yline(3.8, lpattern(dash) lcolor(black)) yline(14.5, lpattern(dot) lcolor(black)) ///
ylabel(#5) xtitle(SNP) xscale(range(0 330)) xlabel(none) title(Contribution to Q statistic for smoking intiation)
 graph save Graph "O:\IEU\aProjects\Education and IQ\analysis files\Two sample analysis\initiationQstat.gph", replace
 graph export "O:\IEU\aProjects\Education and IQ\analysis files\Two sample analysis\initiationQstat.png", as(png) replace
 
restore
preserve
keep if idoutcome == 963
gen n = _n
twoway (scatter Qsnp n, mcolor(black) msize(small)), ytitle(Contribution to Q statistic) yscale(range(0 15)) yline(3.8, lpattern(dash) lcolor(black)) yline(14.5, lpattern(dot) lcolor(black)) ///
ylabel(#5) xtitle(SNP) xscale(range(0 330)) xlabel(none) title(Contribution to Q statistic for smoking cessation)
 graph save Graph "O:\IEU\aProjects\Education and IQ\analysis files\Two sample analysis\cessationQstat.gph", replace
 graph export "O:\IEU\aProjects\Education and IQ\analysis files\Two sample analysis\cessationQstat.png", as(png) replace
 
restore


**MVMR Egger analysis

*create the orientated variables
foreach x in IQ EA {
gen change`x' = beta`x'<0
gen EA_adj`x' = betaEA
replace EA_adj`x' = -betaEA if change`x' == 1

gen IQ_adj`x' = betaIQ
replace IQ_adj`x' = -betaIQ if change`x' == 1

gen outcome_adj`x' = betaoutcome
replace outcome_adj`x' = -betaoutcome if change`x' == 1
}

*unorientated
bysort idoutcome: reg betaoutcome betaIQ betaEA [weight = seoutcome^-2]

*orientated by each exposure
foreach x in EA IQ {
bysort idoutcome: reg outcome_adj`x' EA_adj`x' IQ_adj`x' [weight = seoutcome^-2]
}

**individual MR egger analysis
bysort idoutcome: reg outcome_adjEA EA_adjEA [weight = seoutcome^-2]
bysort idoutcome: reg outcome_adjIQ IQ_adjIQ [weight = seoutcome^-2]


**repeat MVMR excluding snps with a high contribution to the Q stat

bysort idoutcome: reg betaoutcome betaIQ betaEA [weight = seoutcome^-2] if Qsnp < 3.8, noc
bysort idoutcome: reg betaoutcome  betaEA [weight = seoutcome^-2] if Qsnp < 3.8, noc
bysort idoutcome: reg betaoutcome betaIQ [weight = seoutcome^-2] if Qsnp < 3.8, noc

**recalculate Q with these SNPs excluded

preserve
drop if Qsnp > 3.8
bysort idoutcome: egen Q_restricted = sum(Qsnp)
tab Q_restricted Q  



