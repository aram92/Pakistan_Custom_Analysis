	use "$intermediate_data/Price_data_2907.dta", clear 
	* Create the three categories required as a percent of original price

	*drop if year != 2017 //Optional
	
	
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
	
	
	local original_taxes "customsduty federalexciseduty petrloeumlevy salestax incometax salestaxleviedascedinvatmode salestaxonlocalsupplies incometaxsurcharge additionalcustomduty gensaletax regduty antidumping addsaletax edibleoilcess frf warehousesurcharge iqra specialfed developmentsurcharge surcharge vrdamount overstayedgoodssurcharge servicecharge guaranteeadditionalsalestax countervailingduty"
	
	foreach var in `original_taxes' {
		count if `var' ==. | `var' == 0
	}
	
	local original_taxes "customsduty federalexciseduty petrloeumlevy salestax incometax salestaxleviedascedinvatmode salestaxonlocalsupplies incometaxsurcharge additionalcustomduty gensaletax regduty antidumping addsaletax edibleoilcess frf warehousesurcharge iqra specialfed developmentsurcharge surcharge vrdamount overstayedgoodssurcharge servicecharge guaranteeadditionalsalestax countervailingduty"
	foreach var in `original_taxes' {
		count if `var' !=. & `var' !=0
	}
	
	local category_taxes "cust_duty_levies taxes extra_taxes total_taxes decl_cust decl_taxes decl_extra_taxes decl_total"
	foreach var in `category_taxes' {
		count if `var' ==. | `var' == 0
	}

	local category_taxes "cust_duty_levies taxes extra_taxes total_taxes decl_cust decl_taxes decl_extra_taxes decl_total"
	foreach var in `category_taxes' {
		count if `var' !=. & `var' !=0
	}
	
	
	import delimited "$intermediate_data/tax_declaration_2017.csv", clear //or suffix _2017_2018
	gsort -pct_declared

	gen flag = 0
	replace flag = 1 if tax_variable=="cust_duty_levies" | ///
				tax_variable=="taxes" | ///
				tax_variable=="extra_taxes" | ///
				tax_variable=="total_taxes" | ///
				tax_variable=="decl_cust" | ///
				tax_variable=="decl_taxes" | ///
				tax_variable=="decl_extra_taxes"| ///
				tax_variable=="decl_total"
	
	graph hbar pct_declared if flag==0, over(tax_variable, sort(1) descending) ///
			title("Percentage of goods declared, by tax type") ///
			blabel(bar, position(outside) format(%9.5fc) color(black)) ///
			ytitle("") ///
			yscale(range(110) off) ///
			ylabel(, nogrid labsize(tiny)) ///
			scheme(s1color)
	
	graph export "$intermediate_results/Graphs/TaxDeclaration1_2017.png", as(png) height(800) replace


	graph hbar (sum) pct_declared if flag==1, over(tax_variable, sort(1) descending) ///
			title("Percentage of goods declared, by tax category") ///
			blabel(bar, position(outside) format(%9.3fc) color(black)) ///
			ytitle("") ///
			yscale(range(110) off) ///
			ylabel(, nogrid) ///
			scheme(s1color)
	
	graph export "$intermediate_results/Graphs/TaxDeclaration2_2017.png", as(png) height(800) replace

********************************************************************************	
********************************************************************************	
********************************************************************************	
	
	import delimited "$onedrive/Imports/hs6_check.csv", clear
	drop v1

	gen hs4 = int(hs6/100)
	
	
	merge 1:1 gd_no_id gd_date ntnid agentid hs4 shippinglinename last_channel grossweight netweight quantity using "$intermediate_data/Price_data_2907.dta", gen(merge2)

	merge 1:1 gd_no_id gd_date ntnid quantity using "$intermediate_data/Price_data_2907.dta", gen(merge3)

	
	duplicates tag gd_no_id gd_date ntnid agentid hs4 shippinglinename last_channel grossweight netweight, gen(duplicate)
	br if duplicate>0
	
/* 	These variables are different:
		declared description
		quantity
		declaredimportvalue
		import_export_value_rs
*/


	import delimited "$onedrive/Imports/PAK_rawdata.csv", clear bindquote(strict) maxquotedrows(1000)
	save "$intermediate_data/Price_data_10_1.dta", replace
	
	gen date=date(gd_date, "DMYhm")
	gen year=year(date)
	replace origin_country=strtrim(origin_country)
	gen co=origin_country
	
* This needs to be continued further based on Merge_dataset.do
