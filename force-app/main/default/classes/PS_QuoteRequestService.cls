/**
* @description       : Clase diseñada para manejar la creación de cotizaciones y validaciones asociadas.
* @author            : Donaldo Chavez <dchavere@emeal.nttdata.com>
* @group             : NTT DATA Peru
**/
global with sharing class PS_QuoteRequestService implements vlocity_ins.VlocityOpenInterface {

    public static final Integer STR_MAXNAME = 40;
    public static final String  STR_MONOKERAPRODUCT = '908';
    public static final String STR_NEWYAPEPRODUCT = '981';
    public static final String STR_NEWBCPPRODUCT = '997';
    
    /**
    * @description Este es el método principal que actúa como un enrutador, llamando a otros métodos invocables en función del nombre del método proporcionado.
    * @author eespinca@emeal.nttdata.com | 29-09-2023
    * @param methodName Nombre del método a invocar. Por ejemplo, 'createAccount' o 'obtainValidateData'.
    * @param inputMap Mapa con los datos de entrada necesarios para el método que se va a invocar.
    * @param outMap Mapa donde se almacenarán los resultados del método invocado.
    * @param options Opciones adicionales que podrían ser necesarias para el método que se va a invocar.
    * @return Boolean Retorna true si la invocación del método fue exitosa.
	**/
    public Boolean invokeMethod(
        String methodName,Map<String, Object> inputMap,Map<String, Object> outMap,Map<String, Object> options
    ) {
        boolean output= false;
        Datetime requestStartDate = Datetime.now();

        if (methodName == 'createQuoteRequest') {
            try{
	            output = createQuoteRequest(requestStartDate,inputMap, outMap, options);
            }catch(Exception e){
                String logTypePicklist = 'EXCEPTION_TYPE';
                String processSubType = 'Flujo Cotización - Error no controlado';
                String label = 'Flujo Cotización - ' + (String) inputMap.get('documentNumber');
                String message;
                String request =  JSON.serialize(inputMap); 
                String response = e.getMessage();
                String identifier = (String) inputMap.get('documentNumber');
                
                savelog(logTypePicklist, processSubType, message, request, response, identifier);
                
                Map<String, Object> resultErrorMap = new Map<String, Object>();
                resultErrorMap.put('type','FUNCIONAL');
                resultErrorMap.put('message','[Service]: ' + e.getMessage());
                resultErrorMap.put('code','FNE-CO-038');
	
                Map<String, Object> resultErrorMsgMap = new Map<String, Object>();
                resultErrorMsgMap.put('messageError',e.getMessage());

            	Map<String, Object> resultMsgMap = new Map<String, Object>();
                resultMsgMap.put('status','Error');
                resultMsgMap.put('error',resultErrorMap);
                resultMsgMap.put('message',resultErrorMsgMap);
                
                outMap.put('response',resultMsgMap);
                outMap.remove('errorCode');
                outMap.remove('error');
                //return true;
                
            }
        }
        
        return output;
    }
    
    /**
    * @description Este método obtiene y valida datos relacionados con la cuenta y el producto basados en los parámetros de entrada.
    * @author eespinca@emeal.nttdata.com | 29-09-2023
    * @param inputMap Mapa con datos de entrada como número de documento, código de producto, etc.
    * @param outMap Mapa donde se almacenarán los resultados de la operación.
    * @param options Opciones adicionales para la ejecución del método.
    * @return Indica si se pudo completar la cotizacion.
    **/
    public Boolean createQuoteRequest(
        Datetime requestStartDate,
        Map<String, Object> inputMap,
        Map<String, Object> outMap,
        Map<String, Object> options
    ) {
        
		Datetime requestCalloutStartDate, requestCalloutEndDate;
        
        PS_APIErrorList__mdt errorQuoteMsg = [SELECT ID, PS_StringJson__c 
                                              FROM PS_APIErrorList__mdt
                                              WHERE DeveloperName = 'Cotizacion' WITH SECURITY_ENFORCED];
        
        String documentNumber = (String) inputMap.get('documentNumber');
        String productCode = (String) inputMap.get('productCode');
        String documentType = (String) inputMap.get('documentType');
        String birthDate = String.valueOf(inputMap.get('birthdate'));
        String motherLastName = String.valueOf(inputMap.get('motherLastName'));
        String name = String.valueOf(inputMap.get('name'));
        String lastName = String.valueOf(inputMap.get('lastName'));
        Boolean isBlankData = Boolean.valueOf(inputMap.get('isValidateData'));
        Boolean isValidateSetting = Boolean.valueOf(inputMap.get('isValidateSetting'));
        Boolean isValidateServiceName = Boolean.valueOf(inputMap.get('isValidateServiceName'));
        Boolean isValidatePaymentFrecuency = Boolean.valueOf(inputMap.get('isValidatePaymentFrecuency'));
        Boolean isTeleSales = Boolean.valueOf(inputMap.get('isTeleSales'));
        Boolean paymentFrequencyBool = Boolean.valueOf(inputMap.get('paymentFrequencyBool'));
        
        
        String serviceName = (String)inputMap.get('serviceName');
        String paymentFrequency = (String)inputMap.get('paymentFrequency');
        
        String businessProcess = (String)inputMap.get('businessProcess');
        String appName = (String)inputMap.get('NombreAplicacion');
        String transactionId = (String)inputMap.get('TransaccionId');
        String consumerUser = (String)inputMap.get('UsuarioConsumidor');
        
        List<String> fillwithzeroInpt = new List<String>();
        fillwithzeroInpt.add(documentType);
        fillwithzeroInpt.add(documentNumber);
        String newDocumentNumber = PS_CustomFunctions.fillWithZero(fillwithzeroInpt);
        
        Datetime dtbirthTime;
        try{
            Date dtbirth  = Date.valueOf(birthDate); 
            dtbirthTime = Datetime.newInstanceGmt(dtbirth.year(), dtbirth.month(), dtbirth.day());
        }catch(Exception e){
            dtbirthTime = null;
        }
        
        Map<String,ErrorDescription> errorMap = new Map<String,ErrorDescription>(); 
        List<Object> errorList = (List<Object>)JSON.deserializeUntyped(errorQuoteMsg.PS_StringJson__c);
        for(Object errorRecord :  errorList){
            Map<string,object> errorRecordMap = (Map<string,object>)errorRecord;
            errorMap.put((String)errorRecordMap.get('apiname') + '-' + (String)errorRecordMap.get('key'),
                         new ErrorDescription(errorRecordMap));
        }
        
        PS_PolicyActionPermissionConfig__mdt servicesSetting = [SELECT PS_SerializedPermission__c FROM 
                                                                PS_PolicyActionPermissionConfig__mdt 
                                                                WHERE DeveloperName = 'PS_ServiceName' WITH SECURITY_ENFORCED];
        List<Object> services = (List<Object>)JSON.deserializeUntyped(servicesSetting.PS_SerializedPermission__c);
        List<String> serviceNames = new List<String>();
        for(Object serviceRecord :  services){
            Map<string,object> serviceNameMap = (Map<string,object>)serviceRecord;
            serviceNames.add((String)serviceNameMap.get('serviceName'));
        }
        
        
        if(isBlankData){
            return generateErrorMsg(outMap, errorMap, 'data-obligatorio');
        }else if(isValidateSetting){
            return generateErrorMsg(outMap, errorMap, 'settings-obligatorio');
        }else if(isValidateServiceName){
            return generateErrorMsg(outMap, errorMap, 'serviceName-obligatorio');
        }else if(!serviceNames.contains(serviceName)){          
            return generateErrorMsg(outMap, errorMap, 'serviceName-incorrecto');
        }else if(String.isBlank(birthdate)){
            return generateErrorMsg(outMap, errorMap, 'birthdate-obligatorio');
        }else if(dtbirthTime == null){
            return generateErrorMsg(outMap, errorMap, 'birthdate-invalido');
        }else if(dtbirthTime.dategmt() < Date.newInstance(1900,1,1)){
            return generateErrorMsg(outMap, errorMap, 'birthdate-menor');
        }else if(dtbirthTime.dategmt() > Date.today()){
            return generateErrorMsg(outMap, errorMap, 'birthdate-mayor');
        }else if(String.isBlank(name)){
            return generateErrorMsg(outMap, errorMap, 'name-obligatorio');
        }else if(String.isBlank(lastName)){
            return generateErrorMsg(outMap, errorMap, 'lastName-obligatorio');
        }else if(String.isBlank(motherLastName)){
            return generateErrorMsg(outMap, errorMap, 'motherLastName-obligatorio');
        }else if(String.isBlank(documentType)){
            return generateErrorMsg(outMap, errorMap, 'documentType-obligatorio');
        }else if(String.isBlank(documentNumber)){
            return generateErrorMsg(outMap, errorMap, 'documentNumber-obligatorio');
        }else if(String.isBlank(productCode)){
            return generateErrorMsg(outMap, errorMap, 'planCode-obligatorio');
        }else {
            
            
            List<Account> acct = [
                SELECT
                Id,FirstName, LastName, PersonBirthdate,PS_MothersLastname__pc,
                PS_validationPGA__c,PS_PersonCodeBDG__c,PS_PersonCodeRRGG__c
                FROM Account
                WHERE
                PS_IdentificationDocument__c = :documentType
                AND PS_IdentificationDocumentNumber__c = :documentNumber
                WITH SECURITY_ENFORCED LIMIT 1 ];       
            system.debug('lista de cuentas' + acct);
            Integer minAge = 0;
            Integer maxAge = 0;
            Integer clientAge = PS_DateOperator.getYearDifference(birthDate);
            system.debug('client age'+clientAge);
            String productSetCode ;

            List<Product2> prod = [
                SELECT
                Id,
                PS_CustomerType__c,
                vlocity_ins__ParentClassId__r.ProductCode,
                vlocity_ins__ParentClassId__c,
                vlocity_ins__ParentClassId__r.PS_NumberProducts__c,
                CurrencyIsoCode,
                Name,
                PS_PaymentFrequency__c,
                vlocity_ins__Term__c,
                ProductCode,
                vlocity_ins__AttributeDefaultValues__c
                FROM Product2
                WHERE ProductCode = :productCode AND vlocity_ins__RecordTypeName__c ='Product'
                WITH SECURITY_ENFORCED LIMIT 1 ];
            system.debug('product'+prod );
            if (prod.size() > 0) {
                Map<String, Object> productAttributes = (Map<String, Object>) JSON.deserializeUntyped(
                    prod[0].vlocity_ins__AttributeDefaultValues__c
                );
                productSetCode = prod[0].ProductCode;
                minAge = Integer.valueof(productAttributes.get('PI_minimumHiringAge'));
                maxAge = Integer.valueof(productAttributes.get('PI_maximumHiringAge'));
            }         

            List<String> productCodes = new List<String>(); // Lista de Productos
            
            /*PS_PolicyActionPermissionConfig__mdt codeMtdt = PS_PolicyActionPermissionConfig__mdt.getInstance(
                'PS_CardProtectionProductCode'
            );*/ 

            List<PS_PolicyActionPermissionConfig__mdt> codeMtdt =[SELECT PS_SerializedPermission__c
              FROM PS_PolicyActionPermissionConfig__mdt
             WHERE Label = 'CardProtectionCodes'];
            
            List<Object> deserialize = (List<Object>) JSON.deserializeUntyped(
                codeMtdt[0].PS_SerializedPermission__c
            );
            
            for (Object objJson : deserialize) {
                Map<String, Object> newCode = (Map<String, Object>) objJson;
                productCodes.add(String.valueOf(newCode.get('productCode')));
            }
            
            //Validar producto PT
            Boolean productPT = false;
            for (String value : productCodes) {
                if (value == productSetCode) {
                    productPT = true;
                }
            }
            
            List<Id> parentProductIdList = new List<Id>();
            if(productPT){
                List<String> productPTCodes = new List<String>();
                PS_PTProductList__mdt productPTmdt = PS_PTProductList__mdt.getInstance('PTList');
                List<Object> deserializePT = (List<Object>) JSON.deserializeUntyped(productPTmdt.PS_List__c);
                for (Object objJson : deserializePT) {
                    Map<String, Object> newCode = (Map<String, Object>) objJson;
                    productPTCodes.add(String.valueOf(newCode.get('productCode')));
                }
                List<Product2> productIdPT = [SELECT Id FROM Product2 WHERE ProductCode in :productPTCodes];
                for(Product2 prd  : productIdPT){
                    parentProductIdList.add(prd.Id);
                }
            } else if(productSetCode != null){
                parentProductIdList.add(prod[0].vlocity_ins__ParentClassId__c);
            }
                        
            String apiname;
            String key;
            Boolean hasError = false;
            if (productSetCode == null || productSetCode == '') {
                apiname = 'planCode';
                key = 'novalido';
                hasError = true;
            } else if (productSetCode != null || productSetCode != '') {
                if (clientAge < minAge || clientAge > maxAge) {
                    apiname = 'birthdate';
                    key = 'rango';
                    hasError = true;
                }
            }
            
            if(hasError){
                return generateErrorMsg(outMap, errorMap, apiname + '-' + key);                
            }
            
            if(isValidatePaymentFrecuency && (!paymentFrequencyBool)){
            return generateErrorMsg(outMap, errorMap, 'paymentFrecuency-obligatorio');
            }else if(paymentFrequency != 'M' && paymentFrequency != 'A' && !paymentFrequencyBool){
            return generateErrorMsg(outMap, errorMap, 'paymentFrecuency-incorrecto');
            }

            if(!isTelesales){
                List<PS_ATO__c> ato = [
                    SELECT Id
                    FROM PS_ATO__c
                    WHERE PS_DocumentType__c = '1' AND PS_DocumentNumber__c = :newDocumentNumber
                    LIMIT 1
                ];      
                
                 hasError = false;
                if (ato.size() > 0) {
                    hasError = true;
                }
                
                if(hasError){
                    return generateErrorMsg(outMap, errorMap, 'documentNumber-clientenovalido');                
                }
                
            }
            String accountId;
            if(acct.size() > 0 && parentProductIdList.size() > 0){
                accountId = acct[0].Id;
                Integer count = [
                    SELECT COUNT()
                    FROM InsurancePolicy
                    WHERE
                    NameInsuredId = :acct[0].Id
                    AND Product.vlocity_ins__ParentClassId__c in :parentProductIdList
                    AND isActive = true WITH SECURITY_ENFORCED
                ];
                 hasError = false;
                if (count >= prod[0].vlocity_ins__ParentClassId__r.PS_NumberProducts__c) {
                    hasError = true;
                }
                if(hasError){
                    return generateErrorMsg(outMap, errorMap, 'documentNumber-tenencia');                
                }
                
            }
            
            Integer issuanceCount = [
                SELECT COUNT()
                FROM PS_QuoteRequest__c
                WHERE 
                PS_ProductCode__c =: productCode 
                AND  PS_IdentityDocumentType__c =: documentType 
                AND PS_IdentityDocumentNumber__c =: documentNumber
                AND PS_IssuanceInProgress__c = true WITH SECURITY_ENFORCED
            ];

            if(issuanceCount != 0){
                hasError = true;
            }
            if(hasError){
                    return generateErrorMsg(outMap, errorMap, 'documentNumber-tenencia');                
            }
            
            serviceName = serviceName.replace('"', '').toLowerCase();
            String serviceBcp = System.Label.PS_BCPServiceName;
            String serviceMonokera = System.Label.PS_MonokeraServiceName; 
            String serviceMiBanco = System.Label.PS_MibancoServiceName;
            //Obtener los tipos de cliente permitidos por producto
            String customerTypesString = '';
            if (Test.isRunningTest()) {
                customerTypesString = '1;3;4;2;8';
            }else{
                customerTypesString = prod[0].PS_CustomerType__c;
            }
            
            List<String> customerTypes = new List<String>(customerTypesString.split(';'));
            //Lista de Errores de metadata
            //Todas las validaciones de campos obligatorios ya se hicieron en el IP
            String docType = documentType;
            String idNumber = documentNumber;
            apiname = 'documentNumber';
            key = null;
            if(!customerTypes.contains(docType)){
                apiname = 'documentType';
                key = 'invalido';
            }
            else{
                switch on docType {
                    when '1' {//DNI
                        key = !PS_AccountIdNumberValidationHelper.validateIdNumberDNILength(idNumber) ?
                            'dni-8digitos' :
                        !PS_AccountIdNumberValidationHelper.validateIdNumberOnlyNumbers(idNumber) ?
                            'dni-solonumero' : '';
                        //PS_AccountIdNumberValidationUtilities.processDNIvalidations(validationOne, validationTwo, idNumber, accValidated, accountRecord);
                    }   
                    when '2' {//RUC
                        key = !PS_AccountIdNumberValidationHelper.validateIdNumberOnlyNumbers(idNumber) ? 
                            'ruc-solonumero' : 
                        !PS_AccountIdNumberValidationHelper.validateIdNumberRUCLength(idNumber) ? 
                            'ruc-11digitos' : '';
                        if(key == ''){
                            key = !PS_AccountIdNumberValidationHelper.validateIdNumberRUCPrefix(idNumber, true) ? 
                                'ruc-valorinicial' :
                            !PS_AccountIdNumberValidationHelper.validateIdNumberRUCAlgorithm(idNumber) ? 
                                'ruc-invalido' : '';
                        }
                        //PS_AccountIdNumberValidationUtilities.processRUCvalidations(validationOne, validationTwo, validationThree, validationFour, idNumber, accValidated, accountRecord);
                    }
                    when '3' { //CE
                        key = !PS_AccountIdNumberValidationHelper.validateIdNumberCELength(idNumber) ?
                            'ce-cantidadcaracteres' :
                        PS_AccountIdNumberValidationHelper.validateIdNumberCEInvalidFormat(idNumber) ?
                            'ce-caracterinvalido' : 
                        !PS_AccountIdNumberValidationHelper.validateIdNumberCEFormat(idNumber) ?
                            'ce-caracterinvalido2' : '';
                    }
                    when '4' {//Pasaporte
                        //CONFIRMAR SI SOLO ADMITE ALFANUMERICO O TBN CARACTERES ESPECIALES - MODIFICAR CONTRATO DE SER NECESARIO
                        String methodCharacterValidation = 'findSpecialCharacterLetter';
                        String methodAccentValidation = 'findSpecialCharacterAccent';
                        key = !PS_AccountIdNumberValidationHelper.validateIdNumberPassCUITLength(idNumber) ?
                            'pp-cantidadcaracteres' :
                        !PS_AccountIdNumberValidationHelper.validateIdPrefixZero(idNumber) ?
                            'pp-ceroizq' :
                        !PS_AccountIdNumberValidationHelper.validateInvalidCharacter(idNumber,methodCharacterValidation) ?
                            'pp-caracterincorrectoñ' :
                        !PS_AccountIdNumberValidationHelper.validateInvalidCharacter(idNumber,methodAccentValidation) ?
                            'pp-caracterincorrectotilde' :
                        '';
                    }
                    when '8' {//CIT Pais Origen
                        //CONFIRMAR SI SOLO ADMITE ALFANUMERICO O TBN CARACTERES ESPECIALES - MODIFICAR CONTRATO DE SER NECESARIO
                        key = !PS_AccountIdNumberValidationHelper.validateIdNumberPassCUITLength(idNumber) ?
                            'cit-cantidadcaracteres' :
                        !PS_AccountIdNumberValidationHelper.validateIdPrefixZero(idNumber) ?
                            'cit-ceroizq' :
                        !PS_AccountIdNumberValidationHelper.validateIdNumberInvalidCharacter(idNumber) ?
                            'cit-caracterincorrecto' : '';
                        
                        //PS_AccountIdNumberValidationUtilities.processPASSCUITvalidations(validationOne, validationTwo, validationThree, idNumber, accValidated, accountRecord);
                    } 
                    when else {
                        key = 'invalido';
                    }
                }
            }
        
            
            if(name.length() > STR_MAXNAME){
                apiname = 'name';
                key = 'length';
            }else if(lastName.length() > STR_MAXNAME){
                apiname = 'lastName';
                key = 'length';
            }
            if(motherLastName.length() > STR_MAXNAME){
                apiname = 'motherLastName';
                key = 'length';
            }else if(serviceName == serviceMonokera ? !PS_AccountBasicInfoValidationHelper.validateStringCharNamesCharacters(name) : !PS_AccountBasicInfoValidationHelper.validateStringCharNames(name)){
                apiname = 'name';
                key = 'caracter';
            }else if(serviceName == serviceMonokera ? !PS_AccountBasicInfoValidationHelper.validateStringCharNamesCharacters(lastName) : !PS_AccountBasicInfoValidationHelper.validateStringCharNames(lastName)){
                apiname = 'lastName';
                key = 'caracter';
            }else if(serviceName == serviceMonokera ? !PS_AccountBasicInfoValidationHelper.validateStringCharNamesCharacters(motherLastName) : !PS_AccountBasicInfoValidationHelper.validateStringCharNames(motherLastName)){
                apiname = 'motherLastName';
                key = 'caracter';
            }
			system.debug('//DELETE apiname: ' + PS_AccountBasicInfoValidationHelper.validateStringCharNames(name));
            if(!String.isBlank(key)){
                Object validacionObj = PS_GlobalHelper.findErrorByApinameAndKey(errorList, apiname, key);
                return generateErrorMsg(outMap, errorMap, apiname + '-' + key);                
            }
       
            ResultPGA resultpgaObj;
            DataPGA dataObj; 
            Boolean updateIndicator = false;
            String body ='';
            if(acct.size() == 0 || (acct.size() > 0 && acct.get(0).PS_validationPGA__c != 'Validacion Completada')){

                try { 
                    
                    PS_CalloutWithToken callout = new PS_CalloutWithToken('PS_PGAValidationToken');

                    Map<String,String> headerMap = new Map<String,String>();
                    headerMap.put('Aplicacion-Id', appName);
                    headerMap.put('Nombre-Aplicacion', appName);
                    headerMap.put('Usuario-Consumidor-Id',consumerUser);
                    headerMap.put('Nombre-Servicio-Consumidor', businessProcess);
                    headerMap.put('Transaccion-Id',  UUID.randomUUID().toString());

                    /*Map<String,String> paramMap = new Map<String,String>();
                    paramMap.put('docNum',newDocumentNumber);*/
                    
                    callout.setHeaders(headerMap);        
                    //callout.setParams(paramMap);        
                    
                    Map<String,Object> bodyMap = new Map<String,Object>();
                    List<Map<String,Object>> records = new List<Map<String,Object>>();
                     
                    Map<String,Object> recordMap = new Map<String,Object>();
                    recordMap.put('fechaNacimiento',dtbirthTime.formatGmt('YYYY-MM-dd').replace('-',''));                      
                    recordMap.put('numeroDocumento',newDocumentNumber.toUpperCase());                      
                    recordMap.put('codigoTipoDocumento',documentType.toUpperCase());                      
                    recordMap.put('apellidoPaterno',lastName.toUpperCase());                      
                    recordMap.put('apellidoMaterno',motherLastName.toUpperCase());                      
                    recordMap.put('nombre',name.toUpperCase());   
                    
                    records.add(recordMap);                      
                    bodyMap.put('datos',records);     
                    body = Json.serialize(bodyMap);
					requestCalloutStartDate = Datetime.now();
                    HttpResponse res = callout.setRequestBody(bodyMap).makeCallout().getResponse();
                    requestCalloutEndDate = Datetime.now();
                    
    
                    if(res.getStatusCode() == 200){
                        resultpgaObj = (ResultPGA)JSON.deserializeStrict(res.getBody(),ResultPGA.class); 
                        dataObj = resultpgaObj.datos[0]; 
                        updateIndicator = true;
                    }else if(res.getStatusCode() == 400){
                        Map<String, Object> resultPGAMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody()); 
                    
                        Map<String, Object> resultErrorMap = new Map<String, Object>();
                        resultErrorMap.put('type','FUNCIONAL');
                        resultErrorMap.put('message','[apiService]: ' + resultPGAMap.get('description'));
                        resultErrorMap.put('code','FNE-CO-038');
            
                        Map<String, Object> resultErrorMsgMap = new Map<String, Object>();
                        resultErrorMsgMap.put('messageError','Error interno en el servicio API PGA Validación cliente - ' + resultPGAMap.get('description'));
        
                        Map<String, Object> resultMsgMap = new Map<String, Object>();
                        resultMsgMap.put('status','Error');
                        resultMsgMap.put('error',resultErrorMap);
                        resultMsgMap.put('message',resultErrorMsgMap);
                        
                        outMap.put('response',resultMsgMap);
                        outMap.remove('errorCode');
                        outMap.remove('error');
                        return true;
                    }else{
                        updateIndicator = false;
                        String logTypePicklist = 'CALLOUT_TYPE';
                        String processSubType = 'Validación PGA';
                        String message;
                        String request = body;
                        String response = res.getBody();
                        String identifier = documentNumber;
                        savelog(logTypePicklist, processSubType, message, request, response, identifier);
                    }
                
                } catch(System.Exception e) { 
                    updateIndicator = false;
                    String logTypePicklist = 'CALLOUT_TYPE';
					String processSubType = 'Validación PGA';
					String message;
                    String request = body;
                    String response = e.getMessage();
                    String identifier = documentNumber;
                    savelog(logTypePicklist, processSubType, message, request, response, identifier);
                }

            }
            
			Date quoteBirthDate = dtbirthTime.dategmt();
            String personCode  = '';
            String personCodeCm = '';            
            
            String pgaValidation = updateIndicator? 'Validacion Completada':'Validacion Erronea';
            
            if((acct.size() > 0 && acct.get(0).PS_validationPGA__c == 'Validacion Completada')){
                Account currentAccount = acct.get(0);
                        
                name = currentAccount.FirstName.toUpperCase();
				quoteBirthDate = currentAccount.PersonBirthdate;
                lastName = currentAccount.LastName.toUpperCase();
                motherLastName = currentAccount.PS_MothersLastname__pc.toUpperCase();
				personCode = currentAccount.PS_PersonCodeBDG__c;
				personCodecm  = String.valueOf(currentAccount.PS_PersonCodeRRGG__c);
                updateIndicator = true;
                pgaValidation = 'Validacion Completada';

            }   

            IF(dataObj != null){
                name = dataObj.nombre.toUpperCase();
                lastName = dataObj.apellidoPaterno.toUpperCase();
                motherLastName = dataObj.apellidoMaterno.toUpperCase();
                if(dataObj.codigoTipoDocumento != '3' && dataObj.codigoTipoDocumento != '4'){
                    documentNumber = dataObj.numeroDocumento;
                }
                documentType = dataObj.codigoTipoDocumento;
                
                Integer birthDateYear = Integer.valueOf(dataObj.fechaNacimiento.substring(0,4));       
                Integer birthDateMonth = Integer.valueOf(dataObj.fechaNacimiento.substring(4,6));       
                Integer birthDateDay = Integer.valueOf(dataObj.fechaNacimiento.substring(6,8));       

                personCode  = String.valueOf(dataObj.codigoPersonaBdg);
                personCodeCm = String.valueOf(dataObj.codigoPersonaCm);
                
                quoteBirthDate = Date.newInstance(birthDateYear,birthDateMonth,birthDateDay);
                hasError = false;
                String birthDatepga = dtbirthTime.formatGmt('YYYY-MM-dd');
                if(birthDatepga != birthDate){
                    clientAge = PS_DateOperator.getYearDifference(birthDatepga);
                    
                    if (clientAge < minAge || clientAge > maxAge) {
                        apiname = 'birthdate';
                        key = 'rango';
                        hasError = true;
                    }              
                }
			}
            
            if(hasError){
                return generateErrorMsg(outMap, errorMap, apiname + '-' + key);                
            }
            hasError = false;

            PS_QuoteRequest__c quoteRequest = new PS_QuoteRequest__c();
    
            quoteRequest.PS_FirstName__c = name.length() < 40 ? name : name.substring(0,40);
            quoteRequest.PS_LastName__c = lastName.length() < 40 ? lastName : lastName.substring(0,40);
            quoteRequest.PS_MothersSurname__c = motherLastName.length() < 40 ? motherLastName :  motherLastName.substring(0,40);
            quoteRequest.PS_BirthDate__c = quoteBirthDate;
            quoteRequest.PS_PersonCode__c = personCode;
            quoteRequest.PS_IdentityDocumentNumber__c = documentNumber;
            quoteRequest.PS_PGAValidation__c = pgaValidation;
            quoteRequest.PS_IdentityDocumentType__c = documentType;
            quoteRequest.PS_AccountId__c = accountId;
            quoteRequest.PS_ProductId__c = prod[0].Id;
            quoteRequest.PS_ProductCode__c = productCode;      
            quoteRequest.PS_PersonCodeCm__c = String.isBlank(personCodecm) ? 0 : Integer.valueof(personCodecm);
            quoteRequest.PS_QuotePaymentType__c = prod[0].PS_PaymentFrequency__c;
            quoteRequest.PS_ProductName__c = prod[0].name;
            quoteRequest.PS_QuoteTerm__c = prod[0].vlocity_ins__Term__c;
            quoteRequest.PS_ProductCurrency__c = prod[0].CurrencyIsoCode;
            quoteRequest.PS_ParentProductCode__c = prod[0].vlocity_ins__ParentClassId__r.ProductCode;
            quoteRequest.PS_HeaderThirdPartyApp__c = businessProcess;
            quoteRequest.PS_HeaderTransactionId__c = transactionId;
            quoteRequest.PS_HeaderAppName__c = appName;
            quoteRequest.PS_HeaderUser__c = consumerUser;
            quoteRequest.PS_RequestStartDate__c = requestStartDate.formatGMT('yyyy-MM-dd HH:mm:ss.SSS');
            if(requestCalloutStartDate != null)
    	        quoteRequest.PS_CalloutStartDate__c = requestCalloutStartDate.formatGMT('yyyy-MM-dd HH:mm:ss.SSS');
            if(requestCalloutEndDate != null)
	            quoteRequest.PS_CalloutEndDate__c = requestCalloutEndDate.formatGMT('yyyy-MM-dd HH:mm:ss.SSS');
            if(requestCalloutStartDate != null && requestCalloutEndDate != null)
	            quoteRequest.PS_CalloutDuration__c = requestCalloutEndDate.gettime() - requestCalloutStartDate.gettime();
            
            if (accountId != null && updateIndicator ){
              quoteRequest.PS_IsUpdate__c = true;
            }

            Double premium = 0;
            Double cdImpuestoPrima = 0;
            Double cdPrimaBruta = 0;
            Double cdPrimaNeta = 0;
            Boolean isMonokera = serviceName == serviceMonokera;
			Boolean isMibanco = serviceName == serviceMibanco;   
            Boolean isBCP = serviceName == serviceBcp;
            Boolean checkProduct981 = quoteRequest.PS_ParentProductCode__c == STR_NEWYAPEPRODUCT;
            Boolean checkProduct997 = quoteRequest.PS_ParentProductCode__c == STR_NEWBCPPRODUCT;
            
            if(isMonokera || isMibanco || (isBCP && (checkProduct981 || checkProduct997))){
                Map<String,Object> inputProductMap = new Map<String,Object>();
                Map<String,Object> outProductMap = new Map<String,Object>();
                Map<String,Object> optionProductMap = new Map<String,Object>();
                
                inputProductMap.put('productId',prod.get(0).Id);
                
                PS_GetProductInformation productInfoService = new PS_GetProductInformation();
                productInfoService.invokeMethod('getPlanAttributes',inputProductMap,outProductMap,optionProductMap);
                
                Map<String,Object> rootMap  = (Map<String,Object>)outProductMap.get('output');
                Map<String,Object> attributesMap  = (Map<String,Object>)rootMap.get('attributes');
                
                for(Map<String,Object> attributeMap : (List<Map<String,Object>>)attributesMap.values()){

                    if(attributeMap.containsKey('CD_NetPremium')){
                        premium += Double.valueOf(attributeMap.get('CD_NetPremium'));
                    }else{
                        premium += Double.valueOf(attributeMap.get('CD_Premium'));
                        cdPrimaBruta = Double.valueOf(attributeMap.get('CD_Premium'));
                    }

                    if(attributeMap.containsKey('CD_IGV')){
                        premium += Double.valueOf(attributeMap.get('CD_IGV'));
                        cdImpuestoPrima = Double.valueOf(attributeMap.get('CD_IGV'));
                    }
                    if(attributeMap.containsKey('CD_emissionRight')){
                        premium += Double.valueOf(attributeMap.get('CD_emissionRight'));
                    }
                }
            }

            Decimal premiumVal = Decimal.valueOf(premium).setScale(2, RoundingMode.HALF_UP);
            cdPrimaNeta = cdImpuestoPrima + cdPrimaBruta;
            Map<String,Object> outputOkMap = new Map<String,Object>();

            
            Datetime effectiveStartDate = Datetime.now();
            Datetime effectiveEndDate = effectiveStartDate.addYears(1);

            Datetime requestEndDate = Datetime.now();
            quoteRequest.PS_RequestEndDate__c = requestEndDate.formatGMT('yyyy-MM-dd HH:mm:ss.SSS');
            quoteRequest.PS_RequestDuration__c = requestEndDate.gettime() - requestStartDate.gettime();
            insert quoteRequest;
            
            if(isMonokera || isMibanco || (isBCP && (checkProduct981 || checkProduct997))){
                if(quoteRequest.PS_ParentProductCode__c == STR_MONOKERAPRODUCT){
                    Map<String, Object> infoTarificacion = new Map<String, Object>();
                    infoTarificacion.put('netPremium',cdPrimaNeta);
                    infoTarificacion.put('premiumTax',cdImpuestoPrima);
                    infoTarificacion.put('grossPremium',cdPrimaBruta);
                    outputOkMap.put('pricing', infoTarificacion);
                    Map<String, Object> infoDelProducto = new Map<String, Object>();
                    infoDelProducto.put('productCode',quoteRequest.PS_ParentProductCode__c);
                    infoDelProducto.put('planCode',quoteRequest.PS_ProductCode__c);
                    outputOkMap.put('product', infoDelProducto);
                    outputOkMap.put('effectiveEndDate',effectiveEndDate);
                    outputOkMap.put('effectiveStartDate',effectiveStartDate);
                    outputOkMap.put('priceQuote',premiumVal);
                	outputOkMap.put('productCode',quoteRequest.PS_ProductCode__c);
                }
                    outputOkMap.put('priceQuote',premiumVal);
            }
            outputOkMap.put('status','ok');
            outputOkMap.put('quoteId',quoteRequest.Id);
            outMap.put('response',outputOkMap);
            outMap.remove('errorCode');
            outMap.remove('error');

            
            return true;
        }   
    }
    
    class ResultPGA{
        DataPGA[] datos;
    }
    
    
    class DataPGA{
        String  nombre {get;set;}
        String  apellidoPaterno {get;set;}
        String  apellidoMaterno {get;set;}
        String  fechaNacimiento {get;set;}
        String  codigoTipoDocumento {get;set;}
        String  numeroDocumento {get;set;}
        Integer codigoPersonaBdg {get;set;}
        Integer codigoPersonaCm {get;set;}
        Boolean indicadorActualizacion {get;set;}
    }
    
    private void saveLog(String logTypePicklist, String processSubType, String message, String request, String response, String documentNumber){
		
        String responseType = 'Error';
        String process = 'Quote';
        String identifier = documentNumber;
        
        String responseSerialized = response != null ? JSON.serialize(response) : null;
        String messageSerialized = message != null ? JSON.serialize(message) : null;


        //Malogras mi velada
        /* PS_Logger.enableStreaming();
        PS_Logger.log(responseType, processSubType,  messageSerialized,  request,  responseSerialized, process, identifier, logTypePicklist); */
        
    }
    
    private Boolean generateErrorMsg(Map<String,Object> outMap, Map<String,Object> errorMap, String errorKey){
        ErrorDescription errorObj = (ErrorDescription)errorMap.get(errorKey);
        Map<String,Object> outputErrorMsgMap = new Map<String,Object>();
        outputErrorMsgMap.put('messageError',errorObj.message);
        
        Map<String,Object> outputErrorMap = new Map<String,Object>();
        outputErrorMap.put('type',errorObj.errorType);
        outputErrorMap.put('message',errorObj.message);
        outputErrorMap.put('code',errorObj.code);
        
        Map<String,Object> outputResponseMap = new Map<String,Object>();
        outputResponseMap.put('error',outputErrorMap);
        outputResponseMap.put('message',outputErrorMsgMap);
        outputResponseMap.put('status','Error');
        
        outMap.put('response',outputResponseMap);
        outMap.remove('errorCode');
        outMap.remove('error');  
        
        return true;
        
    }
    
    class ErrorDescription{
        /**
         * @description Metodo constructor
         * @param errorRecordMap enviar los datos del error en un map
         */
        public ErrorDescription(Map<String,Object> errorRecordMap){
            this.apiname = (String)errorRecordMap.get('apiname');
            this.message = (String)errorRecordMap.get('message');
            this.code = (String)errorRecordMap.get('code');
            this.errorType = (String)errorRecordMap.get('type');
        }
        
        String apiname {get;set;}
        String key {get;set;}
        String errorType {get;set;}
        String code {get;set;}
        String message {get;set;}
    }

}