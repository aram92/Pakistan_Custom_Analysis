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
	
/*
	* Install of a package to export tables as docx files
	ssc install asdoc
	ssc install estout
  
	* Install Tabplot package
	ssc inst tabplot, replace
	
	* Install ftools (remove program if it existed previously)
	cap ado uninstall ftools
	ssc install ftools
	
	* Install reghdfe 5.x
	cap ado uninstall reghdfe
	ssc install reghdfe
	
	* Install boottest for Stata 11 and 12 only
	if (c(version)<13) cap ado uninstall boottest
	if (c(version)<13) ssc install boottest
	
	* Install moremata (sometimes used by ftools but not needed for reghdfe)
	cap ssc install moremata
	
	ftools, compile
	reghdfe, compile
*/

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
	if c(username)=="wb554990" {
			global onedrive "C:/Users/wb554990/OneDrive - WBG/Pakistan Custom Data Analysis"
			}
			
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
	global imports_data				"$onedrive/Imports"
	global exports_data				"$onedrive/ExportsToPK_comtrade"

	* Upload the most recent data set 
	use "$intermediate_data/Price_data_2907.dta", clear 

* ---------------------------------------------------------------------------- *
* Data Cleaning
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
	label variable shed_name "Shed name"
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
         
	* Generate hs6 code:
	gen hs6=int(hs_code*100)
	label variable hs6 "HS6 code"
	
	*generate yearmonth
	gen yearmonth=ym(year,month)
		
	* Manually labelling yearmonth because the following formatting command is 
	* not sufficient to make dates appear in graphs: "format yearmonth %tmMonth,_CCYY"
	label variable yearmonth "Month-Year"
	label define yearmonth_label 684 "January, 2017" ///
									685	"February, 2017" ///
									686	"March, 2017" ///
									687	"April, 2017" ///
									688	"May, 2017" ///
									689	"June, 2017" ///
									690	"July, 2017" ///
									691	"August, 2017" ///
									692	"September, 2017" ///
									693	"October, 2017" ///
									694	"November, 2017" ///
									695	"December, 2017" ///
									696	"January, 2018" ///
									697	"February, 2018" ///
									698	"March, 2018" ///
									699	"April, 2018" ///
									700	"May, 2018" ///
									701	"June, 2018"
									
	label values yearmonth yearmonth_label
	
	* Label the variables year and month (probably useless now)
	label variable year "Year"
	label variable month "Month"
	label define month_names 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" ///
							 7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
	label values month month_names
	
	* Setting font for graphs to Times New Roman
	graph set window fontface "Times New Roman"
	
* ---------------------------------------------------------------------------- *
* Reuse the code to generate reference price #1
* ---------------------------------------------------------------------------- *
	
	* Generate new variable for sheds for the frequency distribution table
	encode shed_name, gen(shed_name_temp)

	* Generate and encode a new variable with desired countries & all other as
	* "Rest of the World"
	gen co_temp = "Rest of the World"
	
	replace co_temp = co if co=="China" | ///
							co=="European Union" | ///
							co=="UAE" | ///
							co=="USA" | ///
							co=="Japan" | ///
							co=="Thailand" | ///
							co=="Malaysia" | ///
							co=="Indonesia" | ///
							co=="India" | ///
							co=="Switzerland" | ///
							co=="South Korea" | ///
							co=="Singapore"
							
	encode co_temp, gen (country)
	gen unit_price_USD=log(imports_USD/quantity)

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

	* create deviation per hs6 and yearmonth
	bys hs6 yearmonth: gen dev= unit_price_USD-av_unitprice
	bys hs6 yearmonth: gen abs_dev= abs(unit_price_USD-av_unitprice)
  sort hs6 co QT_code
  save "$intermediate_data/check_prices.dta", replace
	
	
