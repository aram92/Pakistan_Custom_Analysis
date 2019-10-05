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
  
	* Install Coefplot package
	ssc install coefplot, replace
	
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
						co=="Virgin Islands U.S." | ///
						co=="U.S Misc Pav Islands" | ///
						co=="American Samoa" | ///						KC's ADDITION
						co=="Johnston Island" | ///
						co=="United States"
	replace co="Dominican Republic" if co=="Dominican Rep." | co =="Dominican Republic"
	replace co="Bahrain" if co=="Bahrain/kingdom Of Bahrain"   		 // KC's ADDITION + EVERYTHING BELOW THIS
	replace co="Norway" if co=="Bouvet Island"						 //
	replace co="Cambodia" if co=="Cambodia/kampuchea Democratic"	 // 
	replace co="European Union" if co=="Canary Is"					 // Aram: This shall be Spain not an independent state
	replace co="Kiribati" if co=="Canton-endbry Island"				 // 
	replace co="Australia" if co=="Christmas Island" | ///
							  co=="Cocos (keeling) Island" | ///
							  co=="Heard Island And Mcdonald Isla" | ///
							  co=="Norfolk Island"
	replace co="Congo, Republic of the" if co=="Congo Republic Of" | co=="Congo"
	replace co="Congo, Democratic Republic of the" if co=="Congo, democratic Republic Of"
	replace co="Iran" if co=="Iran (islamic Republic Of)"
	replace co="Ivory Coast" if co=="Ivory Coast / Cote D'ivoire"
	replace co="North Korea" if co=="Korea (North)"
	replace co="South Korea" if co=="Korea (South)" | co=="Korea Republic Of" | co=="Rep. of Korea"
	replace co="Kazakhstan" if co=="Kazakistan"
	replace co="Kyrgyzstan" if co=="Kyrgyz Republic" | co =="Kyrzyghistan"
	replace co="Laos" if co=="Lao People's Democratic Republ"
	replace co="Libya" if co=="Libyan Arab Jamhirya"
	replace co="Moldova" if co=="MOLDOVA, REPUBLIC OF"
	replace co="Madagascar" if co=="Malagasy Rep"
	replace co="Myanmar" if co=="Myanmar/burma"
	replace co="Russia" if co=="Russian Fedration" | co=="Russian Federation"
	replace co="Saint Kitts and Nevis" if co=="Saint Kitts  and Nevis" | ///
			co=="St Christopher"
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
	replace co="Venezuela" if co=="Venezuela, bolivarian Republic"
	replace co="Tanzania" if co=="Tanzania, united Republic Of"
	replace co="Tanzania" if co=="United Rep. of Tanzania"
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
	
	save "$intermediate_data/Price_data_clean.dta", replace 

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
	bys hs4 yearmonth: egen av_unitprice=mean(unit_price_USD)
		
	* Create standard deviation by HS_code
	bys hs4 yearmonth: egen sd_unitprice= sd(unit_price_USD)

	* Create standard error by HS_code
	by  hs4 yearmonth: gen se_unitprice=sd_unitprice/sqrt(_N)

	* Create lower bound for CI by HS_code using 3SD
	bys  hs4 yearmonth: gen low_3sd=av_unitprice-3*sd_unitprice

	* Create upper bound for CI by HS_code using 3SD
	bys hs4 yearmonth: gen up_3sd=av_unitprice+3*sd_unitprice

	* create deviation per hs4 and yearmonth
	bys hs4 yearmonth: gen dev= unit_price_USD-av_unitprice
	bys hs4 yearmonth: gen abs_dev= abs(unit_price_USD-av_unitprice)
  sort hs4 year co QT_code
  save "$intermediate_data/check_prices.dta", replace
	
	
