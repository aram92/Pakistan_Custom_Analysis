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

       ** Last date modified:  31 July 2019
      
	 
* ******************************************************************** *
* ******************************************************************** */
	
	clear all
	set more off
	cap log close
	set maxvar 32767
	set matsize 800
	
	version 12.1
	
	*Installation of a package to export tables as docx files
//	ssc install asdoc
  
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
	if c(username)=="kc" {
			global onedrive "/Users/kc/Documents/World Bank/Pakistan Price Analysis"
			}
 
			
* ---------------------------------------------------------------------------- *
*  Set globals to allow everyone to use the same code
* ---------------------------------------------------------------------------- *

	
	global initial_data   			"$onedrive/Code"
	global analysis_data          	"$onedrive/Price analysis" 
	global intermediate_code		"$analysis_data/Code"
	global intermediate_data		"$analysis_data/Data"
	global intermediate_results		"$analysis_data/Results"

	* Upload the most recent data set 

	use "$intermediate_data/Price_data_2907.dta", clear 

* ---------------------------------------------------------------------------- *
* Cleaning of country, quantity codes, and shed variables
* ---------------------------------------------------------------------------- *

	replace co="European Union" if co=="Austria" | ///
			co=="Azores" | ///
			co=="Balearic Is" | ///
			co=="Belgium" | ///
			co=="Bulgaria" | ///
			co=="Croatia" | ///
			co=="Republic of Cyprus" | ///
			co=="Cyprus" | ///									KC's ADDITION
			co=="Czechia" | ///
			co=="Czechoslovakia" | ///
			co=="Czech Republic" | ///
			co=="Denmark" | ///
			co=="Estonia" | ///
			co=="Europein Union" | ///
			co=="Europien Union" | ///							KC's ADDITION
			co=="Faeroe Islands" | ///
			co=="Finland" | ///
			co=="France" | ///
			co=="Germany" | ///
			co=="German Fedr Republic" | ///
			co=="German Demo Republic" | ///
			co=="Greece" | ///
			co=="Hungary" | ///
			co=="Ireland" | ///
			co=="Italy" | ///
			co=="Latvia" | ///
			co=="Liechtenstein" | ///
			co=="Lithuania" | ///
			co=="Luxembourg" | ///
			co=="Madeira" | ///
			co=="Malta" | ///
			co=="Netherlands" | ///
			co=="Poland" | ///
			co=="Portugal" | ///
			co=="Romania" | ///
			co=="Slovakia" | ///
			co=="Slovenia" | ///
			co=="Spain" | ///
			co=="Sweden" | ///
			co=="United Kingdom"

	replace co="Bolivia" if co=="Bolivia (Plurinational State of)"
	replace co="Bosnia" if co=="Bosnia And Herzegovina" | co=="Bosnia Herzegovina"
	replace co="China" if co=="China, Hong Kong SAR" | co=="Hong Kong, china"
	replace co="UAE" if co=="UNITED ARAB EMIRATES" | co=="United Arab Emirates"
	replace co="USA" if co=="Puerto Rico" | ///
						co=="United States Minor Outlying I" | ///
						co=="Virgin Islands U.S. " | ///
						co=="U.S Misc Pav Islands" | ///
						co=="American Samoa" | ///						KC's ADDITION
						co=="Johnston Island" | ///
						co=="United States"
	replace co="Dominican Republic" if co=="Dominica" | co=="Dominican Rep." | co =="Dominican Republic"
	replace co="Bahrain" if co=="Bahrain/kingdom Of Bahrain"   		 // KC's ADDITION + EVERYTHING BELOW THIS
	replace co="Norway" if co=="Bouvet Island"						 //
	replace co="Cambodia" if co=="Cambodia/kampuchea Democratic"	 // 
	replace co="European Union" if co=="Canary Is"					 // Aram: This shall be Spain not an independent state
	replace co="Kiribati" if co=="Canton-endbry Island"				 // 
	replace co="Australia" if co=="Christmas Island" | ///
							  co=="Cocos (keeling) Island" | ///
							  co=="Heard Island And Mcdonald Isla" | ///
							  co=="Norfolk Island"
	replace co="Congo, Republic of the" if co=="Congo Republic Of"
	replace co="Congo, Democratic Republic of the" if co=="Congo, democratic Republic Of"
	replace co="Iran" if co=="Iran (islamic Republic Of)"
	replace co="Ivory Coast" if co=="Ivory Coast / Cote D'ivoire"
	replace co="North Korea" if co=="Korea (North)"
	replace co="South Korea" if co=="Korea (South)" | co=="Korea Republic Of"
	replace co="Kyrgyzstan" if co=="Kyrgyz Republic" | co =="Kyrzyghistan"
	replace co="Laos" if co=="Lao People's Democratic Republ"
	replace co="Libya" if co=="Libyan Arab Jamhirya"
	replace co="Moldova" if co=="MOLDOVA, REPUBLIC OF"
	replace co="Madagascar" if co=="Malagasy Rep"
	replace co="Myanmar" if co=="Myanmar/burma"
	replace co="Russia" if co=="Russian Fedration"
	replace co="Saint Kitts and Nevis" if co=="Saint Kitts  and Nevis" | ///
			co=="St Christopher"
	replace co="Samoa" if co=="Samda/samoa"
	replace co="Suriname" if co=="Surinam"
	replace co="Syria" if co=="Syrian Arab Republic"
	replace co="Taiwan" if co=="Taiwan/sep Customs Territory O"

	* Aram
	replace co="New Zealand" if co=="Tokelau"
	replace co="European Union" if co=="Turks And  caicos Island" 
	replace co="USA" if co=="U.S Misc Pav Islands" 
	replace co="USA" if co=="Virgin Islands U.S"
	replace co="USA" if co=="Wake Island"
	*replace co="European Union" if co=="Aruba" //Netherlands
	replace co="European Union" if co=="Anguilla" //UK
	replace co="European Union" if co=="British Indian Ocean Territori"
	*replace co="European Union" if co=="Curacao" //Netherlands
	replace co="European Union" if co=="Falkland Island (malvinas)" //UK
	replace co="North Macedonia" if co=="Former Yogoslav Republic Of Ma"
	replace co="North Macedonia" if co=="Macedonia"
	replace co="European Union" if co=="Frecnh West Indies" | co=="French Guiana"  //France
	replace co="European Union" if co=="Guadeloupe"
	replace co="China" if co=="Macao" 
	replace co="USA" if co=="Marshall Islands"
	replace co="European Union" if co=="Martinique"
	replace co="European Union" if co=="Reunion" // France
	replace co="European Union" if co=="South Georgia And The South Sa" //UK
	replace co="Norway" if co=="Svalbard And Jan Mayen"
	* What to do about North/East/West Africa, Yugoslavia, Far East and all origins?? Not sure also
	* about the territories in the netherlands, just put them in comments here in case
	* Since they are all antilles, Shall we reclassify them as Netherlands Antilles ?

	* what about neutral zone?
	* What is Int.Brand Mfg.In Other Country? and Pacific Island Trtry ?

	* for below, make sure that no conflicting replace with my previous cleanings
	replace QT_code="Thousands" if quantity_unit_code=="1000"
	replace QT_code="Carats" if quantity_unit_code=="CARA"
	replace QT_code="Cubic meters" if quantity_unit_code=="CUM" 
	replace QT_code="Kg" if quantity_unit_code=="KG"
	replace QT_code="Volume in liters" if quantity_unit_code=="L"
	replace QT_code="SQM" if quantity_unit_code=="METE"
	replace QT_code="Number of items" if quantity_unit_code=="NO"
	replace QT_code="Number of items" if quantity_unit_code=="PACK"
	replace QT_code="Number of pairs" if quantity_unit_code=="PAIR"
	replace QT_code="Number of pairs" if quantity_unit_code=="Pair"
	replace QT_code="Number of pairs" if quantity_unit_code=="pair"
	replace QT_code="SQM" if quantity_unit_code=="SQM"
	replace QT_code="SQM" if quantity_unit_code=="sqm"
	replace QT_code="Cubic meters" if quantity_unit_code=="cum"
	replace QT_code="Kg" if quantity_unit_code=="kg"
	replace QT_code="Number of items" if quantity_unit_code=="no"

	* KC's additons:
	replace shed_name="South Asia Pakistan Terminals" ///
				if shed_name=="SOUTH ASIA PAKISTAN TERMINALS"
	replace shed_name="Peshawar Torkham" if shed_name=="PESHAWAR TORKHAM"

