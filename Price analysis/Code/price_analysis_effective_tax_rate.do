/* ******************************************************************** *
* ******************************************************************** *

*  Analysis of Pakistan Custom Data


       ** PURPOSE:      Exploring the dataset and analyzing the data

       ** OUTLINE:      PART 1: 
                        PART 2: 
                        PART 3: 
						
       ** IDS VAR:      hs_code, hs_2, hs_4

       ** NOTES:

       ** WRITEN BY:    Alice Duhaut, Kaustubh Chahande, Aram Gassama

       ** Last date modified:  29 July 2019
      
	 
* ******************************************************************** *
* ******************************************************************** */
	
	clear all
	set more off
	cap log close
	set maxvar 32767
	set matsize 800
	
	version 12.1
	
  
	dis "`c(username)'" // The text that shows up is the username of your computer (say XXX), and insert that into the code below

	*change to working directory

	* Alice
	if c(username)=="wb495814" {
           * Put general folder where data and codes are stored, @Alice check that your path is correct.
		   * I would though prefer you to put a linked to a desktop version of 
		   * the folder if possible to avoid using dircetly raw_data 
		   * from oned drive at this stage that we are still exploring
		   
			global onedrive "C:/Users/wb495814/OneDrive - WBG/Pakistan_Customs_analysis/Mirror and desc stats"
            }
			*
	* Aram
	if c(username)=="wb523133" {
			global onedrive "C:/Users/wb523133/Desktop/IEConnect/Alice/Pakistan"
            }

	* Kaustubh
	
	if c(username)=="Kaustubh" {
           * Put general folder where data and codes are stored, @Kaustubh update here
			global onedrive ""
            }
 
			
* ---------------------------------------------------------------------------- *
*  Set globals to allow everyone to use the same code
* ---------------------------------------------------------------------------- *

	
	global initial_data   			"$onedrive/Code"
	global analysis_data          	"$onedrive/Price analysis" 
	global intermediate_code		"$analysis_data/Code"
	global intermediate_data		"$analysis_data/Data"
	global intermediate_results		"$analysis_data/Results"