* ---------------------------------------------------------------------------- *
* Use export data to generate reference price #2
* ---------------------------------------------------------------------------- *

	import delimited "$exports_data/exports_comtrade_2017_2018.csv", clear
	
	
	gen co=reporter
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
			co=="Frecnh West Indies" | ///
			co=="French Guiana" | ///
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
						co=="Virgin Islands U.S." | ///
						co=="U.S Misc Pav Islands" | ///
						co=="American Samoa" | ///						KC's ADDITION
						co=="Johnston Island" | ///
						co=="United States"
	replace co="Dominican Republic" if co=="Dominican Rep." | co =="Dominican Republic"
	replace co="Bahrain" if co=="Bahrain/kingdom Of Bahrain"   		 // KC's ADDITION + EVERYTHING BELOW THIS
	replace co="Norway" if co=="Bouvet Island"						 //
	replace co="Cambodia" if co=="Cambodia/kampuchea Democratic"	 // 
	replace co="European Union" if co=="Canary Is"					 // Aram: This shall be Spain not an independent state
	replace co="Kiribati" if co=="Canton-endbry Island"				 // 
	replace co="Australia" if co=="Christmas Island" | ///
							  co=="Cocos (keeling) Island" | ///
							  co=="Heard Island And Mcdonald Isla" | ///
							  co=="Norfolk Island"
	replace co="Congo, Republic of the" if co=="Congo Republic Of" | co=="Congo"
	replace co="Congo, Democratic Republic of the" if co=="Congo, democratic Republic Of"
	replace co="Iran" if co=="Iran (islamic Republic Of)"
	replace co="Ivory Coast" if co=="Ivory Coast / Cote D'ivoire"
	replace co="North Korea" if co=="Korea (North)"
	replace co="South Korea" if co=="Korea (South)" | co=="Korea Republic Of" | co=="Rep. of Korea"
	replace co="Kazakhstan" if co=="Kazakistan"
	replace co="Kyrgyzstan" if co=="Kyrgyz Republic" | co =="Kyrzyghistan"
	replace co="Laos" if co=="Lao People's Democratic Republ"
	replace co="Libya" if co=="Libyan Arab Jamhirya"
	replace co="Moldova" if co=="MOLDOVA, REPUBLIC OF"
	replace co="Madagascar" if co=="Malagasy Rep"
	replace co="Myanmar" if co=="Myanmar/burma"
	replace co="Russia" if co=="Russian Fedration" | co=="Russian Federation"
	replace co="Saint Kitts and Nevis" if co=="Saint Kitts  and Nevis" | ///
			co=="St Christopher"
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
	replace co="Venezuela" if co=="Venezuela, bolivarian Republic"
	replace co="Tanzania" if co=="Tanzania, united Republic Of"
	replace co="Tanzania" if co=="United Rep. of Tanzania"
	* What to do about North/East/West Africa, Yugoslavia, Far East and all origins?? Not sure also
	* about the territories in the netherlands, just put them in comments here in case
	* Since they are all antilles, Shall we reclassify them as Netherlands Antilles ?

	* what about neutral zone?
	* What is Int.Brand Mfg.In Other Country? and Pacific Island Trtry ?

	* for below, make sure that no conflicting replace with my previous cleanings

		
	gen QT_code=""
	replace QT_code="SQM" if qtyunit=="Area in square metres"
	replace altqtyunit=altqtyunit*12 if qtyunit=="Dozen of items"
	replace QT_code="Number of items" if qtyunit=="Dozen of items"
	replace QT_code="Number of items" if qtyunit=="No Quantity"
	replace QT_code="Number of items" if qtyunit=="Number of items"
	replace QT_code="Number of pairs" if qtyunit=="Number of pairs"
	replace QT_code="Thousands" if qtyunit=="Thousands of items"
	replace QT_code="Cubic meters" if qtyunit=="Volume in cubic meters"
	replace QT_code="Volume in liters" if qtyunit=="Volume in litres" 
	replace QT_code="Carats" if qtyunit=="Weight in carats"
	replace QT_code="Kg" if qtyunit=="Weight in kilograms"
	replace QT_code="Number of items" if qtyunit==""

	
	* Generate hs4 and hs2 code:
	gen hs4 = int(commoditycode/100)
	label variable hs4 "HS4 code"
	gen hs2=int(hs4/100)

	gen unit_price_comtrade=log(tradevalueus/altqtyunit)
	gen sdu_price=unit_price_comtrade
	
	collapse (sum) netweightkg altqtyunit tradevalueus (mean) unit_price_comtrade (sd) sdu_price, by(hs4 year co QT_code)
	*drop if hs4==. | QT_code=="" | co==""
	sort hs4 year co QT_code
	save "$exports_data/ExportsToPK_collapsehs4_co.dta", replace
	
	* Merge
	merge 1:m hs4 year co QT_code using "$intermediate_data/check_prices.dta", generate(merge2)
  
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
	
	* Harmonizing post-merge HS2 values
	replace hs2=int(hs4/100)
	
	* Generate frequency distribution tables to see the distribution of unmatched data from the merge
	asdoc tab1 year shed_code hs2 co_code if merge2==2, replace label save(Price_check_Freq_Dist_9_25.rtf)

	save "$intermediate_data/Price_check_graphs.dta", replace

* ---------------------------------------------------------------------------- *
* 			Check regressions
* ---------------------------------------------------------------------------- *
	use "$intermediate_data/Price_check_graphs.dta", clear
	
	areg dev logimpUSD logqua i.channel_code i.shed_code i.co_code i.hs2, absorb(yearmonth) vce(cluster shed_code)	
	eststo m1 
	*"% Deviation from the mean"
	
	areg dev2 logimpUSD logqua i.channel_code i.shed_code i.hs2 i.co_code, absorb(yearmonth) vce(cluster shed_code)	
	eststo m2
	*"% Deviation from the mean"

	esttab m1 m2 using "$intermediate_results/Tables/Check_deteriminants_prices_9_25_final.rtf", label r2 ar2 ///
	             se star(* 0.10 ** 0.05 *** 0.01) replace nobaselevels style(tex) ///
				 title ("Determinants of prices and deviations from the average price")			 

	coefplot m2, keep(*.hs2) sort(,descending) xline(0) bgcolor(white) ///
					graphregion(fcolor(white)) byopts(xrescale) grid(none) ///
					ysize(20) scheme(s1color)
	quietly graph export "$intermediate_results/Graphs/PriceCoef_hs2.png", replace
	 
	coefplot m2, keep(*.shed_code) sort(,descending) xline(0) bgcolor(white) ///
					graphregion(fcolor(white)) byopts(xrescale) grid(none) ///
					ysize(12) xsize(6) scheme(s1color) coeflabels( ,labsize(vsmall))
	quietly graph export "$intermediate_results/Graphs/PriceCoef_shed.png", replace
	
	coefplot m2, keep(*.co_code) sort(,descending) xline(0) bgcolor(white) ///
					graphregion(fcolor(white)) byopts(xrescale) grid(none) ///
					ysize(10.5) scheme(s1color)
	quietly graph export "$intermediate_results/Graphs/PriceCoef_co.png", replace
	 
	coefplot m2, keep(logimpUSD logqua *.channel_code) xline(0) bgcolor(white) ///
				graphregion(fcolor(white)) byopts(xrescale) grid(none) ///
				scheme(s1color)
	quietly graph export "$intermediate_results/Graphs/PriceCoef_mainvars.png", replace

		
