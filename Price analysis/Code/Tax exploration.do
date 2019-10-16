********************************************************************************	
***************************** HS6 ANALYSIS FROM SCRATCH ************************
********************************************************************************	
	
	import delimited "$onedrive/Imports/PAK_rawdata.csv", clear bindquote(strict) maxquotedrows(1000)
	save "$intermediate_data/Price_data_10_1.dta", replace

*-------------------------------------------------------------------------------
	use "$intermediate_data/Price_data_10_1.dta", clear

	drop v1
	
	foreach var of varlist _all {
		capture confirm string variable `var' 
		if _rc==0 {
			replace `var'="." if `var'=="NA"
		}
	}
	
	local tax_vars "customsduty federalexciseduty countervailingduty antidumping petrloeumlevy edibleoilcess regduty salestax incometax gensaletax salestaxleviedascedinvatmode salestaxonlocalsupplies incometaxsurcharge additionalcustomduty addsaletax frf warehousesurcharge iqra specialfed developmentsurcharge surcharge vrdamount overstayedgoodssurcharge servicecharge guaranteeadditionalsalestax decalredcustomsduty decalredfederalexciseduty decalredcountervailingduty decalredantidumping decalredpetrloeumlevy decalrededibleoilcess decalredregduty decalredsalestax decalredincometax decalredgensaletax decalredsalestaxleviedascedinvat decalredsalestaxonlocalsupplies decalredincometaxsurcharge decalredadditionalcustomduty decalredaddsaletax decalredfrf decalredwarehousesurcharge decalrediqra decalredspecialfed decalreddevelopmentsurcharge decalredsurcharge decalredvrdamount decalredoverstayedgoodssurcharge decalredservicecharge decalredguaranteeadditionalsales"
	foreach var in `tax_vars' {
		destring `var', float replace
	}
	
	gen date=date(gd_date, "DMYhm")
	gen year=year(date)
	gen month=month(date)
	
	replace origin_country=strtrim(origin_country)
	gen co=origin_country
	
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

*-------------------------------	
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
*-_---------------------------	
	
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
	replace QT_code="SQM" if quantity_unit_code=="SQM"
	replace QT_code="Cubic meters" if quantity_unit_code=="cum"
	replace QT_code="Kg" if quantity_unit_code=="kg"
	replace QT_code="Number of items" if quantity_unit_code=="no" 
	replace QT_code="Number of pairs" if quantity_unit_code=="pair"
	replace QT_code="SQM" if quantity_unit_code=="sqm"
	
	
	label variable shed_name "Shed name"
	replace shed_name="South Asia Pakistan Terminals" ///
				if shed_name=="SOUTH ASIA PAKISTAN TERMINALS"
	replace shed_name="Peshawar Torkham" if shed_name=="PESHAWAR TORKHAM"
	
	
	gen hs4 = int(hs6/100)
	
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
	
	* Merge the data set containing the exchange rate variable
	merge m:1 year month using "$initial_data/Exchange_rate.dta", gen(_Merge_Tax)
/*	2,408 out of 3,406,177 not matched, out of which 2,398 from master and 10
	from using.
*/
	drop if _Merge_Tax!=3
	
	gen imports_USD=import_export_value_rs/USDollar
	
	drop if co=="Afghanistan"
	
	save "$intermediate_data/PriceData_clean_hs6_10_1.dta", replace
	
********************************************************************************
* 			TAX AND TRADE GAP
********************************************************************************

	use "$intermediate_data/PriceData_clean_hs6_10_1.dta", clear
	
	