* ---------------------------------------------------------------------------- *
* Trial on CI, to be applied on correct unit_price.
* ---------------------------------------------------------------------------- *
	
	* Create unit price in USD
	* We first need to make sure that for each quantity we have the same
	* unit of measurement by hs_code
	
	codebook QT_code
	ta QT_code
		
	gen flag=0
	bys hs_code: replace flag=1 if QT_code!=QT_code[_N]
	ta flag 
		
	* There are 0.01% of cases with differences in the unit of measurement within 
	* a same hs_code
	
	ta hs_code if flag==1
	br hs_code QT_code if flag==1
	
	* hs_code 7308.3 has 249 observations in KG and 4 in NO.)
	* @ Alice what do you suggest, I saw that NO stands for number but I am not 
	* sure if it is possible to convert it somehow.
	
	ta hs_code QT_code if hs_code>=7308&hs_code<=7309
	
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
	
		bys 	hs_code:	egen temp_mean=mean(unit_price_USD) if d_window==1
		replace	sem_price=temp_mean if date==`date'
	
		drop 	d_window	temp_mean
	}

	* Choose one hs_code to test if the code has worked
	
	br unit_price_USD sem_price date month year hs_code if hs_code==9206	

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

**************************************************************************
* Data visualization
**************************************************************************
	
	use "$intermediate_data/Price_data_2907_outliers.dta", clear 

	* Determine the % of outliers
	ta outliers_3sd
	
	* Label the variables year and month
	label variable year "Year"
	label variable month "Month"
	label define month_names 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
							 7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
	label values month month_names
	
	* Check the distribution and availability of data
	ta month year
	* No observations for July-December 2018

	* Check distribution of outliers over month-year
	bysort year: tab outliers month
	bysort year: tab outliers_3sd month
	
	******	 We first use 95% CI	 ******
	
	preserve
	keep if outliers==1
	* Create graph of # of outliers per HS code using 95% CI, by month & year
	graph hbar (count) outliers if outliers==1, over(month) ///
				ytitle("") ///
				yscale(range(6400)) ///
				ylabel(, format(%9.0fc)) ///
				by(year, title("Number of outliers per HS code") ///
				subtitle("using 95% confidence intervals, by month and year") ///
				note("Note: There are no observations for July-December 2018.")) ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
	
	graph 	export "$intermediate_results/Graphs/outliers_month.png", replace
	
	restore
	
	
	* Create monthly means 
	bys year month: egen av_unitprice_monthyr=mean(unit_price_USD)

	* Create deviation from the mean by month
	bys year month: gen dev_mean_monthyr=unit_price_USD - av_unitprice_monthyr

	* Create percentage of deviation from the monthly means
	bys year month: gen per_dev_monthyr= dev_mean_month/av_unitprice_monthyr
	
	* Create sum of absolute values of percentage of deviation from the monthly mean
	bys year month: egen sum_dev_monthyr = sum(abs(per_dev_monthyr))
	
	sum sum_dev_monthyr
	* Create bar plot of sum of absolute value of % deviations from the mean per month
	graph hbar sum_dev_monthyr, over(month) ///
				ytitle("") ///
				ylabel(#3, format(%9.00fc)) ///
				by(year, title("Sum of absolute value of % deviations from the mean per month") ///
				subtitle("by month and year") ///
				note("Note: There are no observations for July-December 2018.")) ///
				blabel(bar, position(outside) format(%9.00fc) color(black))

	graph 	export "$intermediate_results/Graphs/outliers_dev_month_year.png", replace
			
	* Create index for shed names & then a facet variable for the following graph
	/*egen shed_index = group(shed_name)
	gen shed_facet = 1 if shed_index<14 & shed_index !=.
	replace shed_facet = 2 if shed_index>13 & shed_index<27 & shed_index !=.
	replace shed_facet = 3 if shed_index>26 & shed_index<40 & shed_index !=.
	replace shed_facet = 4 if shed_index>39 & shed_index !=.
*/
	* Create graph of # of outliers per shed using 95% CI
	preserve
	keep if outliers==1
	
/*	graph hbar (count) outliers if outliers==1, ///
				over(shed_name, sort(1) descending) ///
				ytitle("") ///
				ylabel(, format(%9.0fc)) ///
				by(shed_facet, title("Number of outliers per HS code") ///
				subtitle("using 95% confidence intervals, by Shed") ///
				note("Note: There are no observations for July-December 2018.")) ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				ysize(20)

	graph 	export "$intermediate_results/Graphs/outliers_shed.png", replace
				
	* Create graph of # of outliers per country using 95% CI
	graph hbar (count) outliers if outliers==1, over(co) ///
				ytitle("") ///
				ylabel(, format(%9.0fc)) ///
				title("Number of outliers per COuntry of origin") ///
				subtitle("using 95% confidence intervals, by Country") ///
				note("Note: There are no observations for July-December 2018.") ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
	
	graph 	export "$intermediate_results/Graphs/outliers_co.png", replace
				
	* Create graph of # of outliers per HS2 code using 95% CI				
	graph hbar (count) outliers if outliers==1, over(hs2) ///
				ytitle("") ///
				ylabel(, format(%9.0fc)) ///
				title("Number of outliers per HS code") ///
				subtitle("using 95% confidence intervals, by HS2 codes") ///
				note("Note: There are no observations for July-December 2018.") ///
				blabel(bar, position(outside) format(%9.0fc) color(black))

	graph 	export "$intermediate_results/Graphs/outliers_hs2.png", replace
	*/
	
	* Aram: I suggest to use by instead of over for the moment to have more 
	* lisibility in country, shed and hs2
	
	graph hbar (sum) outliers, ///
				by(shed_name) ///
				ytitle("Number of outliers per HS code")		///
				ylabel(, format(%9.0fc)) ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) 

	graph 	export "$intermediate_results/Graphs/outliers_shed.png", replace
				
	* Create graph of # of outliers per country using 95% CI
	graph hbar (sum) outliers, by(co) ///
				ytitle("Number of outliers per Country of origin") ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
	
	graph 	export "$intermediate_results/Graphs/outliers_co.png", replace
				
	* Create graph of # of outliers per HS2 code using 95% CI				
	graph hbar (sum) outliers, by(hs2) ///
				ytitle("Number of outliers per HS code") ///
				blabel(bar, position(outside) format(%9.0fc) color(black))

	graph 	export "$intermediate_results/Graphs/outliers_hs2.png", replace
	
	

	restore
	
	******		We then use 3SD		******		
	
	* Create graph of # of outliers per HS code using 3SD, by month & year
	
	preserve

	keep if outliers_3sd==1
	
	graph hbar (sum) outliers_3sd, over(month) by(year) ///
				yscale(range(6400)) ///
				ylabel(, format(%9.0fc)) ///
				ytitle("Number of outliers per HS code") ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
	graph 	export "$intermediate_results/Graphs/outliers_3sd_month.png", replace

	* Create graph of # of outliers per shed using 3SD
	
	graph hbar (sum) outliers_3sd, by(shed_name) ///
				ylabel(, format(%9.0fc)) ///
				ytitle("Number of outliers per HS code") ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
	
	graph 	export "$intermediate_results/Graphs/outliers_3sd_shed.png", replace
	
	
	* Create graph of # of outliers per country using 3SD
	
	graph hbar (count) outliers_3sd if outliers_3sd==1, by(co) ///
				ylabel(, format(%9.0fc)) ///
				ytitle("Number of outliers per Country of origin") ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
	
	graph 	export "$intermediate_results/Graphs/outliers_3sd_co.png", replace
				
	* Create graph of # of outliers per HS2 code using 95% CI				
	
	graph hbar (count) outliers_3sd if outliers_3sd==1, by(hs2) ///
				ylabel(, format(%9.0fc)) ///
				ytitle("Number of outliers per HS code") ///
				blabel(bar, position(outside) format(%9.0fc) color(black))

	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2.png", replace
	
	restore
 
 	save "$intermediate_data/Price_data_2907_graphs.dta", replace 

	*************************************************************************
	* Regression
	**************************************************************************
	
	use "$intermediate_data/Price_data_2907_outliers.dta", clear 

	* We create the log variables for the regression
	gen logimpUSD=log(imports_USD)
	
	gen logqua=log(quantity)

	* We make sure that string variables that need to be considered as dummies
	* are correctly encoded
	encode(shed_name),gen (shed_code)
	encode(co), gen(co_code)
	encode(currency_abbreviation), gen(currency_code)
	encode(processed_channel), gen(channel_code)
	
	* We need to adapt hs_code, if we simply have an int we have a distortion.
	* however we can multiply by 100000
	
	gen hs_code_int=hs_code*100000

	eststo clear	

	regress unit_price_USD i.hs2 i.shed_code i.co_code logimpUSD logqua i.year i.month i.currency_code i.channel_code 
	 
	esttab 	using "$intermediate_results/Tables/reg1.tex", label r2 ar2 ///
			se star(* 0.10 ** 0.05 *** 0.01) replace nobaselevels style(tex)	
	
	* If we really want to include hs_code, not only we need to have it as an 
	* integrer but also to increase the matrix size (default is 800). Do we really need this?


	save "$intermediate_data/Price_data_2907_regression.dta", replace

* ---------------------------------------------------------------------------- *
* 			Simulation on taxes to determine currency and discrepancies
* ---------------------------------------------------------------------------- *

	use "$intermediate_data/Price_data_2907_outliers.dta", clear 

	* Create the three categories required:

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


	* Create means by HS code
	bys hs_code: egen av_cust_duty_levies = mean(cust_duty_levies)
	bys hs_code: egen av_taxes = mean(taxes)
	bys hs_code: egen av_extra_taxes = mean(extra_taxes)
	bys hs_code: egen av_total_taxes = mean(total_taxes)
	bys hs_code: egen av_decl_cust = mean(decl_cust)
	bys hs_code: egen av_decl_taxes = mean(decl_taxes)
	bys hs_code: egen av_decl_extra_taxes = mean(decl_extra_taxes)
	bys hs_code: egen av_decl_total = mean(decl_total)

	* Create SDs by HS code
	bys hs_code: egen sd_cust_duty_levies = sd(cust_duty_levies)
	bys hs_code: egen sd_taxes = sd(taxes)
	bys hs_code: egen sd_extra_taxes = sd(extra_taxes)
	bys hs_code: egen sd_total_taxes = sd(total_taxes)
	bys hs_code: egen sd_decl_cust = sd(decl_cust)
	bys hs_code: egen sd_decl_taxes = sd(decl_taxes)
	bys hs_code: egen sd_decl_extra_taxes = sd(decl_extra_taxes)
	bys hs_code: egen sd_decl_total = sd(decl_total)

	* Create Lower bound for CI by HS code using 3SD
	bys hs_code: gen sd3_lower_cust= av_cust_duty_levies - (3 * sd_cust_duty_levies)
	bys hs_code: gen sd3_lower_taxes= av_taxes - (3 * sd_taxes)
	bys hs_code: gen sd3_lower_extra= av_extra_taxes - (3 * sd_extra_taxes)
	bys hs_code: gen sd3_lower_total= av_total_taxes - (3 * sd_total_taxes)
	bys hs_code: gen sd3_lower_dcust= av_decl_cust - (3 * sd_decl_cust)
	bys hs_code: gen sd3_lower_dtaxes= av_decl_taxes - (3 * sd_decl_taxes)
	bys hs_code: gen sd3_lower_dextra= av_decl_extra_taxes - (3 * sd_decl_extra_taxes)
	bys hs_code: gen sd3_lower_dtotal= av_decl_total - (3 * sd_decl_total)

	* Create Upper bound for CI by HS code using 3SD
	bys hs_code: gen sd3_upper_cust= av_cust_duty_levies + (3 * sd_cust_duty_levies)
	bys hs_code: gen sd3_upper_taxes= av_taxes + (3 * sd_taxes)
	bys hs_code: gen sd3_upper_extra= av_extra_taxes + (3 * sd_extra_taxes)
	bys hs_code: gen sd3_upper_total= av_total_taxes + (3 * sd_total_taxes)
	bys hs_code: gen sd3_upper_dcust= av_decl_cust + (3 * sd_decl_cust)
	bys hs_code: gen sd3_upper_dtaxes= av_decl_taxes + (3 * sd_decl_taxes)
	bys hs_code: gen sd3_upper_dextra= av_decl_extra_taxes + (3 * sd_decl_extra_taxes)
	bys hs_code: gen sd3_upper_dtotal= av_decl_total + (3 * sd_decl_total)
	
	* Create variable for outliers using 3SD
	gen outliers_sd3_cust=1
	gen outliers_sd3_taxes=1
	gen outliers_sd3_extra=1
	gen outliers_sd3_total=1
	gen outliers_sd3_dcust=1
	gen outliers_sd3_dtaxes=1
	gen outliers_sd3_dextra=1
	gen outliers_sd3_dtotal=1

	* Remove from outliers the values within 3SD
	replace outliers_sd3_cust=0 if sd3_lower_cust<cust_duty_levies<sd3_upper_cust
	replace outliers_sd3_taxes=0 if sd3_lower_taxes<taxes<sd3_upper_taxes
	replace outliers_sd3_extra=0 if sd3_lower_extra<extra_taxes<sd3_upper_extra
	replace outliers_sd3_total=0 if sd3_lower_total<total_taxes<sd3_upper_total
	replace outliers_sd3_dcust=0 if sd3_lower_dcust<decl_cust<sd3_upper_dcust
	replace outliers_sd3_dtaxes=0 if sd3_lower_dtaxes<decl_taxes<sd3_upper_dtaxes
	replace outliers_sd3_dextra=0 if sd3_lower_dextra<decl_extra_taxes<sd3_upper_dextra
	replace outliers_sd3_dtotal=0 if sd3_lower_dtotal<decl_total<sd3_upper_dtotal

	label variable outliers_sd3_cust "Outliers in custom duties & levies"
	label variable outliers_sd3_taxes "Outliers in taxes"
	label variable outliers_sd3_extra "Outliers in extra taxes and duties"
	label variable outliers_sd3_total "Outliers in total of three categories"
	label variable outliers_sd3_dcust "Outliers in declared custom duties & levies"
	label variable outliers_sd3_dtaxes "Outliers in declared taxes"
	label variable outliers_sd3_dextra "Outliers in declared extra taxes and duties"
	label variable outliers_sd3_dtotal "Outliers in declared total of three categories"

	label define outliers_cust 0 "Not Outlier" 1 "Outlier"
	label define outliers_taxes 0 "Not Outlier" 1 "Outlier"
	label define outliers_extra 0 "Not Outlier" 1 "Outlier"
	label define outliers_total 0 "Not Outlier" 1 "Outlier"
	label define outliers_dcust 0 "Not Outlier" 1 "Outlier"
	label define outliers_dtaxes 0 "Not Outlier" 1 "Outlier"
	label define outliers_dextra 0 "Not Outlier" 1 "Outlier"
	label define outliers_dtotal 0 "Not Outlier" 1 "Outlier"
	
	label values outliers_sd3_cust outliers_cust
	label values outliers_sd3_taxes outliers_taxes
	label values outliers_sd3_extra outliers_extra
	label values outliers_sd3_total outliers_total
	label values outliers_sd3_dcust outliers_dcust
	label values outliers_sd3_dtaxes outliers_dtaxes
	label values outliers_sd3_dextra outliers_dextra
	label values outliers_sd3_dtotal outliers_dtotal
	
	* Determine the % of outliers (3SD)
	ta outliers_sd3_cust
//	0.09% of observations are outliers

	ta outliers_sd3_taxes
//	0.03% of observations are outliers

	ta outliers_sd3_extra
//	0.09% of observations are outliers

	ta outliers_sd3_total
//	0.03% of observations are outliers

	ta outliers_sd3_dcust
//	0.09% of observations are outliers

	ta outliers_sd3_dtaxes
//	0.03% of observations are outliers

	ta outliers_sd3_dextra
//	0.09% of observations are outliers

	ta outliers_sd3_dtotal
//	0.03% of observations are outliers

 
	asdoc tab1 outliers_sd3_cust outliers_sd3_taxes outliers_sd3_extra ///
				outliers_sd3_total outliers_sd3_dcust outliers_sd3_dtaxes ///
				outliers_sd3_dextra outliers_sd3_dtotal, replace label
	
	save "$intermediate_data/Price_data_2907_taxes.dta", replace

	
**** Custom duties & levies				
	* Create graph of # of outliers per HS code using 3SD, by MONTH & YEAR
	
	use "$intermediate_data/Price_data_2907_taxes.dta", clear

	preserve
	keep if outliers_sd3_cust==1
	
	graph hbar (count) outliers_sd3_cust, over(month) ///
				ytitle("") ///
				ylabel(, format(%9.0fc)) ///
				by(year, title("Number of outliers per HS code for custom duties & levies") ///
				subtitle("by month and year") ///
				note("Note: There are no observations for July-December 2018.")) ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
	
	graph 	export "$intermediate_results/Graphs/outliers_3sd_month_cust.pdf", replace

	restore
	
**** Taxes

	preserve
	keep if outliers_sd3_taxes==1
	

	graph hbar (count) outliers_sd3_taxes, over(month) ///
				ytitle("") ///
				yscale(range(158)) ///
				ylabel(, format(%9.0fc)) ///
				by(year, title("Number of outliers per HS code for taxes") ///
				subtitle("by month and year") ///
				note("Note: There are no observations for July-December 2018.")) ///
				blabel(bar, position(outside) format(%9.0fc) color(black))

	graph 	export "$intermediate_results/Graphs/outliers_3sd_month_taxes.pdf", replace

	restore
	
*** Extra taxes and duties

	preserve
	keep if outliers_sd3_extra==1
	

	graph hbar (count) outliers_sd3_extra, over(month) ///
				ytitle("") ///
				ylabel(, format(%9.0fc)) ///
				by(year, title("Number of outliers per HS code for extra taxes & duties") ///
				subtitle("by month and year") ///
				note("Note: There are no observations for July-December 2018.")) ///
				blabel(bar, position(outside) format(%9.0fc) color(black))

	graph 	export "$intermediate_results/Graphs/outliers_3sd_month_extra.pdf", replace
				
	restore
	
*** Total of first three categories
	preserve
	keep if outliers_sd3_total==1

	graph hbar (count) outliers_sd3_total, over(month) ///
				ytitle("") ///
				yscale(range(157)) ///
				ylabel(, format(%9.0fc)) ///
				by(year, title("Number of outliers per HS code for total") ///
				subtitle("by month and year") ///
				note("Note: There are no observations for July-December 2018.")) ///
				blabel(bar, position(outside) format(%9.0fc) color(black))				

	graph 	export "$intermediate_results/Graphs/outliers_3sd_month_total.pdf", replace
	
	restore
	
**** Declared custom duties & levies
	preserve
	keep if outliers_sd3_dcust==1
	
	graph hbar (count) outliers_sd3_dcust, over(month) ///
				ytitle("") ///
				ylabel(, format(%9.0fc)) ///
				by(year, title("Number of outliers per HS code for declared custom duties & levies") ///
				subtitle("by month and year") ///
				note("Note: There are no observations for July-December 2018.")) ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6)

	graph 	export "$intermediate_results/Graphs/outliers_3sd_month_dcust.pdf", replace
		
	restore
	
	
*** Declared taxes
	preserve
	keep if outliers_sd3_dtaxes==1
	

	graph hbar (count) outliers_sd3_dtaxes, over(month) ///
				ytitle("") ///
				yscale(range(157)) ///
				ylabel(, format(%9.0fc)) ///
				by(year, title("Number of outliers per HS code for declared taxes") ///
				subtitle("by month and year") ///
				note("Note: There are no observations for July-December 2018.")) ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///

	graph 	export "$intermediate_results/Graphs/outliers_3sd_month_dtaxes.pdf", replace
		
	restore
	
***	Declared extra taxes and duties	
	preserve
	keep if outliers_sd3_dextra==1
	
	graph hbar (count) outliers_sd3_dextra, over(month) ///
				ytitle("") ///
				ylabel(, format(%9.0fc)) ///
				by(year, title("Number of outliers per HS code for declared extra taxes & duties") ///
				subtitle("by month and year") ///
				note("Note: There are no observations for July-December 2018.")) ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6)
				

	graph 	export "$intermediate_results/Graphs/outliers_3sd_month_dextra.pdf", replace

	restore	
	
***	Total of the three declared categories
	preserve
	keep if outliers_sd3_total==1
		
	graph hbar (count) outliers_sd3_dtotal if outliers_sd3_dtotal==1, over(month) ///
				ytitle("") ///
				ylabel(, format(%9.0fc)) ///
				yscale(range(157)) ///
				by(year, title("Number of outliers per HS code for declared total") ///
				subtitle("by month and year") ///
				note("Note: There are no observations for July-December 2018.")) ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6)

	graph 	export "$intermediate_results/Graphs/outliers_3sd_month_dtotal.pdf", replace
				
	restore			

	
	*------------- Bar plot by shed -------------*
	
	* CUSTOMS DUTIES & LEVIES
	
	* Determine lowest number of outliers for top 10 Sheds
	ta shed_name outliers_sd3_cust if outliers_sd3_cust==1
	*It's 26

	* Create a variable that sums number of outliers by Sheds
	bys shed_name: egen outliers_cust_shed = sum(outliers_sd3_cust)
		
	* Graph top 10 Sheds by number of outliers
	preserve
	keep if outliers_cust_shed>25	

	graph hbar outliers_cust_shed if outliers_cust_shed > 25, ///
				over(shed_name, sort(1) descending) ///
				yscale(range(1150)) ///
				ytitle("") ///
				title("Top 10 sheds with most outliers in customs & levies") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(7) ///
				nofill
	
	graph 	export "$intermediate_results/Graphs/outliers_3sd_shed_cust.pdf", replace
	
	restore
	
//----
	* TAXES
	
	* Determine lowest number of outliers for top 10 Sheds
	ta shed_name outliers_sd3_taxes if outliers_sd3_taxes==1
	*It's 12
	
	* Create a variable that sums number of outliers by Sheds
	bys shed_name: egen outliers_taxes_shed = sum(outliers_sd3_taxes)
	
	
	preserve
	keep if outliers_taxes_shed>11
	
	* Graph top 10 Sheds by number of outliers
	graph hbar outliers_taxes_shed if outliers_taxes_shed > 11, ///
				over(shed_name, sort(1) descending) ///
				ytitle("") ///
				title("Top 10 sheds with most outliers in taxes") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				nofill
				
	graph 	export "$intermediate_results/Graphs/outliers_3sd_shed_taxes.png", replace
	
	restore	
	
//----
	* EXTRA TAXES & DUTIES
	
	* Determine lowest number of outliers for top 10 Sheds
	ta shed_name outliers_sd3_extra if outliers_sd3_extra==1
	*It's 36
	
	* Create a variable that sums number of outliers by Sheds
	bys shed_name: egen outliers_extra_shed = sum(outliers_sd3_extra)
	
	preserve
	keep if outliers_extra_shed>35

	* Graph top 10 Sheds by number of outliers
	graph hbar outliers_extra_shed if outliers_extra_shed > 35, ///
				over(shed_name, sort(1) descending) ///
				ytitle("") ///
				yscale(range(900)) ///
				title("Top 10 sheds with most outliers in extra taxes & duties") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6.5) ///
				nofill
				
	graph 	export "$intermediate_results/Graphs/outliers_3sd_extra_shed.png", replace
				
	restore
	
//----
	* TOTAL FOR FIRST THREE CATEGORIES
	
	* Determine lowest number of outliers for top 10 Sheds
	ta shed_name outliers_sd3_total if outliers_sd3_total==1
	*It's 9
	
	* Create a variable that sums number of outliers by Sheds
	bys shed_name: egen outliers_total_shed = sum(outliers_sd3_total)

	preserve
	keep if outliers_total_shed>8

	* Graph top 10 Sheds by number of outliers
	graph hbar outliers_total_shed if outliers_total_shed > 8, ///
				over(shed_name, sort(1) descending) ///
				ytitle("") ///
				title("Top 10 sheds with most outliers in total for first 3 categories") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(7) ///
				nofill	
				
	graph 	export "$intermediate_results/Graphs/outliers_3sd_total_shed.png", replace
	
	restore
	
//----				
	* DECLARED CUSTOMS DUTIES & LEVIES
	
	* Determine lowest number of outliers for top 10 Sheds
	ta shed_name outliers_sd3_dcust if outliers_sd3_dcust==1
	*It's 26
	
	* Create a variable that sums number of outliers by Sheds
	bys shed_name: egen outliers_dcust_shed = sum(outliers_sd3_dcust)
	
	preserve
	keep if outliers_dcust_shed>25

	* Graph top 10 Sheds by number of outliers
	graph hbar outliers_dcust_shed if outliers_dcust_shed > 25, ///
				over(shed_name, sort(1) descending) ///
				ytitle("") ///
				yscale(range(1100)) ///
				title("TTop 10 sheds with most outliers in declared custom duties & levies") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(8.5) ///
				nofill	

	graph 	export "$intermediate_results/Graphs/outliers_3sd_shed_dcust.png", replace
	
	restore
	
//----				
	* DECLARED TAXES
	
	* Determine lowest number of outliers for top 10 Sheds
	ta shed_name outliers_sd3_dtaxes if outliers_sd3_dtaxes==1
	*It's 12
	
	* Create a variable that sums number of outliers by Sheds
	bys shed_name: egen outliers_dtaxes_shed = sum(outliers_sd3_dtaxes)

	preserve
	keep if outliers_dtaxes_shed>11

	* Graph top 10 Sheds by number of outliers
	graph hbar outliers_dtaxes_shed if outliers_dtaxes_shed > 11, ///
				over(shed_name, sort(1) descending) ///
				ytitle("") ///
				title("Top 10 sheds with most outliers in total for declared taxes") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(7) ///
				nofill		

	graph 	export "$intermediate_results/Graphs/outliers_3sd_shed_dtaxes.png", replace
	
	restore
	
//----
	* DECLARED EXTRA TAXES & DUTIES
	
	* Determine lowest number of outliers for top 10 Sheds
	ta shed_name outliers_sd3_dextra if outliers_sd3_dextra==1
	*It's 38
	
	* Create a variable that sums number of outliers by Sheds
	bys shed_name: egen outliers_dextra_shed = sum(outliers_sd3_dextra)

	preserve
	keep if outliers_dextra_shed>37
	
	* Graph top 10 Sheds by number of outliers
	graph hbar outliers_dextra_shed if outliers_dextra_shed > 37, ///
				over(shed_name, sort(1) descending) ///
				ytitle("") ///
				title("Top 10 sheds with most outliers in declared extra taxes & duties") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(7.5) ///
				nofill

	graph 	export "$intermediate_results/Graphs/outliers_3sd_shed_dextra.png", replace
				
	restore
	
//----
	* TOTAL FOR DECLARED CATEGORIES
	
	* Determine lowest number of outliers for top 10 Sheds
	ta shed_name outliers_sd3_dtotal if outliers_sd3_dtotal==1
	*It's 10
	
	* Create a variable that sums number of outliers by Sheds
	bys shed_name: egen outliers_dtotal_shed = sum(outliers_sd3_dtotal)
	
	preserve
	keep if outliers_dtotal_shed>9

	* Graph top 10 Sheds by number of outliers
	graph hbar outliers_dtotal_shed if outliers_dtotal_shed > 9, ///
				over(shed_name, sort(1) descending) ///
				ytitle("") ///
				title("Top 10 sheds with most outliers in total for first 3 categories") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
 				xsize(7) ///				
				nofill		

	graph 	export "$intermediate_results/Graphs/outliers_3sd_shed_dtotal.png", replace

	restore

				*------------- Bar plot by country -------------*

//----
	* CUSTOMS DUTIES & LEVIES
	
	* Determine lowest number of outliers for top 10 countries
	ta co outliers_sd3_cust if outliers_sd3_cust==1
	*It's 60
	
	* Create a variable that sums number of outliers by Country
	bys co: egen outliers_cust_co = sum(outliers_sd3_cust)
	
	* Graph top 10 countries by number of outliers
	graph hbar outliers_cust_co if outliers_cust_co > 59, ///
				over(co, sort(1) descending) ///
				yscale(range(1200)) ///
				ytitle("") ///
				title("Top 10 countries with most outliers in customs & levies") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6) ///
				nofill
	
	* Create means by HS code
	bys hs_code: egen av_cust_duty_levies = mean(cust_duty_levies)
	bys hs_code: egen av_taxes = mean(taxes)
	bys hs_code: egen av_extra_taxes = mean(extra_taxes)
	bys hs_code: egen av_total_taxes = mean(total_taxes)
	bys hs_code: egen av_decl_cust = mean(decl_cust)
	bys hs_code: egen av_decl_taxes = mean(decl_taxes)
	bys hs_code: egen av_decl_extra_taxes = mean(decl_extra_taxes)
	bys hs_code: egen av_decl_total = mean(decl_total)

	
//----
	* TAXES
	
	* Determine lowest number of outliers for top 10 Country
	ta co outliers_sd3_taxes if outliers_sd3_taxes==1
	*It's 15
	
	* Create a variable that sums number of outliers by Country
	bys co: egen outliers_taxes_co = sum(outliers_sd3_taxes)
	
	* Graph top 10 Country by number of outliers
	graph hbar outliers_taxes_co if outliers_taxes_co > 14, ///
				over(co, sort(1) descending) ///
				yscale(range(260)) ///
				ytitle("") ///
				title("Top 10 countries with most outliers in taxes") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				nofill

//----
	* EXTRA TAXES & DUTIES
	
	* Determine lowest number of outliers for top 10 Country
	ta co outliers_sd3_extra if outliers_sd3_extra==1
	*It's 60
	
	* Create a variable that sums number of outliers by Country
	bys co: egen outliers_extra_co = sum(outliers_sd3_extra)
	
	* Graph top 10 Country by number of outliers
	graph hbar outliers_extra_co if outliers_extra_co > 59, ///
				over(co, sort(1) descending) ///
				ytitle("") ///
				yscale(range(1200)) ///
				title("Top 10 countries with most outliers in extra taxes & duties") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6.5) ///
				nofill
				
//----
	* TOTAL FOR FIRST THREE CATEGORIES
	
	* Determine lowest number of outliers for top 10 Country
	ta co outliers_sd3_total if outliers_sd3_total==1
	*It's 15
	
	* Create a variable that sums number of outliers by Country
	bys co: egen outliers_total_co = sum(outliers_sd3_total)
	
	* Graph top 10 Country by number of outliers
	graph hbar outliers_total_co if outliers_total_co > 14, ///
				over(co, sort(1) descending) ///
				ytitle("") ///
				title("Top 10 countries with most outliers in total for first 3 categories") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6.5) ///
				nofill	
				
//----				
	* DECLARED CUSTOMS DUTIES & LEVIES
	
	* Determine lowest number of outliers for top 10 Country
	ta co outliers_sd3_dcust if outliers_sd3_dcust==1
	*It's 60
	
	* Create a variable that sums number of outliers by Country
	bys co: egen outliers_dcust_co = sum(outliers_sd3_dcust)
	
	* Graph top 10 Country by number of outliers
	graph hbar outliers_dcust_co if outliers_dcust_co > 59, ///
				over(co, sort(1) descending) ///
				ytitle("") ///
				yscale(range(1200)) ///
				title("Top 10 countries with most outliers in total for declared custom duties & levies") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(8) ///
				nofill	

//----				
	* DECLARED TAXES
	
	* Determine lowest number of outliers for top 10 Country
	ta co outliers_sd3_dtaxes if outliers_sd3_dtaxes==1
	*It's 15
	
	* Create a variable that sums number of outliers by Country
	bys co: egen outliers_dtaxes_co = sum(outliers_sd3_dtaxes)
	
	* Graph top 10 Country by number of outliers
	graph hbar outliers_dtaxes_co if outliers_dtaxes_co > 14, ///
				over(co, sort(1) descending) ///
				yscale(rang(260)) ///
				ytitle("") ///
				title("Top 10 countries with most outliers in total for declared taxes") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6.5) ///
				nofill		

//----
	* DECLARED EXTRA TAXES & DUTIES
	
	* Determine lowest number of outliers for top 10 Country
	ta co outliers_sd3_dextra if outliers_sd3_dextra==1
	*It's 60
	
	* Create a variable that sums number of outliers by Country
	bys co: egen outliers_dextra_co = sum(outliers_sd3_dextra)
	
	* Graph top 10 Country by number of outliers
	graph hbar outliers_dextra_co if outliers_dextra_co > 59, ///
				over(co, sort(1) descending) ///
				yscale(range(1200)) ///
				ytitle("") ///
				title("Top 10 countries with most outliers in declared extra taxes & duties") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(7.5) ///
				nofill

//----
	* TOTAL FOR DECLARED CATEGORIES
	
	* Determine lowest number of outliers for top 10 Country
	ta co outliers_sd3_dtotal if outliers_sd3_dtotal==1
	*It's 15
	
	* Create a variable that sums number of outliers by Country
	bys co: egen outliers_dtotal_co = sum(outliers_sd3_dtotal)
	
	* Graph top 10 Country by number of outliers
	graph hbar outliers_dtotal_co if outliers_dtotal_co > 14, ///
				over(co, sort(1) descending) ///
				ytitle("") ///
				title("Top 10 countries with most outliers in total for declared categories") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6.8) ///
				nofill	
	
	
	
					*------------- Bar plot by HS2 -------------*							

//----
	* CUSTOMS DUTIES & LEVIES
	
	* Determine the top 10 HS2 Codes with the highest number of outliers
	ta hs2 outliers_sd3_cust if outliers_sd3_cust==1
	*It's 67
	
	* Create a variable that sums number of outliers by HS2 Codes
	bys hs2: egen outliers_cust_hs2 = sum(outliers_sd3_cust)

	preserve
	keep if outliers_cust_hs2>66

	* Graph top 10 countries by number of outliers
	graph hbar outliers_cust_hs2 if outliers_cust_hs2 > 66, ///
				over(hs2, sort(1) descending) ///
				ytitle("") ///
				title("Top 10 HS2 codes with most outliers in customs & levies") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				nofill

	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2_cust.png", replace
	
	restore
	
//----
	* TAXES
	
	* Determine lowest number of outliers for top 10 HS2 Codes
	ta hs2 outliers_sd3_taxes if outliers_sd3_taxes==1
	*It's 18
	
	* Create a variable that sums number of outliers by HS2 Codes
	bys hs2: egen outliers_taxes_hs2 = sum(outliers_sd3_taxes)
	
	preserve
	keep if outliers_taxes_hs2>17
	
	* Graph top 10 HS2 Codes by number of outliers
	graph hbar outliers_taxes_hs2 if outliers_taxes_hs2 > 17, ///
				over(hs2, sort(1) descending) ///
				ytitle("") ///
				yscale(range(210)) ///
				title("Top 10 HS2 codes with most outliers in taxes") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				nofill
	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2_taxes.png", replace
		
	restore
	
//----
	* EXTRA TAXES & DUTIES
	
	* Determine lowest number of outliers for top 10 HS2 Codes
	ta hs2 outliers_sd3_extra if outliers_sd3_extra==1
	*It's 63
	
	* Create a variable that sums number of outliers by HS2 Codes
	bys hs2: egen outliers_extra_hs2 = sum(outliers_sd3_extra)

	preserve
	keep if outliers_extra_hs2>62
	
	* Graph top 10 HS2 Codes by number of outliers
	graph hbar outliers_extra_hs2 if outliers_extra_hs2 > 62, ///
				over(hs2, sort(1) descending) ///
				ytitle("") ///
				title("Top 10 HS2 codes with most outliers in extra taxes & duties") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				nofill

	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2_extra.png", replace
				
	restore
	
//----
	* TOTAL FOR FIRST THREE CATEGORIES
	
	* Determine lowest number of outliers for top 10 HS2 Codes
	ta hs2 outliers_sd3_total if outliers_sd3_total==1
	*It's 9
	
	* Create a variable that sums number of outliers by HS2 Codes
	bys hs2: egen outliers_total_hs2 = sum(outliers_sd3_total)

	preserve
	keep if outliers_total_hs2>8
	
	* Graph top 10 HS2 Codes by number of outliers
	graph hbar outliers_total_hs2 if outliers_total_hs2 > 8, ///
				over(hs2, sort(1) descending) ///
				ytitle("") ///
				yscale(range(210)) ///
				title("Top 10 HS2 codes with most outliers in total for first 3 categories") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				nofill	

	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2_total.png", replace
				
	restore
	
//----				
	* DECLARED CUSTOMS DUTIES & LEVIES
	
	* Determine lowest number of outliers for top 10 HS2 Codes
	ta hs2 outliers_sd3_dcust if outliers_sd3_dcust==1
	*It's 67
	
	* Create a variable that sums number of outliers by HS2 Codes
	bys hs2: egen outliers_dcust_hs2 = sum(outliers_sd3_dcust)

	preserve
	keep if outliers_dcust_hs2>66

	* Graph top 10 HS2 Codes by number of outliers
	graph hbar outliers_dcust_hs2 if outliers_dcust_hs2 > 66, ///
				over(hs2, sort(1) descending) ///
				ytitle("") ///
				title("Top 10 HS2 codes with most outliers in total for declared custom duties & levies") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6.5) ///
				nofill	

	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2_dcust.png", replace
				
	restore
	
//----				
	* DECLARED TAXES
	
	* Determine lowest number of outliers for top 10 HS2 Codes
	ta hs2 outliers_sd3_dtaxes if outliers_sd3_dtaxes==1
	*It's 18
	
	* Create a variable that sums number of outliers by HS2 Codes
	bys hs2: egen outliers_dtaxes_hs2 = sum(outliers_sd3_dtaxes)

	preserve
	keep if outliers_dtaxes_hs2>17
	
	* Graph top 10 HS2 Codes by number of outliers
	graph hbar outliers_dtaxes_hs2 if outliers_dtaxes_hs2 > 17, ///
				over(hs2, sort(1) descending) ///
				ytitle("") ///
				yscale(range(205)) ///
				title("Top 10 HS2 codes with most outliers in total for declared taxes") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(7) ///
				nofill		

	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2_dtaxes.png", replace
				
	restore
	
//----
	* DECLARED EXTRA TAXES & DUTIES
	
	* Determine lowest number of outliers for top 10 HS2 Codes
	ta hs2 outliers_sd3_dextra if outliers_sd3_dextra==1
	*It's 67
	
	* Create a variable that sums number of outliers by HS2 Codes
	bys hs2: egen outliers_dextra_hs2 = sum(outliers_sd3_dextra)
	
	* Graph top 10 HS2 Codes by number of outliers
	preserve
	keep if outliers_dextra_hs2>66
	
	graph hbar outliers_dextra_hs2 if outliers_dextra_hs2 > 66, ///
				over(hs2, sort(1) descending) ///
				ytitle("") ///
				title("Top 10 HS2 codes with most outliers in declared extra taxes & duties") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				nofill

	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2_dextra.png", replace
				
	restore
	
//----
	* TOTAL FOR DECLARED CATEGORIES
	
	* Determine lowest number of outliers for top 10 HS2 Codes
	ta hs2 outliers_sd3_dtotal if outliers_sd3_dtotal==1
	*It's 9
	
	* Create a variable that sums number of outliers by HS2 Codes
	bys hs2: egen outliers_dtotal_hs2 = sum(outliers_sd3_dtotal)
	
	preserve
	keep if outliers_dtotal_hs2>8
	
	* Graph top 10 HS2 Codes by number of outliers
	graph hbar outliers_dtotal_hs2 if outliers_dtotal_hs2 > 8, ///
				over(hs2, sort(1) descending) ///
				ytitle("") ///
				yscale(range(205)) ///
				title("Top 10 HS2 codes with most outliers in total for declared categories") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				nofill	

	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2_dtotal.png", replace

	restore
	
  *------------- Bar plots by HS2 codes with biggest trade gaps -------------*							

  * Generate a new variable with only the 11 HS2_Gap codes with biggest trade gaps
  gen hs2_gap = .
  replace hs2_gap = hs2 if hs2 == 84 | ///
							hs2 == 85 | ///
							hs2 == 72 | ///
							hs2 == 87 | ///
							hs2 == 52 | ///
							hs2 == 12 | ///
							hs2 == 29 | ///
							hs2 == 15 | ///
							hs2 == 88 | ///
							hs2 == 90 | ///
							hs2 == 30
  
//----
	* CUSTOMS DUTIES & LEVIES
	
	* Create a variable that sums number of outliers by HS2_Gap Codes
	bys hs2_gap: egen outliers_cust_hs2_gap = sum(outliers_sd3_cust)
		
	* Graph countries by number of outliers
	graph hbar outliers_cust_hs2_gap, ///
				over(hs2_gap, sort(1) descending) ///
				ytitle("") ///
				yscale(range(205)) ///
				title("Number of outliers among HS2 gap codes in customs & levies") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6) ///
				nofill
	
	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2gap_cust.png", replace

//----
	* TAXES
	
	* Create a variable that sums number of outliers by HS2_Gap Codes
	bys hs2_gap: egen outliers_taxes_hs2_gap = sum(outliers_sd3_taxes)
		
	* Graph countries by number of outliers
	graph hbar outliers_taxes_hs2_gap, ///
				over(hs2_gap, sort(1) descending) ///
				ytitle("") ///
				yscale(range(205)) ///
				title("Number of outliers among HS2 gap codes in taxes") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6) ///
				nofill
	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2gap_taxes.png", replace
				
//----
	* EXTRA TAXES & DUTIES
	
	* Create a variable that sums number of outliers by HS2_Gap Codes
	bys hs2_gap: egen outliers_extra_hs2_gap = sum(outliers_sd3_extra)
		
	* Graph countries by number of outliers
	graph hbar outliers_extra_hs2_gap, ///
				over(hs2_gap, sort(1) descending) ///
				ytitle("") ///
				yscale(range(205)) ///
				title("Number of outliers among HS2 gap codes in extra taxes & duties") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6) ///
				nofill
	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2gap_extra.png", replace
			
//----
	* TOTAL FOR FIRST THREE CATEGORIES
	
	* Create a variable that sums number of outliers by HS2_Gap Codes
	bys hs2_gap: egen outliers_total_hs2_gap = sum(outliers_sd3_total)
		
	* Graph countries by number of outliers
	graph hbar outliers_total_hs2_gap, ///
				over(hs2_gap, sort(1) descending) ///
				ytitle("") ///
				yscale(range(205)) ///
				title("# of outliers among HS2 gap codes in total for first three categories") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6.5) ///
				nofill
	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2gap_total.png", replace
			
//----				
	* DECLARED CUSTOMS DUTIES & LEVIES
	
	* Create a variable that sums number of outliers by HS2_Gap Codes
	bys hs2_gap: egen outliers_dcust_hs2_gap = sum(outliers_sd3_dcust)
		
	* Graph countries by number of outliers
	graph hbar outliers_dcust_hs2_gap, ///
				over(hs2_gap, sort(1) descending) ///
				ytitle("") ///
				yscale(range(205)) ///
				title("Number of outliers among HS2 gap codes in declared custom duties & levies") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(7) ///
				nofill
	
	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2gap_dcust.png", replace
	
//----				
	* DECLARED TAXES
	
	* Create a variable that sums number of outliers by HS2_Gap Codes
	bys hs2_gap: egen outliers_dtaxes_hs2_gap = sum(outliers_sd3_dtaxes)
		
	* Graph countries by number of outliers
	graph hbar outliers_dtaxes_hs2_gap, ///
				over(hs2_gap, sort(1) descending) ///
				ytitle("") ///
				yscale(range(205)) ///
				title("Number of outliers among HS2 gap codes in declared taxes") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6) ///
				nofill
				
	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2gap_dtaxes.png", replace
			
//----
	* DECLARED EXTRA TAXES & DUTIES
	
	* Create a variable that sums number of outliers by HS2_Gap Codes
	bys hs2_gap: egen outliers_dextra_hs2_gap = sum(outliers_sd3_dextra)
		
	* Graph countries by number of outliers
	graph hbar outliers_dextra_hs2_gap, ///
				over(hs2_gap, sort(1) descending) ///
				ytitle("") ///
				yscale(range(205)) ///
				title("Number of outliers among HS2 gap codes in declared extra taxes & duties") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6.7) ///
				nofill
	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2gap_dextra.png", replace

//----
	* TOTAL FOR DECLARED CATEGORIES
	
	* Create a variable that sums number of outliers by HS2_Gap Codes
	bys hs2_gap: egen outliers_dtotal_hs2_gap = sum(outliers_sd3_dtotal)
		
	* Graph countries by number of outliers
	graph hbar outliers_dtotal_hs2_gap, ///
				over(hs2_gap, sort(1) descending) ///
				ytitle("") ///
				yscale(range(205)) ///
				title("# of outliers among HS2 gap codes in total for declared categories") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6.5) ///
				nofill
	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2gap_dtotal.png", replace

	save "$intermediate_data/Price_data_2907_graph_taxes.dta", replace

	*************************************************************************
	* Regression Taxes
	**************************************************************************
	
	use "$intermediate_data/Price_data_2907_taxes.dta", clear 
	
	* We create the log variables for the regression
	gen logimpUSD=log(imports_USD)
	
	gen logqua=log(quantity)

	* We make sure that string variables that need to be considered as dummies
	* are correctly encoded
	encode(shed_name),gen (shed_code)
	encode(co), gen(co_code)

	encode(currency_abbreviation), gen(currency_code)
	encode(processed_channel), gen(channel_code)
	
	egen overall_total=rowtotal(total_taxes decl_total)
	eststo clear	

	regress  overall_total i.hs2 i.shed_code i.co_code logimpUSD logqua i.year i.month i.currency_code i.channel_code 
	 
	esttab 	using "$intermediate_results/Tables/reg2.tex", label r2 ar2 ///
			se star(* 0.10 ** 0.05 *** 0.01) replace nobaselevels style(tex)	


	save "$intermediate_data/Price_data_2907_regression_taxes.dta", replace

	