//---- Regressions without HS2 and CO
	
	areg dev logimpUSD logqua i.channel_code i.shed_code, absorb(yearmonth) vce(cluster shed_code)	
	eststo m3 
	*"% Deviation from the mean"
	
	areg dev2 logimpUSD logqua i.channel_code i.shed_code, absorb(yearmonth) vce(cluster shed_code)	
	eststo m4
	*"% Deviation from the mean"

	esttab m3 m4 using "$intermediate_results/Tables/Check_deteriminants_prices_9_25_final_NoHS2Co.rtf", label r2 ar2 ///
	             se star(* 0.10 ** 0.05 *** 0.01) replace nobaselevels style(tex) ///
				 title ("Determinants of prices and deviations from the average price (w/o hs2 & co)")			 
	 
	coefplot m3, keep(*.shed_code) sort(,descending) xline(0) bgcolor(white) ///
					graphregion(fcolor(white)) byopts(xrescale) grid(none) ///
					ysize(12) xsize(6) scheme(s1color) coeflabels( ,labsize(vsmall))
	quietly graph export "$intermediate_results/Graphs/PriceCoef_shed_NoHS2Co.png", replace
	
	 
	coefplot m3, keep(logimpUSD logqua *.channel_code) xline(0) bgcolor(white) ///
				graphregion(fcolor(white)) byopts(xrescale) grid(none) ///
				scheme(s1color)
	quietly graph export "$intermediate_results/Graphs/PriceCoef_mainvars_NoHS2Co.png", replace

//----	
	
	
	gen outliers_3sd=1


	* remove from outliers the values within the CI
	replace outliers_3sd=0 if low_3sd<unit_price_comtrade<up_3sd
	
	* Graph of distribution of outliers before dropping observations
	graph hbar (sum) outliers_3sd, over(yearmonth) ///
			title("Monthly number of outlier deviations from average price") ///
			subtitle("before dropping observations") ///
			blabel(bar, position(outside) format(%9.0fc) color(black)) ///
			ytitle("") ///
			yscale(range(18000) off) ///
			ylabel(, nogrid) ///
			xsize(6) ///
			scheme(s1color)
	
	graph export "$intermediate_results/Graphs/Price_outliers_3sd_predrop_9_25.png", replace

	preserve
	
	* Drop HS4 code for which number of observations are under 30
	bys hs4 yearmonth: drop if _N<30
	* The above command deletes 272,488 observations
	
	* Graph of distribution of outliers after dropping observations
	graph hbar (sum) outliers_3sd, over(yearmonth) ///
			title("Monthly number of outlier deviations from average price") ///
			subtitle("after dropping observations") ///
			blabel(bar, position(outside) format(%9.0fc) color(black)) ///
			ytitle("") ///
			yscale(range(18000) off) ///
			ylabel(, nogrid) ///
			xsize(6) ///
			scheme(s1color)
	
	graph export "$intermediate_results/Graphs/PriceCheck_o_3sd_postdrop_9_25.png", as(png) height(800) replace
	
	restore
	

**************************************************************************
* 			Check graphs
**************************************************************************
		
	keep if outliers_3sd==1

				*------------- BAR PLOTS BY MONTH -------------*
		
//----
	
	*collapse per hs4 shed_name yearmonth and origin country: count to have the number of outliers, sum of absolute deviation)
*	collapse (sum) abs_dev2 (count) outliers_3sd, by(hs4 shed_name yearmonth co) 
	
	preserve
	
	collapse (sum) abs_dev2 (count) outliers_3sd, by(yearmonth) 
	
	* @Kaustubh now you have sum ob abs dev and count of outliers. You will need to change the code for the graph
	graph hbar (asis) outliers_3sd, over(yearmonth) ///
			title("Monthly number of outlier deviations from average price") ///
			blabel(bar, position(outside) format(%9.0fc) color(black)) ///
			ytitle("") ///
			yscale(range(18000) off) ///
			ylabel(, nogrid) ///
			xsize(6) ///
			scheme(s1color)
				
 graph export "$intermediate_results/Graphs/PriceCheck_o_3sd_month_9_25.png", as(png) height(800) replace
//----
	* SUM OF ABSOLUTE VALUE OF % DEVIATIONS FROM THE MEAN BY MONTH
	

	* Create bar plot of sum of absolute value of % deviations from the mean by month
	graph hbar abs_dev2, over(yearmonth) ///
			title("Sum of deviations from as compared to the reference price") ///
			blabel(bar, position(outside) format(%9.3fc) color(black)) ///
			ytitle("") ///
			yscale(range(5300) off) ///
			ylabel(, nogrid) ///
			xsize(6) ///
			scheme(s1color)

	graph export "$intermediate_results/Graphs/PriceCheck_absdev_month_year_9_25.png", as(png) height(800) replace
	restore
	
	
				*------------- BAR PLOTS BY SHED -------------*
//---- 
	
	preserve
	
	collapse (sum) abs_dev2 (count) outliers_3sd, by(shed_name) 
	
	* sorting by most outliers using gsort
	gsort -outliers_3sd
		
	* Graph top 10 Sheds by number of outliers
	graph hbar outliers_3sd in 1/10 , ///
			over(shed_name, sort(1) descending) ///
			title("Top 10 sheds with most number of" "outlier deviations from average price") ///
			blabel(bar, position(outside) format(%9.0fc) color(black)) ///
			ytitle("") ///
			yscale(range(60000) off) ///
			ylabel(, nogrid) ///
			xsize(6) ///
			scheme(s1color)
	
	graph export "$intermediate_results/Graphs/PriceCheck_o_3sd_shed_9_25.png", as(png) height(800) replace
	
  gsort - abs_dev2
	* Graph top 10 Sheds by sum of deviation 
	graph hbar abs_dev in 1/10, ///
			over(shed_name, sort(1) descending) ///
			title("Top 10 sheds with biggest sums of" "outlier deviations from average prices") ///
			blabel(bar, position(outside) format(%10.3fc) color(black)) ///
			ytitle("") ///
			yscale(range(18000) off) ///
			ylabel(, nogrid) ///
			xsize(6) ///
			scheme(s1color)
	
	graph export "$intermediate_results/Graphs/Price_absdev_shed_9_25.png", as(png) height(800) replace
	
	restore
	
	
				*------------- BAR PLOTS BY COUNTRY -------------*