* ---------------------------------------------------------------------------- *
* Trial on CI, to be applied on correct unit_price.
* ---------------------------------------------------------------------------- *

	* Upload the most recent data set containing 

	use "$intermediate_data/Price_data_2907.dta" 

	* Create unit price in USD
	* We first need to make sure that for each quantity we have the same
	* unit of measurement by hs_code
	
	codebook quantity_unit_code
	ta quantity_unit_code
	
	* We notice that there are 16 unique values for unit of measurement but the
	* writing is not standardize, so we need to make sure that each unit
	* appears only once with one wirting style.
	
	replace quantity_unit_code="KG" if quantity_unit_code=="kg" 
	replace quantity_unit_code="PAIR" if quantity_unit_code=="Pair"|quantity_unit_code=="pair" 	
	replace quantity_unit_code="SQM" if quantity_unit_code=="sqm" 
	replace quantity_unit_code="CUM" if quantity_unit_code=="cum" 
	replace quantity_unit_code="NO" if quantity_unit_code=="no" 

	ta quantity_unit_code
	
	gen flag=0
	bys hs_code: replace flag=1 if quantity_unit_code!=quantity_unit_code[_N]
	ta flag
		
	* There are 0.01% of cases with differences in the unit of measurement within 
	* a same hs_code
	
	ta hs_code if flag==1
	br hs_code quantity_unit_code if flag==1
	
	* Most of those cases appear as a flag cause the unit is missing.
	* However for some of them it is really different (ex hs_code 7308.3
	* has 249 observations in KG and 4 in NO.) @ Alice what do you suggest,
	* I saw that NO stands for number but I am not sure if it is possible to 
	* convert it somehow.
	
	ta hs_code quantity_unit_code if hs_code>=7308&hs_code<=7309
	
	* For the moment we don't make any change and create the unit price based on 
	* the assumption that the unit of measurement are equivalement for each quantity
	
	bys hs_code: gen unit_price_USD=imports_USD/quantity

	* Create mean by HS_Code
	
	bys hs_code: egen av_unitprice=mean(unit_price_USD)

		/* Mean by 6 months interval, to be run at the last moment
	* Generate the variable that will eventually store the result of our loop
	
	gen 	sem_price=.

	* Determine all the unique dates in our sample and make sure to set them in 
	* a way that will allow the loop to look through them all. Create a local for 
	* this variable

	levelsof 	date, local(all_date)

	* Start the loop and ask to look through all the dates. Create local storing
	* the values of the bounds for the interval we are interested in. Create a 
	* temporary window variable and make sure to generate mean of unit prices 
	* within the window.
	* Store this value in the first variable create if the date falls within
	* the specified interval and drop the temporary mean variable to allow
	* the loop to restart over for the next observation.

	foreach 	date of local all_date{

		local	lower_bound=`date'-90
		local	upper_bound=`date'+90
	
		gen 	d_window=`lower_bound'<=date & date<=`upper_bound'
	
		bys 	hs_code:	egen temp_mean=mean(unit_price) if d_window==1
		replace	sem_price=temp_mean if date==`date'
	
		drop 	d_window	temp_mean
	}

	* Choose one hs_code to test if the code has worked
	
	br unit_price sem_price date month year hs_code if hs_code==9206	

		
		*/
	* Create sd by HS_code
	bys hs_code: egen sd_unitprice= sd(unit_price_USD)

	* Create se by HS_code
	by hs_code: gen se_unitprice=sd_unitprice/sqrt(_N)

	* Create Lower bound for CI by HS_code
	bys hs_code: gen ci_lower= av_unitprice - (1.96 * se_unitprice)

	* Create Upper bound for CI by HS_code
	bys hs_code: gen ci_upper= av_unitprice + (1.96 * se_unitprice)

	* Create deviation from the mean by HS_code
	bys hs_code: gen dev_mean=unit_price_USD - av_unitprice

	* Create percentage of deviation from the mean by HS_code
	bys hs_code: gen per_dev= dev_mean/av_unitprice

	* Create variable for ouliers
	gen outliers=1

	* remove from outliers the values within the CI
	replace outliers=0 if ci_lower<unit_price_USD<ci_upper
	* in this case we have 1.43% outliers
	
	
	* Determine the % of outliers
	ta outliers

	br hs_code unit_price_USD av_unitprice se_unitprice ci_lower ci_upper dev_mean per_dev outliers 

	* Redefine ouliers by considering observations outside the 3*sd interval
	
	bys hs_code: gen low_3sd=av_unitprice-3*sd_unitprice
	bys hs_code: gen up_3sd=av_unitprice+3*sd_unitprice

	gen outliers_3sd=1
	replace outliers_3sd=0 if low_3sd<unit_price_USD<up_3sd
	
	* In this case we have 1.07% outliers
	
	save "$intermediate_data/Price_data_2907_outliers.dta", replace 

* ---------------------------------------------------------------------------- *
	* Data visualization
* ---------------------------------------------------------------------------- *
	
	use "$intermediate_data/Price_data_2907_outliers.dta", clear 
	
	* Bar plots by month
	preserve 
	
	keep if outliers_3sd==1
	*graph hbar outliers_3sd if outliers_3sd==1, by(month)
	
	graph 	hbar (sum) outliers_3sd, over(month) by(year)				///
            ytitle("Total number of outliers by month")
	graph 	export "$intermediate_results/Graphs/outliers_month.png", replace

	* May is the most with most outliers across the 12 months of observation.
	* Generate absolute value for deviation from the mean
	
	gen abs_per_dev=abs(per_dev)
	
	* Graph this absolute value
	
	graph 	hbar (sum) abs_per_dev, over(month) by(year)	
			ytitle	("Percentage deviation from the mean of outliers by month")

	* ? Not sure if it makes sense and how one can interpret this. Without sum 
	* for some reasons we also have months going from january to may 2017 but
	* with sum most of the values are above 100%. @ALice what do you mean?
	* without the absolute values it makes more sense but starngely again we 
	* values again between january and mai.
	
	* Bar plot by shed
	graph 	hbar (sum) outliers_3sd, by(shed)							///
            ytitle("Total number of outliers by Shed")
	graph 	export "$intermediate_results/Graphs/outliers_shed.png", replace

	* The place of inspection with most outliers is : Qasim international
	* container termina (by far), followed by KPT East Warf, KPT West Wharf, 
	* South ASia PAkistan Terminal, MTO, KPT East Wharf Bulk 
	
	* Bar plot by country
	graph 	hbar (sum) outliers_3sd, by(co)								///	
            ytitle("Total number of outliers by country")
	graph 	export "$intermediate_results/Graphs/outliers_country.png", replace
	
	* This comment shall be adjusted with the cleaning performed by @Kaustubh
	* The countries with most outliers are (in order): USA, EU, UAE, China, 
	* South Africa, Kuwait, Oman, Australia, Canada, Indonesia
	
	* Bar plot by HS2
	graph 	hbar (sum) outliers_3sd, by(hs2)							///
			ytitle("Total number of outliers by HS2")								
	graph 	export "$intermediate_results/Graphs/outliers_hs2.png", replace

	
	* we notice that HS72 has a large number of outliers
       

	* Those graphs are not beautiful but can tell clearly which country and shed 
	* and goods type are outliers.
	
	
	restore
	save "$intermediate_data/Price_data_2907_graphs_pa.dta", replace

