**Code to conduct the one sample MR analysis in "Mendelian Randomisation Analysis of the effect of educational attainment and cognitive ability on smoking"
 
*Uses UK Biobank data with individuals removed as described in the paper. 

**import the cleaned dataset that only includes individuals included in the analysis. 
use onesamplebiobankdata.dta

global controls i.year_of_birth i.year_of_birth#female age pc1 - pc40 

ivreg2 smoke_now (eduyears IQ_combined_std = GCA_score Education_score) $controls, robust ffirst 
gen inreg = e(sample)

ivreg2 smoke_ever (eduyears IQ_combined_std = GCA_score Education_score) $controls, robust ffirst 
ivreg2 smoke_former (eduyears IQ_combined_std = GCA_score Education_score) $controls, robust ffirst 


**OLS regressions 
reg smoke_now eduyears IQ_combined_std $controls if inreg == 1, robust
reg smoke_ever eduyears IQ_combined_std $controls if inreg == 1, robust
reg smoke_former eduyears IQ_combined_std $controls if inreg == 1, robust


*Single variable IV regressions

ivreg2 smoke_now (eduyears = Education_score) $controls if inreg == 1, robust ffirst 
ivreg2 smoke_ever (eduyears = Education_score) $controls if inreg == 1, robust ffirst 
ivreg2 smoke_former (eduyears = Education_score) $controls  if inreg == 1, robust ffirst 

ivreg2 smoke_now (IQ_combined_std = GCA_score) $controls if inreg == 1, robust ffirst 
ivreg2 smoke_ever (IQ_combined_std = GCA_score) $controls  if inreg == 1, robust ffirst 
ivreg2 smoke_former (IQ_combined_std = GCA_score) $controls if inreg == 1, robust ffirst 


**comparison between educational attainment years and self-reported age left education
*education

tab eduyears
tab eduyears if inreg == 1
tab left_education if inreg == 1


*smoking

tab smoke_ever smoke_now if inreg == 1, row col


**supplementary IV regressions***

/*with alternative education definitions*/
ivreg2 smoke_now (left_education IQ_combined_std = GCA_score Education_score) $controls  if inreg == 1 , robust ffirst
ivreg2 smoke_ever (left_education IQ_combined_std = GCA_score Education_score) $controls if inreg == 1 , robust ffirst
ivreg2 smoke_former (left_education IQ_combined_std = GCA_score Education_score) $controls if inreg == 1 , robust ffirst

**OLS regressions 
reg smoke_now left_education IQ_combined_std $controls if inreg == 1, robust
reg smoke_ever left_education IQ_combined_std $controls if inreg == 1, robust
reg smoke_former left_education IQ_combined_std $controls if inreg == 1, robust

*Single variable IV regressions
ivreg2 smoke_now (left_education = Education_score) $controls if inreg == 1, robust ffirst 
ivreg2 smoke_ever (left_education = Education_score) $controls if inreg == 1, robust ffirst 
ivreg2 smoke_former (left_education = Education_score) $controls  if inreg == 1, robust ffirst 

ivreg2 smoke_now (IQ_combined_std = GCA_score) $controls if inreg == 1, robust ffirst 
ivreg2 smoke_ever (IQ_combined_std = GCA_score) $controls  if inreg == 1, robust ffirst 
ivreg2 smoke_former (IQ_combined_std = GCA_score) $controls if inreg == 1, robust ffirst 


/*with only at clinic cognition testing*/
ivreg2 smoke_now (eduyears IQ_std = GCA_score Education_score) $controls, robust ffirst 
gen inregclinic = e(sample)
ivreg2 smoke_ever (eduyears IQ_std = GCA_score Education_score) $controls if inregclinic == 1, robust ffirst 
ivreg2 smoke_former (eduyears IQ_std = GCA_score Education_score) $controls if inregclinic == 1, robust ffirst 

ivreg2 smoke_now (eduyears = Education_score) $controls if inregclinic == 1, robust ffirst 
ivreg2 smoke_ever (eduyears = Education_score) $controls if inregclinic == 1, robust ffirst 
ivreg2 smoke_former (eduyears = Education_score) $controls if inregclinic == 1, robust ffirst 

ivreg2 smoke_now (IQ_std = GCA_score) $controls if inregclinic == 1, robust ffirst 
ivreg2 smoke_ever (IQ_std = GCA_score) $controls if inregclinic == 1, robust ffirst 
ivreg2 smoke_former (IQ_std = GCA_score) $controls if inregclinic == 1, robust ffirst 

reg smoke_now eduyears IQ_std $controls if inregclinic == 1, robust
reg smoke_ever eduyears IQ_std $controls if inregclinic == 1, robust
reg smoke_former eduyears IQ_std $controls  if inregclinic == 1, robust



/*weighting by selection into the sample 
see Hughes et al 'Selection bias in instrumental variable analysis' 
*/

gen weight_NQ_deg = 2.01
replace weight_NQ_deg = 1 if eduyears>15
replace weight_NQ_deg = 0.77 if eduyears >20

ivreg2 smoke_now (eduyears IQ_combined_std = GCA_score Education_score) $controls [weight=weight_NQ_deg], robust ffirst
ivreg2 smoke_ever (eduyears IQ_combined_std = GCA_score Education_score) $controls [weight=weight_NQ_deg], robust ffirst
ivreg2 smoke_former (eduyears IQ_combined_std = GCA_score Education_score) $controls [weight=weight_NQ_deg], robust ffirst 

**OLS regressions 
reg smoke_now eduyears IQ_combined_std $controls [weight=weight_NQ_deg] if inreg == 1, robust
reg smoke_ever eduyears IQ_combined_std $controls [weight=weight_NQ_deg] if inreg == 1, robust
reg smoke_former eduyears IQ_combined_std $controls [weight=weight_NQ_deg] if inreg == 1, robust

*Single variable IV regressions
ivreg2 smoke_now (eduyears = Education_score) $controls [weight=weight_NQ_deg] if inreg == 1, robust ffirst 
ivreg2 smoke_ever (eduyears = Education_score) $controls [weight=weight_NQ_deg] if inreg == 1, robust ffirst 
ivreg2 smoke_former (eduyears = Education_score) $controls [weight=weight_NQ_deg] if inreg == 1, robust ffirst 

ivreg2 smoke_now (IQ_combined_std = GCA_score) $controls [weight=weight_NQ_deg] if inreg == 1, robust ffirst 
ivreg2 smoke_ever (IQ_combined_std = GCA_score) $controls [weight=weight_NQ_deg] if inreg == 1, robust ffirst 
ivreg2 smoke_former (IQ_combined_std = GCA_score) $controls [weight=weight_NQ_deg] if inreg == 1, robust ffirst 