* ---------------------------------------------------------------------------- *
* Use export data to generate reference price #2
* ---------------------------------------------------------------------------- *

  use "$exports_data\ExportsToPK.dta"
	gen co=origin_country
	replace co="United States"  if co=="USA"
	replace co="European Union" if co=="Austria" | ///
		co=="Belgium" | ///
		co=="Bulgaria" | ///
		co=="Croatia" | ///
		co=="Republic of Cyprus" | ///
		co=="Czech Republic" | ///
		co=="Denmark" | ///
		co=="Estonia" | ///
		co=="Finland" | ///
		co=="France" | ///
		co=="Germany" | ///
		co=="Greece" | ///
		co=="Hungary" | /// 
		co=="Ireland" | ///
		co=="Italy" | ///
		co=="Latvia" | ///
		co=="Lithuania" | ///
		co=="Luxembourg" | ///
		co=="Malta" | ///
		co=="Netherlands" | ///
		co=="Poland" | ///
		co=="Portugal" | ///
		co=="Romania" | ///
		co=="Slovakia" | ///
		co=="Slovenia" | ///
		co=="Spain" | ///
		co=="Sweden" | ///
		co=="United Kingdom" | ///
		co=="Azores" | ///
		co=="Europein Union" | ///
		co=="Balearic Is" | ///
		co=="Czechia" | ///
		co=="Madeira" | ///
		co=="Liechtenstein" | ///
		co=="German Fedr Republic" | ///
		co=="German Demo Republic" | ///
		co=="Faeroe Islands" | ///
		co=="Czechoslovakia"

	replace co="Bolivia" if co=="Bolivia (Plurinational State of)"
	replace co="Bosnia" if co=="Bosnia And Herzegovina" | co=="Bosnia Herzegovina"
	replace co="China" if co=="China, Hong Kong SAR" | co==" Hong Kong, china "
	replace co="UAE" if co=="UNITED ARAB EMIRATES" | co=="United Arab Emirates"
	replace co="USA" if co=="United States Minor Outlying I" | co=="Virgin Islands U.S. " | co==" U.S Misc Pav Islands" | co=="United States"
	replace co="Dominican Republic" if co=="Dominica" | co=="Dominican Rep." |co =="Dominican Republic"

		
	gen QT_code=""
	replace QT_code="SQM" if qtyunit=="Area in square metres"
	replace altqtyunit=altqtyunit*12 if qtyunit=="Dozen of items"
	replace QT_code="Number of items" if qtyunit=="Dozen of items"
	replace QT_code="Number of items" if qtyunit=="No Quantity"
	replace QT_code="Number of items" if qtyunit=="Number of items"
	replace QT_code="Number of pairs" if qtyunit=="Number of pairs"
	replace altqtyunit=altqtyunit*1000 if qtyunit=="Thousands of items"
	replace QT_code="Number of pairs" if qtyunit=="Thousands of items"
	replace QT_code="Cubic meters" if qtyunit=="Volume in cubic meters"
	replace QT_code="Volume in liters" if qtyunit=="Volume in litres" 
	replace QT_code="Carats" if qtyunit=="Weight in carats"
	replace QT_code="Kg" if qtyunit=="Weight in kilograms"
	replace QT_code="Number of items" if qtyunit==""

	
	* Generate hs2 and hs6 code:
	gen hs2=int(hs4/100)
	gen hs6=int(hs4*100)
	label variable hs6 "HS6 code"

	gen unit_price_comtrade=log(tradevalueus/altqtyunit)
	gen sdu_price=unit_price_comtrade
	collapse (sum) netweightkg altqtyunit tradevalueus (mean) unit_price_comtrade (sd) sdu_price, by(hs6 QT_code co)
	drop if hs6==. | QT_code=="" | co==""
	sort hs6 co QT_code
	save "$exports_data\ExportsToPK_collapsehs6_co.dta", replace
	
	* Merge
	merge 1:m hs6 co QT_code using "$intermediate_data/check_prices.dta", generate(two)
  
  * We create the log variables for the regression
	gen logimpUSD=log(imports_USD)
	gen logqua=log(quantity)
	
	* We make sure that string variables that need to be considered as dummies
	* are correctly encoded
	encode(shed_name),gen (shed_code)
	encode(co), gen(co_code)
	encode(currency_abbreviation), gen(currency_code)
	encode(processed_channel), gen(channel_code)

	gen dev2= unit_price_USD-unit_price_comtrade
	gen abs_dev2=abs(unit_price_USD-unit_price_comtrade)