* ---------------------------------------------------------------------------- *
* Simulation on taxes to determine currency and discrepancies.
* ---------------------------------------------------------------------------- *

	use "$intermediate_data/Price_data_2907_outliers.dta", clear 

	* Creat the three categories required:

	* Custom Duty

	egen cust_duty_levies=rowtotal(customsduty federalexciseduty petrloeumlevy)

	* Taxes

	egen taxes=rowtotal(salestax incometax salestaxleviedascedinvatmode salestaxonlocalsupplies)

	* Extra taxes

	egen extra_taxes=rowtotal(incometaxsurcharge additionalcustomduty gensaletax regduty antidumping addsaletax edibleoilcess frf warehousesurcharge iqra specialfed developmentsurcharge surcharge vrdamount overstayedgoodssurcharge servicecharge guaranteeadditionalsalestax countervailingduty)

	* Generate total

	egen total_taxes=rowtotal(cust_duty_levies taxes extra_taxes)

	* Determine if smaller than import to understand if currency is a problem

	gen tax_curr_disc=0  
	replace tax_curr_disc=1 if total_taxes<imports_USD

	ta total_taxes if tax_curr_disc==1 

	* Create the three additional categories for declared

	* Declared custom duties

	egen decl_cust=rowtotal(decalredcustomsduty decalredfederalexciseduty decalredpetrloeumlevy)

	* Declared taxes
	egen decl_taxes=rowtotal(decalredsalestax decalredincometax decalredsalestaxleviedascedinvat decalredsalestaxonlocalsupplies)

	* Declared extra taxes
	egen decl_extra_taxes=rowtotal(decalredincometaxsurcharge decalredadditionalcustomduty decalredgensaletax decalredregduty decalredantidumping decalredaddsaletax decalrededibleoilcess decalredfrf decalredwarehousesurcharge decalrediqra decalredspecialfed decalreddevelopmentsurcharge decalredsurcharge decalredvrdamount decalredoverstayedgoodssurcharge decalredservicecharge decalredguaranteeadditionalsales decalredcountervailingduty)

	* Declared total
	egen decl_total=rowtotal(decl_cust decl_taxes decl_extra_taxes)

	* Deviation from import USD value

	gen tax_curr_disc_dec=0  
	replace tax_curr_disc_dec=1 if decl_total<imports_USD

	ta decl_total if tax_curr_disc_dec==1 
	ta tax_curr_disc_dec
	ta decl_total if tax_curr_disc_dec==1&decl_total==0
	su decl_total if tax_curr_disc_dec==1&decl_total>0

	* We have a larger number of discrepancies with higher variations as well (now
	* 95% of the discrepancies = 0 , around 10,000 observations)

	* Total as percentage of original price

	* For this we need to merge the data set containing the exchange rate variable

	merge m:1 year month using "$initial_data/Exchange_rate.dta", gen(_Merge_Tax)

	drop if _merge!=3

	gen tax_USD=total_taxes/USDollar

	gen dec_tax_USD=decl_total/USDollar

	* Total taxes

	gen per_tax_price=(tax_USD/imports_USD)*100

	gen dec_per_tax_price=(dec_tax_USD/imports_USD)*100



	save "$intermediate_data/Price_data_2907_taxes.dta", replace