//----
	* Create the three categories required as a percent of original price

	* Custom Duty
	egen cust_duty_levies_temp=rowtotal(customsduty federalexciseduty countervailingduty antidumping petrloeumlevy edibleoilcess regduty)
	gen cust_duty_levies = ((cust_duty_levies_temp/USDollar)/imports_USD)*100
	
	* Taxes
	egen taxes_temp=rowtotal(salestax incometax gensaletax salestaxleviedascedinvatmode salestaxonlocalsupplies)
	gen taxes = ((taxes_temp/USDollar)/imports_USD)*100

	* Extra taxes
	egen extra_taxes_temp=rowtotal(incometaxsurcharge additionalcustomduty addsaletax frf warehousesurcharge iqra specialfed developmentsurcharge surcharge vrdamount overstayedgoodssurcharge servicecharge guaranteeadditionalsalestax)
	gen extra_taxes = ((extra_taxes_temp/USDollar)/imports_USD)*100

	* Generate total
	egen total_taxes=rowtotal(cust_duty_levies taxes extra_taxes)

	
//----
	* Create the three additional categories for declared

	* Declared custom duties
	egen decl_cust_temp=rowtotal(decalredcustomsduty decalredfederalexciseduty decalredcountervailingduty decalredantidumping decalredpetrloeumlevy decalrededibleoilcess decalredregduty)
	gen decl_cust = ((decl_cust_temp/USDollar)/imports_USD)*100

	* Declared taxes
	egen decl_taxes_temp=rowtotal(decalredsalestax decalredincometax decalredgensaletax decalredsalestaxleviedascedinvat decalredsalestaxonlocalsupplies)
	gen decl_taxes = ((decl_taxes_temp/USDollar)/imports_USD)*100

	* Declared extra taxes
	egen decl_extra_taxes_temp=rowtotal(decalredincometaxsurcharge decalredadditionalcustomduty decalredaddsaletax decalredfrf decalredwarehousesurcharge decalrediqra decalredspecialfed decalreddevelopmentsurcharge decalredsurcharge decalredvrdamount decalredoverstayedgoodssurcharge decalredservicecharge decalredguaranteeadditionalsales)
	gen decl_extra_taxes = ((decl_extra_taxes_temp/USDollar)/imports_USD)*100

	* Declared total
	egen decl_total = rowtotal(decl_cust decl_taxes decl_extra_taxes)

	drop if year!=2017
	
//----
	* Loop to create averages and standard deviations for each of the categories
	local category_taxes "cust_duty_levies taxes extra_taxes total_taxes decl_cust decl_taxes decl_extra_taxes decl_total"
	foreach var in `category_taxes' {
		* Create means, SD by HS code
		bys hs6 yearmonth: egen av_`var'= mean(`var')
		bys hs6 yearmonth:  gen sd_`var' = `var'
		gen dev`var'=`var'-av_`var'
		
		* Generate sum of absolute deviations from mean
		bys hs6: gen per_dev_`var'=(`var' - av_`var')/av_`var'
		bys yearmonth: egen dev_`var' = sum(abs(per_dev_`var'))
	}

	save "$intermediate_data/TaxData_10_1.dta", replace