* ---------------------------------------------------------------------------- *
* 			Check regressions
* ---------------------------------------------------------------------------- *
  reghdfe dev logimpUSD logqua i.channel_code i.shed_code i.co_code i.hs2, absorb(i.yearmonth) vce(cluster shed_code yearmonth)		
	eststo m2 
	*"% Deviation from the mean"
	reghdfe dev2 logimpUSD logqua i.channel_code i.shed_code i.hs2 i.co_code, absorb( i.yearmonth) vce(cluster shed_code yearmonth)			
	eststo m3 
	*"% Deviation from the mean"

	esttab m1 m2 using "$intermediate_results/Tables/Check_deteriminants_prices_8_23.rtf", label r2 ar2 ///
	             se star(* 0.10 ** 0.05 *** 0.01) replace nobaselevels style(tex) title ("Determinants of prices and deviations from the average price")
	
	gen outliers_3sd=1


	* remove from outliers the values within the CI
	replace outliers_3sd=0 if low_3sd<unit_price_comtrade<up_3sd
	
	* Graph of distribution of outliers before dropping observations
	graph hbar (sum) outliers_3sd, over(yearmonth) ///
			title("Monthly number of outlier deviations from average price") ///
			subtitle("before dropping observations") ///
			blabel(bar, position(outside) format(%9.0fc) color(black)) ///
			ytitle("") ///
			yscale(range(22000) off) ///
			ylabel(, nogrid) ///
			xsize(6) ///
			scheme(s1color)
	
	graph export "$intermediate_results/Graphs/Price_outliers_3sd_predrop_8_23.pdf", replace

	* Drop HS6 code for which number of observations are under 30
	bys hs6 yearmonth: drop if _N<30
	
	* Graph of distribution of outliers after dropping observations
	graph hbar (sum) outliers_3sd, over(yearmonth) ///
			title("Monthly number of outlier deviations from average price") ///
			subtitle("after dropping observations") ///
			blabel(bar, position(outside) format(%9.0fc) color(black)) ///
			ytitle("") ///
			yscale(range(22000) off) ///
			ylabel(, nogrid) ///
			xsize(6) ///
			scheme(s1color)
	
	graph export "$intermediate_results/Graphs/PriceCheck_o_3sd_postdrop_8_23.pdf", replace
	
	

**************************************************************************
* 			Check graphs
**************************************************************************
		
	keep if outliers_3sd==1

				*------------- BAR PLOTS BY MONTH -------------*
		
//----
	
	*collapse per hs6 shed_name yearmonth and origin country: count to have the number of outliers, sum of absolute deviation)
*	collapse (sum) abs_dev2 (count) outliers_3sd, by(hs6 shed_name yearmonth co) 
	
	preserve
	
	collapse (sum) abs_dev2 (count) outliers_3sd, by(yearmonth) 
	
	* @Kaustubh now you have sum ob abs dev and count of outliers. You will need to change the code for the graph
	graph hbar (asis) outliers_3sd, over(yearmonth) ///
			title("Monthly number of outlier deviations from average price") ///
			blabel(bar, position(outside) format(%9.0fc) color(black)) ///
			ytitle("") ///
			yscale(off) ///
			ylabel(, nogrid) ///
			xsize(6) ///
			scheme(s1color)
				
	graph export "$intermediate_results/Graphs/PriceCheck_o_3sd_month_8_23.rtf", replace

//----
	* SUM OF ABSOLUTE VALUE OF % DEVIATIONS FROM THE MEAN BY MONTH
	

	* Create bar plot of sum of absolute value of % deviations from the mean by month
	graph hbar abs_dev2, over(yearmonth) ///
			title("Sum of deviations from as compared to the reference price") ///
			blabel(bar, position(outside) format(%9.3fc) color(black)) ///
			ytitle("") ///
			yscale(range(2100) off) ///
			ylabel(, nogrid) ///
			xsize(6) ///
			scheme(s1color)

	graph export "$intermediate_results/Graphs/PriceCheck_absdev_month_year_8_23.rtf", replace
	restore
	
	
				*------------- BAR PLOTS BY SHED -------------*
//---- 
	
	preserve
	
	collapse (sum) abs_dev2 (count) outliers_3sd, by(shed_name) 
	
	* sorting by most outliers using gsort
	gsort - outliers_3sd
		
	* Graph top 10 Sheds by number of outliers
	graph hbar outliers_3sd in 1/10 , ///
			over(shed_name, sort(1) descending) ///
			title("Top 10 sheds with most" "outlier deviations from average price") ///
			blabel(bar, position(outside) format(%9.0fc) color(black)) ///
			ytitle("") ///
			yscale(range(60000) off) ///
			ylabel(, nogrid) ///
			xsize(6) ///
			scheme(s1color)
	
	graph export "$intermediate_results/Graphs/PriceCheck_o_3sd_shed_8_23.pdf", replace
	
  gsort - abs_dev2
	* Graph top 10 Sheds by sum of deviation 
	graph hbar abs_dev in 1/10, ///
			over(shed_name, sort(1) descending) ///
			title("Top 10 sheds with biggest sums of" "outlier deviations from average prices") ///
			blabel(bar, position(outside) format(%9.3fc) color(black)) ///
			ytitle("") ///
			yscale(range(4800) off) ///
			ylabel(, nogrid) ///
			xsize(6) ///
			scheme(s1color)
	
	graph export "$intermediate_results/Graphs/Price_absdev_shed_8_23.pdf", replace
	
	restore
	
	
				*------------- BAR PLOTS BY COUNTRY -------------*
