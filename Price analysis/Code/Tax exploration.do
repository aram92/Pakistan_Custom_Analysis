	use "$intermediate_data/Price_data_2907.dta", clear 
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
	
	
	local original_taxes "customsduty	federalexciseduty	petrloeumlevy	salestax	incometax	salestaxleviedascedinvatmode	salestaxonlocalsupplies	incometaxsurcharge	additionalcustomduty	gensaletax	regduty	antidumping	addsaletax	edibleoilcess	frf	warehousesurcharge	iqra	specialfed	developmentsurcharge	surcharge	vrdamount	overstayedgoodssurcharge	servicecharge	guaranteeadditionalsalestax	countervailingduty"
	
	foreach var in `original_taxes' {
		count if `var' ==. | `var' == 0
	}
	
	local original_taxes "customsduty	federalexciseduty	petrloeumlevy	salestax	incometax	salestaxleviedascedinvatmode	salestaxonlocalsupplies	incometaxsurcharge	additionalcustomduty	gensaletax	regduty	antidumping	addsaletax	edibleoilcess	frf	warehousesurcharge	iqra	specialfed	developmentsurcharge	surcharge	vrdamount	overstayedgoodssurcharge	servicecharge	guaranteeadditionalsalestax	countervailingduty"
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
	
	