//----
	preserve
	collapse (sum) abs_dev2 (count) outliers_3sd, by(co) 
	gsort -outliers_3sd
		
	* Graph top 10 countries by number of outliers
	graph hbar outliers_3sd in 1/10, ///
				over(co, sort(1) descending) ///
				title("Top 10 countries with most number of" "outlier deviations from average price") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				ytitle("") ///
				yscale(range(25000) off) ///
				ylabel(, nogrid) ///
				scheme(s1color)
	
	graph export "$intermediate_results/Graphs/PriceCheck_o_3sd_co_9_25.png", as(png) height(800) replace
	
	gsort -abs_dev2
		
	* Graph top 10 countries by sum of deviation
	graph hbar abs_dev2 in 1/10 , ///
			over(co, sort(1) descending) ///
			title("Top 10 countries with biggest sums of" "outlier deviations from average prices") ///
			blabel(bar, position(outside) format(%9.3fc) color(black)) ///
			ytitle("") ///
 			yscale(range(9500) off) ///
			ylabel(, nogrid) ///
			scheme(s1color)
       
	graph export "$intermediate_results/Graphs/PriceCheck_absdev_co_9_25.png", as(png) height(800) replace
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
				title("Top 10 HS2 codes with most number of" "outlier deviations from average prices") ///
				blabel(bar, position(outside) format(%9.0fc) color(black)) ///
				ytitle("") ///
				yscale(range(61000) off) ///
				ylabel(, nogrid) ///
				scheme(s1color)
	
	graph export "$intermediate_results/Graphs/PriceCheck_o_3sd_hs2_9_25.png", as(png) height(800) replace
	
	
	gsort -abs_dev2

	graph hbar abs_dev2 in 1/10, ///
				over(hs2, sort(1) descending) ///
				title("Top 10 HS2 codes with biggest sums of" "outlier deviations from average prices") ///
				blabel(bar, position(outside) format(%10.3fc) color(black)) ///
				ytitle("") ///
				yscale(off) ///
				ylabel(, nogrid) ///
				scheme(s1color)
	
	graph export "$intermediate_results/Graphs/PriceCheck_absdev_hs2_9_25.png", as(png) height(800) replace
	
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
				yscale(range(61000) off) ///
				ylabel(, nogrid) ///
				scheme(s1color)
	
	graph export "$intermediate_results/Graphs/PriceCheck_o_3sd_hs2gap_9_25.png", as(png) height(800) replace
		
	
	gsort -abs_dev2

	graph hbar abs_dev2, ///
				over(hs2_gap, sort(1) descending) ///
				title("HS2 codes with biggest trade gaps by sums of" "outlier deviations from average prices") ///
				blabel(bar, position(outside) format(%10.3fc) color(black)) ///
				ytitle("") ///
				yscale(off) ///
				ylabel(, nogrid) ///
				scheme(s1color)
	
	graph export "$intermediate_results/Graphs/PriceCheck_absdev_hs2gap_9_25.png", as(png) height(800) replace
		
	restore

**************************************************************************
* 			TAX AND TRADE GAP
**************************************************************************

	use "$intermediate_data/Price_data_clean.dta", clear
	
	

	* Merge the data set containing the exchange rate variable
	merge m:1 year month using "$initial_data/Exchange_rate.dta", gen(_Merge_Tax)
	drop if _merge!=3
	
	
//----
	* Create the three categories required as a percent of original price

	* Custom Duty
	egen cust_duty_levies_temp=rowtotal(customsduty federalexciseduty petrloeumlevy)
	gen cust_duty_levies = ((cust_duty_levies_temp/USDollar)/imports_USD)*100
	
	* Taxes
	egen taxes_temp=rowtotal(salestax incometax salestaxleviedascedinvatmode salestaxonlocalsupplies)
	gen taxes = ((taxes_temp/USDollar)/imports_USD)*100

	* Extra taxes
	egen extra_taxes_temp=rowtotal(incometaxsurcharge additionalcustomduty gensaletax regduty antidumping addsaletax edibleoilcess frf warehousesurcharge iqra specialfed developmentsurcharge surcharge vrdamount overstayedgoodssurcharge servicecharge guaranteeadditionalsalestax countervailingduty)
	gen extra_taxes = ((extra_taxes_temp/USDollar)/imports_USD)*100

	* Generate total
	egen total_taxes_temp=rowtotal(cust_duty_levies taxes extra_taxes)
	gen total_taxes = ((total_taxes_temp/USDollar)/imports_USD)*100

	
//----
	* Create the three additional categories for declared

	* Declared custom duties
	egen decl_cust_temp=rowtotal(decalredcustomsduty decalredfederalexciseduty decalredpetrloeumlevy)
	gen decl_cust = ((decl_cust_temp/USDollar)/imports_USD)*100

	* Declared taxes
	egen decl_taxes_temp=rowtotal(decalredsalestax decalredincometax decalredsalestaxleviedascedinvat decalredsalestaxonlocalsupplies)
	gen decl_taxes = ((decl_taxes_temp/USDollar)/imports_USD)*100

	* Declared extra taxes
	egen decl_extra_taxes_temp=rowtotal(decalredincometaxsurcharge decalredadditionalcustomduty decalredgensaletax decalredregduty decalredantidumping decalredaddsaletax decalrededibleoilcess decalredfrf decalredwarehousesurcharge decalrediqra decalredspecialfed decalreddevelopmentsurcharge decalredsurcharge decalredvrdamount decalredoverstayedgoodssurcharge decalredservicecharge decalredguaranteeadditionalsales decalredcountervailingduty)
	gen decl_extra_taxes = ((decl_extra_taxes_temp/USDollar)/imports_USD)*100

	* Declared total
	egen decl_total_temp = rowtotal(decl_cust decl_taxes decl_extra_taxes)
	gen decl_total = ((decl_total_temp/USDollar)/imports_USD)*100

	drop if year!=2017
	
