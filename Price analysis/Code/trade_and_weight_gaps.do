* ******************************************************************** *

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
 
 * ******************************************************************** *
			
	import delimited "$imports_data/imports_comtrade_2017_2018.csv", clear
	
	foreach x of varlist * {
         rename `x' imp_`x'
	}

	* Dropping reporter as its only value is Pakistan in the case of imports
	drop imp_reporter
	
	gen co=imp_partner
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
	replace QT_code="SQM" if imp_qtyunit=="Area in square metres"
	replace imp_altqtyunit=imp_altqtyunit*12 if imp_qtyunit=="Dozen of items"
	replace QT_code="Number of items" if imp_qtyunit=="Dozen of items"
	replace QT_code="Number of items" if imp_qtyunit=="No Quantity"
	replace QT_code="Number of items" if imp_qtyunit=="Number of items"
	replace QT_code="Number of pairs" if imp_qtyunit=="Number of pairs"
	replace QT_code="Thousands" if imp_qtyunit=="Thousands of items"
	replace QT_code="Cubic meters" if imp_qtyunit=="Volume in cubic meters"
	replace QT_code="Volume in liters" if imp_qtyunit=="Volume in litres" 
	replace QT_code="Carats" if imp_qtyunit=="Weight in carats"
	replace QT_code="Kg" if imp_qtyunit=="Weight in kilograms"
	replace QT_code="Number of items" if imp_qtyunit==""

	
	* Generate hs6 and hs2 code:
	gen hs6 = int(imp_commoditycode)
	label variable hs6 "HS6 code"
	gen hs4=int(hs6/100)
	label variable hs4 "HS4 code"

	gen imp_unitprice_comtrade=log(imp_tradevalueus/imp_altqtyunit)
	gen imp_sdu_price=imp_unitprice_comtrade
	
	collapse (sum) imp_netweightkg imp_altqtyunit imp_tradevalueus imp_unitprice_comtrade, by(hs4 QT_code)
	sort hs4 QT_code
	save "$imports_data/ImportsToPK_collapsehs4_QT.dta", replace
	
****************************** SAME THING FOR EXPORTS COMTRADE DATA

import delimited "$exports_data/exports_comtrade_2017_2018.csv", clear
	
	foreach x of varlist * {
         rename `x' exp_`x'
	}

	gen co=exp_reporter
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
	replace QT_code="SQM" if exp_qtyunit=="Area in square metres"
	replace exp_altqtyunit=exp_altqtyunit*12 if exp_qtyunit=="Dozen of items"
	replace QT_code="Number of items" if exp_qtyunit=="Dozen of items"
	replace QT_code="Number of items" if exp_qtyunit=="No Quantity"
	replace QT_code="Number of items" if exp_qtyunit=="Number of items"
	replace QT_code="Number of pairs" if exp_qtyunit=="Number of pairs"
	replace QT_code="Thousands" if exp_qtyunit=="Thousands of items"
	replace QT_code="Cubic meters" if exp_qtyunit=="Volume in cubic meters"
	replace QT_code="Volume in liters" if exp_qtyunit=="Volume in litres" 
	replace QT_code="Carats" if exp_qtyunit=="Weight in carats"
	replace QT_code="Kg" if exp_qtyunit=="Weight in kilograms"
	replace QT_code="Number of items" if exp_qtyunit==""

	
	* Generate hs6 and hs2 code:
	gen hs6 = int(exp_commoditycode)
	label variable hs6 "HS6 code"
	gen hs4=int(hs6/100)
	label variable hs4 "HS4 code"

	gen exp_unitprice_comtrade=log(exp_tradevalueus/exp_altqtyunit)
	gen exp_sdu_price=exp_unitprice_comtrade
	
	collapse (sum) exp_netweightkg exp_altqtyunit exp_tradevalueus exp_unitprice_comtrade, by(hs4 QT_code)
	sort hs4 QT_code
	save "$exports_data/ExportsToPK_collapsehs4_QT.dta", replace
	
	* Merge
	merge 1:1 hs4 QT_code using "$imports_data/ImportsToPK_collapsehs4_QT.dta"
	
	/* The above merge results in 1,373 matched obs. and 400 unmatched obs. out
		of which the 244 were from the exports comtrade data and 156 were from
		imports comtrade data.
	*/
	
	bys hs4 QT_code: gen trade_gap_hs4=exp_tradevalueus-imp_tradevalueus       
	bys hs4 QT_code: gen weight_gap_hs4=exp_altqtyunit-imp_altqtyunit
	/* The above two commands generate 387 missing values in each of the two
		variables, which are the ones that were not matched in the merge.
		This can be confirmed by the following two commands:
	*/
	tab _merge trade_gap_hs4 if trade_gap_hs4==., missing
	tab _merge weight_gap_hs4 if weight_gap_hs4==., missing
	
	save "$onedrive/Mirror and desc stats/matched_comtrade_hs4QT.dta", replace
	
**************************************************************************
* 			Data Visualization
**************************************************************************
	
	use "$onedrive/Mirror and desc stats/matched_comtrade_hs4QT.dta", clear

	collapse (sum) trade_gap_hs4 weight_gap_hs4, by(hs4)
	
	gsort -trade_gap_hs4
	
	graph hbar trade_gap_hs4 in 1/10, ///
				over(hs4, sort(1) descending) ///
				title("Top 10 HS4 codes with largest trade gaps" "between export and import comtrade data") ///
				blabel(bar, position(outside) format(%16.0fc) color(black)) ///
				ytitle("") ///
				yscale(off) ///
				ylabel(, nogrid) ///
				scheme(s1color)
	
	graph export "$intermediate_results/Graphs/tradegap_comtrade_hs4_9_4.png", as(png) height(800) replace

	
	gsort -weight_gap_hs4
	
	graph hbar trade_gap_hs4 in 1/10, ///
				over(hs4, sort(1) descending) ///
				title("Top 10 HS4 codes with largest weight gaps" "between export and import comtrade data") ///
				blabel(bar, position(outside) format(%17.0fc) color(black)) ///
				ytitle("") ///
				yscale(range(-400000000) off) ///
				ylabel(, nogrid) ///
				scheme(s1color)
			
	graph export "$intermediate_results/Graphs/weightgap_comtrade_hs4_9_4.png", as(png) height(800) replace
