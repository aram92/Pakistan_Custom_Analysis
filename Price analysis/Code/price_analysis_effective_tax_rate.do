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
	*ssc install asdoc
	*ssc install estout
  
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
*	set scheme plotplainblind
	
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

	* KC's additions:
	replace shed_name="South Asia Pakistan Terminals" ///
				if shed_name=="SOUTH ASIA PAKISTAN TERMINALS"
	replace shed_name="Peshawar Torkham" if shed_name=="PESHAWAR TORKHAM"

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
	*generate hs6 code:
	gen hs6=int(hs_code*100)
	
	*generate yearmonth
	gen yearmonth=ym(year,month)
* ---------------------------------------------------------------------------- *
* Trial on CI, to be applied on correct unit_price.
* ---------------------------------------------------------------------------- *
	
	* Create unit price in USD
	* We first need to make sure that for each quantity we have the same
	* unit of measurement by hs_code
	
	codebook QT_code
	ta QT_code
		
	gen flag=0
	bys hs6: replace flag=1 if QT_code!=QT_code[_N]
	ta flag 
		
	* There are 0.01% of cases with differences in the unit of measurement within 
	* a same hs6
	
	ta hs_code if flag==1
	br hs_code QT_code if flag==1
	
	* hs_code 7308.3 has 249 observations in KG and 4 in NO.)
	* @ Alice what do you suggest, I saw that NO stands for number but I am not 
	* sure if it is possible to convert it somehow.
	
	ta hs_code QT_code if hs_code>=7308&hs_code<=7309
	
	* For the moment we don't make any change and create the unit price based on 
	* the assumption that the unit of measurement are equivalement for each quantity
	
	gen unit_price_USD=imports_USD/quantity

	* Create mean by HS_Code and yearmonth
	bys hs6 yearmonth: egen av_unitprice=mean(unit_price_USD)
		
	* Create standard deviation by HS_code
	bys hs6 yearmonth: egen sd_unitprice= sd(unit_price_USD)

	* Create standard error by HS_code
	by  hs6 yearmonth: gen se_unitprice=sd_unitprice/sqrt(_N)

	* Create lower bound for CI by HS_code using 3SD
	bys  hs6 yearmonth: gen low_3sd=av_unitprice-3*sd_unitprice

	* Create upper bound for CI by HS_code using 3SD
	bys hs6 yearmonth: gen up_3sd=av_unitprice+3*sd_unitprice

	* Create percentage of deviation from the mean by HS_code
	bys hs6 yearmonth: gen per_dev=(unit_price_USD - av_unitprice)/av_unitprice

	* Create variable for outliers
	gen outliers_3sd=1

	* remove from outliers the values within the CI
	replace outliers_3sd=0 if low_3sd<unit_price_USD<up_3sd
	
	* Determine the % of outliers
	ta outliers_3sd
	* In this case we have 1.07% outliers

	save "$intermediate_data/Price_data_2907_outliers.dta", replace 

**************************************************************************
* 			Data Visualization
**************************************************************************
	
	use "$intermediate_data/Price_data_2907_outliers.dta", clear 

	
				*------------- BAR PLOTS BY MONTH -------------*

	* Label the variables year and month
	label variable year "Year"
	label variable month "Month"
	label define month_names 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
							 7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
	label values month month_names
	
	
		
//----
	* NUMBER OF OUTLIERS per HS code using 3SD, by month
	gen abs_dev=abs(per_dev)
	*Alice would drop this: preserve and then preserve and collapse
	
	keep if outliers_3sd==1
	*collapse per hs6 shed_code yearmoth and origin country: count to have the number of outliers, sum of absolute deviation)
	collapse (sum) abs_dev (count) outliers_3sd, by(hs6 shed_code yearmonth co) 
	
	preserve
	
	collapse (sum) abs_dev (count) outliers_3sd, by(yearmonth) 
	* @Kaustubh now you have sum ob abs dev and count of outliers. You will need to change the code for the graph
	* graph hbar (asis) outliers_3sd, over(month) by(yearmonth) ///
				ytitle("") ///
				yscale(range(4300)) ///
				note("Note: There are no observations for July-December 2018.") ///
				ylabel(, format(%9.0fc)) ///
				title("Monthly number of outlier deviations from average price") ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
				
	graph export "$intermediate_results/Graphs/Price_outliers_3sd_month.pdf", replace