//----
	* Loop to create averages and standard deviations for each of the categories
	local category_taxes "cust_duty_levies taxes extra_taxes total_taxes decl_cust decl_taxes decl_extra_taxes decl_total"
	foreach var in `category_taxes' {
		* Create means, SD by HS code
		bys hs4 yearmonth: egen av_`var'= mean(`var')
		bys hs_code yearmonth:  gen sd_`var' =`var'
		gen dev`var'=`var'-av_`var'
		
		* Generate sum of absolute deviations from mean
		bys hs4: gen per_dev_`var'=(`var' - av_`var')/av_`var'
		bys yearmonth: egen dev_`var' = sum(abs(per_dev_`var'))
	}

	
	save "$intermediate_data/check_prices_taxes.dta", replace
	
	
*****************Revenue loss estimation using previously calculated trade gaps:
	use "$imports_data\imports_2017_2018.full.dta", clear

	
	gen QT_code="Number of items"
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

	label variable shed_name "Shed name"
	replace shed_name="South Asia Pakistan Terminals" ///
				if shed_name=="SOUTH ASIA PAKISTAN TERMINALS"
	replace shed_name="Peshawar Torkham" if shed_name=="PESHAWAR TORKHAM"
	 
	collapse (sum) import_export_value_rs declaredimportvalue netweight quantity,by(hs4 QT_code date co)
	gen month=month(date)
	gen year=year(date)
	save "$imports_data/imports_yearcollapsed.full.dta", replace

	drop if year!=2017
	sort year month

	merge m:1 year month using "$initial_data/Exchange_rate.dta"
	drop if _merge!=3
	gen imports_USD=import_export_value_rs/USDollar
	save "$imports_data/imports_yearcollapsed.full.dta", replace

	preserve
	collapse (sum) imports_USD declaredimportvalue netweigh quantity, by(hs4 QT_code)
	save "$imports_data/imports_yearcollapsedhs4_all.dta", replace
	restore

	 * use comtrade data
	import delimited "$exports_data/exports_comtrade_2017_2018.csv", clear
	
	gen co=reporter
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
			co=="Frecnh West Indies" | ///
			co=="French Guiana" | ///
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
						co=="Virgin Islands U.S." | ///
						co=="U.S Misc Pav Islands" | ///
						co=="American Samoa" | ///						KC's ADDITION
						co=="Johnston Island" | ///
						co=="United States"
	replace co="Dominican Republic" if co=="Dominican Rep." | co =="Dominican Republic"
	replace co="Bahrain" if co=="Bahrain/kingdom Of Bahrain"   		 // KC's ADDITION + EVERYTHING BELOW THIS
	replace co="Norway" if co=="Bouvet Island"						 //
	replace co="Cambodia" if co=="Cambodia/kampuchea Democratic"	 // 
	replace co="European Union" if co=="Canary Is"					 // Aram: This shall be Spain not an independent state
	replace co="Kiribati" if co=="Canton-endbry Island"				 // 
	replace co="Australia" if co=="Christmas Island" | ///
							  co=="Cocos (keeling) Island" | ///
							  co=="Heard Island And Mcdonald Isla" | ///
							  co=="Norfolk Island"
	replace co="Congo, Republic of the" if co=="Congo Republic Of" | co=="Congo"
	replace co="Congo, Democratic Republic of the" if co=="Congo, democratic Republic Of"
	replace co="Iran" if co=="Iran (islamic Republic Of)"
	replace co="Ivory Coast" if co=="Ivory Coast / Cote D'ivoire"
	replace co="North Korea" if co=="Korea (North)"
	replace co="South Korea" if co=="Korea (South)" | co=="Korea Republic Of" | co=="Rep. of Korea"
	replace co="Kazakhstan" if co=="Kazakistan"
	replace co="Kyrgyzstan" if co=="Kyrgyz Republic" | co =="Kyrzyghistan"
	replace co="Laos" if co=="Lao People's Democratic Republ"
	replace co="Libya" if co=="Libyan Arab Jamhirya"
	replace co="Moldova" if co=="MOLDOVA, REPUBLIC OF"
	replace co="Madagascar" if co=="Malagasy Rep"
	replace co="Myanmar" if co=="Myanmar/burma"
	replace co="Russia" if co=="Russian Fedration" | co=="Russian Federation"
	replace co="Saint Kitts and Nevis" if co=="Saint Kitts  and Nevis" | ///
			co=="St Christopher"
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
	replace co="Venezuela" if co=="Venezuela, bolivarian Republic"
	replace co="Tanzania" if co=="Tanzania, united Republic Of"
	replace co="Tanzania" if co=="United Rep. of Tanzania"
	* What to do about North/East/West Africa, Yugoslavia, Far East and all origins?? Not sure also
	* about the territories in the netherlands, just put them in comments here in case
	* Since they are all antilles, Shall we reclassify them as Netherlands Antilles ?

	* what about neutral zone?
	* What is Int.Brand Mfg.In Other Country? and Pacific Island Trtry ?

		
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

	
	* Generate hs4 and hs2 code:
	
	gen hs4 = int(commoditycode/100)
	label variable hs4 "HS4 code"
	gen hs2=int(hs4/100)
	
	preserve 
	drop if year != 2017 	//40,313 observations deleted
	collapse (sum) netweightkg altqtyunit tradevalueus, by(hs4 QT_code)
	sort hs4 QT_code
	save "$exports_data/ExportsToPK_collapsehs4.dta", replace
	restore

	* Sum stats per hs4 : @Alice since ExportsToPK_collapsehs4 doesn't have co, I've skipped it from the merge command
	use "$imports_data/imports_yearcollapsedhs4_all.dta", clear
	sort hs4 QT_code 
	merge 1:1 hs4 QT_code using "$exports_data/ExportsToPK_collapsehs4.dta"
	save "$onedrive/Mirror and desc stats/matched_hs4.dta", replace

	replace tradevalueus =0 if tradevalueus ==.
	replace imports_USD=0 if imports_USD==.
	replace altqtyunit =0 if altqtyunit ==.
	replace netweightkg =0 if netweightkg ==.
	replace  quantity =0 if  quantity ==.

	bys hs4 QT_code : gen trade_gap_HS4=tradevalueus-imports_USD
	bys hs4 QT_code : gen weight_gap_HS4=altqtyunit-quantity

	
	collapse (sum) tradevalueus imports_USD trade_gap_HS4 weight_gap_HS4 altqtyunit quantity, by(hs4 QT_code)
	gen hs2=int(hs4/100)
	gen tenpercciffob=tradevalueus*0.15
	gen allowedgap=imports_USD*0.15

	gen hs2_names="Animal Prod" if hs2<=6
	replace hs2_names="Veg. Prod" if hs2>=6 & hs2<16
	replace hs2_names=" Food Stuffs" if hs2>=16 & hs2<25
	replace hs2_names=" Mineral Prod" if hs2>=25 & hs2<28
	replace hs2_names="Chem/Allied Ind" if hs2>=28 & hs2<39
	replace hs2_names="Plastics/Rubber" if hs2>=39 & hs2<41
	replace hs2_names="Hides & Furs" if hs2>=41 & hs2<44
	replace hs2_names="Wood Products" if hs2>=44 & hs2<50
	replace hs2_names="Textiles" if hs2>=50 & hs2<64
	replace hs2_names="Footwear/Headgear" if hs2>=64 & hs2<68
	replace hs2_names="Stone/glass" if hs2>=68 & hs2<72
	replace hs2_names="Metals" if hs2>=72 & hs2<84
	replace hs2_names="Machinery/Elec." if hs2>=84 & hs2<86
	replace hs2_names="Transportation" if hs2>=86 & hs2<90
	replace hs2_names="Misc." if hs2>=90

	collapse (sum) tradevalueus imports_USD trade_gap_HS4 weight_gap_HS4 altqtyunit quantity, by(hs4)
	sort hs4
	save "$intermediate_data/trade_gaps.dta", replace

	use "$intermediate_data/check_prices_taxes.dta"

	collapse (mean) cust_duty_levies taxes extra_taxes total_taxes (first) av_cust_duty_levies av_taxes av_extra_taxes av_total_taxes (sd) sd*, by(hs4)
	sort hs4
	merge 1:1 hs4 using "$intermediate_data/trade_gaps.dta"
	
	gen logtrad=log(trade_gap_HS4)
	gen logavtaxes=log(av_total_taxes)
	gen logtotaltaxes=log(total_taxes)
	gen logsdtaxes=log(sd_total_taxes)

	gen hs2=int(hs4/100)
	
	gen av_effective_tax = float(av_total_taxes/100)
	bys hs4: gen lossUSD = av_effective_tax*trade_gap_HS4	
	
	save "$intermediate_data/check_prices_gap_preregression.dta", replace
	
