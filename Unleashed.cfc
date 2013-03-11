component name="Unleashed" output="false" accessors="true" hint="A ColdFusion wrapper for the Unleashed Software API" {

	property type="string" 	name="service"				default="Unleashed"	getter=true setter=true;
	property type="string"	name="apiId"				default=""			getter=true setter=true;
	property type="string"  name="apiKey"				default=""			getter=true setter=true;
	property type="string" 	name="baseUrl"				default=""			getter=true setter=true;
	property type="string" 	name="username"				default=""			getter=true setter=true;
	property type="string" 	name="password"				default=""			getter=true setter=true;
	property type="string" 	name="returnDataFormat"		default="json"		getter=true setter=true;
	property type="boolean" name="debugMode"			default=false		getter=true setter=true;

	public any function init( required struct settings ){

		for( key in arguments.settings ){
			evaluate("set#key#('#arguments.settings[key]#')");
		}

		return this;
	}

	/** COMPANIES **/

	public any function getCompanies(
		any guid = "",
		any companyName = "",
		any baseCurrencyCode = ""
	){

		var service = createHTTPService("GET");

		service.setUrl(	getBaseUrl() & '/companies');

		urlParams = buildUrlParams(arguments);

		service = addUrlParams(service,arguments);

		signature = getSignature( urlParams,getApiKey() );

		return call(service,signature);

	}

	/** BILL OF MATERIALS **/

	public any function getBillOfMaterials(
		any guid = "",
		any product = "",
		any billofmaterialslines = "",
		any lastmodifiedon = ""
	){

		var service = createHTTPService("GET");

		service.setUrl(	getBaseUrl() & '/BillOfMaterials');

		urlParams = buildUrlParams(arguments);

		service = addUrlParams(service,arguments);

		signature = getSignature( urlParams,getApiKey() );

		return call(service,signature);

	}

	/** CUSTOMERS **/

	public any function getCustomers(
		any customerCode = "",
		any customerName = "",
		any modifiedSince = "",
	){

		var service = createHTTPService("GET");

		service.setUrl(	getBaseUrl() & '/customers');

		urlParams = buildUrlParams(arguments);

		service = addUrlParams(service,arguments);

		signature = getSignature( urlParams,getApiKey() );

		return call(service,signature);

	}

	public any function getCustomer(required any customer_id){

		var service = createHTTPService("GET");

		service.setUrl(	getBaseUrl() & '/customers/#arguments.customer_id#');

		signature = getSignature( "",getApiKey() );

		return call(service,signature);

	}

	public any function createCustomer(required any customer_id, required any customer){

		var service = createHTTPService("POST");

		service.setUrl( getBaseUrl() & '/customers/#arguments.customer_id#' );

		service = addParams(service,arguments.customer);

		signature = getSignature( "",getApiKey() );

		return call(service,signature);

	}

	public any function updateCustomer(required any customer_id, required any customer){

		var service = createHTTPService("POST");

		service.setUrl( getBaseUrl() & '/customers/#arguments.customer_id#' );

		service = addParams(service,arguments.customer);

		signature = getSignature( "",getApiKey() );

		return call(service,signature);

	}

	/** CUSTOMER TYPES **/

	public any function getCustomerTypes(any typeName = ""){

		var service = createHTTPService("GET");

		service.setUrl(	getBaseUrl() & '/CustomerTypes');

		urlParams = buildUrlParams(arguments);

		service = addUrlParams(service,arguments);

		signature = getSignature( urlParams,getApiKey() );

		return call(service,signature);

	}

	/** PRODUCTS **/

	public any function getProducts(
		any productCode = "",
		any productDescription = "",
		any product = "",
		any modifiedSince = "",
		any isObsolete = ""
	){

		var service = createHTTPService("GET");

		service.setUrl(	getBaseUrl() & '/products');

		urlParams = buildUrlParams(arguments);

		service = addUrlParams(service,arguments);

		signature = getSignature( urlParams,getApiKey() );

		return call(service,signature);

	}

	public any function getProduct(required any product_id){

		var service = createHTTPService("GET");

		service.setUrl(	getBaseUrl() & '/products/#arguments.product_id#');

		signature = getSignature( "",getApiKey() );

		return call(service,signature);

	}

	public any function createProduct(required any product){

		var service = createHTTPService("POST");

		service.setUrl( getBaseUrl() & '/products' );

		service = addParams(service,arguments.product);

		signature = getSignature( "",getApiKey() );

		return call(service,signature);

	}

	public any function updateProduct(required any product){

		var service = createHTTPService("POST");

		service.setUrl( getBaseUrl() & '/products' );

		service = addParams(service,arguments.product);

		signature = getSignature( "",getApiKey() );

		return call(service,signature);

	}

	/** SALES INVOICES **/

	public any function getSalesInvoices(
		any customerCode = "",
		any startDate = "",
		any endDate = "",
		any modifiedSince = "",
		any orderNumber = ""
	){

		var service = createHTTPService("GET");

		service.setUrl(	getBaseUrl() & '/SalesInvoices');

		urlParams = buildUrlParams(arguments);

		service = addUrlParams(service,arguments);

		signature = getSignature( urlParams,getApiKey() );

		return call(service,signature);

	}

	public any function getSalesInvoice(required any invoice_id){

		var service = createHTTPService("GET");

		service.setUrl(	getBaseUrl() & '/SalesInvoices/#arguments.invoice_id#');

		signature = getSignature( "",getApiKey() );

		return call(service,signature);

	}

	public any function createSalesInvoice(required any invoice_id, required any invoice){

		var service = createHTTPService("POST");

		service.setUrl( getBaseUrl() & '/SalesInvoices/#arguments.invoice_id#' );

		service = addParams(service,arguments.invoice);

		signature = getSignature( "",getApiKey() );

		return call(service,signature);

	}

	/** PRIVATE **/

	private any function getSignature(any request="", required any key){
		var secret = createObject('java', 'javax.crypto.spec.SecretKeySpec' ).Init( arguments.key.GetBytes("UTF-8"), 'HmacSHA256');
		var mac = createObject('java', "javax.crypto.Mac").getInstance("HmacSHA256");
		mac.init(secret);
		var digest = mac.doFinal(arguments.request.GetBytes("UTF-8"));
		var signature = createObject("java","org.apache.commons.codec.binary.Base64").encodeBase64( digest );
		return toString(signature);
	}

	private any function call(required any httpService, required any signature){

		var service = arguments.httpService;
		service.addParam(type="header",name="api-auth-signature",value="#arguments.signature#");
		var result = service.send().getPrefix();

		// log while in development
		//if( this.debugMode ){
			writeLog(type="information",file=getService(),text=toString(result.fileContent));
		//}

		if (NOT isDefined("result.statusCode")) {
			throw(type=getService(),errorcode="#getService()#_unresponsive", message="The #getService()# server did not respond.", detail="The #getService()# server did not respond.");
		}

		var response = createObject("component","UnleashedResponse").init( result, getReturnDataFormat() );

		return response; // deserializeJSON(result.fileContent);
	}

	private HTTP function createHTTPService(string urlmethod='POST', any httptimeout=30) {

		var service = new HTTP();
		service.setUsername(getUsername());
		service.setPassword(getPassword());
		service.setMethod(arguments.urlmethod);
		service.setCharset('utf-8');
		service.setTimeout(arguments.httptimeout);
		service.addParam(type="header",name="Accept",value="application/#getReturnDataFormat()#");
		service.addParam(type="header",name="Content-Type",value="application/#getReturnDataFormat()#");
		service.addParam(type="header",name="api-auth-id",value=getApiId());

		return service;
	}
	
	private any function addParams( required any service, required struct params ){
		var s = arguments.service;
		var p = arguments.params;
		var debug = {};
		
		s.addParam( type="body", value=jsonencode(p) );
		
		return s;
	}

	private any function addUrlParams( required any service, required struct params, string exclude_list="" ){

		var s = arguments.service;
		var p = arguments.params;
		var e = arguments.exclude_list;

		for( key in p ){
			if( listFindNoCase(e,key) eq 0 AND len(p[key]) gt 0 ){
				s.addParam(
					type="url",
					name=key,
					value=trim(p[key])
				);
			}
			// check the exclude_list for prefixed 'array_' keys and add
			if( listFindNoCase(e,key) AND left(key,6) eq "array_" ){
				var _arr = p[key];
				var param_name = right(key,len(key)-6);
				// loop over the array and add the name value pairs to the service
				for( k=1;k<=arrayLen(_arr);k++){
					s.addParam(
						type="url",
						name="#param_name#[]",
						value=_arr[k]
					);
				}
			}
		}

		return s;
	}

	private any function buildUrlParams( required struct params, string exclude_list="" ){

		var result = "";
		var p = arguments.params;
		var e = arguments.exclude_list;

		for( key in p ){
			if( listFindNoCase(e,key) eq 0 AND len(p[key]) gt 0 ){
				if( len(result) ){ result += "&"; }
				result += key & "=" & trim(p[key]);
			}
		}

		return result;
	}

	/**
	 * Serialize native ColdFusion objects (simple values, arrays, structures, queries) into JSON format
	 * http://json.org/
	 * http://jehiah.com/projects/cfjson/
	 *
	 * @param object Native data to be serialized
	 * @return Returns string with serialized data.
	 * @author Jehiah Czebotar (jehiah@gmail.com)
	 * @version 1.2, August 20, 2005
	 */

	public any function jsonencode(arg)
	{
		var i=0;
		var o="";
		var u="";
		var v="";
		var z="";
		var r="";

		if (isarray(arg))
		{
			o="";
			for (i=1;i lte arraylen(arg);i=i+1){
				try{
					v = jsonencode(arg[i]);
					if (o neq ""){
						o = o & ',';
					}
					o = o & v;
				}
				catch(Any ex){
					o=o;
				}
			}
			return '['& o &']';
		}
		if (isstruct(arg))
		{
			o = '';
			if (structisempty(arg)){
				return "{null}";
			}
			z = StructKeyArray(arg);
			for (i=1;i lte arrayLen(z);i=i+1){
				try{
				v = jsonencode(evaluate("arg."&z[i]));
				}catch(Any err){WriteOutput("caught an error when trying to evaluate z[i] where i="& i &" it evals to "  & z[i] );}
				if (o neq ""){
					o = o & ",";
				}
				o = o & '"'& lcase(z[i]) & '":' & v;
			} 
			return '{' & o & '}';
		}
		if (isobject(arg)){
			return "unknown";
		}
		if (issimplevalue(arg) and isnumeric(arg)){
			return ToString(arg);
		}
		if (issimplevalue(arg)){
			return '"' & JSStringFormat(ToString(arg)) & '"';
		}
		if (IsQuery(arg)){
			o = o & '"RECORDCOUNT":' & arg.recordcount;
			o = o & ',"COLUMNLIST":'&jsonencode(arg.columnlist);
			// do the data [].column
			o = o & ',"DATA":{';
			// loop through the columns
			for (i=1;i lte listlen(arg.columnlist);i=i+1){
				v = '';
				// loop throw the records
				for (z=1;z lte arg.recordcount;z=z+1){
					if (v neq ""){
						v =v  & ",";
					}
					// encode this cell
					v = v & jsonencode(evaluate("arg." & listgetat(arg.columnlist,i) & "["& z & "]"));
				}
				// put this column in the output
				if (i neq 1){
					o = o & ",";
				}
				o = o & '"' & listgetat(arg.columnlist,i) & '":[' & v & ']';
			}
			// close our data section
			o = o & '}';
			// put the query struct in the output
			return '{' & o & '}';
		}
		return "unknown";
	}

}