*------------------------------------------------------------------------------
	use "$intermediate_data/TaxData_10_1.dta", clear
	
	local category_taxes "cust_duty_levies taxes extra_taxes total_taxes decl_cust decl_taxes decl_extra_taxes decl_total"
	foreach var of local category_taxes {
		preserve
		collapse (mean)`var', by(hs6)

		hist `var', freq addlabels addlabopts(mlabsize(vsmall)) ytitle("") yscale(off) ///
			ylabel(, nogrid) xtitle("Taxation rate (%)") xlabel(,format(%15.0fc)) ///
			title("Distribution of average taxation rate per HS6 code for "`var') ///
			color(dkgreen) lstyle(axisline) graphregion(style(none) color(gs16))
			
		graph export "$intermediate_results/Graphs/TaxDist_`var'_10_11.png", as(png) height(800) replace
		
		restore
*%%%%%%%%%%%%		
		preserve
		
		collapse (mean) cust_duty_levies total_taxes, by(hs6)
		
		hist cust_duty_levies, freq addlabels ytitle("") yscale(off) ///
			ylabel(, nogrid) xtitle("Taxation rate (%)") xlabel(,format(%15.0fc)) ///
			title("Distribution of average taxation rate per HS6 code for cust_duty_levies") ///
			color(dkgreen) lstyle(axisline) graphregion(style(none) color(gs16)) ///
			width(10)
			
		graph export "$intermediate_results/Graphs/TaxDist_custdutylevies_10_11.png", as(png) height(800) replace

		
		hist total_taxes, freq addlabels ytitle("") yscale(off) ///
			ylabel(, nogrid) xtitle("Taxation rate (%)") xlabel(,format(%15.0fc)) ///
			title("Distribution of average taxation rate per HS6 code for total_taxes") ///
			color(dkgreen) lstyle(axisline) graphregion(style(none) color(gs16)) ///
			width(10)
			
		graph export "$intermediate_results/Graphs/TaxDist_totaltaxes_10_11.png", as(png) height(800) replace	
		
		restore
*%%%%%%%%%%%%		
		
		preserve
		gen `var'_max=`var'
		gen `var'_min=`var'
		
		collapse (min) `var'_min (max) `var'_max, by(hs4)
		gen d_`var'=`var'_max - `var'_min
		
		hist d_`var', freq addlabels addlabopts(mlabsize(vsmall)) ytitle("") yscale(off) ///
			ylabel(, nogrid) xtitle("Difference between minimum and maximum") ///
			xlabel(,format(%15.0fc)) color(dkgreen) lstyle(axisline) ///
			title("Distribution of difference between the minimum" "and maximum taxation rate per HS4 code for "`var') ///
			graphregion(style(none) color(gs16))
			
		
		graph export "$intermediate_results/Graphs/TaxDistDiff_`var'_10_11.png", as(png) height(800) replace
		
		restore
	}
	
	
	use "$intermediate_data/TaxData_10_1.dta", clear
		local category_taxes "cust_duty_levies taxes extra_taxes total_taxes decl_cust decl_taxes decl_extra_taxes decl_total"
	foreach var of local category_taxes {
		display "`var' per item"
		count if `var' > 100 & `var'!=.
		count if `var' > 1000 & `var'!=.
	}
	
	collapse (mean) cust_duty_levies taxes extra_taxes total_taxes decl_cust decl_taxes decl_extra_taxes decl_total, by(hs6)
	local category_taxes "cust_duty_levies taxes extra_taxes total_taxes decl_cust decl_taxes decl_extra_taxes decl_total"
	foreach var of local category_taxes {
		display "`var' per HS6 code"
		count if `var' > 100 & `var'!=.
		count if `var' > 1000 & `var'!=.
	}
	
	
	use "$intermediate_data/TaxData_10_1.dta", clear
	local category_taxes "cust_duty_levies taxes extra_taxes total_taxes decl_cust decl_taxes decl_extra_taxes decl_total"
	foreach var of local category_taxes {
		display "`var'"
		count if `var' == 0
		count if `var' == .
		count if `var' != 0 & `var' != .
	}
	
	import delimited "$intermediate_data/tax_declaration_2017.csv", clear
	gsort -pct_declared
	
	replace tax_variable="Custom Duties & Levies" if tax_variable=="cust_duty_levies"
	replace tax_variable="Taxes" if tax_variable=="taxes"
	replace tax_variable="Extra Taxes & Duties" if tax_variable=="extra_taxes"
	replace tax_variable="Total Taxes" if tax_variable=="total_taxes"
	replace tax_variable="Declared Custom Duties & Levies" if tax_variable=="decl_cust"
	replace tax_variable="Declared Taxes" if tax_variable=="decl_taxes"
	replace tax_variable="Declared Extra Taxes & Duties" if tax_variable=="decl_extra_taxes"
	replace tax_variable="Declared Total Taxes" if tax_variable=="decl_total"
	
	graph hbar pct_declared, over(tax_variable, sort(1) descending) ///
			title("Percentage of goods declared, by tax category, 2017") ///
			blabel(bar, position(outside) format(%9.3fc) color(black)) ///
			ytitle("") ///
			yscale(range(110) off) ///
			ylabel(, nogrid) ///
			xsize(7) ///
			scheme(s1color)
	
	graph export "$intermediate_results/Graphs/TaxDeclaration2017_10_7.png", as(png) height(800) replace
	
/*
	local hist_taxes "cust_duty_levies taxes extra_taxes total_taxes decl_cust decl_taxes decl_extra_taxes decl_total"
	foreach var in `hist_taxes'	{
		bys hs4: egen max_`var' = max(`var')
		bys hs4: egen min_`var' = min(`var')
		gen `var'_hs4range= max_`var' - min_`var'
		drop max_`var' min_`var'
	}
	
	collapse (first) cust_duty_levies_hs4range taxes_hs4range ///
					extra_taxes_hs4range total_taxes_hs4range decl_cust_hs4range ///
					decl_taxes_hs4range decl_extra_taxes_hs4range decl_total_hs4range ///
					, by(hs4)
	
	hist d_`var', freq addlabels ytitle("") yscale(off) ylabel(, nogrid) ///
			title("Distribution of difference between the minimum" "and maximum taxation rate per HS4 code for "`var') ///
			xtitle("Difference between minimum and maximum") color(dkgreen) ///
			lstyle(axisline) graphregion(style(none) color(gs16))	
	
	
	gsort hs6 yearmonth
	br hs6 yearmonth av*
	
	collapse (mean) total_taxes decl_total av*, by(hs6)
	
	histogram total_taxes, start(0) width(1)
	levelsof total_taxes if total_taxes>100
	br hs4 hs6 total_taxes if total_taxes > 100
	
	histogram decl_total, start(0) width(1)
	levelsof decl_total if decl_total>100
	br hs4 hs6 decl_total if decl_total>100
*/	
	
	
	local category_taxes "cust_duty_levies taxes extra_taxes total_taxes decl_cust decl_taxes decl_extra_taxes decl_total"
	foreach var of local category_taxes {
		gen `var'_max=`var'
		gen `var'_min=`var'
	}
		
	collapse (min) *_min (max) *_max, by(hs4)
	
	local category_taxes "cust_duty_levies taxes extra_taxes total_taxes decl_cust decl_taxes decl_extra_taxes decl_total"
	foreach var of local category_taxes {
		gen d_`var'=`var'_max - `var'_min	
	}
	
	local category_taxes "cust_duty_levies taxes extra_taxes total_taxes decl_cust decl_taxes decl_extra_taxes decl_total"
	foreach var of local category_taxes {
		display "d_`var'"
		count if d_`var' > 100
		count if d_`var' > 1000
	}
*------------------------------------------------------------------------------
	
	use "$intermediate_data/PriceData_clean_hs6_10_1.dta", clear
	
	collapse (sum) import_export_value_rs declaredimportvalue netweight quantity, by(hs6 QT_code date co)
	gen month=month(date)
	gen year=year(date)
	save "$imports_data/imports_yearcollapsed.full_10_1.dta", replace

	drop if year!=2017							//442,919 observations deleted
	sort year month

	merge m:1 year month using "$initial_data/Exchange_rate.dta"
	* 16 observations out of 439,380 unmatched. All from using
	
	drop if _merge!=3								//16 observations deleted
	
	gen imports_USD=import_export_value_rs/USDollar
	save "$imports_data/imports_yearcollapsed.full_10_1.dta", replace

	preserve
	collapse (sum) imports_USD declaredimportvalue netweigh quantity, by(hs6 QT_code)
	save "$imports_data/imports_yearcollapsedhs6_all_10_1.dta", replace
	restore
	
*------------------------
	 * use comtrade data
	import delimited "$exports_data/exports_comtrade_2017_2018.csv", clear
	
	gen co=reporter
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

*-------------------------------	
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

	
	* Generate hs6, hs4, and hs2 code:
	gen hs6 = int(commoditycode)
	label variable hs6 "HS6 code"
	gen hs4 = int(commoditycode/100)
	label variable hs4 "HS4 code"
	gen hs2=int(hs4/100)
	
	preserve 
	drop if year != 2017 	//40,313 observations deleted
	collapse (sum) netweightkg altqtyunit tradevalueus, by(hs6 QT_code)
	sort hs6 QT_code
	save "$exports_data/ExportsToPK_collapsehs6_10_1.dta", replace
	restore

	* Sum stats per hs4 : @Alice since ExportsToPK_collapsehs4 doesn't have co, I've skipped it from the merge command
	use "$imports_data/imports_yearcollapsedhs6_all_10_1.dta", clear
	sort hs6 QT_code 
	
	merge 1:1 hs6 QT_code using "$exports_data/ExportsToPK_collapsehs6_10_1.dta"
/*	Unmatched:			2,358
		from master:	489
		from using:		1,869
		
	Matched:			3,950
*/

	replace tradevalueus =0 if tradevalueus ==.
	replace imports_USD=0 if imports_USD==.
	replace altqtyunit =0 if altqtyunit ==.
	replace netweightkg =0 if netweightkg ==.
	replace  quantity =0 if  quantity ==.

	save "$onedrive/Mirror and desc stats/matched_hs6_10_1.dta", replace

********************************************************************************
* 			Data Visualization for Tax Revenue Loss with FBR-Comtrade
********************************************************************************
	use "$onedrive/Mirror and desc stats/matched_hs6_10_1.dta", clear
	
	bys hs6 QT_code: gen trade_gap_graph = tradevalueus-imports_USD
	bys hs6 QT_code: gen weight_gap_graph = altqtyunit-quantity

	collapse (sum) trade_gap_graph, by(hs6)
	save "$intermediate_data/trade_gaps_taxloss_10_11.dta", replace

	use "$intermediate_data/TaxData_10_1.dta", clear

	collapse (mean) total_taxes av_total_taxes cust_duty_levies taxes extra_taxes decl_cust decl_taxes decl_extra_taxes decl_total, by(hs6)
	
	sort hs6
	merge 1:1 hs6 using "$intermediate_data/trade_gaps_taxloss_10_11.dta"
	
	gen av_effective_tax = float(av_total_taxes/100)
	bys hs6: gen lossUSD = av_effective_tax*trade_gap_graph

	gen hs2=int(hs6/10000)

	save "$intermediate_data/pretaxlossgraph_10_11.dta", replace
*--------
	
	use "$intermediate_data/pretaxlossgraph_10_11.dta", clear
	
	
	*	HS2 15 has net negative tax revenue loss because of missing tax data:
	list hs6 if hs2==15 & av_total_taxes==.
	list hs6 if hs2==15 & total_taxes==.
/* 	HS6 codes with missing average and total tax data:
		150110
		150290
		150710
		151211
		151411
		151491
		151521
*/
	
	
	collapse (mean) total_taxes av_total_taxes cust_duty_levies taxes extra_taxes decl_cust decl_taxes decl_extra_taxes decl_total (sum) trade_gap_graph lossUSD, by(hs2)
	
	keep if hs2 == 84 | ///
	hs2 == 85 | ///
	hs2 == 72 | ///
	hs2 == 87 | ///
	hs2 == 52 | ///
	hs2 == 23 | ///
	hs2 == 29 | ///
	hs2 == 15 | ///
	hs2 == 88 | ///
	hs2 == 90 | ///
	hs2 == 30
	
	
	local category_taxes "av_total_taxes total_taxes cust_duty_levies taxes extra_taxes decl_cust decl_taxes decl_extra_taxes decl_total"
	foreach var in `category_taxes' {
	 display "`var'"
	 list hs2 if `var' ==.
	}


*--------
	
	use "$intermediate_data/pretaxlossgraph_10_11.dta", clear

	collapse (sum) lossUSD, by(hs2)
	drop if hs2==27
	
	gen tradegap_order = 0		
	replace tradegap_order = 1 if hs2 == 84		
	replace tradegap_order = 2 if hs2 == 85		
	replace tradegap_order = 3 if hs2 == 72		
	replace tradegap_order = 4 if hs2 == 87		
	replace tradegap_order = 5 if hs2 == 52		
	replace	tradegap_order = 6 if hs2 == 23		
	replace tradegap_order = 7 if hs2 == 29		
	replace tradegap_order = 8 if hs2 == 15		
	replace tradegap_order = 9 if hs2 == 88		
	replace tradegap_order = 10 if hs2 == 90
	replace tradegap_order = 11 if hs2 == 30
	
	drop if tradegap_order==0
		
	gsort tradegap_order		
	graph hbar lossUSD, ///		
				over(hs2, sort(tradegap_order)) ///		
				title("Tax revenue losses of Top 10 HS2 codes with greatest positive" "trade gaps, 2017") ///		
				subtitle("(U.S. Dollars)") ///		
				note("Using both import & tax data from FBR and export data from UN Comtrade") ///		
				blabel(bar, position(outside) format(%15.0fc) color(black)) ///		
				ytitle("") ///		
				yscale(range(-300000000) off) ///		
				ylabel(, nogrid) ///		
				scheme(s1color)		
			
	graph export "$intermediate_results/Graphs/TaxLoss_FRB_ordered_10_11.png", as(png) height(800) replace	

		
	
********************************************************************************
********************************************************************************
	
	use "$onedrive/Mirror and desc stats/matched_hs6_10_1.dta", clear

	
	bys hs6 QT_code : gen trade_gap_hs6=log(tradevalueus)-log(imports_USD)
	bys hs6 QT_code : gen weight_gap_hs6=log(altqtyunit)-log(quantity)

	
	collapse (sum) tradevalueus imports_USD trade_gap_hs6 weight_gap_hs6 altqtyunit quantity, by(hs6 QT_code)
	gen hs2=int(hs6/10000)
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

	collapse (sum) tradevalueus imports_USD trade_gap_hs6 weight_gap_hs6 altqtyunit quantity, by(hs6)
	sort hs6
	save "$intermediate_data/trade_gaps_10_1.dta", replace

	use "$intermediate_data/TaxData_10_1.dta"

	collapse (mean) cust_duty_levies taxes extra_taxes total_taxes av_cust_duty_levies av_taxes av_extra_taxes av_total_taxes (sd) sd*, by(hs6)
	
	sort hs6
	merge 1:1 hs6 using "$intermediate_data/trade_gaps_10_1.dta"
/*	Unmatched:			689
		from master:	0
		from using:		689
		
	Matched:			4,380
*/
	
	gen hs4 = int(hs6/100)
	bys hs4: egen av_total_taxes_hs4 = mean(av_total_taxes)
	
	gen logavtaxes=log(av_total_taxes)
	gen logtotaltaxes=log(total_taxes)
	gen logsdtaxes=log(sd_total_taxes)
	gen logavtaxes_hs4=log(av_total_taxes_hs4)

	gen hs2=int(hs6/10000)
	
	gen av_effective_tax = float(av_total_taxes/100)
	bys hs6: gen lossUSD = av_effective_tax*trade_gap_hs6	
	
	save "$intermediate_data/check_prices_gap_preregression_10_1.dta", replace
	
*===============================================================================
	
	use "$intermediate_data/check_prices_gap_preregression_10_1.dta", clear
	
	// @KC: Try different permutations of these regs to see what's significant
	eststo clear
	reghdfe trade_gap_hs6 av_total_taxes av_total_taxes_hs4, vce(cluster hs2) noabsorb
	eststo reg_1
	reghdfe weight_gap_hs6 av_total_taxes av_total_taxes_hs4, vce(cluster hs2) noabsorb
	eststo reg_2
	reghdfe trade_gap_hs6 logavtaxes logavtaxes_hs4, vce(cluster hs2) noabsorb
	eststo reg_3
	reghdfe weight_gap_hs6 logavtaxes logavtaxes_hs4, vce(cluster hs2) noabsorb
	eststo reg_4

	
	esttab reg_1 reg_2 reg_3 reg_4 using ///
		"$intermediate_results/Tables/DeterminantsofGap_FBRComtrade_10_11.rtf", ///
		label r2 ar2 se star(* 0.10 ** 0.05 *** 0.01) replace nobaselevels style(tex)


*-------------------------------------------------------------------------------	
*-------------------------------------------------------------------------------
* 								COMTRADE-COMTRADE ANALYSIS
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------


/*------------------------------------------------------------------------------
	Analysis at HS6 level
*------------------------------------------------------------------------------*/	

	use "$exports_data/ExportsToPK_clean.dta", clear
	
	drop if exp_year != 2017
	collapse (sum) exp_netweightkg exp_altqtyunit exp_tradevalueus exp_unitprice_comtrade, by(hs6 QT_code)
	sort hs6 QT_code
	* This dataset has 5,819 observations
	save "$exports_data/ExportsToPK2017_collapsehs6_QT_10_11.dta", replace
	
	
	use "$imports_data/ImportsToPK_clean.dta", clear
	
	drop if imp_year != 2017
	collapse (sum) imp_netweightkg imp_altqtyunit imp_tradevalueus imp_unitprice_comtrade, by(hs6 QT_code)
	sort hs6 QT_code
	* This dataset has 4,816 observations
	save "$imports_data/ImportsToPK2017_collapsehs6_QT_10_11.dta", replace
	
	merge 1:1 hs6 QT_code using "$exports_data/ExportsToPK2017_collapsehs6_QT_10_11.dta"
	* Matched: 1,320 | Not Matched: 352 (101 from imports, 251 from exports)
	
	replace exp_tradevalueus = 0 if exp_tradevalueus==.
	replace imp_tradevalueus = 0 if imp_tradevalueus==.
	replace exp_altqtyunit = 0 if exp_altqtyunit==.
	replace imp_altqtyunit = 0 if imp_altqtyunit==.

	bys hs6 QT_code: gen trade_gap_hs6=log(exp_tradevalueus)-log(imp_tradevalueus)
	bys hs6 QT_code: gen weight_gap_hs6=log(exp_altqtyunit)-log(imp_altqtyunit)

			
	collapse (sum) trade_gap_hs6 weight_gap_hs6, by(hs6)
	
	save "$onedrive/Mirror and desc stats/matched_comtrade_hs6QT_10_11.dta", replace
	
	
	use "$intermediate_data/TaxData_10_1.dta"
	collapse (mean) total_taxes av_total_taxes, by(hs6)
	sort hs6
	merge 1:1 hs6 using "$onedrive/Mirror and desc stats/matched_comtrade_hs6QT_10_11.dta", generate(merge3)
	* Matched: 1,154 | Not Matched: 55 (4 from check_prices_taxes, 51 from matched_comtrade_hs4QT_9_30)
	
	gen hs2=int(hs6/10000)

	gen av_effective_tax = float(av_total_taxes/100)
	bys hs6: gen lossUSD = av_effective_tax*trade_gap_hs6
	
	gen hs4 = int(hs6/100)
	bys hs4: egen av_total_taxes_hs4 = mean(av_total_taxes)
	
	gen logavtaxes=log(av_total_taxes)
	gen logtotaltaxes=log(total_taxes)
	gen logavtaxes_hs4=log(av_total_taxes_hs4)
	
	save "$intermediate_data/preregression_10_11.dta", replace		
				
	// @KC: Try different permutations of these regs to see what's significant
	eststo clear
	reghdfe trade_gap_hs6 av_total_taxes av_total_taxes_hs4, vce(cluster hs2) noabsorb
	eststo reg_1_comtrade
	reghdfe weight_gap_hs6 av_total_taxes av_total_taxes_hs4, vce(cluster hs2) noabsorb
	eststo reg_2_comtrade
	reghdfe trade_gap_hs6 logavtaxes logavtaxes_hs4, vce(cluster hs2) noabsorb
	eststo reg_3_comtrade
	reghdfe weight_gap_hs6 logavtaxes logavtaxes_hs4, vce(cluster hs2) noabsorb
	eststo reg_4_comtrade

	
	esttab reg_1_comtrade reg_2_comtrade reg_3_comtrade reg_4_comtrade using ///
		"$intermediate_results/Tables/DeterminantsofGap_ComtradeOnly_10_11.rtf", ///
		label r2 ar2 se star(* 0.10 ** 0.05 *** 0.01) replace nobaselevels style(tex)