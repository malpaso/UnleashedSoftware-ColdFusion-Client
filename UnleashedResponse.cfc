component name="UnleashedResponse" accessors="true" output="false" hint="A container object for Unleashed Software API responses" {

	property type="any" name="httpObject" default="" getter=true setter=true;
	property type="any" name="response" default="" getter=true setter=true;

	public any function init( required any response, responseFormat="json" ){

		setHttpObject(arguments.response);

		setResponse( toString(body()) );

		return this;
	}

	public any function headers(){
		return getHttpObject().responseHeader;
	}

	public any function body(){
		return getHttpObject().fileContent;
	}

	public any function statusCode(){
		return getHttpObject().statusCode;
	}

	public any function fromJson(){
		return deserializeJSON(getResponse());
	}

	public any function fromXml(){
		return xmlParse(getResponse());
	}

	// error handling

	public boolean function hasErrors(){
		if( left(statusCode(),3) neq "200" ){
			return true;
		}
		return false;
	}

	public any function getError(){
		var error = {
			code = "",
			message = ""
		};
		if( hasErrors() ){
			switch( left(statusCode(),3) ){
				case "400":
					error["code"] = "400";
					error["message"] = "Bad Request";
					break;
				case "403":
					error["code"] = "403";
					error["message"] = "Forbidden";
					break;
				case "404":
					error["code"] = "404";
					error["message"] = "Not Found";
					break;
				case "405":
					error["code"] = "405";
					error["message"] = "Not Allowed";
					break;
			}
		}
		return error;
	}

}