//----
	* SUM OF ABSOLUTE VALUE OF % DEVIATIONS FROM THE MEAN BY MONTH
	

	* Create bar plot of sum of absolute value of % deviations from the mean by month
	graph hbar abs_dev, over(month) ///
				yscale(range(245)) ///
				ytitle("") ///
				ylabel(#3, format(%9.00fc)) ///
				by(year, title("Monthly sum of outlier deviations from average prices") ///
				note("Note: There are no observations for July-December 2018.")) ///
				blabel(bar, position(outside) format(%9.00fc) color(black))

	graph 	export "$intermediate_results/Graphs/Price_absdev_month_year.pdf", replace
	restore
	
				*------------- BAR PLOTS BY SHED -------------*
//---- 
	
	preserve
	collapse (sum) abs_dev (count) outliers_3sd, by(shed_name) 
	
	* sorting by most outliers using gsort
	gsort - outliers_3sd
	

		
	* Graph top 10 Sheds by number of outliers
	graph hbar outliers_3sd_shed in 1/l0 , ///
				over(shed_name, sort(1) descending) ///
				yscale(range(21000)) ///
				ylabel(, format(%9.0fc)) ///
				ytitle("") ///
				title("Top 10 sheds with most of outlier deviations from average price") ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
	
	graph export "$intermediate_results/Graphs/Price_outliers_3sd_shed.pdf", replace
	gsort - abs_dev
	* Graph top 10 Sheds by sum of deviation 
	graph hbar abs_dev in 1/l0, ///
				over(shed_name, sort(1) descending) ///
				yscale(range(21000)) ///
				ylabel(, format(%9.0fc)) ///
				ytitle("") ///
				title("Top 10 sheds with biggest sums of outlier deviations from average prices") ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
	
	graph export "$intermediate_results/Graphs/Price_absdev_shed.pdf", replace
	
	restore
	
	
				*------------- BAR PLOTS BY COUNTRY -------------*
//----
	preserve
	collapse (sum) abs_dev (count) outliers_3sd, by(co) 
	gsort -outliers_3sd
		
	* Graph top 10 countries by number of outliers
	graph hbar outliers_3sd in 1/10, ///
				over(co, sort(1) descending) ///
				yscale(range(8100)) ///
				ylabel(, format(%9.0fc)) ///
				ytitle("") ///
				title("Top 10 countries with most of outlier deviations from average price") ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
	
	graph export "$intermediate_results/Graphs/Price_outliers_3sd_co.pdf", replace
	
	gsort -abs_dev
		
	* Graph top 10 countries by sum of deviation
	graph hbar abs_dev in 1/10 , ///
				over(co, sort(1) descending) ///
				yscale(range(8100)) ///
				ylabel(, format(%9.0fc)) ///
				ytitle("") ///
				title("Top 10 countries with biggest sums of outlier deviations from average prices") ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
	
	graph export "$intermediate_results/Graphs/Price_absdev_co.pdf", replace
	restore

				*------------- BAR PLOTS BY HS2 CODE -------------*
//----
	* NUMBER OF OUTLIERS per HS code using 3SD, by HS2 code
	preserve 
	gen hs2=int(hs6/10000)
	
	collapse (sum) abs_dev (count) outliers_3sd, by(hs2) 

	* Graph top 10 HS2 codes with most outliers
	gsort -outliers_3sd

	graph hbar outliers_3sd in 1/10, ///
				over(hs2, sort(1) descending) ///
				yscale(range(31500)) ///
				ylabel(, format(%9.0fc)) ///
				ytitle("") ///
				title("Top 10 HS2 codes with most outlier deviations from average prices") ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
	
	graph 	export "$intermediate_results/Graphs/Price_outliers_3sd_hs2.pdf", replace
	
	gsort -abs_dev

	graph hbar abs_dev in 1/10, ///
				over(hs2, sort(1) descending) ///
				yscale(range(31500)) ///
				ylabel(, format(%9.0fc)) ///
				ytitle("") ///
				title("Top 10 HS2 codes with biggest sums of outlier deviations from average prices") ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
	
	graph 	export "$intermediate_results/Graphs/Price_absdev_hs2.pdf", replace
	
	restore
	
	*------------- BAR PLOTS BY HS2 CODES WITH BIGGEST TRADE GAPS -------------*
//----
	* NUMBER OF OUTLIERS per HS code using 3SD, by HS2_Gap codes
	preserve
	collapse (sum) abs_dev (count) outliers_3sd, by(hs2_gap) 
	
	* Graph HS2 codes with biggest trade gaps by number of outliers
	graph hbar outliers, ///
				over(hs2_gap, sort(1) descending) ///
				yscale(range(31000)) ///
				ylabel(, format(%9.0fc)) ///
				ytitle("") ///
				title("HS2 codes with biggest trade gaps by number of outlier deviations from average prices") ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
	
	graph export "$intermediate_results/Graphs/outliers_3sd_hs2gap.pdf", replace
		
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

	reghdfe, compile
	ftools, compile
	
	eststo clear	

	
	* @ Aram- I am changing this to make more readable tables 
	*Aram skipping the first reg if it crashes your computer
	*regress unit_price_USD i.hs2 i.shed_code i.co_code logimpUSD logqua i.year i.month i.currency_code i.channel_code 
	*qui 	reghdfe unit_price_USD logimpUSD logqua i.channel_code i.shed_code, ///
	*		absorb(i.currency_code i.co_code i.yearmonth i.hs6) ///
	*		vce(cluster shed_code yearmonth)
	
	*eststo m1 
	*"Unit price"
	
	gen dev=per_dev*av_unitprice
	
	areg dev logimpUSD logqua i.channel_code i.shed_code i.hs2, absorb( i.co_code i.yearmonth) vce(cluster shed_code )
				
	eststo m2 
	*"% Deviation from the mean"
	
	areg per_dev logimpUSD logqua i.channel_code i.shed_code i.hs2, absorb( i.co_code i.yearmonth) vce(cluster shed_code yearmonth)
				
	eststo m3 
	*"% Deviation from the mean"
	
	esttab 	m2 m3 using "$intermediate_results/Tables/Determinants_of_PirceDeviation.rtf", label r2 ar2 ///
			se star(* 0.10 ** 0.05 *** 0.01) replace nobaselevels style(tex) title ("Determinants of prices and deviations from the average price")
	
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

	* Total taxes: !!!! The other categories needs to be expressed in % as well!

	gen per_tax_price=(tax_USD/imports_USD)*100

	gen dec_per_tax_price=(dec_tax_USD/imports_USD)*100
	
	local category_taxes cust_duty_levies taxes extra_taxes total_taxes decl_cust decl_taxes decl_extra_taxes decl_total
	foreach var in category_taxes {
		* Create means, SD by HS code
		bys hs6 yearmonth: egen av_`var'= mean(`var')
		bys hs6 yearmonth: egen sd_`var' = sd(`var')
		gen dev`var'=`var'-av`var'
		
		* Create Lower bound for CI by HS code using 3SD
		bys hs6 yearmonth: gen sd3LB_`var'= av_`var' - (3 * sd_`var')
	
		* Create Upper bound for CI by HS code using 3SD
		bys hs6 yearmonth: gen sd3UB_`var'= av_`var' + (3 * sd_`var')
	
		* Create variable for outliers using 3SD
		gen o_`var'=1

		* Remove from outliers the values within 3SD
		replace o_`var'=0 if sd3LB_`var'<cust_duty_levies<sd3UB_`var'
	}
	label variable o_cust_duty_levies "Outliers in custom duties & levies"
	label variable o_taxes "Outliers in taxes"
	label variable o_extra_taxes "Outliers in extra taxes"
	label variable o_total_taxes "Outliers in total taxes"
	label variable o_decl_cust_duty_levies "Outliers in declared custom duties & levies"
	label variable o_decl_taxes "Outliers in declared taxes"
	label variable o_decl_extra_taxes "Outliers in declared extra taxes"
	label variable o_decl_total_taxes "Outliers in declared total taxes"
	
	label define outliers_cust 0 "Not Outlier" 1 "Outlier"
	label define outliers_taxes 0 "Not Outlier" 1 "Outlier"
	label define outliers_extra 0 "Not Outlier" 1 "Outlier"
	label define outliers_total 0 "Not Outlier" 1 "Outlier"
	label define outliers_dcust 0 "Not Outlier" 1 "Outlier"
	label define outliers_dtaxes 0 "Not Outlier" 1 "Outlier"
	label define outliers_dextra 0 "Not Outlier" 1 "Outlier"
	label define outliers_dtotal 0 "Not Outlier" 1 "Outlier"
	
	label values o_cust_duty_levies outliers_cust
	label values o_taxes outliers_taxes
	label values o_extra outliers_extra
	label values o_total outliers_total
	label values o_dcust outliers_dcust
	label values o_dtaxes outliers_dtaxes
	label values o_dextra outliers_dextra
	label values o_dtotal outliers_dtotal
	
	* Determine the % of outliers (3SD): @Kaustub: by this definition of outliers, and if the data were normally distributed, 
	*we should have around 0.1 to 0.5 % outliers max
	/*ta outliers_sd3_cust
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
 */
 
	asdoc tab1 outliers_sd3_cust outliers_sd3_taxes outliers_sd3_extra ///
				outliers_sd3_total outliers_sd3_dcust outliers_sd3_dtaxes ///
				outliers_sd3_dextra outliers_sd3_dtotal, replace label
	
	save "$intermediate_data/Price_data_2907_taxes.dta", replace
	collapse (sum) dev* (count) o_*, by(hs6 shed_code yearmonth co) 
				*------------- BAR PLOTS BY MONTH -------------*
//----
				
	* Create graph of # of outliers per HS code using 3SD, by MONTH & YEAR
	
	use "$intermediate_data/Price_data_2907_taxes.dta", clear

	preserve
	
	foreach var in category_taxes {
	keep if o_`var'==1
	graph hbar (count) o_`var', over(monthyear) ///
				ytitle("") ///
				ylabel(, format(%9.0fc)) ///
				by(year, title("Number of outliers per HS code for `"`: var label'"' ") ///
				subtitle("by month and year") ///
				note("Note: There are no observations for July-December 2018.")) ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
	
	graph 	export "$intermediate_results/Graphs/Taxes_o_`var'_month.pdf", replace