*-------------------------------------------------------------------------------	
	use "$intermediate_data/check_prices_gap_preregression.dta", clear

	collapse (sum) lossUSD, by(hs2)
	
	keep if hs2 == 99 | ///
			hs2 == 88 | ///
			hs2 == 71 | ///
			hs2 == 64 | ///
			hs2 == 62 | ///
			hs2 == 42 | ///
			hs2 == 61 | ///
			hs2 == 93 | ///
			hs2 == 50 | ///
			hs2 == 24
	
	gen tradegap_order = 0
	replace tradegap_order = 1 if hs2 == 99
	replace tradegap_order = 2 if hs2 == 88
	replace tradegap_order = 3 if hs2 == 71
	replace tradegap_order = 4 if hs2 == 64
	replace tradegap_order = 5 if hs2 == 62
	replace	tradegap_order = 6 if hs2 == 42
	replace tradegap_order = 7 if hs2 == 61
	replace tradegap_order = 8 if hs2 == 93
	replace tradegap_order = 9 if hs2 == 50
	replace tradegap_order = 10 if hs2 == 24
	
	
	* Graph top 10 HS2 codes with most tax lost
	gsort tradegap_order

	graph hbar lossUSD, ///
				over(hs2, sort(tradegap_order)) ///
				title("Tax revenue losses of Top 10 HS2 codes with greatest positive" "trade gaps, 2017") ///
				subtitle("(U.S. Dollars)") ///
				note("Using import and tax data from FBR and export data from UN Comtrade") ///
				blabel(bar, position(outside) format(%15.0fc) color(black)) ///
				ytitle("") ///
				yscale(range(5500000) off) ///
				ylabel(, nogrid) ///
				scheme(s1color)
	
	graph export "$intermediate_results/Graphs/TaxLoss_FBRComtrade_Order_10_2.png", as(png) height(800) replace
	
*--------------

	use "$intermediate_data/check_prices_gap_preregression.dta", clear

	collapse (sum) lossUSD, by(hs2)
	
	* Graph top 10 HS2 codes with most tax lost
	gsort -lossUSD

	graph hbar lossUSD in 1/10, ///
				over(hs2, sort(1) descending) ///
				title("Top 10 HS2 codes with most tax revenue losses" "due to trade gaps, 2017") ///
				subtitle("(U.S. Dollars)") ///
				note("Using import and tax data from FBR and export data from UN Comtrade") ///
				blabel(bar, position(outside) format(%15.0fc) color(black)) ///
				ytitle("") ///
				yscale(range(16500000) off) ///
				ylabel(, nogrid) ///
				scheme(s1color)
	
	graph export "$intermediate_results/Graphs/TaxLoss_FBRComtrade_Top_10_2.png", as(png) height(800) replace	
	
	