//----
	preserve
	collapse (sum) abs_dev2 (count) outliers_3sd, by(co) 
	gsort -outliers_3sd
		
	* Graph top 10 countries by number of outliers
	graph hbar outliers_3sd in 1/10, ///
				over(co, sort(1) descending) ///
				title("Top 10 countries with most" "outlier deviations from average price") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				ytitle("") ///
				yscale(off) ///
				ylabel(, nogrid) ///
				scheme(s1color)
	
	graph export "$intermediate_results/Graphs/PriceCheck_o_3sd_co_8_23.pdf", replace
	
	gsort -abs_dev2
		
	* Graph top 10 countries by sum of deviation
	graph hbar abs_dev2 in 1/10 , ///
			over(co, sort(1) descending) ///
			title("Top 10 countries with biggest sums of" "outlier deviations from average prices") ///
			blabel(bar, position(outside) format(%9.3fc) color(black)) ///
			ytitle("") ///
 			yscale(range(4900) off) ///
			ylabel(, nogrid) ///
			scheme(s1color)
       
	graph export "$intermediate_results/Graphs/PriceCheck_absdev_co_8_23.pdf", replace
	restore

				*------------- BAR PLOTS BY HS2 CODE -------------*
//----
	* NUMBER OF OUTLIERS per HS code using 3SD, by HS2 code
	preserve 
	
	collapse (sum) abs_dev2 (count) outliers_3sd, by(hs2) 

	* Graph top 10 HS2 codes with most outliers
	gsort -outliers_3sd

	graph hbar outliers_3sd in 1/10, ///
				over(hs2, sort(1) descending) ///
				title("Top 10 HS2 codes with most" "outlier deviations from average prices") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				ytitle("") ///
				yscale(range(68000) off) ///
				ylabel(, nogrid) ///
				scheme(s1color)
	
	graph export "$intermediate_results/Graphs/PriceCheck_o_3sd_hs2_8_23.pdf", replace
	
	
	gsort -abs_dev2

	graph hbar abs_dev2 in 1/10, ///
				over(hs2, sort(1) descending) ///
				title("Top 10 HS2 codes with biggest sums of" "outlier deviations from average prices") ///
				blabel(bar, position(outside) format(%9.3fc) color(black)) ///
				ytitle("") ///
				yscale(range(5000) off) ///
				ylabel(, nogrid) ///
				scheme(s1color)
	
	graph export "$intermediate_results/Graphs/PriceCheck_absdev_hs2_8_23.pdf", replace
	
	restore
	
	*------------- BAR PLOTS BY HS2 CODES WITH BIGGEST TRADE GAPS -------------*
//----
	* NUMBER OF OUTLIERS per HS code using 3SD, by HS2_Gap codes
	preserve
	
	collapse (sum) abs_dev2 (count) outliers_3sd, by(hs2_gap) 
	
	* Graph HS2 codes with biggest trade gaps by number of outliers
	graph hbar outliers, ///
				over(hs2_gap, sort(1) descending) ///
				title("HS2 codes with biggest trade gaps by number of" "outlier deviations from average prices") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				ytitle("") ///
				yscale(range(70000) off) ///
				ylabel(, nogrid) ///
				scheme(s1color)
	
	graph export "$intermediate_results/Graphs/PriceCheck_o_3sd_hs2gap_8_23.pdf", replace
		
	
	gsort -abs_dev2

	graph hbar abs_dev2, ///
				over(hs2_gap, sort(1) descending) ///
				title("HS2 codes with biggest trade gaps by sums of" "outlier deviations from average prices") ///
				blabel(bar, position(outside) format(%9.3fc) color(black)) ///
				ytitle("") ///
				yscale(off) ///
				ylabel(, nogrid) ///
				scheme(s1color)
	
	graph export "$intermediate_results/Graphs/PriceCheck_absdev_hs2gap_8_23.pdf", replace
		
	restore

 