graph hbar (sum) dev`var', over(monthyear) ///
				ytitle("") ///
				ylabel(, format(%9.0fc)) ///
				by(year, title("sum of deviations per HS code for `"`: var label'"' ") ///
				subtitle("by month and year") ///
				note("Note: There are no observations for July-December 2018.")) ///
				blabel(bar, position(outside) format(%9.0fc) color(black))
	
	graph 	export "$intermediate_results/Graphs/Taxes_o_`var'_month.pdf", replace

	restore
	}
//----	

	
					*------------- Bar plot by shed -------------*
	
	* CUSTOMS DUTIES & LEVIES
	
	* Determine lowest number of outliers for top 10 Sheds
	ta shed_name outliers_sd3_cust if outliers_sd3_cust==1
	*It's 26

	* Create a variable that sums number of outliers by Sheds
	preserve
	collapse (sum) dev* (count) o_*, by(shed_code) 

	* Graph top 10 Sheds by number of outliers
		foreach var in category_taxes {
		keep if o_`var'==1
		gsort -o_`var'
		graph hbar o_`var' in 1/10,  ///
				over(shed_name, sort(1) descending) ///
				yscale(range(1100)) ///
				ytitle("") ///
				title("Top 10 sheds with most outliers in `"`: var label'"' ") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(7.3) ///
				nofill
	
	graph 	export "$intermediate_results/Graphs/Taxes_o_`var'_shed.pdf", replace
		gsort -dev
		graph hbar dev in 1/10,  ///
				over(shed_name, sort(1) descending) ///
				yscale(range(1100)) ///
				ytitle("") ///
				title("Top 10 sheds with most outliers in `"`: var label'"' ") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(7.3) ///
				nofill
	
	graph 	export "$intermediate_results/Graphs/Taxes_o_`var'_shed.pdf", replace
	
	restore
	

				*------------- Bar plot by country -------------*

//----

	* Create a variable that sums number of outliers by co
	preserve
	collapse (sum) dev* (count) o_*, by(co) 

	* Graph top 10 Sheds by number of outliers
		foreach var in category_taxes {
		keep if o_`var'==1
		gsort -o_`var'
		graph hbar o_`var' in 1/10,  ///
				over(co, sort(1) descending) ///
				yscale(range(1100)) ///
				ytitle("") ///
				title("Top 10 countries with most outliers in `"`: var label'"' ") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(7.3) ///
				nofill
	
	graph 	export "$intermediate_results/Graphs/Taxes_o_`var'_co.pdf", replace
		gsort -dev
		graph hbar dev in 1/10,  ///
				over(co, sort(1) descending) ///
				yscale(range(1100)) ///
				ytitle("") ///
				title("Top 10 sheds with most outliers in `"`: var label'"'") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(7.3) ///
				nofill
	
	graph 	export "$intermediate_results/Graphs/Taxes_o_`var'_co.pdf", replace
	
	restore
	
					*------------- Bar plot by HS2 -------------*							

//----
	** Create a variable that sums number of outliers by co
	preserve
	collapse (sum) dev* (count) o_*, by(hs2) 

	* Graph top 10 Sheds by number of outliers
		foreach var in category_taxes {
		keep if o_`var'==1
		gsort -o_`var'
		graph hbar o_`var' in 1/10,  ///
				over(hs2, sort(1) descending) ///
				yscale(range(1100)) ///
				ytitle("") ///
				title("Top 10 countries with most outliers in `"`: var label'"' ") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(7.3) ///
				nofill
	
	graph 	export "$intermediate_results/Graphs/Taxes_o_`var'_hs2.pdf", replace
		gsort -dev
		graph hbar dev in 1/10,  ///
				over(hs2, sort(1) descending) ///
				yscale(range(1100)) ///
				ytitle("") ///
				title("Top 10 hs2 with most deviations in `"`: var label'"'") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(7.3) ///
				nofill
	
	graph 	export "$intermediate_results/Graphs/Taxes_o_`var'_hs2.pdf", replace
	
	restore
 		 *------------- Bar plots by HS2 codes with biggest trade gaps -------------*							
  
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
	
	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2gap_cust.pdf", replace

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
				nofill
	
	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2gap_taxes.pdf", replace
				
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
				xsize(6.1) ///
				nofill
	
	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2gap_extra.pdf", replace
			
//----
	* TOTAL FOR FIRST THREE CATEGORIES
	
	* Create a variable that sums number of outliers by HS2_Gap Codes
	bys hs2_gap: egen outliers_total_hs2_gap = sum(outliers_sd3_total)
		
	* Graph countries by number of outliers
	graph hbar outliers_total_hs2_gap, ///
				over(hs2_gap, sort(1) descending) ///
				ytitle("") ///
				yscale(range(205)) ///
				title("Number of outliers among HS2 gap codes in total for first three categories") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(6.8) ///
				nofill
	
	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2gap_total.pdf", replace
			
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
				xsize(7.1) ///
				nofill
	
	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2gap_dcust.pdf", replace
	
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
				
	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2gap_dtaxes.pdf", replace
			
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
				xsize(6.8) ///
				nofill
	
	graph 	export "$intermediate_results/Graphs/outliers_3sd_hs2gap_dextra.pdf", replace

//----
	* TOTAL FOR DECLARED CATEGORIES
	
	* Create a variable that sums number of outliers by HS2_Gap Codes
	bys hs2_gap: egen outliers_dtotal_hs2_gap = sum(outliers_sd3_dtotal)
		
	* Graph countries by number of outliers
	graph hbar outliers_dtotal_hs2_gap, ///
				over(hs2_gap, sort(1) descending) ///
				ytitle("") ///
				yscale(range(205)) ///
				title("Number of outliers among HS2 gap codes in declared total") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				xsize(5.8) ///
				nofill
	
	graph export "$intermediate_results/Graphs/outliers_3sd_hs2gap_dtotal.pdf", replace

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

	areg devtotal_tax logimpUSD logqua i.channel_code i.shed_code i.hs2, absorb(i.co_code i.yearmonth) vce(cluster shed_code)
	 eststo m1
	 
	esttab 	using "$intermediate_results/Tables/reg2.tex", label r2 ar2 ///
			se star(* 0.10 ** 0.05 *** 0.01) replace nobaselevels style(tex)	


	save "$intermediate_data/Price_data_2907_regression_taxes.dta", replace

	