*-------------------------------------------------------------------------------	
	
	use "$intermediate_data/check_prices_gap_preregression.dta", clear
	
	eststo clear
	reghdfe trade_gap_HS4 av_total_taxes, vce(cluster hs2) noabsorb
	eststo reg_trade_gap_log1
	reghdfe trade_gap_HS4 av_total_taxes sd_total_taxes, vce(cluster hs2) noabsorb
	eststo reg_trade_gap_log2
	reghdfe weight_gap_HS4 av_total_taxes, vce(cluster hs2) noabsorb
	eststo reg_weight_gap_log1
	reghdfe weight_gap_HS4 av_total_taxes sd_total_taxes, vce(cluster hs2) noabsorb
	eststo reg_weight_gap_log2
	
	reghdfe trade_gap_HS4 total_tax av_total_taxes, vce(cluster hs2) noabsorb
	eststo reg_trade_gap1
	reghdfe trade_gap_HS4 total_tax av_total_taxes sd_total_taxes, vce(cluster hs2) noabsorb
	eststo reg_trade_gap2
	reghdfe weight_gap_HS4 total_tax av_total_taxes, vce(cluster hs2) noabsorb
	eststo reg_weightgap_HS4_1
	reghdfe weight_gap_HS4 total_tax av_total_taxes sd_total_taxes, vce(cluster hs2) noabsorb
	eststo reg_weightgap_HS4_2
	reghdfe logtrad logtotaltaxes logavtaxes logsdtaxes, vce(cluster hs2) noabsorb
	eststo reg_logtrad

	esttab reg_trade_gap_log1 reg_trade_gap_log2 reg_weight_gap_log1 reg_weight_gap_log2 using ///
			"$intermediate_results/Tables/DeterminantsofGapNEW_FBRComtrade_10_1.rtf", ///
				label r2 ar2 se star(* 0.10 ** 0.05 *** 0.01) ///
				replace nobaselevels style(tex)
				
	esttab reg_trade_gap1 reg_trade_gap2 reg_weightgap_HS4_1 reg_weightgap_HS4_2 reg_logtrad using ///
			"$intermediate_results/Tables/DeterminantsofGap_FBRComtrade_10_1.rtf", ///
				label r2 ar2 se star(* 0.10 ** 0.05 *** 0.01) ///
				replace nobaselevels style(tex)
				
	coefplot reg_trade_gap1, bylabel(DV: Trade Gap) || ///
				reg_trade_gap2, bylabel(DV: Trade Gap) || ///
				reg_logtrad, bylabel(DV: log(Trade Gap)) ||, byopts(xrescale) ///
								xline(0) mlabel format(%14.3fc) mlabposition(2) ///
								mlabgap(*2) bgcolor(white) ///
								graphregion(fcolor(white)) grid(none) ///
								scheme(s1color)
	quietly graph export "$intermediate_results/Graphs/TradeGap_FBRComtrade_DeterminantsofGap_9_30.png", replace
	
	coefplot reg_weightgap_HS4_1, bylabel(DV: Weight Gap) || ///
				reg_trade_gap2, bylabel(DV: Weight Gap) ||, byopts(xrescale) ///
								xline(0) mlabel format(%14.3fc) mlabposition(2) ///
								mlabgap(*2) bgcolor(white) ///
								graphregion(fcolor(white)) grid(none) ///
								scheme(s1color)
					
	quietly graph export "$intermediate_results/Graphs/WeightGap_FBRComtrade_DeterminantsofGap_9_30.png", replace

	
	
	
*-------------------------------------------------------------------------------	
*-------------------------------------------------------------------------------
* 								COMTRADE-COMTRADE ANALYSIS
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------


/*------------------------------------------------------------------------------
	Analysis at HS4 level
*------------------------------------------------------------------------------*/	

	use "$exports_data/ExportsToPK_clean.dta", clear
	
	drop if exp_year != 2017
	collapse (sum) exp_netweightkg exp_altqtyunit exp_tradevalueus exp_unitprice_comtrade, by(hs4 QT_code)
	sort hs4 QT_code
	* This dataset has 5,819 observations
	save "$exports_data/ExportsToPK2017_collapsehs4_QT_9_30.dta", replace
	
	
	use "$imports_data/ImportsToPK_clean.dta", clear
	
	drop if imp_year != 2017
	collapse (sum) imp_netweightkg imp_altqtyunit imp_tradevalueus imp_unitprice_comtrade, by(hs4 QT_code)
	sort hs4 QT_code
	* This dataset has 4,816 observations
	save "$imports_data/ImportsToPK2017_collapsehs4_QT_9_30.dta", replace
	
	merge 1:1 hs4 QT_code using "$exports_data/ExportsToPK2017_collapsehs4_QT_9_30.dta"
	* Matched: 1,320 | Not Matched: 352 (101 from imports, 251 from exports)
	
	replace exp_tradevalueus = 0 if exp_tradevalueus==.
	replace imp_tradevalueus = 0 if imp_tradevalueus==.
	replace exp_altqtyunit = 0 if exp_altqtyunit==.
	replace imp_altqtyunit = 0 if imp_altqtyunit==.

	bys hs4 QT_code: gen trade_gap_HS4=exp_tradevalueus-imp_tradevalueus
	bys hs4 QT_code: gen weight_gap_HS4=exp_altqtyunit-imp_altqtyunit

			
	collapse (sum) trade_gap_HS4 weight_gap_HS4, by(hs4)
	
	save "$onedrive/Mirror and desc stats/matched_comtrade_hs4QT_9_30.dta", replace
	
	
	use "$intermediate_data/check_prices_taxes.dta", clear
	collapse (mean) total_taxes (first) av_total_taxes (sd) sd*, by(hs4)
	sort hs4
	merge 1:1 hs4 using "$onedrive/Mirror and desc stats/matched_comtrade_hs4QT_9_30.dta", generate(merge3)
	* Matched: 1,154 | Not Matched: 55 (4 from check_prices_taxes, 51 from matched_comtrade_hs4QT_9_30)
	
	gen hs2=int(hs4/100)

	gen av_effective_tax = float(av_total_taxes/100)
	bys hs4: gen lossUSD = av_effective_tax*trade_gap_HS4	
	
	gen logavtaxes=log(av_total_taxes)
	gen logsdtaxes=log(sd_total_taxes)
	
	save "$intermediate_data/preregression_10_1.dta", replace

