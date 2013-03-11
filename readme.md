UnleashedSoftware ColdFusion Client
===================================
Bill Tindal, 2013

** work in progress **

This is a ColdFusion client for the Unleashed Software inventory system API - https://api.unleashedsoftware.com

Example usage:

	<cfscript>
		settings = {
			apiId = "",
			apiKey = "",
			baseUrl = "",
			username = "",
			password = "",
			returnDataFormat = "json"
		};
		unleashed = createObject("component","Unleashed").init(settings);
		products = unleashed.getProducts();
	</cfscript>