*-------------------------------------------------------------------------------	
	use "$intermediate_data/preregression_10_1.dta", clear

	collapse (sum) lossUSD, by(hs2)
	
	keep if hs2 == 99 | ///
			hs2 == 88 | ///
			hs2 == 71 | ///
			hs2 == 64 | ///
			hs2 == 62 | ///
			hs2 == 42 | ///
			hs2 == 61 | ///
			hs2 == 93 | ///
			hs2 == 50 | ///
			hs2 == 24
	
	gen tradegap_order = 0
	replace tradegap_order = 1 if hs2 == 99
	replace tradegap_order = 2 if hs2 == 88
	replace tradegap_order = 3 if hs2 == 71
	replace tradegap_order = 4 if hs2 == 64
	replace tradegap_order = 5 if hs2 == 62
	replace	tradegap_order = 6 if hs2 == 42
	replace tradegap_order = 7 if hs2 == 61
	replace tradegap_order = 8 if hs2 == 93
	replace tradegap_order = 9 if hs2 == 50
	replace tradegap_order = 10 if hs2 == 24
	
	
	* Graph top 10 HS2 codes with most tax lost
	gsort tradegap_order

	graph hbar lossUSD, ///
				over(hs2, sort(tradegap_order)) ///
				title("Tax revenue losses of Top 10 HS2 codes with greatest positive" "trade gaps, 2017") ///
				subtitle("(U.S. Dollars)") ///
				note("Using both import and export data from UN Comtrade and tax data from FBR") ///
				blabel(bar, position(outside) format(%15.0fc) color(black)) ///
				ytitle("") ///
				yscale(range(2800000) off) ///
				ylabel(, nogrid) ///
				scheme(s1color)
	
	graph export "$intermediate_results/Graphs/TaxLoss_Comtrade_Order_10_2.png", as(png) height(800) replace
	
*--------------

	use "$intermediate_data/preregression_10_1.dta", clear

	collapse (sum) lossUSD, by(hs2)
	
	* Graph top 10 HS2 codes with most tax lost
	gsort -lossUSD

	graph hbar lossUSD in 1/10, ///
				over(hs2, sort(1) descending) ///
				title("Top 10 HS2 codes with most tax revenue losses" "due to trade gaps, 2017") ///
				subtitle("(U.S. Dollars)") ///
				note("Using both import and export data from UN Comtrade and tax data from FBR") ///
				blabel(bar, position(outside) format(%15.0fc) color(black)) ///
				ytitle("") ///
				yscale(off) ///
				ylabel(, nogrid) ///
				scheme(s1color)
	
	graph export "$intermediate_results/Graphs/TaxLoss_Comtrade_Top_10_2.png", as(png) height(800) replace	

*--------------

	keep if hs4==7101 | ///
			hs4==7107 | ///
			hs4==7111
	
*-------------------------------------------------------------------------------
	
	use "$intermediate_data/preregression_10_1.dta", clear
	
	eststo clear
	reghdfe trade_gap_HS4 av_total_taxes, vce(cluster hs2) noabsorb
	eststo reg_tradegap_log1
	reghdfe trade_gap_HS4 av_total_taxes sd_total_taxes, vce(cluster hs2) noabsorb
	eststo reg_tradegap_log2
	reghdfe weight_gap_HS4 av_total_taxes, vce(cluster hs2) noabsorb
	eststo reg_weightgap_log1
	reghdfe weight_gap_HS4 av_total_taxes sd_total_taxes, vce(cluster hs2) noabsorb
	eststo reg_weightgap_log2
	
	
	reghdfe trade_gap_HS4 total_taxes av_total_taxes, vce(cluster hs2) noabsorb
	eststo reg_tradegapHS4
	reghdfe trade_gap_HS4 total_taxes av_total_taxes sd_total_taxes, vce(cluster hs2) noabsorb
	eststo reg_tradegapHS4_sd
	reghdfe weight_gap_HS4 total_taxes av_total_taxes, vce(cluster hs2) noabsorb
	eststo reg_weightgapHS4
	reghdfe weight_gap_HS4 total_taxes av_total_taxes sd_total_taxes, vce(cluster hs2) noabsorb
	eststo reg_weightgapHS4_sd
	
	esttab reg_tradegap_log1 reg_tradegap_log2 reg_weightgap_log1 reg_weightgap_log2 using ///
			"$intermediate_results/Tables/DeterminantsofGapNEW_ComtradeOnly_10_1.rtf", ///
				label r2 ar2 se star(* 0.10 ** 0.05 *** 0.01) ///
				replace nobaselevels style(tex)

	esttab reg_tradegapHS4 reg_tradegapHS4_sd reg_weightgapHS4 reg_weightgapHS4_sd using ///
			"$intermediate_results/Tables/DeterminantsofGap_ComtradeOnly_10_1.rtf", ///
				label r2 ar2 se star(* 0.10 ** 0.05 *** 0.01) ///
				replace nobaselevels style(tex)
				
	coefplot reg_tradegapHS4, bylabel(DV: Trade Gap) || ///
				reg_tradegapHS4_sd, bylabel(DV: Trade Gap) ||, ///
								byopts(xrescale) xline(0)  ///
								mlabel format(%14.3fc) mlabposition(2) ///
								mlabgap(*2) bgcolor(white) ///
								graphregion(fcolor(white)) grid(none) ///
								scheme(s1color)
	quietly graph export "$intermediate_results/Graphs/TradeGap_DeterminantsofGap_ComtradeOnly_9_30.png", replace
	
	coefplot reg_weightgapHS4, bylabel(DV: Weight Gap) || ///
				reg_weightgapHS4_sd, bylabel(DV: Weight Gap) ||, byopts(xrescale) ///
								xline(0) mlabel format(%14.3fc) mlabposition(2) ///
								mlabgap(*2) bgcolor(white) ///
								graphregion(fcolor(white)) grid(none) ///
								scheme(s1color)
					
	quietly graph export "$intermediate_results/Graphs/WeightGap_DeterminantsofGap_ComtradeOnly_9_30.png", replace
