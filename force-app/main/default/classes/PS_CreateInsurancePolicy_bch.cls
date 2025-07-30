/**
* @description       : Clase para generar pólizas de forma masiva
* @author            : Rebeca Cruz <rcruzgar@emeal.nttdata.com>
* @group             : NTT DATA
* @last modified on  : 06-24-2025
**/ 
public class PS_CreateInsurancePolicy_bch implements Database.Batchable<sObject> {
    PUBLIC STATIC FINAL STRING ISSUANCEREQUESTSTATUS = 'Unprocessed';
    PUBLIC STATIC FINAL STRING INSURANCETYPEJOINT = 'M';
    PUBLIC STATIC FINAL STRING INSURANCEPOLICYNUMBER = 'PolicyAutoNumber';
    PUBLIC STATIC FINAL STRING INSURANCEPOLICYREQUEST = 'RequestAutoNumber';
    PUBLIC STATIC FINAL STRING INSURANCEPOLICYOPERATION = 'OperationCodeAutoNumber';
    PUBLIC STATIC FINAL STRING INSURANCEMASSIVEPOLICYNUMBER = 'PolicyAutoNumberMassive';
    PUBLIC STATIC FINAL STRING INSURANCEMASSIVEPOLICYREQUEST = 'RequestAutoNumberMassive';
    PUBLIC STATIC FINAL STRING INSURANCEMASSIVEPOLICYOPERATION = 'OperationCodeAutoNumberMassive';
    PUBLIC STATIC FINAL STRING ACCOUNTOBJECTAPINAME = 'Account';
    PUBLIC STATIC FINAL STRING ACCOUNTEXTERNALIDAPINAME = 'FinServ__SourceSystemId__c';
    PUBLIC STATIC FINAL STRING ACCCOUNTVALIDATIONVALUE = 'Validacion Completada';
    PUBLIC STATIC FINAL STRING ADDITIONALINSUREDROLE = 'AdditionalInsured';
    PUBLIC STATIC FINAL STRING CONTRACTORINSUREDROLE = 'Contractor';
    PUBLIC STATIC FINAL STRING INSUREDROLE = 'Insured';
    PUBLIC STATIC FINAL STRING MORTGAGEINSURED = 'MortgageInsured';
    PUBLIC STATIC FINAL STRING PROPERTYINSURED = 'PropertyH';
    PUBLIC STATIC FINAL STRING ENDOSEERINSURED = 'Endorseer';
    PUBLIC STATIC FINAL STRING BENEFICIARYROLE = 'Beneficiary';
    PUBLIC STATIC FINAL STRING REGISTRATIONSTATUS = '0';
    PUBLIC STATIC FINAL STRING CERTIFICATESOURCEPROCESS = '00';
    PUBLIC STATIC FINAL STRING CREATIONUSER = 'Salesforce';
    PUBLIC STATIC FINAL STRING OPERATIONTYPE = '1';
    PUBLIC STATIC FINAL STRING SOURCESYSTEMIDENTIFIER = 'SourceSystemIdentifier';
    PUBLIC STATIC FINAL STRING PARTICIPANTNAME = 'PS_Name__c';
    PUBLIC STATIC FINAL STRING PARTICIPANTLASTNAME = 'PS_LastName__c';
    PUBLIC STATIC FINAL STRING PARTICIPANTMOTHERSURNAME = 'PS_MotherSurname__c';
    PUBLIC STATIC FINAL STRING PARTICIPANTINSTANCEKEY = 'vlocity_ins_fsc__ParticipantName__c';
    PUBLIC STATIC FINAL STRING PARTICIPANTDOCUMENTTYPE = 'PS_DocumentType__c';
    PUBLIC STATIC FINAL STRING PARTICIPANTDOCUMENTNUMBER = 'PS_IdentificationDocumentNumber__c';
    PUBLIC STATIC FINAL STRING PARTICIPANTROLE = 'Role';
    PUBLIC STATIC FINAL STRING PARTICIPANTRELATIONSHIP = 'RelationshipToInsured';
    PUBLIC STATIC FINAL STRING PARTICIPANTPOLICYID = 'InsurancePolicy';
    PUBLIC STATIC FINAL STRING PARTICIPANTACCOUNTID = 'PrimaryParticipantAccount';
    PUBLIC STATIC FINAL STRING PARTICIPANTPRODUCTCODE = 'PS_ProductCode__c';
    PUBLIC STATIC FINAL STRING PARTICIPANTINSUREDFORMAT = 'PS_InsuredAttributesFormat__c';
    PUBLIC STATIC FINAL STRING PARTICIPANTCONTRACTORFORMAT = 'PS_ContractorAttributesFormat__c';
    PUBLIC STATIC FINAL STRING PARTICIPANTADDINSUREDFORMAT = 'PS_AdditionalInsuredAttributesFormat__c';
    PUBLIC STATIC FINAL STRING PARTICIPANTPROPERTYFORMAT = 'PS_PropertyAttributesFormat__c';
    PUBLIC STATIC FINAL STRING COVERAGEPOLICYID = 'InsurancePolicyId';
    PUBLIC STATIC FINAL STRING COVERAGEINSUREDID = 'InsuredId';
    PUBLIC STATIC FINAL STRING COVERAGEADDITIONALINSUREDID = 'AdditionalInsuredId';
    PUBLIC STATIC FINAL STRING COVERAGEMORTGAGEINSUREDID = 'MortgageInsuredId';
    PUBLIC STATIC FINAL STRING COVERAGEPROPERTYINSUREDID = 'PropertyHId';
    PUBLIC STATIC FINAL STRING COVERAGEPRODUCTCODE = 'ProductCode';
    PUBLIC STATIC FINAL STRING APPLICATIONNAME = 'SFSC';
    PUBLIC STATIC FINAL STRING POLICYSTATUS = 'Aprobada sin primer pago';
    PUBLIC STATIC FINAL STRING PERSONTYPE = 'N';
    PUBLIC STATIC FINAL STRING REQUESTTYPECL = 'Desgravamen';
    PUBLIC STATIC FINAL STRING ERRORCODE = 'DUPLICATE_VALUE';
    PUBLIC STATIC FINAL STRING PREMIUMFIELDNAME = 'StandardPremiumAmount';
    PUBLIC STATIC FINAL STRING TAXFIELDNAME = 'StandardTaxAmount';
    PUBLIC STATIC FINAL STRING FEEFIELDNAME = 'StandardFeeAmount';
    PUBLIC STATIC FINAL DECIMAL CONTACTMANAGERCODE = 0;
    PUBLIC STATIC FINAL STRING REQUESTTYPEPT = 'ProteccionTarjeta';
    PUBLIC STATIC FINAL STRING REQUESTTYPEHIPOTECARIO = 'Hipotecario';
    PUBLIC STATIC FINAL STRING DEFAULTACCOUNTTYPEPT = '000';
    PUBLIC STATIC FINAL STRING DEFAULTACCOUNTTYPEVF = '002';
    PUBLIC STATIC FINAL STRING ACCOUNTNUMBERWITHOUTACCOUNTHPT = '000000000000';
    PUBLIC STATIC FINAL STRING REQUESTTYPECESANTIA = 'Cesantia';
    PUBLIC STATIC FINAL STRING REQUESTTYPEVIDAFLEX = 'VidaPrestamo';
    PUBLIC STATIC FINAL STRING REQUESTTYPEFINANCIALPROTECTION = 'ProteccionFinanciera';
    PUBLIC STATIC FINAL STRING REQUESTTYPEFINANCIALPROTECTIONMB = 'ProteccionFinancieraMB';
    PUBLIC STATIC FINAL STRING REQUESTTYPEUNEMPLOYMENT = 'ProteccionFinancieraDesempleo'; //nk 9833-6
    PUBLIC STATIC FINAL STRING REQUESTTYPEPROTECTEDFAMILY = 'FamiliaProtegida';
    PUBLIC STATIC FINAL STRING REQUESTTYPEINDEMNIZATORIO = 'AccidentesIndemnizatorio';
    PUBLIC STATIC FINAL STRING REQUESTTYPESA = 'AdultoSeguro';
    PUBLIC STATIC FINAL STRING REQUESTTYPEEL = 'VidaEsencial';
    PUBLIC STATIC FINAL DECIMAL VALVIDAFLEX = 0.03;
    PUBLIC STATIC FINAL DECIMAL VALCESANTIA = 0.025;
    PUBLIC STATIC FINAL DECIMAL NETPREMIUMFACTOR = 1.2154; 



    PUBLIC STATIC FINAL List<String> FIELDSKEYMORTGAGEINSURED = new List<String> {
        'PS_ContactType__c',
        'PS_NationalityCountry__c',
        'PS_Gender__c',
        'PS_MaritalStatus__c',
        'PS_Birthdate__c',
        'PS_TelephoneType__c',
        'PS_CountryCodeTelephon__c',
        'PS_AreaCodeTelephon__c',
        'PS_EmailType__c',
        'PS_EmailAddress__c',
        'PS_IndicatorPrimaryInsured__c',
        'PS_IndicatorContractingPolicy__c',
        'PS_CodeTypeofAddress__c',
        'PS_HousingTypeCode__c',
        'PS_CodeTypeResidence__c',
        'PS_Country__c',
        'PS_PostalCode__c',
        'PS_LocationCode__c',
        'PS_StreetType__c',
        'PS_StreetName__c',
        'PS_StreetNumber__c',
        'PS_PersonCodeBDG__c',
        'PS_PersonCodeRRGG__c'
    };
    private static Map<String, List<Map<String, Object>>> coverageInfo = new Map<String, List<Map<String, Object>>>();
    private static Map<String,PS_PremiumRatingConfig__mdt> factorMap = new Map<String,PS_PremiumRatingConfig__mdt>();
    //PRODUCTO 971
    List<PS_PolicyPricingSource__c> configPrimaMensual = new List<PS_PolicyPricingSource__c>();
    Set<InsurancePolicy> successfulPolicies = new Set<InsurancePolicy>();
    Map<String, List<Map<String, Object>>> coverageStructureMap = new Map<String, List<Map<String, Object>>>();
    Map<String, Decimal> commissionPercentageMap = new Map<String, Decimal>();
    Map<String, Map<String, Decimal>> policyAmountMap = new Map<String, Map<String, Decimal>>();
    Map<String, Map<String, Decimal>> policyAuxAmountMap = new Map<String, Map<String, Decimal>>();
    List<PS_IssuanceRequest__c> listSolicitudesHipotecario = new List<PS_IssuanceRequest__c>();
    List<PS_IssuanceRequest__c> listSolicitudesVF = new List<PS_IssuanceRequest__c>();
    Map<String, Map<String, Decimal>> policyTotalAmountMap = new Map<String, Map<String, Decimal>>();
    Map<String, InsurancePolicyAsset> propertyMapList = new Map<String, InsurancePolicyAsset>();
    Map<String, PS_GeographicLocation__c> geographicyMapList = new Map<String, PS_GeographicLocation__c>();
    List<PS_MortgageIssuanceRequest__c> recordQueryMortgage = new List<PS_MortgageIssuanceRequest__c>();
    Map<String, PS_MortgageIssuanceRequest__c> operationNumberMapMortgage = new Map<String, PS_MortgageIssuanceRequest__c>();
    Boolean isMassive = false;
    Integer recordLimit = 0;
    /**
    * @description Metodo de ejecución desde scheduler, obtiene datos del mapa de coberturas
    * @author rcruzgar@emeal.nttdata.com| 2024-07-04
    * @param coverageDataMap
    * @param commissionMap
    **/
    public PS_CreateInsurancePolicy_bch(Map<String, List<Map<String, Object>>> coverageDataMap,
        Map<String, Decimal> commissionMap,
        Map<String, Map<String, Decimal>> amountMap) {
        coverageStructureMap = coverageDataMap;
        commissionPercentageMap = commissionMap;
        policyAmountMap = amountMap;
    }
    /**
    * @description Metodo de ejecución desde scheduler, obtiene datos del mapa de coberturas
    * @author rcruzgar@emeal.nttdata.com| 2024-07-04
    * @param coverageDataMap
    * @param commissionMap
    **/
    public PS_CreateInsurancePolicy_bch(Map<String, List<Map<String, Object>>> coverageDataMap,
        Map<String, Decimal> commissionMap,
        Map<String, Map<String, Decimal>> amountMap,
        Boolean isMassive, Integer recordLimit) {
        coverageStructureMap = coverageDataMap;
        commissionPercentageMap = commissionMap;
        policyAmountMap = amountMap;
        this.isMassive = isMassive;
        this.recordLimit = recordLimit;
    }
    /**
    * @description Metodo Database.QueryLocator, obtiene los registros PS_IssuanceRequest__c a procesar
    * @author rcruzgar@emeal.nttdata.com| 2024-07-04
    * @param bc contexto batch
    * @return Lista de solicitudes de emisión a procesar
    **/
    public Database.QueryLocator start(Database.BatchableContext bc) {
        Database.QueryLocator recordQuery = null;
        if (recordLimit > 0) {
            recordQuery = Database.getQueryLocator([SELECT PS_OperationNumber__c, PS_Currency__c, PS_OperationAmount__c, PS_TotalDebtAmount__c, PS_IssuanceRequestType__c, PS_ProductId__r.vlocity_ins__ParentClassId__r.PS_DanaServiceAPI__c,
                    PS_ProductCode__c, PS_LastName__c, PS_MotherSurname__c, PS_ClientName__c, PS_Birthdate__c, PS_DocumentType__c, PS_DocumentNumber__c, PS_ProductId__r.vlocity_ins__LineOfBusiness__c,
                    PS_Nationality__c, PS_Address__c, PS_StreetType__c, PS_StreetName__c, PS_StreetNumber__c, PS_LocationCode__c, PS_InsuredAttributesFormat__c, PS_AdditionalInsuredAttributesFormat__c,
                    PS_BuildingType__c, PS_UrbanizationType__c, PS_UrbanizationName__c, PS_AddressBlock__c, PS_AddressLot__c, PS_AddressSector__c, PS_SpouseBirthdate__c,
                    PS_FlatNumber__c, PS_Cellphone__c, PS_PhoneNumber__c, PS_EmailAddress__c, PS_InsuranceType__c, PS_IntermediaryAccountId__c, PS_ProducerId__c,
                    PS_CreditTerm__c, PS_EffectiveDate__c, PS_ExpirationDate__c, PS_ReserveRate__c, PS_SpousePersonCodeBDG__c, PS_RelationshipToInsured__c,
                    PS_Gender__c, PS_MaritalStatus__c, PS_ElectronicConsent__c, PS_ProductFamily__c, PS_ProductType__c, PS_SalesSubchannel__c, PS_ProductId__r.vlocity_ins__Term__c,
                    PS_SpouseName__c, PS_SpouseLastName__c, PS_SpouseMotherSurname__c, PS_SpouseDocumentType__c, PS_SpouseDocumentNumber__c, PS_MigratedPolicy__c,
                    PS_InsuredAccountId__c, PS_AdditionalInsuredAccountId__c, PS_DisbursementDate__c, PS_PersonCodeBDG__c, PS_InsuredAccountId__r.FinServ__SourceSystemId__c,
                    PS_InsuredAccountId__r.PS_PersonCodeRRGG__c,PS_InsuredAccountId__r.vlocity_ins__Email__c,PS_InsuredAccountId__r.Phone,PS_InsuredAccountId__r.PersonMobilePhone,
                    PS_InsuredAccountId__r.PersonHomePhone,
                    PS_AdditionalInsuredAccountId__r.FinServ__SourceSystemId__c, PS_PlanType__c, PS_InsuranceRate__c, PS_InsuranceIsActive__c, PS_ProductId__c, PS_ProductName__c,
                    PS_ProductId__r.vlocity_ins__ParentClassCode__c, PS_InsuredUniqueIdentifier__c, PS_AdditionalInsuredUniqueIdentifier__c, PS_ProductId__r.PS_PaymentFrequency__c,
                    PS_ProductId__r.CurrencyIsoCode, PS_ProductId__r.vlocity_ins__AttributeDefaultValues__c, PS_Department__c, PS_Province__c, PS_District__c,
                    PS_ProductId__r.Name, PS_ProductId__r.vlocity_ins__ParentClassId__r.PS_StatusOfEmission__c, PS_RenewalDate__c, PS_ProductId__r.PS_EntityCollection__c, PS_AccountType__c,
                    PS_ProductId__r.PS_StatusOfEmission__c, PS_ProductId__r.PS_RenewalType__c, PS_GenerateCredit__c, PS_PersonCodeRRGG__c, PS_PersonalDataProtection__c, PS_SalesDate__c,
                    PS_Height__c, PS_Weight__c, PS_IMC__c, PS_PremiumAmount__c,

                   
                    PS_ProductId__r.PS_TotalAmountExpenses__c,PS_ProductId__r.PS_TotalAmountExpensesContent__c, PS_ProductId__r.PS_PrimaryCommission__c,
                    PS_SumInsuredBuilding__c, PS_SumInsuredContents__c, PS_WarrantyNumber__c,
                    PS_EmailCorrespondence__c, PS_DeliveryMethod__c, PS_PolicyTermType__c, PS_CurrencySumAssured__c, PS_ReferenceDateRate__c, PS_ReferenceDateCoverage__c, PS_PremiumPaymentMethod__c,
                    PS_AxelRenewalIndicator__c, PS_NumberAcselRenewals__c, PS_AcselIssueDate__c, PS_AcselxPolicyNumber__c, PS_ProducerIndicator__c, PS_Channel__c, PS_Agent__c, PS_ApplicationDate__c,
                    PS_GrouperCode__c, PS_FixedPremiumIndicator__c, PS_PaymentPlan__c, PS_QuoteOrIssueIndicator__c, PS_TypeMortgageOperation__c, PS_ExternalSellerCode__c,
                    PS_CreditNumber__c, PS_CreditType__c, PS_CreditStartDate__c, PS_CreditEndDate__c, PS_SalesCode__c, PS_AcselxChannelCode__c, PS_ContactType__c, PS_NationalityCountry__c, PS_TelephoneType__c, PS_CountryCodeTelephon__c,
                    PS_AreaCodeTelephon__c, PS_EmailType__c, PS_IndicatorPrimaryInsured__c, PS_IndicatorContractingPolicy__c, PS_PostalCode__c, PS_Country__c, PS_CodeTypeResidence__c,
                    PS_HousingTypeCode__c, PS_CodeTypeofAddress__c, PS_PercentageSumInsured__c, PS_TypeAssignee__c, PS_WarrantyValue__c, PS_AccountNumber__c, PS_ContractorActivity__c,
                    PS_BeneficiaryType__c, PS_Nemo__c, PS_InsuredPlan__c, PS_ContractorMotherSurname__c, PS_ContractorLastName__c, PS_ContractorPersonCodeBDG__c, PS_ContractorBirthdate__c, PS_ContractorUniqueIdentifier__c,
                    PS_ContractorName__c, PS_ContractorDocumentNumber__c, PS_ContractorDocumentType__c, PS_ContractorAccountId__c, PS_ContractorGender__c, PS_ContractorAddress__c, PS_ContractorMaritalStatus__c, PS_ContractorCountry__c,
                    PS_ContractorAttributesFormat__c,PS_MortgageMigrationIndicator__c,PS_ProductId__r.vlocity_ins__ParentClassId__r.ProductCode, PS_ContractorEmail__c,
                    PS_ContractorNationality__c, PS_ProductId__r.PS_PremiumRate__c,PS_ProductId__r.PS_IsMultibranch__c,PS_PolicyNumberGW__c 
                     FROM PS_IssuanceRequest__c
                    WHERE PS_ProcessedFlag__c = : ISSUANCEREQUESTSTATUS 
                    LIMIT: recordLimit]);
        } else {
            recordQuery = Database.getQueryLocator([SELECT PS_OperationNumber__c, PS_Currency__c, PS_OperationAmount__c, PS_TotalDebtAmount__c, PS_IssuanceRequestType__c, PS_ProductId__r.vlocity_ins__ParentClassId__r.PS_DanaServiceAPI__c,
                    PS_ProductCode__c, PS_LastName__c, PS_MotherSurname__c, PS_ClientName__c, PS_Birthdate__c, PS_DocumentType__c, PS_DocumentNumber__c, PS_ProductId__r.vlocity_ins__LineOfBusiness__c,
                    PS_Nationality__c, PS_Address__c, PS_StreetType__c, PS_StreetName__c, PS_StreetNumber__c, PS_LocationCode__c, PS_InsuredAttributesFormat__c, PS_AdditionalInsuredAttributesFormat__c,
                    PS_BuildingType__c, PS_UrbanizationType__c, PS_UrbanizationName__c, PS_AddressBlock__c, PS_AddressLot__c, PS_AddressSector__c, PS_SpouseBirthdate__c,
                    PS_FlatNumber__c, PS_Cellphone__c, PS_PhoneNumber__c, PS_EmailAddress__c, PS_InsuranceType__c, PS_IntermediaryAccountId__c, PS_ProducerId__c,
                    PS_CreditTerm__c, PS_EffectiveDate__c, PS_ExpirationDate__c, PS_ReserveRate__c, PS_SpousePersonCodeBDG__c, PS_RelationshipToInsured__c,
                    PS_Gender__c, PS_MaritalStatus__c, PS_ElectronicConsent__c, PS_ProductFamily__c, PS_ProductType__c, PS_SalesSubchannel__c, PS_ProductId__r.vlocity_ins__Term__c,
                    PS_SpouseName__c, PS_SpouseLastName__c, PS_SpouseMotherSurname__c, PS_SpouseDocumentType__c, PS_SpouseDocumentNumber__c, PS_MigratedPolicy__c,
                    PS_InsuredAccountId__c, PS_AdditionalInsuredAccountId__c, PS_DisbursementDate__c, PS_PersonCodeBDG__c, PS_InsuredAccountId__r.FinServ__SourceSystemId__c,
                    PS_InsuredAccountId__r.PS_PersonCodeRRGG__c,PS_InsuredAccountId__r.vlocity_ins__Email__c,PS_InsuredAccountId__r.Phone,PS_InsuredAccountId__r.PersonMobilePhone,
                    PS_InsuredAccountId__r.PersonHomePhone,
                    PS_AdditionalInsuredAccountId__r.FinServ__SourceSystemId__c, PS_PlanType__c, PS_InsuranceRate__c, PS_InsuranceIsActive__c, PS_ProductId__c, PS_ProductName__c,
                    PS_ProductId__r.vlocity_ins__ParentClassCode__c, PS_InsuredUniqueIdentifier__c, PS_AdditionalInsuredUniqueIdentifier__c, PS_ProductId__r.PS_PaymentFrequency__c,
                    PS_ProductId__r.CurrencyIsoCode, PS_ProductId__r.vlocity_ins__AttributeDefaultValues__c, PS_Department__c, PS_Province__c, PS_District__c,
                    PS_ProductId__r.Name, PS_ProductId__r.vlocity_ins__ParentClassId__r.PS_StatusOfEmission__c, PS_RenewalDate__c, PS_ProductId__r.PS_EntityCollection__c, PS_AccountType__c,
                    PS_ProductId__r.PS_StatusOfEmission__c, PS_ProductId__r.PS_RenewalType__c, PS_GenerateCredit__c, PS_PersonCodeRRGG__c, PS_PersonalDataProtection__c, PS_SalesDate__c,
                    PS_Height__c, PS_Weight__c, PS_IMC__c, PS_PremiumAmount__c,
                    
                    PS_ProductId__r.PS_TotalAmountExpenses__c,PS_ProductId__r.PS_TotalAmountExpensesContent__c, PS_ProductId__r.PS_PrimaryCommission__c,
                    PS_SumInsuredBuilding__c, PS_SumInsuredContents__c, PS_WarrantyNumber__c,
                    PS_EmailCorrespondence__c, PS_DeliveryMethod__c, PS_PolicyTermType__c, PS_CurrencySumAssured__c, PS_ReferenceDateRate__c, PS_ReferenceDateCoverage__c, PS_PremiumPaymentMethod__c,
                    PS_AxelRenewalIndicator__c, PS_NumberAcselRenewals__c, PS_AcselIssueDate__c, PS_AcselxPolicyNumber__c, PS_ProducerIndicator__c, PS_Channel__c, PS_Agent__c, PS_ApplicationDate__c,
                    PS_GrouperCode__c, PS_FixedPremiumIndicator__c, PS_PaymentPlan__c, PS_QuoteOrIssueIndicator__c, PS_TypeMortgageOperation__c, PS_ExternalSellerCode__c,
                    PS_CreditNumber__c, PS_CreditType__c, PS_CreditStartDate__c, PS_CreditEndDate__c, PS_SalesCode__c, PS_AcselxChannelCode__c,
                    PS_ContactType__c, PS_NationalityCountry__c, PS_TelephoneType__c, PS_CountryCodeTelephon__c, PS_AreaCodeTelephon__c, PS_EmailType__c, PS_Country__c, PS_CodeTypeResidence__c,
                    PS_CodeTypeofAddress__c, PS_IndicatorPrimaryInsured__c, PS_IndicatorContractingPolicy__c, PS_PostalCode__c, PS_HousingTypeCode__c, PS_PercentageSumInsured__c,
                    PS_TypeAssignee__c, PS_WarrantyValue__c, PS_AccountNumber__c, PS_ContractorActivity__c,
                    PS_BeneficiaryType__c, PS_Nemo__c, PS_InsuredPlan__c, PS_ContractorMotherSurname__c, PS_ContractorLastName__c, PS_ContractorPersonCodeBDG__c, PS_ContractorBirthdate__c, PS_ContractorUniqueIdentifier__c,
                    PS_ContractorName__c, PS_ContractorDocumentNumber__c, PS_ContractorDocumentType__c, PS_ContractorAccountId__c, PS_ContractorGender__c, PS_ContractorAddress__c, PS_ContractorMaritalStatus__c, PS_ContractorCountry__c,
                    PS_ContractorAttributesFormat__c,PS_MortgageMigrationIndicator__c,PS_ProductId__r.vlocity_ins__ParentClassId__r.ProductCode, PS_ContractorEmail__c,
                    PS_ContractorNationality__c, PS_ProductId__r.PS_PremiumRate__c,PS_ProductId__r.PS_IsMultibranch__c,
                    PS_PolicyNumberGW__c 
                    FROM PS_IssuanceRequest__c
                    WHERE PS_ProcessedFlag__c = : ISSUANCEREQUESTSTATUS  ]);
        }
        return recordQuery;
    }
    /**
    * @description Metodo principal execute. Invoca a diferentes clases para generar cuentas, pólizas, participantes y coberturas. Actualiza
    * las solicitudes de emisión si el proceso es exitoso o fallido
    * @author rcruzgar@emeal.nttdata.com| 2024-07-04
    * @param bc Contexto batch
    * @param scope Lista de solicitudes de emisión a procesar
    **/
    public void execute(Database.BatchableContext bc, List<PS_IssuanceRequest__c> scope) {
        Integer scopeSize = scope.size();
        Integer counter = 0;
        List<String> policyAutoNumber = new List<String>();
        List<String> requestAutoNumber = new List<String>();
        List<String> operationAutoNumber = new List<String>();
        factorMap = PS_PremiumRatingConfig__mdt.getAll();
        //971
        configPrimaMensual = [SELECT Id, PS_TermStart__c, PS_TermEnd__c, PS_PremiumRate__c, PS_DataSource__c, PS_StartDate__c, PS_EndDate__c, PS_PlanType__c, PS_StartingAmount__c, PS_EndingAmount__c, PS_Premium__c FROM PS_PolicyPricingSource__c];
        Schema.SObjectField externalIdToken = Schema.getGlobalDescribe().get(ACCOUNTOBJECTAPINAME).getDescribe().fields.getMap().get(ACCOUNTEXTERNALIDAPINAME);
        try {
            policyAutoNumber = PS_AutoNumberGenerator.generateNumberBatchFlow(this.isMassive ? INSURANCEMASSIVEPOLICYNUMBER : INSURANCEPOLICYNUMBER, scopeSize);
        } catch (exception e) {
            policyAutoNumber = PS_AutoNumberGenerator.generateNumberBatchFlow(this.isMassive ? INSURANCEMASSIVEPOLICYNUMBER : INSURANCEPOLICYNUMBER, scopeSize);
        }
        try {
            requestAutoNumber = PS_AutoNumberGenerator.generateNumberBatchFlow(this.isMassive ? INSURANCEMASSIVEPOLICYREQUEST : INSURANCEPOLICYREQUEST, scopeSize);
        } catch (exception e) {
            requestAutoNumber = PS_AutoNumberGenerator.generateNumberBatchFlow(this.isMassive ? INSURANCEMASSIVEPOLICYREQUEST : INSURANCEPOLICYREQUEST, scopeSize);
        }
        try {
            operationAutoNumber = PS_AutoNumberGenerator.generateNumberBatchFlow(this.isMassive ? INSURANCEMASSIVEPOLICYOPERATION : INSURANCEPOLICYOPERATION, scopeSize);
        } catch (exception e) {
            operationAutoNumber = PS_AutoNumberGenerator.generateNumberBatchFlow(this.isMassive ? INSURANCEMASSIVEPOLICYOPERATION : INSURANCEPOLICYOPERATION, scopeSize);
        }
        Set<String> warrantyOperationNumbers = new Set<String>();
        //solicitudes de hipotecario
        for (PS_IssuanceRequest__c item : scope) {
            if (item.PS_IssuanceRequestType__c == REQUESTTYPEHIPOTECARIO) {
                warrantyOperationNumbers.add(item.PS_OperationNumber__c);
                listSolicitudesHipotecario.add(item);
            }
        }
        if (listSolicitudesHipotecario.size() > 0) {
            //mapa de montos por nro de operación
            recordQueryMortgage = [SELECT PS_OperationNumber__c, PS_WarrantyNumber__c, PS_Floor__c, PS_DeclaredBuildingHome__c, PS_AddressReference__c,
                PS_AlarmIndicator__c, PS_AnnualRate__c, PS_Apple__c, PS_AppraisalValue__c,
                PS_Appraiser__c, PS_CodeTypeofAddress__c, PS_CodeTypeofInterior__c,
                PS_CodeTypeResidence__c, PS_CondominiumIndicator__c, PS_ConstructedFootage__c,
                PS_ConstructionMaterialsCode__c, PS_Country__c, PS_DateAppraisal__c,
                PS_DeclaredValueContents__c, PS_DescriptionInterior__c,
                PS_HomeOccupant__c, PS_HousingTypeCode__c, PS_Kilometer__c, PS_Lot__c,
                PS_MonthlyPremium__c, PS_MortgageMigrationIndicator__c, PS_NumberAssets__c,
                PS_NumberBasementsBuilding__c, PS_NumberFloorsBuilding__c, PS_OfferingHousing__c,
                PS_RateType__c, PS_ResidentialComplex__c, PS_RestAddress__c, PS_StreetName__c,
                PS_StreetNumber__c, PS_StreetType__c, PS_SumInsuredBuilding__c,
                PS_SumInsuredContents__c, PS_SurveillanceIndicator__c,
                PS_TheftInclusionIndicator__c, PS_TypeHousingComplex__c,
                PS_TypeofHousingUse__c, PS_Typeofproperty__c, PS_TypeofUrbanization__c,
                PS_Ubigeo__c, PS_Urbanization__c,
                PS_YearConstructionProperty__c, PS_ZipCode__c, PS_PropertyAttributesFormat__c,PS_Currency__c
                FROM PS_MortgageIssuanceRequest__c
                WHERE PS_ProcessedFlag__c = : ISSUANCEREQUESTSTATUS and PS_OperationNumber__c IN : warrantyOperationNumbers];
            propertyMapList =  PS_ConsultMapPropertyRecords.generateMapRecordsAsset(recordQueryMortgage);
            policyTotalAmountMap = PS_UtilitaryClassCoverageTotalAmounts.generatePolicyTotalAmounts(coverageStructureMap, listSolicitudesHipotecario);
        }
        for (PS_IssuanceRequest__c itemVF : scope) {
            if (itemVF.PS_IssuanceRequestType__c == REQUESTTYPEVIDAFLEX || itemVF.PS_IssuanceRequestType__c == REQUESTTYPECESANTIA) {
                listSolicitudesVF.add(itemVF);
            }
        }
        if (listSolicitudesVF.size() > 0) {
            policyAuxAmountMap = PS_UtilitaryClassCoverageAuxTotalAmounts.generatePolicyTotalAmounts(coverageStructureMap, listSolicitudesVF);
        }
        for (PS_MortgageIssuanceRequest__c issMortgage : recordQueryMortgage) {
            operationNumberMapMortgage.put(issMortgage.PS_WarrantyNumber__c, issMortgage);
        }
       
        List<PS_PaymentRequest__c> paymentRequestInsertList = new List<PS_PaymentRequest__c>();
        Map<String, PS_IssuanceRequest__c>  updateRequestMap = new Map<String, PS_IssuanceRequest__c>();
        Map<String, PS_MortgageIssuanceRequest__c>  updateRequestMapMortgage = new Map<String, PS_MortgageIssuanceRequest__c>();
        List<PS_IssuanceRequest__c> updateRequestLst = new List<PS_IssuanceRequest__c>();
        List<PS_MortgageIssuanceRequest__c> updateRequestMortgageLst = new List<PS_MortgageIssuanceRequest__c>();
        List<PS_IssuanceRequest__c> successfulIssuanceRequest = new List<PS_IssuanceRequest__c>();
        List<Account> fullAccountData = new List<Account>();
        Map<String, PS_IssuanceRequest__c> requestData = new Map<String, PS_IssuanceRequest__c>();
        Set<InsurancePolicy> insurancePolicyInsert = new Set<InsurancePolicy>();
        List<InsurancePolicy> insurancePolicyInsertLst = new List<InsurancePolicy>();
        
        List<InsurancePolicyAsset> newAssetList = new List<InsurancePolicyAsset>();
        Map<String, InsurancePolicy> requestIssPolicy = new Map<String, InsurancePolicy>();
        List<Map<String, Object>> participantList = new List<Map<String, Object>>();
        List<PS_MasivePolicyRegistration__c> policiesRegistrationData = new List<PS_MasivePolicyRegistration__c>();
        List<PS_PolicyCertificate__c> policiesCertificateData = new List<PS_PolicyCertificate__c>();
        Map<String, String> acctDuplicateMap = new Map<String, String>();
        Map<String, PS_IssuanceRequest__c> operationNumberMap = new Map<String, PS_IssuanceRequest__c>();
        Map<String, insurancePolicyWrapper> wrapperMap = new Map<String, insurancePolicyWrapper>();
        List<PS_MortgageIssuanceRequest__c> successfulMortgageIssuanceRequest = new List<PS_MortgageIssuanceRequest__c>();
        List<Map<String, Object>> assetDataList = new List<Map<String, Object>>();
        Map<String, List<PS_PolicyParticipantRequest__c>> operationParticipantMap = new Map<String, List<PS_PolicyParticipantRequest__c>>();
        for (PS_IssuanceRequest__c issReq : scope) {
            Account newAcctRecord = new Account();
            Account updateAcctRecord = new Account();
            Account additionalAcctRecord = new Account();
            Account contractorAcctRecord = new Account();
            Boolean addToLst = false;
            Map<String, Decimal> planPremiumMap = new Map<String, Decimal>();
            Map<String, Decimal> PremiumMapByNroOperacion = new Map<String, Decimal>();
            Map<String, Decimal> premiumByOpVp = new Map<String, Decimal>();
            Map<String, Decimal> planAddPremiumMap = new Map<String, Decimal>();
            insurancePolicyWrapper wrapperClass = new insurancePolicyWrapper();
            if (issReq.PS_InsuredAccountId__c == null) {
                if (!acctDuplicateMap.containsKey(issReq.PS_InsuredUniqueIdentifier__c)) {
                    newAcctRecord = createAccountData(issReq);
                    fullAccountData.add(newAcctRecord);
                    requestData.put(newAcctRecord.FinServ__SourceSystemId__c, issReq);
                    acctDuplicateMap.put(issReq.PS_InsuredUniqueIdentifier__c, issReq.PS_OperationNumber__c);
                } else {
                    addToLst = true;
                }
            } else {
                updateAcctRecord = updateAccountData(issReq);
                fullAccountData.add(updateAcctRecord);
                requestData.put(issReq.PS_InsuredAccountId__r.FinServ__SourceSystemId__c, issReq);
            }
            if (issReq.PS_AdditionalInsuredAccountId__c == null && issReq.PS_InsuranceType__c == INSURANCETYPEJOINT) {
                if (!acctDuplicateMap.containsKey(issReq.PS_AdditionalInsuredUniqueIdentifier__c)) {
                    acctDuplicateMap.put(issReq.PS_AdditionalInsuredUniqueIdentifier__c, issReq.PS_OperationNumber__c);
                    additionalAcctRecord = createAdditionalAccountData(issReq);
                    fullAccountData.add(additionalAcctRecord);
                    requestData.put(additionalAcctRecord.FinServ__SourceSystemId__c, issReq);
                }
            }

            if (issReq.PS_ContractorAccountId__c == null && (issReq.PS_IssuanceRequestType__c == REQUESTTYPESA || issReq.PS_IssuanceRequestType__c == REQUESTTYPEEL)) {
                if (!acctDuplicateMap.containsKey(issReq.PS_ContractorUniqueIdentifier__c)) {
                    acctDuplicateMap.put(issReq.PS_ContractorUniqueIdentifier__c, issReq.PS_OperationNumber__c);
                    contractorAcctRecord = createContractorAccountData(issReq);
                    fullAccountData.add(contractorAcctRecord);
                    requestData.put(contractorAcctRecord.FinServ__SourceSystemId__c, issReq);
                }
            }
            wrapperClass.accountId = issReq.PS_InsuredUniqueIdentifier__c;
            wrapperClass.contractorId = issReq.PS_ContractorUniqueIdentifier__c;
            wrapperClass.policyNum = policyAutoNumber[counter];
            wrapperClass.requestNum = requestAutoNumber[counter];
            wrapperClass.operationNum = operationAutoNumber[counter];
            wrapperClass.commPercentage = commissionPercentageMap.get(issReq.PS_ProductCode__c);
            if (issReq.PS_IssuanceRequestType__c == REQUESTTYPEHIPOTECARIO) {
                PremiumMapByNroOperacion = policyTotalAmountMap.get(issReq.PS_OperationNumber__c);
                wrapperClass.premiumAmount = PremiumMapByNroOperacion.get('totalStandardPremiumAmount');
                wrapperClass.taxAmount = PremiumMapByNroOperacion.get('totalStandardTaxAmount');
                wrapperClass.feeAmount = PremiumMapByNroOperacion.get('totalStandardFeeAmount');
                wrapperClass.totalPremiumAmount = PremiumMapByNroOperacion.get('totalStandardPremiumAmount');
                wrapperClass.totalTaxAmount = PremiumMapByNroOperacion.get('totalStandardTaxAmount');
                wrapperClass.totalFeeAmount = PremiumMapByNroOperacion.get('totalStandardFeeAmount');
            } else if (issReq.PS_IssuanceRequestType__c == REQUESTTYPEVIDAFLEX || issReq.PS_IssuanceRequestType__c == REQUESTTYPECESANTIA) {
                premiumByOpVp = policyAuxAmountMap.get(issReq.PS_OperationNumber__c);
                wrapperClass.premiumAmount = premiumByOpVp.get('totalStandardPremiumAmount');
                wrapperClass.taxAmount = premiumByOpVp.get('totalStandardTaxAmount');
                wrapperClass.feeAmount = premiumByOpVp.get('totalStandardFeeAmount');
                wrapperClass.totalPremiumAmount = premiumByOpVp.get('totalStandardPremiumAmount');
                wrapperClass.totalTaxAmount = premiumByOpVp.get('totalStandardTaxAmount');
                wrapperClass.totalFeeAmount = premiumByOpVp.get('totalStandardFeeAmount');
            }else if(issReq.PS_IssuanceRequestType__c == REQUESTTYPEUNEMPLOYMENT){ //nk 9833-6
                Map<String,Decimal> premiumRating = premiumRating(issReq);
                wrapperClass.premiumAmount      = premiumRating.get('premium');
                wrapperClass.taxAmount          = premiumRating.get('tax');
                wrapperClass.feeAmount          = premiumRating.get('fee');
                wrapperClass.totalPremiumAmount = premiumRating.get('premium');
                wrapperClass.totalTaxAmount     = premiumRating.get('tax');
                wrapperClass.totalFeeAmount     = premiumRating.get('fee');
                wrapperClass.requestType        = issReq.PS_IssuanceRequestType__c;
            }else if(issReq.PS_IssuanceRequestType__c == REQUESTTYPEFINANCIALPROTECTION || 
                     issReq.PS_IssuanceRequestType__c == REQUESTTYPEPROTECTEDFAMILY ||
                     issReq.PS_IssuanceRequestType__c == REQUESTTYPEFINANCIALPROTECTIONMB) {
                Map<String,Decimal> premiumRating = premiumRating(issReq, configPrimaMensual);
                wrapperClass.premiumAmount      = premiumRating.get('premium');
                wrapperClass.taxAmount          = premiumRating.get('tax');
                wrapperClass.feeAmount          = premiumRating.get('fee');
                wrapperClass.totalPremiumAmount = premiumRating.get('premium');
                wrapperClass.totalTaxAmount     = premiumRating.get('tax');
                wrapperClass.totalFeeAmount     = premiumRating.get('fee');
                wrapperClass.requestType        = issReq.PS_IssuanceRequestType__c;
            } else {
                String planInsured = issReq.PS_ProductCode__c + '-Insured';
                planPremiumMap = policyAmountMap.get(planInsured);
                wrapperClass.premiumAmount = planPremiumMap.get('totalStandardPremiumAmount');
                wrapperClass.taxAmount = planPremiumMap.get('totalStandardTaxAmount');
                wrapperClass.feeAmount = planPremiumMap.get('totalStandardFeeAmount');
                wrapperClass.totalPremiumAmount = planPremiumMap.get('totalStandardPremiumAmount');
                wrapperClass.totalTaxAmount = planPremiumMap.get('totalStandardTaxAmount');
                wrapperClass.totalFeeAmount = planPremiumMap.get('totalStandardFeeAmount');
                if (issReq.PS_InsuranceType__c == INSURANCETYPEJOINT) {
                    String planAddInsured = issReq.PS_ProductCode__c + '-AdditionalInsured';
                    planAddPremiumMap = policyAmountMap.get(planAddInsured);
                    wrapperClass.addPremiumAmount = planAddPremiumMap.get('totalStandardPremiumAmount');
                    wrapperClass.addTaxAmount = planAddPremiumMap.get('totalStandardTaxAmount');
                    wrapperClass.addFeeAmount = planAddPremiumMap.get('totalStandardFeeAmount');
                    wrapperClass.totalPremiumAmount += wrapperClass.addPremiumAmount;
                    wrapperClass.totalTaxAmount += wrapperClass.addTaxAmount;
                    wrapperClass.totalFeeAmount += wrapperClass.addFeeAmount;
                }
            }

            wrapperMap.put(issReq.PS_OperationNumber__c, wrapperClass);
            InsurancePolicy policyRecord = createPolicyData(issReq, wrapperClass);
            operationNumberMap.put(issReq.PS_OperationNumber__c, issReq);
            requestIssPolicy.put(issReq.Id, policyRecord);
            if (addToLst) {
                insurancePolicyInsert.add(policyRecord);
            }
            
            counter++;
        }

        if (fullAccountData.size() > 0) {
            Database.UpsertResult[] acctSrLst = Database.upsert(fullAccountData, externalIdToken, false);
            for (Integer indexAcct = 0; indexAcct < acctSrLst.size(); indexAcct++) {
                PS_IssuanceRequest__c recordAcct = new PS_IssuanceRequest__c();
                recordAcct.Id = String.valueOf(requestData.get(fullAccountData[indexAcct].FinServ__SourceSystemId__c).get('Id'));
                if (!acctSrLst[indexAcct].isSuccess()) {
                    for (Database.Error errorLst : acctSrLst[indexAcct].getErrors()) {
                        if (String.valueOf(errorLst.getStatusCode()) == ERRORCODE) {
                            insurancePolicyInsert.add(requestIssPolicy.get(recordAcct.Id));//recordAcct.Id
                                                                                        // del
                                                                                        // issuancerequest
                        } else {
                            recordAcct.PS_ProcessedFlag__c = 'Error';
                            recordAcct.PS_ErrorDescription__c = String.ValueOf(acctSrLst[indexAcct].getErrors()).abbreviate(255);
                        }
                    }
                } else if (acctSrLst[indexAcct].isSuccess()) {
                    insurancePolicyInsert.add(requestIssPolicy.get(recordAcct.Id));
                }
                updateRequestMap.put(recordAcct.Id, recordAcct);
            }
            
        }
        if (insurancePolicyInsert.size() > 0) {
            insurancePolicyInsertLst.addAll(insurancePolicyInsert);
            Database.SaveResult[] polSrLst = Database.insert(insurancePolicyInsertLst, false);
            for (Integer indexInsPol = 0; indexInsPol < polSrLst.size(); indexInsPol++) {
                PS_IssuanceRequest__c recordPol = new PS_IssuanceRequest__c();
                recordPol.Id = String.valueOf(operationNumberMap.get(insurancePolicyInsertLst[indexInsPol].PS_OperationNumber__c).get('Id'));
                recordPol.PS_ProcessingDate__c = Datetime.now();
                if (!polSrLst[indexInsPol].isSuccess()) {
                    recordPol.PS_ProcessedFlag__c = 'Error';
                    recordPol.PS_ErrorDescription__c = String.ValueOf(polSrLst[indexInsPol].getErrors()).abbreviate(255);
                } else {
                    recordPol.PS_ProcessedFlag__c = 'Processed';
                    recordPol.PS_IssuedPolicy__c = polSrLst[indexInsPol].getId();
                    successfulPolicies.add(requestIssPolicy.get(recordPol.Id));
                    successfulIssuanceRequest.add(operationNumberMap.get(insurancePolicyInsertLst[indexInsPol].PS_OperationNumber__c));
                }
                updateRequestMap.put(recordPol.Id, recordPol);
            }
        }
        //-----Consulta a tabla de participantes-----//
        List<PS_PolicyParticipantRequest__c> participantLst = [SELECT Id, PS_Role__c, PS_FirstName__c, PS_LastName__c, PS_MothersMaidenName__c, PS_ParticipationPercentage__c,
            PS_RelationshipToInsured__c, PS_IdentificationDocumentType__c, PS_IdentificationDocumentNumber__c,
            PS_OperationNumber__c, PS_Gender__c, PS_Birthdate__c, PS_EmailAddress__c
            FROM PS_PolicyParticipantRequest__c
            WHERE PS_OperationNumber__c IN : (operationNumberMap.keySet())];
        for (PS_PolicyParticipantRequest__c partRq : participantLst) {
            List<PS_PolicyParticipantRequest__c> policyParticipantList = new List<PS_PolicyParticipantRequest__c>();
            policyParticipantList.add(partRq);
            if (operationParticipantMap.containsKey(partRq.PS_OperationNumber__c)) {
                operationParticipantMap.get(partRq.PS_OperationNumber__c).add(partRq);
            } else {
                operationParticipantMap.put(partRq.PS_OperationNumber__c, policyParticipantList);
            }
        }
        //-----Fin Consulta a tabla de participantes-----//
        InsurancePolicyAsset obj = new InsurancePolicyAsset();
        //recorrer el Mapa de idSolicitudEmision con cada póliza
        for (PS_IssuanceRequest__c createdRecord : successfulIssuanceRequest) {
            fieldsHipotecarioWrapper wrapperHipotecario = new fieldsHipotecarioWrapper();
            fieldsVidaFlexWrapper wrapperVidaFlex = new fieldsVidaFlexWrapper();
            InsurancePolicy policyRecord = new InsurancePolicy();
            Map<String, Object> additionalParticipantRecords = new  Map<String, Object>();
            Map<String, Object> contractorParticipantRecords = new  Map<String, Object>();
            Map<String, Object> participantRecords  = new  Map<String, Object>();
            List<Map<String, Object>> beneficiaryRecords  = new  List<Map<String, Object>>();
            Map<String, Object> mortgageInsuredParticipantRecords = new  Map<String, Object>();
            Map<String, Object> propertyInsuredParticipantRecords = new  Map<String, Object>();
            Map<String, Object> endoseerInsuredParticipantRecords = new  Map<String, Object>();
            Map<String, Object> propertyRecords = new  Map<String, Object>();
            List<PS_PolicyParticipantRequest__c> participanBeneficiarytLst = new List<PS_PolicyParticipantRequest__c>();
            //Hipotecario
            wrapperHipotecario.requestype = createdRecord.PS_IssuanceRequestType__c;
            wrapperHipotecario.sumAssured = (Decimal)createdRecord.PS_SumInsuredBuilding__c;
            wrapperHipotecario.primaryComission = createdRecord.PS_ProductId__r.PS_PrimaryCommission__c;
            wrapperHipotecario.totalAmountExpenses = createdRecord.PS_ProductId__r.PS_TotalAmountExpenses__c;
            wrapperHipotecario.totalAmountExpensesContent = createdRecord.PS_ProductId__r.PS_TotalAmountExpensesContent__c;
            wrapperHipotecario.hasContent = createdRecord.PS_MortgageMigrationIndicator__c;    
            //Vida Flex        
            wrapperVidaFlex.totalDebtAmount = createdRecord.PS_TotalDebtAmount__c;
            wrapperVidaFlex.operationAmount = createdRecord.PS_OperationAmount__c;
            wrapperVidaFlex.requestype = createdRecord.PS_IssuanceRequestType__c;
            

            Set<String> requestTypesWithSimplePayment = new Set<String>{
                REQUESTTYPEPT, REQUESTTYPECESANTIA, REQUESTTYPEVIDAFLEX, REQUESTTYPEINDEMNIZATORIO, REQUESTTYPESA, REQUESTTYPEEL
            };
            
            if (createdRecord.PS_GenerateCredit__c) {
                policyRecord = requestIssPolicy.get(createdRecord.Id);
                
                if (requestTypesWithSimplePayment.contains(createdRecord.PS_IssuanceRequestType__c)) {
                    PS_PaymentRequest__c paymentRequestRecord = createPaymentRequest(policyRecord);
                    paymentRequestInsertList.add(paymentRequestRecord);
            
                } else if (createdRecord.PS_IssuanceRequestType__c == REQUESTTYPEHIPOTECARIO) {
                    createPaymentRequestHipotecario(policyRecord, paymentRequestInsertList);
            
                } else if (createdRecord.PS_IssuanceRequestType__c == REQUESTTYPEFINANCIALPROTECTION) {
                    createPaymentRequestMonthly(policyRecord, paymentRequestInsertList);
            
                } else if (createdRecord.PS_IssuanceRequestType__c == REQUESTTYPEUNEMPLOYMENT) {
                    createPaymentRequestMonthlyUnenployment(policyRecord, paymentRequestInsertList);
            
                } else if (createdRecord.PS_IssuanceRequestType__c == REQUESTTYPEPROTECTEDFAMILY) {
                    PS_PaymentRequest__c paymentRequestRecord = createPaymentRequestRecord(policyRecord);
                    paymentRequestInsertList.add(paymentRequestRecord);
                } 
            }

            obj.InsurancePolicy = new InsurancePolicy(SourceSystemIdentifier = String.valueOf(requestIssPolicy.get(createdRecord.Id).get(SOURCESYSTEMIDENTIFIER)));
            if (createdRecord.PS_IssuanceRequestType__c == REQUESTTYPEHIPOTECARIO) {
                    InsurancePolicyAsset itemAsset = propertyMapList.get(createdRecord.PS_OperationNumber__c);
                    propertyRecords = generatePropertyData(createdRecord, String.valueOf(requestIssPolicy.get(createdRecord.Id).get(SOURCESYSTEMIDENTIFIER)), wrapperMap.get(createdRecord.PS_OperationNumber__c), itemAsset);
                    assetDataList.add(propertyRecords);
                    wrapperHipotecario.propertyInsuredId = String.valueOf(propertyRecords.get(SOURCESYSTEMIDENTIFIER));
                    wrapperHipotecario.sumAssuredContent = (Decimal)itemAsset.PS_SumInsuredContents__c;
                
                mortgageInsuredParticipantRecords = generateMortgageInsuredParticipantData(createdRecord, String.valueOf(requestIssPolicy.get(createdRecord.Id).get(SOURCESYSTEMIDENTIFIER)), wrapperMap.get(createdRecord.PS_OperationNumber__c));
                participantList.add(mortgageInsuredParticipantRecords);
                endoseerInsuredParticipantRecords = generateEndoseerInsuredParticipantData(createdRecord, String.valueOf(requestIssPolicy.get(createdRecord.Id).get(SOURCESYSTEMIDENTIFIER)));
                participantList.add(endoseerInsuredParticipantRecords);
            } else  {
                participantRecords = generateInsuredParticipantData(createdRecord, String.valueOf(requestIssPolicy.get(createdRecord.Id).get(SOURCESYSTEMIDENTIFIER)), wrapperMap.get(createdRecord.PS_OperationNumber__c));
                participantList.add(participantRecords);
            }
            if (createdRecord.PS_InsuranceType__c == INSURANCETYPEJOINT) {
                additionalParticipantRecords = generateAdditionalInsuredParticipantData(createdRecord, String.valueOf(requestIssPolicy.get(createdRecord.Id).get(SOURCESYSTEMIDENTIFIER)), wrapperMap.get(createdRecord.PS_OperationNumber__c));
                participantList.add(additionalParticipantRecords);
            }
            if (createdRecord.PS_IssuanceRequestType__c == REQUESTTYPESA || createdRecord.PS_IssuanceRequestType__c == REQUESTTYPEEL) {
                contractorParticipantRecords = generateContractorParticipantData(createdRecord, String.valueOf(requestIssPolicy.get(createdRecord.Id).get(SOURCESYSTEMIDENTIFIER)));
                participantList.add(contractorParticipantRecords);
            }
            generateCoverageData(String.valueOf(requestIssPolicy.get(createdRecord.Id).get(SOURCESYSTEMIDENTIFIER)), String.valueOf(participantRecords.get(SOURCESYSTEMIDENTIFIER)), String.valueOf(additionalParticipantRecords.get(SOURCESYSTEMIDENTIFIER)), createdRecord.PS_ProductCode__c, wrapperHipotecario, wrapperVidaFlex, wrapperMap.get(createdRecord.PS_OperationNumber__c));
            if (createdRecord.PS_ProductId__r.vlocity_ins__ParentClassId__r.PS_DanaServiceAPI__c && (createdRecord.PS_MigratedPolicy__c == false)) {
                policiesCertificateData.add(generatePolicyCertificate(String.valueOf(requestIssPolicy.get(createdRecord.Id).get(SOURCESYSTEMIDENTIFIER))));
            }
            /*---------BENEFICIARIOS PARTICIPANTES---------*/
            participanBeneficiarytLst = operationParticipantMap.get(createdRecord.PS_OperationNumber__c);
            if (participanBeneficiarytLst != null && participanBeneficiarytLst.size() > 0) {
                beneficiaryRecords = generateBeneficiaryData(createdRecord, participanBeneficiarytLst, wrapperMap.get(createdRecord.PS_OperationNumber__c), String.valueOf(requestIssPolicy.get(createdRecord.Id).get(SOURCESYSTEMIDENTIFIER)));
                participantList.addAll(beneficiaryRecords);
            }
            /*---------BENEFICIARIOS PARTICIPANTES---------*/
            policiesRegistrationData.add(generatePolicyRegistration(requestIssPolicy.get(createdRecord.Id), createdRecord));
        }
            updateRequestLst.addAll(updateRequestMap.values());
            List<InsurancePolicyAsset> newAssettList = new List<InsurancePolicyAsset>();
             
            if (assetDataList.size() > 0) {
                newAssetList = PS_PolicyAssetJSONUtility.generateJSON(assetDataList);
                
            }        	
            
          if (newAssetList.size() > 0) {
            Database.SaveResult[] polSrLst = Database.insert(newAssetList, false);
            for (Integer indexInsPol = 0; indexInsPol < polSrLst.size(); indexInsPol++) {
                PS_MortgageIssuanceRequest__c recordPol = new PS_MortgageIssuanceRequest__c();
                recordPol.Id = String.valueOf(operationNumberMapMortgage.get(newAssetList[indexInsPol].AssetName).get('Id'));
                recordPol.PS_ProcessingDate__c = Datetime.now();
                if (!polSrLst[indexInsPol].isSuccess()) {
                    recordPol.PS_ProcessedFlag__c = 'Error';
                    recordPol.PS_ErrorDescription__c = String.ValueOf(polSrLst[indexInsPol].getErrors()).abbreviate(255);
                    
                } else {
                    recordPol.PS_ProcessedFlag__c = 'Processed';
                    recordPol.PS_IssuedAsset__c = polSrLst[indexInsPol].getId();
                   

                }
                updateRequestMapMortgage.put(recordPol.Id, recordPol);
            }
        }
        List<InsurancePolicyParticipant> newParticipantList = PS_PolicyParticipantJSONUtility.generateJSON(participantList);
        List<InsurancePolicyCoverage> coverageLst = PS_PolicyCoverageJSONUtility.generateJSON(coverageInfo, coverageStructureMap);

        updateRequestMortgageLst.addAll(updateRequestMapMortgage.values());
        
        if (newParticipantList.size() > 0) {
            Database.insert(newParticipantList);
        }
        if (coverageLst.size() > 0) {
            Database.insert(coverageLst);
        }
        if (updateRequestLst.size() > 0) {
            Database.update(updateRequestLst);
        }
        if (updateRequestMortgageLst.size() > 0) {
            Database.update(updateRequestMortgageLst);
        }
        if (policiesCertificateData.size() > 0) {
            Database.insert(policiesCertificateData);
        }
        if (policiesRegistrationData.size() > 0) {
            Database.insert(policiesRegistrationData);
        }
        if (paymentRequestInsertList.size() > 0) {
            Database.insert(paymentRequestInsertList);
        }
    }
    /**
    * @description Metodo finish del proceso batch
    * @author rcruzgar@emeal.nttdata.com| 2024-07-04
    * @param bc contexto batch
    **/
    public void finish(Database.BatchableContext bc) {}
    /**
    * @description Mapea los datos para crear una cuenta
    * @author rcruzgar@emeal.nttdata.com
    * @param requestAccountInfo Datos de la solicitud de emisión
    * @return Account datos de la cuenta
    **/
    public static Account createAccountData(PS_IssuanceRequest__c requestAccountInfo) {
        Account newAccount = new Account();
        PS_GeographicLocation__c accountLocation = new PS_GeographicLocation__c(PS_UniqueIdentifier__c = requestAccountInfo.PS_LocationCode__c);
        newAccount.FinServ__SourceSystemId__c = requestAccountInfo.PS_InsuredUniqueIdentifier__c;
        newAccount.LastName = requestAccountInfo.PS_LastName__c;
        newAccount.PS_MothersLastname__pc = requestAccountInfo.PS_MotherSurname__c;
        newAccount.FirstName = requestAccountInfo.PS_ClientName__c;
        newAccount.PersonBirthdate = requestAccountInfo.PS_Birthdate__c;
        newAccount.PS_IdentificationDocument__c = requestAccountInfo.PS_DocumentType__c;
        newAccount.PS_IdentificationDocumentNumber__c = requestAccountInfo.PS_DocumentNumber__c;
        newAccount.PS_PersonCodeBDG__c = requestAccountInfo.PS_PersonCodeBDG__c;
        newAccount.PS_validationPGA__c = ACCCOUNTVALIDATIONVALUE;
        newAccount.PS_Nationality__c = requestAccountInfo.PS_Nationality__c;
        newAccount.BillingStreet = requestAccountInfo.PS_Address__c;
        if (requestAccountInfo.PS_LocationCode__c != null) {
            newAccount.PS_District__r = accountLocation;
        }
        newAccount.PS_PersonCodeRRGG__c = requestAccountInfo.PS_PersonCodeRRGG__c ?? CONTACTMANAGERCODE;
        newAccount.PS_StreetType__c = requestAccountInfo.PS_StreetType__c;
        newAccount.PS_NameStreet__c = requestAccountInfo.PS_StreetName__c;
        newAccount.PS_StreetNumber__c = requestAccountInfo.PS_StreetNumber__c;
        newAccount.PS_IndoorType__c = requestAccountInfo.PS_BuildingType__c;
        newAccount.PS_TypeOfUrbanization__c = requestAccountInfo.PS_UrbanizationType__c;
        newAccount.PS_NameUrbanization__c = requestAccountInfo.PS_UrbanizationName__c;
        newAccount.PS_Block__c = requestAccountInfo.PS_AddressBlock__c;
        newAccount.PS_Plot__c = requestAccountInfo.PS_AddressLot__c;
        newAccount.PS_AddressSector__c = requestAccountInfo.PS_AddressSector__c;
        newAccount.PS_InsideDescription__c = requestAccountInfo.PS_FlatNumber__c;
        newAccount.PersonMobilePhone = requestAccountInfo.PS_Cellphone__c;
        newAccount.PersonHomePhone = requestAccountInfo.PS_PhoneNumber__c;
        newAccount.vlocity_ins__Email__c = requestAccountInfo.PS_EmailAddress__c;
        newAccount.FinServ__Gender__pc = requestAccountInfo.PS_Gender__c;
        newAccount.FinServ__MaritalStatus__pc = requestAccountInfo.PS_MaritalStatus__c;
        newAccount.PS_ContactType__c = requestAccountInfo.PS_ContactType__c;
        newAccount.PS_NationalityCountry__c = requestAccountInfo.PS_NationalityCountry__c;
        newAccount.PS_AreaCodeTelephon__c = requestAccountInfo.PS_AreaCodeTelephon__c;
        newAccount.PS_TelephoneType__c = requestAccountInfo.PS_TelephoneType__c;
        newAccount.PS_EmailType__c  = requestAccountInfo.PS_EmailType__c;
        newAccount.PS_IndicatorPrimaryInsured__c = requestAccountInfo.PS_IndicatorPrimaryInsured__c;
        newAccount.PS_IndicatorContractingPolicy__c = requestAccountInfo.PS_IndicatorContractingPolicy__c;
        newAccount.PS_CountryCodeTelephon__c = requestAccountInfo.PS_CountryCodeTelephon__c;
        newAccount.PS_TypeofAddress__c = requestAccountInfo.PS_CodeTypeofAddress__c;
        newAccount.PS_HousingTypeCode__c = requestAccountInfo.PS_HousingTypeCode__c;
        newAccount.PS_CodeTypeResidence__c = requestAccountInfo.PS_CodeTypeResidence__c;
        newAccount.PS_CountryProperty__c = requestAccountInfo.PS_Country__c;
        return newAccount;
    }
    /**
    * @description Mapea los datos para actualizar una cuenta
    * @author rcruzgar@emeal.nttdata.com
    * @param requestAccountUpdate Datos de la solicitud de emisión
    * @return Account datos de la cuenta
    **/
    public static Account updateAccountData(PS_IssuanceRequest__c requestAccountUpdate) {
        PS_GeographicLocation__c accountLocation = new PS_GeographicLocation__c(PS_UniqueIdentifier__c = requestAccountUpdate.PS_LocationCode__c);
        Account updateAccount = new Account();
        updateAccount.FinServ__SourceSystemId__c = requestAccountUpdate.PS_InsuredAccountId__r.FinServ__SourceSystemId__c;
        updateAccount.PS_Nationality__c = requestAccountUpdate.PS_Nationality__c;
        updateAccount.BillingStreet = requestAccountUpdate.PS_Address__c;
        if (requestAccountUpdate.PS_LocationCode__c != null) {
            updateAccount.PS_District__r = accountLocation;
        }
        if (requestAccountUpdate.PS_InsuredAccountId__r.PS_PersonCodeRRGG__c == null || requestAccountUpdate.PS_InsuredAccountId__r.PS_PersonCodeRRGG__c == 0){
            if (requestAccountUpdate.PS_PersonCodeRRGG__c != null && requestAccountUpdate.PS_PersonCodeRRGG__c != 0) {
                updateAccount.PS_PersonCodeRRGG__c = requestAccountUpdate.PS_PersonCodeRRGG__c;
                }
            }
        if (requestAccountUpdate.PS_InsuredAccountId__r.Phone == null){
            if (requestAccountUpdate.PS_Cellphone__c != null && requestAccountUpdate.PS_Cellphone__c != '0') {
                updateAccount.PersonMobilePhone = requestAccountUpdate.PS_Cellphone__c;
                updateAccount.Phone = requestAccountUpdate.PS_Cellphone__c;
                }
            }
        if (requestAccountUpdate.PS_InsuredAccountId__r.PersonHomePhone == null){    
            if (requestAccountUpdate.PS_PhoneNumber__c != null && requestAccountUpdate.PS_PhoneNumber__c != '0') {
                updateAccount.PersonHomePhone = requestAccountUpdate.PS_PhoneNumber__c;
                }
            }
        if (requestAccountUpdate.PS_InsuredAccountId__r.vlocity_ins__Email__c == null){
            if (requestAccountUpdate.PS_EmailAddress__c != null) {
                updateAccount.vlocity_ins__Email__c = requestAccountUpdate.PS_EmailAddress__c;
                }
            }
        /*updateAccount.PS_StreetType__c = requestAccountUpdate.PS_StreetType__c;
        updateAccount.PS_NameStreet__c = requestAccountUpdate.PS_StreetName__c;
        updateAccount.PS_StreetNumber__c = requestAccountUpdate.PS_StreetNumber__c;
        updateAccount.PS_IndoorType__c = requestAccountUpdate.PS_BuildingType__c;
        updateAccount.PS_TypeOfUrbanization__c = requestAccountUpdate.PS_UrbanizationType__c;
        updateAccount.PS_NameUrbanization__c = requestAccountUpdate.PS_UrbanizationName__c;
        updateAccount.PS_Block__c = requestAccountUpdate.PS_AddressBlock__c;
        updateAccount.PS_Plot__c = requestAccountUpdate.PS_AddressLot__c;
        updateAccount.PS_AddressSector__c = requestAccountUpdate.PS_AddressSector__c;
        updateAccount.PS_InsideDescription__c = requestAccountUpdate.PS_FlatNumber__c;
        updateAccount.FinServ__Gender__pc = requestAccountUpdate.PS_Gender__c;
        updateAccount.FinServ__MaritalStatus__pc = requestAccountUpdate.PS_MaritalStatus__c;*/
        updateAccount.PS_ContactType__c = requestAccountUpdate.PS_ContactType__c;
        updateAccount.PS_NationalityCountry__c = requestAccountUpdate.PS_NationalityCountry__c;
        updateAccount.PS_AreaCodeTelephon__c = requestAccountUpdate.PS_AreaCodeTelephon__c;
        updateAccount.PS_TelephoneType__c = requestAccountUpdate.PS_TelephoneType__c;
        updateAccount.PS_EmailType__c  = requestAccountUpdate.PS_EmailType__c;
        updateAccount.PS_IndicatorPrimaryInsured__c = requestAccountUpdate.PS_IndicatorPrimaryInsured__c;
        updateAccount.PS_IndicatorContractingPolicy__c = requestAccountUpdate.PS_IndicatorContractingPolicy__c;
        updateAccount.PS_CountryCodeTelephon__c = requestAccountUpdate.PS_CountryCodeTelephon__c;
        updateAccount.PS_TypeofAddress__c = requestAccountUpdate.PS_CodeTypeofAddress__c;
        updateAccount.PS_HousingTypeCode__c = requestAccountUpdate.PS_HousingTypeCode__c;
        updateAccount.PS_CodeTypeResidence__c = requestAccountUpdate.PS_CodeTypeResidence__c;
        updateAccount.PS_CountryProperty__c = requestAccountUpdate.PS_Country__c;
        return updateAccount;
    }
    /**
    * @description Mapea los datos para actualizar una cuenta
    * @author rcruzgar@emeal.nttdata.com
    * @param requestAdditionalAccount Datos de la solicitud de emisión
    * @return Account datos de la cuenta
    **/
    public static Account createAdditionalAccountData(PS_IssuanceRequest__c requestAdditionalAccount) {
        Account additionalInsuredAccount = new Account();
        additionalInsuredAccount.PS_PersonCodeBDG__c = requestAdditionalAccount.PS_SpousePersonCodeBDG__c;
        additionalInsuredAccount.FinServ__SourceSystemId__c = requestAdditionalAccount.PS_AdditionalInsuredUniqueIdentifier__c;
        additionalInsuredAccount.FirstName = requestAdditionalAccount.PS_SpouseName__c;
        additionalInsuredAccount.LastName = requestAdditionalAccount.PS_SpouseLastName__c;
        additionalInsuredAccount.PS_MothersLastname__pc = requestAdditionalAccount.PS_SpouseMotherSurname__c;
        additionalInsuredAccount.PS_IdentificationDocument__c = requestAdditionalAccount.PS_SpouseDocumentType__c;
        additionalInsuredAccount.PS_IdentificationDocumentNumber__c = requestAdditionalAccount.PS_SpouseDocumentNumber__c;
        additionalInsuredAccount.PS_validationPGA__c = ACCCOUNTVALIDATIONVALUE;
        additionalInsuredAccount.PS_PersonCodeRRGG__c = CONTACTMANAGERCODE;
        additionalInsuredAccount.PersonBirthdate = requestAdditionalAccount.PS_SpouseBirthdate__c;
        return additionalInsuredAccount;
    }
    /**
    * @description Mapea los datos para crear una cuenta
    * @author luis.susaya@softtek.com
    * @param requestContratorAccount Datos de la solicitud de emisión
    * @return Account datos de la cuenta
    **/
    public static Account createContractorAccountData(PS_IssuanceRequest__c requestContratorAccount) {
        Account contractorAccount = new Account();
        contractorAccount.PS_PersonCodeBDG__c = requestContratorAccount.PS_ContractorPersonCodeBDG__c;
        contractorAccount.FinServ__SourceSystemId__c = requestContratorAccount.PS_ContractorUniqueIdentifier__c;
        contractorAccount.FirstName = requestContratorAccount.PS_ContractorName__c;
        contractorAccount.LastName = requestContratorAccount.PS_ContractorLastName__c;
        contractorAccount.PS_MothersLastname__pc = requestContratorAccount.PS_ContractorMotherSurname__c;
        contractorAccount.PS_IdentificationDocument__c = requestContratorAccount.PS_ContractorDocumentType__c;
        contractorAccount.PS_IdentificationDocumentNumber__c = requestContratorAccount.PS_ContractorDocumentNumber__c;
        contractorAccount.PS_validationPGA__c = ACCCOUNTVALIDATIONVALUE;
        contractorAccount.PS_PersonCodeRRGG__c = CONTACTMANAGERCODE;
        contractorAccount.PersonBirthdate = requestContratorAccount.PS_ContractorBirthdate__c;
        contractorAccount.FinServ__Gender__pc = requestContratorAccount.PS_ContractorGender__c;
        contractorAccount.FinServ__MaritalStatus__pc = requestContratorAccount.PS_ContractorMaritalStatus__c;
        contractorAccount.PS_CountryProperty__c = requestContratorAccount.PS_ContractorCountry__c;
        contractorAccount.BillingStreet = requestContratorAccount.PS_ContractorAddress__c;
        contractorAccount.vlocity_ins__Email__c = requestContratorAccount.PS_ContractorEmail__c;
        contractorAccount.PS_Nationality__c = requestContratorAccount.PS_ContractorNationality__c;
        return contractorAccount;
    }
    /**
    * @description Mapea los datos para crear una póliza en base al tipo de solicitud
    * @author rcruzgar@emeal.nttdata.com
    * @param requestPolicy Datos de la solicitud de emisión
    * @param wrapperClass Identificador de la cuenta
    * @return InsurancePolicy datos de la póliza
    **/
    public static InsurancePolicy createPolicyData(PS_IssuanceRequest__c requestPolicy, insurancePolicyWrapper wrapperClass ) {
        InsurancePolicy insurancePolicyRecord = new InsurancePolicy();
        Account insuredAccount = new Account(FinServ__SourceSystemId__c = wrapperClass.accountId);
        Account contractorAccId = new Account(FinServ__SourceSystemId__c = wrapperClass.contractorId);
        Map<String, Object> productAtt = new Map<String, Object>();
        Time timeEffectiveDate = Time.newInstance(00, 00, 00, 00);
        Time timeExpirationDate = Time.newInstance(23, 59, 59, 59);
        if (!String.isBlank(requestPolicy.PS_ProductId__r.vlocity_ins__AttributeDefaultValues__c)) {
            productAtt = (Map<String, Object>)JSON.deserializeUntyped(requestPolicy.PS_ProductId__r.vlocity_ins__AttributeDefaultValues__c);
        }
        insurancePolicyRecord.NameInsured = insuredAccount;
        insurancePolicyRecord.SourceSystemIdentifier = PS_CustomFunctions.generateUuid();
        insurancePolicyRecord.ProductId = requestPolicy.PS_ProductId__c;
        insurancePolicyRecord.PolicyName = requestPolicy.PS_ProductName__c;
        insurancePolicyRecord.Name = wrapperClass.policyNum;
        insurancePolicyRecord.PS_ApplicationNumber__c = wrapperClass.requestNum;
        insurancePolicyRecord.PS_IssuanceHeaderTransactionId__c = insurancePolicyRecord.SourceSystemIdentifier;
        insurancePolicyRecord.PS_IssuanceHeaderAppName__c = APPLICATIONNAME;
        insurancePolicyRecord.PS_IssuanceHeaderThirdPartyApp__c = APPLICATIONNAME;
        insurancePolicyRecord.PS_IssuanceHeaderUser__c = CREATIONUSER;
        insurancePolicyRecord.ProducerId = requestPolicy.PS_ProducerId__c;
        insurancePolicyRecord.IntermediaryAccountId = requestPolicy.PS_IntermediaryAccountId__c;
        insurancePolicyRecord.PS_OperationNumber__c = requestPolicy.PS_OperationNumber__c;
        insurancePolicyRecord.PS_Currency__c = requestPolicy.PS_Currency__c;
        insurancePolicyRecord.EffectiveDate = DateTime.newInstance(requestPolicy.PS_EffectiveDate__c, timeEffectiveDate);
        insurancePolicyRecord.ExpirationDate = DateTime.newInstance(requestPolicy.PS_ExpirationDate__c, timeExpirationDate);
        insurancePolicyRecord.PS_SubSalesChannel__c = requestPolicy.PS_SalesSubchannel__c;
        insurancePolicyRecord.PS_OperationAmount__c = requestPolicy.PS_OperationAmount__c;
        insurancePolicyRecord.PS_TotalDebtAmount__c = requestPolicy.PS_TotalDebtAmount__c;
        insurancePolicyRecord.PS_MigratedPolicy__c = requestPolicy.PS_MigratedPolicy__c;
        insurancePolicyRecord.PS_ProductFamilyCreditLifeIns__c = requestPolicy.PS_ProductFamily__c;
        insurancePolicyRecord.PS_ProductTypeCreditLifeIns__c = requestPolicy.PS_ProductType__c;
        insurancePolicyRecord.PS_DisbursementDate__c = requestPolicy.PS_DisbursementDate__c;
        insurancePolicyRecord.PS_PlanTypeCreditLifeIns__c = requestPolicy.PS_PlanType__c;
        insurancePolicyRecord.PS_InsuranceRateCreditLifeIns__c = requestPolicy.PS_InsuranceRate__c;
        insurancePolicyRecord.PS_InsuranceIsActiveCreditLifeIns__c = requestPolicy.PS_InsuranceIsActive__c;
        insurancePolicyRecord.PS_InsuranceType__c = requestPolicy.PS_InsuranceType__c;
        insurancePolicyRecord.PS_CreditTerm__c = requestPolicy.PS_CreditTerm__c;
        insurancePolicyRecord.PS_ElectronicPolicyConsent__c = requestPolicy.PS_ElectronicConsent__c;
        insurancePolicyRecord.PS_ReserveRate__c = requestPolicy.PS_ReserveRate__c;
        insurancePolicyRecord.OriginalEffectiveDate = insurancePolicyRecord.EffectiveDate;
        insurancePolicyRecord.PremiumFrequency = requestPolicy.PS_ProductId__r.PS_PaymentFrequency__c;
        insurancePolicyRecord.PolicyTerm = requestPolicy.PS_ProductId__r.vlocity_ins__Term__c;
        insurancePolicyRecord.CurrencyIsoCode = requestPolicy.PS_ProductId__r.CurrencyIsoCode;
        insurancePolicyRecord.PS_ContractorActivity__c = requestPolicy.PS_ContractorActivity__c;
        insurancePolicyRecord.PS_PersonType__c = PERSONTYPE;
        insurancePolicyRecord.vlocity_ins_fsc__AttributesSelectedValues__c = requestPolicy.PS_ProductId__r.vlocity_ins__AttributeDefaultValues__c;
        insurancePolicyRecord.Status = requestPolicy.PS_ProductId__r.PS_StatusOfEmission__c;
        insurancePolicyRecord.PS_OperationCode__c = wrapperClass.operationNum;
        insurancePolicyRecord.PS_IssuanceRequestType__c = requestPolicy.PS_IssuanceRequestType__c;
        insurancePolicyRecord.PS_DANAServiceResponse__c = requestPolicy.PS_ProductId__r.vlocity_ins__ParentClassId__r.PS_DanaServiceAPI__c;
        insurancePolicyRecord.PS_PolicyCommissionPercentage__c = wrapperClass.commPercentage;
        insurancePolicyRecord.StandardPremiumAmount = wrapperClass.premiumAmount.setScale(2);
        insurancePolicyRecord.StandardFeeAmount = wrapperClass.feeAmount.setScale(2);
        insurancePolicyRecord.StandardTaxAmount = wrapperClass.taxAmount.setScale(2);
        insurancePolicyRecord.PS_EntityCollection__c = requestPolicy.PS_ProductId__r.PS_EntityCollection__c;
        insurancePolicyRecord.PS_PaymentModeCollections__c = productAtt.containsKey('PI_PaymentMode') ? String.valueOf(productAtt.get('PI_PaymentMode')) : DEFAULTACCOUNTTYPEPT;
        insurancePolicyRecord.PS_AccountType__c = requestPolicy.PS_AccountType__c ?? DEFAULTACCOUNTTYPEPT;
        insurancePolicyRecord.PS_AccountNumber__c = requestPolicy.PS_AccountNumber__c;
        insurancePolicyRecord.RenewalDate = requestPolicy.PS_RenewalDate__c;
        insurancePolicyRecord.SaleDate = requestPolicy.PS_SalesDate__c != null
            ? DateTime.newInstance(requestPolicy.PS_SalesDate__c, timeEffectiveDate)
            : null;
        if (requestPolicy.PS_IssuanceRequestType__c == REQUESTTYPECL || requestPolicy.PS_IssuanceRequestType__c == REQUESTTYPEFINANCIALPROTECTION || requestPolicy.PS_IssuanceRequestType__c == REQUESTTYPEFINANCIALPROTECTIONMB || requestPolicy.PS_IssuanceRequestType__c == REQUESTTYPEUNEMPLOYMENT) { //nk 9833-6
            if(requestPolicy.PS_IssuanceRequestType__c == REQUESTTYPEFINANCIALPROTECTION || requestPolicy.PS_IssuanceRequestType__c == REQUESTTYPEUNEMPLOYMENT){
                insurancePolicyRecord.PS_AccountNumber__c = ACCOUNTNUMBERWITHOUTACCOUNTHPT;
            }else{
                insurancePolicyRecord.PS_AccountNumber__c = null;
            }
            insurancePolicyRecord.SaleDate = DateTime.newInstance(requestPolicy.PS_EffectiveDate__c, timeEffectiveDate);
            insurancePolicyRecord.PS_NewCreditLifeIns__c = true;
            insurancePolicyRecord.PS_NewIssuanceCreditLife__c = requestPolicy.PS_MigratedPolicy__c == false ? 'S' : 'N';
            insurancePolicyRecord.PS_PaymentMode__c = 'P';
            insurancePolicyRecord.PS_AccountType__c = DEFAULTACCOUNTTYPEPT;
            insurancePolicyRecord.PS_ProductTypeCreditLifeIns__c = requestPolicy.PS_ProductType__c;
        } else if (requestPolicy.PS_IssuanceRequestType__c == REQUESTTYPEPROTECTEDFAMILY) {
            insurancePolicyRecord.PS_AccountNumber__c = requestPolicy.PS_IssuanceRequestType__c == REQUESTTYPEPROTECTEDFAMILY ? ACCOUNTNUMBERWITHOUTACCOUNTHPT : null;
            insurancePolicyRecord.SaleDate = DateTime.newInstance(requestPolicy.PS_EffectiveDate__c, timeEffectiveDate);
            insurancePolicyRecord.PS_NewCreditLifeIns__c = true;
            insurancePolicyRecord.PS_NewIssuanceCreditLife__c = requestPolicy.PS_MigratedPolicy__c == false ? 'S' : 'N';
            insurancePolicyRecord.PS_PaymentMode__c = 'P';
            insurancePolicyRecord.PS_AccountType__c = DEFAULTACCOUNTTYPEPT;
            insurancePolicyRecord.PS_ProductTypeCreditLifeIns__c = requestPolicy.PS_ProductType__c;
            insurancePolicyRecord.RenewalDate = insurancePolicyRecord.ExpirationDate;
        
        } else if (requestPolicy.PS_IssuanceRequestType__c == REQUESTTYPEPT)   {
            insurancePolicyRecord.PS_AccountType__c = requestPolicy.PS_AccountType__c;
            insurancePolicyRecord.PS_AccountNumber__c = ACCOUNTNUMBERWITHOUTACCOUNTHPT;
            insurancePolicyRecord.SaleDate = DateTime.newInstance(requestPolicy.PS_SalesDate__c, timeEffectiveDate);
            insurancePolicyRecord.PS_PersonalDataProtection__c = requestPolicy.PS_PersonalDataProtection__c;
            if (requestPolicy.PS_ProductId__r.vlocity_ins__ParentClassCode__c == '934') {
                if (requestPolicy.PS_ProductCode__c == '9341') {
                    insurancePolicyRecord.RenewalDate = requestPolicy.PS_RenewalDate__c.addYears(1);
                } else  {
                    insurancePolicyRecord.RenewalDate = requestPolicy.PS_RenewalDate__c.addMonths(1);
                }
            } else  {
                insurancePolicyRecord.RenewalDate = requestPolicy.PS_RenewalDate__c;
            }
        } else if (requestPolicy.PS_IssuanceRequestType__c == REQUESTTYPECESANTIA || requestPolicy.PS_IssuanceRequestType__c == REQUESTTYPEVIDAFLEX)   {
            insurancePolicyRecord.PS_FirstCharge__c = true;
            insurancePolicyRecord.PS_AccountType__c = DEFAULTACCOUNTTYPEVF;
            insurancePolicyRecord.PS_GoodRate__c = requestPolicy.PS_InsuranceRate__c;
            insurancePolicyRecord.PS_LoanAmount__c = requestPolicy.PS_TotalDebtAmount__c;
            if (requestPolicy.PS_ProductId__r.vlocity_ins__ParentClassCode__c == '952') {
                insurancePolicyRecord.PS_PremiumCalculated__c = requestPolicy.PS_TotalDebtAmount__c*VALVIDAFLEX;
            } else {
                insurancePolicyRecord.PS_PremiumCalculated__c = requestPolicy.PS_TotalDebtAmount__c*VALCESANTIA;
            }
            insurancePolicyRecord.SaleDate = DateTime.newInstance(requestPolicy.PS_EffectiveDate__c, timeEffectiveDate);
            insurancePolicyRecord.PS_AccountNumber__c = requestPolicy.PS_AccountNumber__c;
            insurancePolicyRecord.StandardFeeAmount = 0;
            insurancePolicyRecord.RenewalDate = DateTime.newInstance(requestPolicy.PS_ExpirationDate__c.addDays(1), timeEffectiveDate);
            insurancePolicyRecord.PS_PersonalDataProtection__c = requestPolicy.PS_PersonalDataProtection__c;
        } else if (requestPolicy.PS_IssuanceRequestType__c == REQUESTTYPEHIPOTECARIO)    {
            insurancePolicyRecord.PS_OriginalPolicyMigratedNumber__c  = requestPolicy.PS_PolicyNumberGW__c ;
            insurancePolicyRecord.PS_IsMultibranch__c = true;
            insurancePolicyRecord.PS_LoanAmount__c = requestPolicy.PS_OperationAmount__c;
            insurancePolicyRecord.PS_Mortgage__c = True;
            insurancePolicyRecord.TotalSumInsured = requestPolicy.PS_SumInsuredBuilding__c;
            List<Object> argumentListSch = new List<Object>();
            String dateTimeString = String.valueOf(requestPolicy.PS_EffectiveDate__c);
            String dateString = dateTimeString.split(' ')[0];
            argumentListSch.add(dateString);
            insurancePolicyRecord.ExpirationDate = PS_CustomFunctions.getNextExpirationDate(argumentListSch);
            insurancePolicyRecord.RenewalDate = insurancePolicyRecord.ExpirationDate;
            insurancePolicyRecord.PS_AccountNumber__c = ACCOUNTNUMBERWITHOUTACCOUNTHPT;
            insurancePolicyRecord.SaleDate = DateTime.newInstance(requestPolicy.PS_SalesDate__c, timeEffectiveDate);
            insurancePolicyRecord.Status = requestPolicy.PS_ProductId__r.vlocity_ins__ParentClassId__r.PS_StatusOfEmission__c;
            insurancePolicyRecord.PS_ProductTypeGW__c = requestPolicy.PS_ProductType__c;
            insurancePolicyRecord.PS_EmailCorrespondence__c = requestPolicy.PS_EmailCorrespondence__c;
            insurancePolicyRecord.PS_DeliveryMethod__c = requestPolicy.PS_DeliveryMethod__c;
            insurancePolicyRecord.PS_PolicyTermType__c = requestPolicy.PS_PolicyTermType__c;
            insurancePolicyRecord.PS_CurrencySumAssured__c = requestPolicy.PS_CurrencySumAssured__c;
            insurancePolicyRecord.PS_ReferenceDateRate__c = requestPolicy.PS_ReferenceDateRate__c;
            insurancePolicyRecord.PS_ReferenceDateCoverage__c = requestPolicy.PS_ReferenceDateCoverage__c;
            insurancePolicyRecord.PS_PremiumPaymentMethod__c = requestPolicy.PS_PremiumPaymentMethod__c;
            insurancePolicyRecord.PS_AxelRenewalIndicator__c = requestPolicy.PS_AxelRenewalIndicator__c;
            insurancePolicyRecord.PS_NumberAcselRenewals__c = requestPolicy.PS_NumberAcselRenewals__c;
            insurancePolicyRecord.PS_AcselIssueDate__c = requestPolicy.PS_AcselIssueDate__c;
            insurancePolicyRecord.PS_AcselxPolicyNumber__c = requestPolicy.PS_AcselxPolicyNumber__c;
            insurancePolicyRecord.PS_ProducerIndicator__c = requestPolicy.PS_ProducerIndicator__c;
            insurancePolicyRecord.PS_Channel__c = requestPolicy.PS_Channel__c;
            insurancePolicyRecord.PS_Agent__c = requestPolicy.PS_Agent__c;
            insurancePolicyRecord.PS_WarrantyNumber__c = requestPolicy.PS_WarrantyNumber__c;
            insurancePolicyRecord.PS_ApplicationDate__c = requestPolicy.PS_ApplicationDate__c;
            insurancePolicyRecord.PS_GrouperCode__c = requestPolicy.PS_GrouperCode__c;
            insurancePolicyRecord.PS_FixedPremiumIndicator__c = requestPolicy.PS_FixedPremiumIndicator__c;
            insurancePolicyRecord.PS_PaymentPlan__c = requestPolicy.PS_PaymentPlan__c;
            insurancePolicyRecord.PS_QuoteOrIssueIndicator__c = requestPolicy.PS_QuoteOrIssueIndicator__c;
            insurancePolicyRecord.PS_TypeMortgageOperation__c = requestPolicy.PS_TypeMortgageOperation__c != null ? requestPolicy.PS_TypeMortgageOperation__c : '';
            insurancePolicyRecord.PS_ExternalSellerCode__c = requestPolicy.PS_ExternalSellerCode__c;
            insurancePolicyRecord.PS_OperationAmount__c = requestPolicy.PS_OperationAmount__c;
            insurancePolicyRecord.PS_CreditNumber__c = requestPolicy.PS_CreditNumber__c;
            insurancePolicyRecord.PS_CreditType__c = requestPolicy.PS_CreditType__c;
            insurancePolicyRecord.PS_CreditStartDate__c = requestPolicy.PS_CreditStartDate__c;
            insurancePolicyRecord.PS_CreditEndDate__c = requestPolicy.PS_CreditEndDate__c;
            insurancePolicyRecord.PS_SalesCode__c = requestPolicy.PS_SalesCode__c;
            insurancePolicyRecord.PS_AcselxChannelCode__c = requestPolicy.PS_AcselxChannelCode__c;
        } else if (requestPolicy.PS_IssuanceRequestType__c == REQUESTTYPESA || requestPolicy.PS_IssuanceRequestType__c == REQUESTTYPEEL)    {
            insurancePolicyRecord.PS_BeneficiaryType__c = requestPolicy.PS_BeneficiaryType__c;
            insurancePolicyRecord.PS_Nemo__c = requestPolicy.PS_Nemo__c;
            insurancePolicyRecord.PS_InsuredPlan__c = requestPolicy.PS_InsuredPlan__c;
            insurancePolicyRecord.PS_PersonalDataProtection__c = requestPolicy.PS_PersonalDataProtection__c;
            insurancePolicyRecord.PS_HasContractor__c = true;
            insurancePolicyRecord.PS_Height__c = requestPolicy.PS_Height__c;
            insurancePolicyRecord.PS_Weight__c = requestPolicy.PS_Weight__c;
            insurancePolicyRecord.PS_IMC__c = requestPolicy.PS_IMC__c;
            if (requestPolicy.PS_ProductId__r.vlocity_ins__ParentClassCode__c == '980') {
                insurancePolicyRecord.PS_AccountNumber__c = ACCOUNTNUMBERWITHOUTACCOUNTHPT;
            }
            if (requestPolicy.PS_ProductId__r.vlocity_ins__ParentClassCode__c == '975'||requestPolicy.PS_ProductId__r.vlocity_ins__ParentClassCode__c == '976') {
                insurancePolicyRecord.PS_FirstCharge__c = true;
            }
            if (requestPolicy.PS_ContractorAccountId__c != null) {
                insurancePolicyRecord.WritingCarrierAccountId = requestPolicy.PS_ContractorAccountId__c;
            } else   {
                insurancePolicyRecord.WritingCarrierAccount = contractorAccId;
            }
        } else if (requestPolicy.PS_IssuanceRequestType__c == REQUESTTYPEINDEMNIZATORIO)    {
            insurancePolicyRecord.PS_IsPendingToAffiliate__c = true;
            if (requestPolicy.PS_ProductCode__c == '9543') {
                insurancePolicyRecord.PS_BeneficiaryType__c = 'Herederos legales';
            }
        }
        return insurancePolicyRecord;
    }
    /**
    * @description Mapea los datos para crear un registro de solicitud de cobranza
    * @author jaclderr@emeal.nttdata.com
    * @param insurancePolicy Datos de la solicitud de póliza success
    * @return PS_CreatePaymentEntrySchedule_bch datos de solicitud de cobranza
    **/
    public static PS_PaymentRequest__c createPaymentRequest(InsurancePolicy insurancePolicy) {
        PS_PaymentRequest__c paymentRequestRecord = new PS_PaymentRequest__c();
        Time timeEffectiveDate = Time.newInstance(00, 00, 00, 00);
        Time timeExpirationDate = Time.newInstance(23, 59, 59, 59);
        Date policyRenewalDate = insurancePolicy.RenewalDate.date();
        Date policyEffectiveDate = insurancePolicy.EffectiveDate.date();
        Date updatedEffectiveExpirationDateMonthly = policyEffectiveDate.addMonths(1).addDays(-1);
        Date updatedEffectiveExpirationDateAnnually = policyEffectiveDate.addYears(1).addDays(-1);
        Date updatedRenewalExpirationDate = policyRenewalDate.addMonths(1).addDays(-1);
        paymentRequestRecord.PS_MonthlyPremium__c = insurancePolicy.StandardPremiumAmount;
        paymentRequestRecord.PS_StandardTaxAmount__c = insurancePolicy.StandardTaxAmount;
        paymentRequestRecord.PS_StandardFeeAmount__c = insurancePolicy.StandardFeeAmount;
        paymentRequestRecord.PS_PolicyOperationNumber__c = insurancePolicy.PS_OperationNumber__c;
        paymentRequestRecord.PS_ProcessedFlag__c = ISSUANCEREQUESTSTATUS;
        paymentRequestRecord.PS_EffectiveDate__c = policyEffectiveDate;
        if (insurancePolicy.PremiumFrequency == 'Annually') {
            paymentRequestRecord.PS_ExpirationDate__c = updatedEffectiveExpirationDateAnnually;
        } else if (insurancePolicy.PremiumFrequency == 'Unique')    {
            paymentRequestRecord.PS_ExpirationDate__c = policyRenewalDate.addDays(-1);
        } else if (insurancePolicy.PremiumFrequency == 'Monthly' && insurancePolicy.Product.PS_RenewalType__c == 'Mixto')    {
            paymentRequestRecord.PS_ExpirationDate__c = updatedRenewalExpirationDate;
        } else  {
            // Entra solo planes mensuales con frecuencia Normal
            paymentRequestRecord.PS_ExpirationDate__c = updatedEffectiveExpirationDateMonthly;
        }
        return paymentRequestRecord;
    }
    
    /**
    * @description Mapea los datos para crear un registro de solicitud de cobranza
    * @author rcruzgar@nttdata.com
    * @param insurancePolicy Datos de la solicitud de póliza success
    * @return PS_CreatePaymentEntrySchedule_bch datos de solicitud de cobranza
    **/
    public static PS_PaymentRequest__c createPaymentRequestRecord(InsurancePolicy insurancePolicy) {
        PS_PaymentRequest__c paymentRequestRecord = new PS_PaymentRequest__c();
        Time timeEffectiveDate = Time.newInstance(00, 00, 00, 00);
        Time timeExpirationDate = Time.newInstance(23, 59, 59, 59);
        Date policyRenewalDate = insurancePolicy.RenewalDate.date();
        Date policyEffectiveDate = insurancePolicy.EffectiveDate.date();
        Date updatedEffectiveExpirationDateMonthly = policyEffectiveDate.addMonths(1).addDays(-1);
        Date updatedEffectiveExpirationDateAnnually = policyEffectiveDate.addYears(1).addDays(-1);
        Date updatedRenewalExpirationDate = policyRenewalDate.addMonths(1).addDays(-1);
        paymentRequestRecord.PS_MonthlyPremium__c = insurancePolicy.StandardPremiumAmount;
        paymentRequestRecord.PS_StandardTaxAmount__c = insurancePolicy.StandardTaxAmount;
        paymentRequestRecord.PS_StandardFeeAmount__c = insurancePolicy.StandardFeeAmount;
        paymentRequestRecord.PS_PolicyOperationNumber__c = insurancePolicy.PS_OperationNumber__c;
        paymentRequestRecord.PS_ProcessedFlag__c = ISSUANCEREQUESTSTATUS;
        paymentRequestRecord.PS_EffectiveDate__c = policyEffectiveDate;
        if (insurancePolicy.PremiumFrequency == 'Annually') {
            paymentRequestRecord.PS_ExpirationDate__c = updatedEffectiveExpirationDateAnnually;
        } else if (insurancePolicy.PremiumFrequency == 'Unique')    {
            paymentRequestRecord.PS_ExpirationDate__c = policyRenewalDate;
        } else if (insurancePolicy.PremiumFrequency == 'Monthly' && insurancePolicy.Product.PS_RenewalType__c == 'Mixto')    {
            paymentRequestRecord.PS_ExpirationDate__c = updatedRenewalExpirationDate;
        } else  {
            // Entra solo planes mensuales con frecuencia Normal
            paymentRequestRecord.PS_ExpirationDate__c = updatedEffectiveExpirationDateMonthly;
        }
        return paymentRequestRecord;
    }
    
    /**
    * @description Mapea los datos para crear 12 registros de solicitud de cobranza para Hipotecario
    * @author jaclderr@emeal.nttdata.com
    * @param insurancePolicy Datos de la solicitud de póliza success
    * @return PS_CreatePaymentEntrySchedule_bch datos de solicitud de cobranza
    **/
    public static void createPaymentRequestHipotecario(InsurancePolicy insurancePolicy, List<PS_PaymentRequest__c> paymentRequestInsertList) {
        // Registro base con valores comunes
        PS_PaymentRequest__c basePaymentRequest = new PS_PaymentRequest__c(
            PS_MonthlyPremium__c = (insurancePolicy.StandardPremiumAmount/12).setScale(2),
            PS_StandardTaxAmount__c = (insurancePolicy.StandardTaxAmount/12).setScale(2),
            PS_StandardFeeAmount__c = (insurancePolicy.StandardFeeAmount/12).setScale(2),
            PS_PolicyOperationNumber__c = insurancePolicy.PS_OperationNumber__c,
            PS_ProcessedFlag__c = ISSUANCEREQUESTSTATUS
            );
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('EffectiveDate', insurancePolicy.EffectiveDate);
        inputMap.put('ExpirationDate', insurancePolicy.ExpirationDate);
        List<Map<String, DateTime>> getMonthsToRenew = getMonthsToRenew(inputMap);
        
        for (Map<String, Datetime> monthMap : getMonthsToRenew) {
            PS_PaymentRequest__c paymentRequestRecord = basePaymentRequest.clone();
            Datetime effectiveDate = Datetime.valueOf(String.valueOf(monthMap.get('EffectiveDate')));//(Datetime)inputMap.get('expirationDate');//inicio
            Datetime expirationDate = Datetime.valueOf(String.valueOf(monthMap.get('ExpirationDate')));//(Datetime)inputMap.get('reinstatementDate');//fin
            paymentRequestRecord.PS_EffectiveDate__c = effectiveDate.date();
            paymentRequestRecord.PS_ExpirationDate__c = expirationDate.date();
            paymentRequestInsertList.add(paymentRequestRecord);
        }
        //return listPaymentRequestResponse;
    }
    
    /**
    * @description Mapea los datos para crear tantos registros de solicitud de cobro como meses pendientes existan
    * @author rcruzgar@emeal.nttdata.com
    * @param insurancePolicy Datos de la solicitud de póliza success
    * @return PS_CreatePaymentEntrySchedule_bch datos de solicitud de cobranza
    **/
    public static void createPaymentRequestMonthly(InsurancePolicy insurancePolicy, List<PS_PaymentRequest__c> paymentRequestInsertList) {
        // Registro base con valores comunes
        PS_PaymentRequest__c basePaymentRequest = new PS_PaymentRequest__c(
            PS_MonthlyPremium__c = (insurancePolicy.StandardPremiumAmount/insurancePolicy.PS_CreditTerm__c).setScale(2),
            PS_StandardTaxAmount__c = (insurancePolicy.StandardTaxAmount/insurancePolicy.PS_CreditTerm__c).setScale(2),
            PS_StandardFeeAmount__c = (insurancePolicy.StandardFeeAmount/insurancePolicy.PS_CreditTerm__c).setScale(2),
            PS_PolicyOperationNumber__c = insurancePolicy.PS_OperationNumber__c,
            PS_DebtAmount__c = insurancePolicy.PS_TotalDebtAmount__c,
            PS_ProcessedFlag__c = ISSUANCEREQUESTSTATUS
            );
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('EffectiveDate', insurancePolicy.EffectiveDate);
        inputMap.put('ExpirationDate', insurancePolicy.ExpirationDate);
        List<Map<String, DateTime>> getMonthsToRenew = getMonthsToRenew(inputMap);
		Integer entryCount = 1;
        for (Map<String, Datetime> monthMap : getMonthsToRenew) {
            PS_PaymentRequest__c paymentRequestRecord = basePaymentRequest.clone();
            Datetime effectiveDate = Datetime.valueOf(String.valueOf(monthMap.get('EffectiveDate')));
            Datetime expirationDate = Datetime.valueOf(String.valueOf(monthMap.get('ExpirationDate')));
            paymentRequestRecord.PS_EffectiveDate__c = effectiveDate.date();
            paymentRequestRecord.PS_ExpirationDate__c = expirationDate.date();
            paymentRequestInsertList.add(paymentRequestRecord);
            entryCount ++;
        }
    }


    //nk 
    public static void createPaymentRequestMonthlyUnenployment(InsurancePolicy insurancePolicy, List<PS_PaymentRequest__c> paymentRequestInsertList) {
        // Registro base con valores comunes
        PS_PaymentRequest__c basePaymentRequest = new PS_PaymentRequest__c(
            PS_MonthlyPremium__c        = insurancePolicy.StandardPremiumAmount,
            PS_StandardTaxAmount__c     = insurancePolicy.StandardTaxAmount,
            PS_StandardFeeAmount__c     = insurancePolicy.StandardFeeAmount,
            PS_PolicyOperationNumber__c = insurancePolicy.PS_OperationNumber__c,
            PS_DebtAmount__c            = insurancePolicy.PS_TotalDebtAmount__c,
            PS_ProcessedFlag__c         = ISSUANCEREQUESTSTATUS
            );
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('EffectiveDate', insurancePolicy.EffectiveDate);
        inputMap.put('ExpirationDate', insurancePolicy.ExpirationDate);
        List<Map<String, DateTime>> getMonthsToRenew = getMonthsToRenew(inputMap);
		Integer entryCount = 1;
        for (Map<String, Datetime> monthMap : getMonthsToRenew) {
            PS_PaymentRequest__c paymentRequestRecord = basePaymentRequest.clone();
            Datetime effectiveDate = Datetime.valueOf(String.valueOf(monthMap.get('EffectiveDate')));
            Datetime expirationDate = Datetime.valueOf(String.valueOf(monthMap.get('ExpirationDate')));
            paymentRequestRecord.PS_EffectiveDate__c = effectiveDate.date();
            paymentRequestRecord.PS_ExpirationDate__c = expirationDate.date();
            paymentRequestInsertList.add(paymentRequestRecord);
            entryCount ++;
        }
    }


    /**
    * @description método que obtiene los meses para renovar
    * @param inputMap
    * @param outMap
    * @param options
    **/
    public static List<Map<String, DateTime>> getMonthsToRenew(Map<String, Object> inputMap) {
        Datetime effectiveDate = Datetime.valueOf(String.valueOf(inputMap.get('EffectiveDate')).replace('T', ' '));//(Datetime)inputMap.get('expirationDate');//inicio
        Datetime expirationDate = Datetime.valueOf(String.valueOf(inputMap.get('ExpirationDate')).replace('T', ' '));//(Datetime)inputMap.get('reinstatementDate');//fin
        //Datetime effectiveDate = expirationDate;//.addDays(1);
        List<Map<String, Datetime>> monthsToRenews = new List<Map<String, Datetime>>();
        Integer counter = 1;
        while (expirationDate >= effectiveDate) {
            if (counter == 1) {
                effectiveDate = effectiveDate;
            }
            Map<String, Datetime> monthMap = new Map<String, Datetime>();
            monthMap.put('EffectiveDate', effectiveDate);
            effectiveDate = effectiveDate.addMonths(1);
            monthMap.put('ExpirationDate', effectiveDate.adddays(-1));
            monthsToRenews.add(monthMap);
            counter++;
        }
        return monthsToRenews;
    }
    /**
    * @description Mapea los datos para la creación de participantes
    * @author rcruzgar@emeal.nttdata.com
    * @param requestParticipant Datos de la solicitud de emisión
    * @param insurancePolicyId Identificador de la póliza
    * @param wrapperMap Mapa Wrapper de los valores de la prima
    * @return Map<String,Object> datos a procesar por clase auxiliar de participantes
    **/
    public static Map<String, Object> generateInsuredParticipantData(PS_IssuanceRequest__c requestParticipant, String insurancePolicyId, insurancePolicyWrapper wrapperMap) {
        Map<String, Object> participant = new Map<String, Object>();
        String motherSurname = requestParticipant.PS_MotherSurname__c != null && !String.isBlank(requestParticipant.PS_MotherSurname__c) ? requestParticipant.PS_MotherSurname__c : '';
        String participantIdentifier = requestParticipant.PS_ClientName__c + ' ' + requestParticipant.PS_LastName__c + ' ' + motherSurname + ' ' + requestParticipant.PS_DocumentNumber__c;
        participant.put(PARTICIPANTNAME, requestParticipant.PS_ClientName__c);
        participant.put(PARTICIPANTLASTNAME, requestParticipant.PS_LastName__c);
        participant.put(PARTICIPANTMOTHERSURNAME, requestParticipant.PS_MotherSurname__c);
        participant.put(PARTICIPANTINSTANCEKEY, participantIdentifier);
        participant.put(PARTICIPANTDOCUMENTTYPE, requestParticipant.PS_DocumentType__c);
        participant.put(PARTICIPANTDOCUMENTNUMBER, requestParticipant.PS_DocumentNumber__c);
        participant.put(PARTICIPANTROLE, INSUREDROLE);
        participant.put(PARTICIPANTPOLICYID, insurancePolicyId);
        participant.put(PARTICIPANTACCOUNTID, requestParticipant.PS_InsuredUniqueIdentifier__c);
        participant.put(PARTICIPANTPRODUCTCODE, requestParticipant.PS_ProductCode__c);
        participant.put(PARTICIPANTINSUREDFORMAT, requestParticipant.PS_InsuredAttributesFormat__c);
        participant.put(PREMIUMFIELDNAME, wrapperMap.premiumAmount);
        participant.put(TAXFIELDNAME, wrapperMap.taxAmount);
        participant.put(FEEFIELDNAME, wrapperMap.feeAmount);
        participant.put(SOURCESYSTEMIDENTIFIER, PS_CustomFunctions.generateUuid());
        return participant;
    }
    /**
      * @description Mapea los datos para la creación de participantes Asegurado Hipotecario
      * @author jcalderr@emeal.nttdata.com
      * @param requestParticipant Datos de la solicitud de emisión
      * @param insurancePolicyId Identificador de la póliza
      * @param wrapperMap Mapa Wrapper de los valores de la prima
      * @return Map<String,Object> datos a procesar por clase auxiliar de participantes
      **/
    public static Map<String, Object> generateMortgageInsuredParticipantData(PS_IssuanceRequest__c requestParticipant, String insurancePolicyId, insurancePolicyWrapper wrapperMap) {
        Map<String, Object> participant = new Map<String, Object>();
        String participantIdentifier = requestParticipant.PS_ClientName__c + ' ' + requestParticipant.PS_LastName__c + ' ' + requestParticipant.PS_MotherSurname__c + ' ' + requestParticipant.PS_DocumentNumber__c;
        participant.put('PS_FirstName__c', requestParticipant.PS_ClientName__c);
        participant.put('PS_LastName__c', requestParticipant.PS_LastName__c);
        participant.put('PS_MotherLastName__c', requestParticipant.PS_MotherSurname__c);
        participant.put(PARTICIPANTINSTANCEKEY, participantIdentifier);
        participant.put(PARTICIPANTDOCUMENTTYPE, requestParticipant.PS_DocumentType__c);
        participant.put('PS_DocumentNumber__c', requestParticipant.PS_DocumentNumber__c);
        participant.put('PS_IdentificationDocumentNumber__c', requestParticipant.PS_DocumentNumber__c);
        participant.put(PARTICIPANTROLE, MORTGAGEINSURED);
        participant.put(PARTICIPANTPOLICYID, insurancePolicyId);
        participant.put(PARTICIPANTACCOUNTID, requestParticipant.PS_InsuredUniqueIdentifier__c);
        participant.put(PARTICIPANTPRODUCTCODE, requestParticipant.PS_ProductCode__c);//9401
        for (String customField : FIELDSKEYMORTGAGEINSURED) {
            participant.put(customField, requestParticipant.get(customField));
        }
        participant.put(PREMIUMFIELDNAME, wrapperMap.premiumAmount);
        participant.put(TAXFIELDNAME, wrapperMap.taxAmount);
        participant.put(FEEFIELDNAME, wrapperMap.feeAmount);
        participant.put(SOURCESYSTEMIDENTIFIER, PS_CustomFunctions.generateUuid());
        return participant;
    }
    /**
   * @description Mapea los datos para la creación de Asset
   * @author jcalderr@emeal.nttdata.com
   * @param requestParticipant Datos de la solicitud de emisión
   * @param insurancePolicyId Identificador de la póliza
   * @param wrapperMap Mapa Wrapper de los valores de la prima
   * @return Map<String,Object> datos a procesar por clase auxiliar de participantes
   **/
    public static Map<String, Object> generatePropertyData(PS_IssuanceRequest__c request, String insurancePolicyId, insurancePolicyWrapper wrapperMap, InsurancePolicyAsset itemAsset) {
        Map<String, Object> property = new Map<String, Object>();
        property.put(PARTICIPANTPOLICYID, insurancePolicyId);
        property.put('WARRANTYNUMBER', request.PS_WarrantyNumber__c);
        property.put(PARTICIPANTROLE, PROPERTYINSURED);
        property.put(PARTICIPANTPRODUCTCODE, request.PS_ProductCode__c);//9401
        property.put(PARTICIPANTPROPERTYFORMAT, itemAsset.vlocity_ins_fsc__AttributesSelectedValues__c);
        
        property.put('ITEMASSET', itemAsset);
        property.put(PREMIUMFIELDNAME, wrapperMap.premiumAmount);
        property.put(TAXFIELDNAME, wrapperMap.taxAmount);
        property.put(FEEFIELDNAME, wrapperMap.feeAmount);
        property.put(SOURCESYSTEMIDENTIFIER, PS_CustomFunctions.generateUuid());
        return property;
    }
    /**
    * @description Mapea los datos para la creación de participantes Asegurado Hipotecario
    * @author jcalderr@emeal.nttdata.com
    * @param requestParticipant Datos de la solicitud de emisión
    * @param insurancePolicyId Identificador de la póliza
    * @param wrapperMap Mapa Wrapper de los valores de la prima
    * @return Map<String,Object> datos a procesar por clase auxiliar de participantes
    **/
    public static Map<String, Object> generateEndoseerInsuredParticipantData(PS_IssuanceRequest__c requestParticipant, String insurancePolicyId) {
        Map<String, Object> participant = new Map<String, Object>();
        String participantIdentifier = 'ENDOSATARIO';
        participant.put(PARTICIPANTNAME, 'ENDOSATARIO : ');
        participant.put(PARTICIPANTLASTNAME, ' BANCO DE CREDITO DEL PERÚ');
        participant.put(PARTICIPANTMOTHERSURNAME, '');
        participant.put(PARTICIPANTINSTANCEKEY, participantIdentifier);
        participant.put(PARTICIPANTDOCUMENTTYPE, '');
        participant.put(PARTICIPANTDOCUMENTNUMBER, '');
        participant.put(PARTICIPANTROLE, ENDOSEERINSURED);
        participant.put(PARTICIPANTPOLICYID, insurancePolicyId);
        participant.put(PARTICIPANTACCOUNTID, 'BCPCH');
        participant.put(PARTICIPANTPRODUCTCODE, requestParticipant.PS_ProductCode__c);
        participant.put('PS_PercentageSumInsured__c', requestParticipant.PS_PercentageSumInsured__c);
        participant.put('PS_TypeAssignee__c', requestParticipant.PS_TypeAssignee__c);
        participant.put('PS_AmountCollateralValue__c', requestParticipant.PS_WarrantyValue__c);
        return participant;
    }
    /**
    * @description Mapea los datos para la creación del participante adicional
    * @author rcruzgar@emeal.nttdata.com
    * @param requestAdditionalParticipant Registro PS_IssuanceRequest__c
    * @param insurancePolicyId Identificador de la póliza
    * @param wrapperMap Mapa Wrapper de los valores de la prima
    * @return Map<String,Object> datos a procesar por clase auxiliar de participantes
    **/
    public static Map<String, Object> generateAdditionalInsuredParticipantData(PS_IssuanceRequest__c requestAdditionalParticipant, String insurancePolicyId, insurancePolicyWrapper wrapperMap) {
        Map<String, Object> additionalParticipant = new Map<String, Object>();
        String motherSurname = requestAdditionalParticipant.PS_SpouseMotherSurname__c != null && !String.isBlank(requestAdditionalParticipant.PS_SpouseMotherSurname__c) ? requestAdditionalParticipant.PS_SpouseMotherSurname__c : '';
        String additionalParticipantIdentifier = requestAdditionalParticipant.PS_SpouseName__c + ' ' + requestAdditionalParticipant.PS_SpouseLastName__c + ' ' + motherSurname + ' ' + requestAdditionalParticipant.PS_SpouseDocumentNumber__c;
        additionalParticipant.put(PARTICIPANTNAME, requestAdditionalParticipant.PS_SpouseName__c);
        additionalParticipant.put(PARTICIPANTLASTNAME, requestAdditionalParticipant.PS_SpouseLastName__c);
        additionalParticipant.put(PARTICIPANTMOTHERSURNAME, requestAdditionalParticipant.PS_SpouseMotherSurname__c);
        additionalParticipant.put(PARTICIPANTINSTANCEKEY, additionalParticipantIdentifier);
        additionalParticipant.put(PARTICIPANTDOCUMENTTYPE, requestAdditionalParticipant.PS_SpouseDocumentType__c);
        additionalParticipant.put(PARTICIPANTDOCUMENTNUMBER, requestAdditionalParticipant.PS_SpouseDocumentNumber__c);
        additionalParticipant.put(PARTICIPANTROLE, ADDITIONALINSUREDROLE);
        additionalParticipant.put(PARTICIPANTRELATIONSHIP, requestAdditionalParticipant.PS_RelationshipToInsured__c);
        additionalParticipant.put(PARTICIPANTPOLICYID, insurancePolicyId);
        additionalParticipant.put(PARTICIPANTACCOUNTID, requestAdditionalParticipant.PS_AdditionalInsuredUniqueIdentifier__c);
        additionalParticipant.put(PARTICIPANTPRODUCTCODE, requestAdditionalParticipant.PS_ProductCode__c);
        additionalParticipant.put(PARTICIPANTADDINSUREDFORMAT, requestAdditionalParticipant.PS_AdditionalInsuredAttributesFormat__c);
        additionalParticipant.put(SOURCESYSTEMIDENTIFIER, PS_CustomFunctions.generateUuid());
        additionalParticipant.put(PREMIUMFIELDNAME, wrapperMap.addPremiumAmount);
        additionalParticipant.put(TAXFIELDNAME, wrapperMap.addTaxAmount);
        additionalParticipant.put(FEEFIELDNAME, wrapperMap.addFeeAmount);
        return additionalParticipant;
    }
    /**
    * @description Mapea los datos para la creación del participante adicional como contratante
    * @author luis.susaya@softtek.com
    * @param requestAdditionalParticipant Registro PS_IssuanceRequest__c
    * @param insurancePolicyId Identificador de la póliza
    * @return Map<String,Object> datos a procesar por clase auxiliar de participantes
    **/
    public static Map<String, Object> generateContractorParticipantData(PS_IssuanceRequest__c requestAdditionalParticipant, String insurancePolicyId) {
        Map<String, Object> contractorParticipant = new Map<String, Object>();
        String motherSurname = requestAdditionalParticipant.PS_ContractorMotherSurname__c != null && !String.isBlank(requestAdditionalParticipant.PS_ContractorMotherSurname__c) ? requestAdditionalParticipant.PS_ContractorMotherSurname__c : '';
        String additionalParticipantIdentifier = requestAdditionalParticipant.PS_ContractorName__c + ' ' + requestAdditionalParticipant.PS_ContractorLastName__c + ' ' + motherSurname + ' ' + requestAdditionalParticipant.PS_ContractorDocumentNumber__c;
        contractorParticipant.put(PARTICIPANTNAME, requestAdditionalParticipant.PS_ContractorName__c);
        contractorParticipant.put(PARTICIPANTLASTNAME, requestAdditionalParticipant.PS_ContractorLastName__c);
        contractorParticipant.put(PARTICIPANTMOTHERSURNAME, requestAdditionalParticipant.PS_ContractorMotherSurname__c);
        contractorParticipant.put(PARTICIPANTINSTANCEKEY, additionalParticipantIdentifier);
        contractorParticipant.put(PARTICIPANTDOCUMENTTYPE, requestAdditionalParticipant.PS_ContractorDocumentType__c);
        contractorParticipant.put(PARTICIPANTDOCUMENTNUMBER, requestAdditionalParticipant.PS_ContractorDocumentNumber__c);
        contractorParticipant.put(PARTICIPANTROLE, CONTRACTORINSUREDROLE);
        contractorParticipant.put(PARTICIPANTPOLICYID, insurancePolicyId);
        contractorParticipant.put(PARTICIPANTACCOUNTID, requestAdditionalParticipant.PS_ContractorUniqueIdentifier__c);
        contractorParticipant.put(PARTICIPANTPRODUCTCODE, requestAdditionalParticipant.PS_ProductCode__c);
        contractorParticipant.put(PARTICIPANTCONTRACTORFORMAT, requestAdditionalParticipant.PS_ContractorAttributesFormat__c);
        contractorParticipant.put(SOURCESYSTEMIDENTIFIER, PS_CustomFunctions.generateUuid());
        return contractorParticipant;
    }
    /**
    * @description Mapea los datos para la creación de beneficiarios
    * @author rcruzgar@emeal.nttdata.com
    * @param requestParticipant Datos de la solicitud de emisión
    * @param insurancePolicyId Identificador de la póliza
    * @param wrapperMap Mapa Wrapper de los valores de la prima
    * @return Map<String,Object> datos a procesar por clase auxiliar de participantes
    **/
    public static List<Map<String, Object>> generateBeneficiaryData(PS_IssuanceRequest__c request, List<PS_PolicyParticipantRequest__c> beneficiaryLst, insurancePolicyWrapper wrapperMap, String insurancePolicyId) {
        List<Map<String, Object>> beneficiaryList = new List<Map<String, Object>>();
        for (PS_PolicyParticipantRequest__c beneficiary : beneficiaryLst) {
            Map<String, Object> beneficiaryMap = new Map<String, Object>();
            String motherSurname = beneficiary.PS_MothersMaidenName__c != null && !String.isBlank(beneficiary.PS_MothersMaidenName__c) ? beneficiary.PS_MothersMaidenName__c : '';
            String participantIdentifier = beneficiary.PS_FirstName__c + ' ' + beneficiary.PS_LastName__c + ' ' + motherSurname + ' ' + beneficiary.PS_IdentificationDocumentNumber__c;
            beneficiaryMap.put(PARTICIPANTNAME, beneficiary.PS_FirstName__c);
            beneficiaryMap.put(PARTICIPANTLASTNAME, beneficiary.PS_LastName__c);
            beneficiaryMap.put(PARTICIPANTMOTHERSURNAME, beneficiary.PS_MothersMaidenName__c);
            beneficiaryMap.put(PARTICIPANTINSTANCEKEY, participantIdentifier);
            beneficiaryMap.put(PARTICIPANTDOCUMENTTYPE, beneficiary.PS_IdentificationDocumentType__c);
            beneficiaryMap.put(PARTICIPANTDOCUMENTNUMBER, beneficiary.PS_IdentificationDocumentNumber__c);
            beneficiaryMap.put(PARTICIPANTROLE, BENEFICIARYROLE);
            beneficiaryMap.put(PARTICIPANTPOLICYID, insurancePolicyId);
            beneficiaryMap.put(PARTICIPANTPRODUCTCODE, request.PS_ProductCode__c);
            beneficiaryMap.put('BeneficiarySharePercentage', beneficiary.PS_ParticipationPercentage__c);
            beneficiaryMap.put('RelationshipToInsured', beneficiary.PS_RelationshipToInsured__c);
            beneficiaryMap.put('PS_EmailAddress__c', beneficiary.PS_EmailAddress__c);
            beneficiaryMap.put('PS_Gender__c', beneficiary.PS_Gender__c);
            beneficiaryMap.put('PS_ParticipantBirthdate__c', beneficiary.PS_Birthdate__c);
            beneficiaryMap.put(SOURCESYSTEMIDENTIFIER, PS_CustomFunctions.generateUuid());
            beneficiaryList.add(beneficiaryMap);
        }
        return beneficiaryList;
    }
    /**
    * @description Mapea los datos para la creación de coberturas
    * @author rcruzgar@emeal.nttdata.com
    * @param insurancePolicyId Identificador de la póliza
    * @param insuredId Identificador de la cuenta
    * @param additionalInsuredId Identificador del asegurado adicional
    * @param productCode Código del producto
    * @param fieldsHipotecarioWrapper Fields Hipotecario
    **/
    public static void generateCoverageData(String insurancePolicyId, String insuredId, String additionalInsuredId, String productCode, fieldsHipotecarioWrapper fieldsHipotecario, fieldsVidaFlexWrapper fieldsVidaFlex, insurancePolicyWrapper policyData) {
        Map<String, Object> coverageMap = new Map<String, Object>();
        List<Map<String, Object>> policyCoverageList = new List<Map<String, Object>>();
        coverageMap.put(COVERAGEPOLICYID, insurancePolicyId);
        coverageMap.put(COVERAGEINSUREDID, insuredId);
        coverageMap.put(COVERAGEADDITIONALINSUREDID, additionalInsuredId);
        coverageMap.put(COVERAGEPRODUCTCODE, productCode);
        coverageMap.put(COVERAGEPROPERTYINSUREDID, fieldsHipotecario.propertyInsuredId);//PropertyH
        //tiene que diferenciar el tipo de emisión de hipotecario
        if (fieldsHipotecario.requestype == REQUESTTYPEHIPOTECARIO) {
            coverageMap.put('sumAssured', fieldsHipotecario.sumAssured);
            coverageMap.put('sumAssuredContent', fieldsHipotecario.sumAssuredContent);
            coverageMap.put('totalAmountExpenses', fieldsHipotecario.totalAmountExpenses);
            coverageMap.put('primaryComission', fieldsHipotecario.primaryComission);
            coverageMap.put('requestype', fieldsHipotecario.requestype);
            coverageMap.put('totalAmountExpensesContent', fieldsHipotecario.totalAmountExpensesContent);
            coverageMap.put('hasContent', fieldsHipotecario.hasContent);
        } else if (fieldsVidaFlex.requestype == REQUESTTYPEVIDAFLEX || fieldsVidaFlex.requestype == REQUESTTYPECESANTIA) {
            coverageMap.put('totalDebtAmount', fieldsVidaFlex.totalDebtAmount);
            coverageMap.put('operationAmount', fieldsVidaFlex.operationAmount);
            coverageMap.put('requestype', fieldsVidaFlex.requestype);
        } else if (policyData.requestType == REQUESTTYPEFINANCIALPROTECTION || policyData.requestType == REQUESTTYPEFINANCIALPROTECTIONMB) {
            coverageMap.put('requestype', policyData.requestType);
            coverageMap.put('premium', policyData.premiumAmount);
            coverageMap.put('tax', policyData.taxAmount);
            coverageMap.put('fee', policyData.feeAmount);
        } else if (policyData.requestType == REQUESTTYPEUNEMPLOYMENT) { //nk 9833-6
            coverageMap.put('requestype', policyData.requestType);
            coverageMap.put('premium', policyData.premiumAmount);
            coverageMap.put('tax', policyData.taxAmount);
        }
        policyCoverageList.add(coverageMap);
        
        if (coverageInfo.containsKey(productCode)) {
            coverageInfo.get(productCode).add(coverageMap);
        } else {
            coverageInfo.put(productCode, policyCoverageList);
        }
    }
    /**
    * @description Mapea los datos para la creación de certificados
    * @author rcruzgar@emeal.nttdata.com
    * @param insurancePolicyId Identificador de la póliza
    * @return PS_PolicyCertificate__c datos del certificado de la póliza
    **/
    public static PS_PolicyCertificate__c generatePolicyCertificate(String insurancePolicyId) {
        PS_PolicyCertificate__c certificate = new PS_PolicyCertificate__c();
        InsurancePolicy policyId = new InsurancePolicy(SourceSystemIdentifier = insurancePolicyId);
        certificate.PS_OriginalPolicyId__r = policyId;
        certificate.PS_PolicyId__r = policyId;
        certificate.PS_SourceProcess__c = CERTIFICATESOURCEPROCESS;
        return certificate;
    }
    /**
    * @description Mapea los datos para la creación del registro de póliza
    * @author rcruzgar@emeal.nttdata.com
    * @param policy Datos de la póliza
    * @param request Datos de la solicitud de emisión
    * @return PS_MasivePolicyRegistration__c datos del registro de la póliza
    **/
    public static PS_MasivePolicyRegistration__c generatePolicyRegistration(InsurancePolicy policy, PS_IssuanceRequest__c request) {
        PS_MasivePolicyRegistration__c registration = new PS_MasivePolicyRegistration__c();
        registration.PS_CreatedBy__c = CREATIONUSER;
        registration.PS_OperationType__c = OPERATIONTYPE;
        registration.PS_CreatedDate__c = system.today();
        registration.PS_RequestStatus__c = REGISTRATIONSTATUS;
        registration.PS_ProductCode__c = request.PS_ProductId__r.vlocity_ins__ParentClassCode__c;
        registration.PS_PolicyNumber__c = policy.Name;
        registration.PS_ApplicationNumber__c = policy.PS_ApplicationNumber__c;
        registration.PS_OperationCode__c = policy.PS_OperationCode__c;
        registration.PS_AddressLine1__c = request.PS_Address__c;
        registration.PS_AddressLine2__c = request.PS_Department__c + '-' + request.PS_Province__c + '-' + request.PS_District__c;
        registration.PS_AddressLine3__c = null;
        registration.PS_ExternalRequestNumber__c = policy.PS_OperationNumber__c;
        return registration;
    }
    /**
    * @description Calcula el monto de la prima
    * @author rcruzgar@emeal.nttdata.com
    * @param issRequest Solicitud de emisión
    * @return Map<String,Decimal> Prima neta, igv y derecho de emisión
    **/
    public static Map<String,Decimal> premiumRating(PS_IssuanceRequest__c issRequest, List<PS_PolicyPricingSource__c> configPrimaMensual) {
        Map<String,Decimal> premiumAmounts = new Map<String,Decimal>();
        Decimal premiumFactor = (Decimal) factorMap.get('PS_PremiumFactor').get('PS_Value__c');
        Decimal taxFactor = (Decimal) factorMap.get('PS_TaxFactor').get('PS_Value__c');
        Decimal feeFactor = (Decimal) factorMap.get('PS_FeeFactor').get('PS_Value__c');

        Decimal totalPremium = 0;
        Decimal premium = 0;
        Decimal tax = 0;
        Decimal fee = 0;
       
        Decimal monthlyPremium = 0;
       
        if(issRequest.PS_IssuanceRequestType__c == REQUESTTYPEFINANCIALPROTECTION && issRequest.PS_ProductId__r.vlocity_ins__LineOfBusiness__c == '51'){
            totalPremium = (issRequest.PS_TotalDebtAmount__c * (issRequest.PS_ProductId__r.PS_PremiumRate__c/100)).setScale(2);
            premium = (totalPremium / premiumFactor).setScale(2);
            fee = premium * feeFactor;
            tax = (totalPremium - (premium + fee)).setScale(2);
        } else if(issRequest.PS_IssuanceRequestType__c == REQUESTTYPEFINANCIALPROTECTION){
            totalPremium = (issRequest.PS_TotalDebtAmount__c * (issRequest.PS_ProductId__r.PS_PremiumRate__c/100)).setScale(2);
            premium = (totalPremium / 1.18).setScale(2);
            tax = (premium * taxFactor).setScale(2);
            fee = 0;
        } else if(issRequest.PS_IssuanceRequestType__c == REQUESTTYPEFINANCIALPROTECTIONMB){ //972
            Decimal premiumRate = 0;
            for (PS_PolicyPricingSource__c config : configPrimaMensual) {
                if (config.PS_DataSource__c == 'Rate' &&
                    config.PS_TermStart__c <= issRequest.PS_CreditTerm__c && issRequest.PS_CreditTerm__c <= config.PS_TermEnd__c) { // Individual
                       premiumRate = config.PS_PremiumRate__c;
                }
        	}
            totalPremium = (issRequest.PS_OperationAmount__c * (premiumRate/100)).setScale(2);
            premium = totalPremium;
            tax = 0;
            fee = 0;
            
        } else if (issRequest.PS_IssuanceRequestType__c == REQUESTTYPEPROTECTEDFAMILY) {//PRODUCTO 971
        	for (PS_PolicyPricingSource__c config : configPrimaMensual) {
                String insuranceType = issRequest.PS_InsuranceType__c == 'M' ? 'F' : issRequest.PS_InsuranceType__c ;
                if (config.PS_DataSource__c == 'Premium' &&
                    config.PS_PlanType__c == insuranceType &&
                    config.PS_StartDate__c <= issRequest.PS_DisbursementDate__c && issRequest.PS_DisbursementDate__c <= config.PS_EndDate__c &&
                    config.PS_StartingAmount__c <= issRequest.PS_OperationAmount__c && issRequest.PS_OperationAmount__c <= config.PS_EndingAmount__c) { // Individual
                       monthlyPremium = config.PS_Premium__c;
                }
        	}
            totalPremium = (monthlyPremium * issRequest.PS_CreditTerm__c).setScale(2);  
            premium = (totalPremium / NETPREMIUMFACTOR).setScale(2);
            fee = premium * VALVIDAFLEX;
            tax = (totalPremium - (premium + fee)).setScale(2);
    	}    
        premiumAmounts.put('premium',premium);
        premiumAmounts.put('tax',tax);
        premiumAmounts.put('fee',fee);
        return premiumAmounts;
    }
    //nk 9833-6
    public static Map<String,Decimal> premiumRating (PS_IssuanceRequest__c issRequest) {
        Map<String,Decimal> premiumAmounts = new Map<String,Decimal>();
		
        Decimal premiumFactorUnployment = (Decimal)factorMap.get('PS_PremiumFactorUnemployment').get('PS_Value__c'); 
        Decimal taxFactor = (Decimal) factorMap.get('PS_TaxFactor').get('PS_Value__c');
		
        String productCode = String.valueOf(issRequest.PS_ProductCode__c).trim();
		        
        Decimal primaplan = 0;
        Decimal fee = 0;
        PS_ProductPremium__mdt planRecord = PS_ProductPremium__mdt.getInstance('Plan_'+productCode);
        if (planRecord != null && planRecord.Premium_Value__c != null) {
            primaplan = planRecord.Premium_Value__c;
        }
        
        Decimal premium = (primaplan / premiumFactorUnployment).setScale(2);
        Decimal tax     = (premium * taxFactor).setScale(2);

        premiumAmounts.put('premium', premium);
        premiumAmounts.put('tax', tax);
        premiumAmounts.put('fee',fee);

        system.debug(REQUESTTYPEPROTECTEDFAMILY + ' tax: ' + tax + ' fee: ' + fee + ' premium: ' + premium);  

        return premiumAmounts;
    }

    
    /**
    * @description Wrapper class para datos de póliza
    * @author rcruzgar@emeal.nttdata.com
    **/
    public class insurancePolicyWrapper {
        public String accountId {get; set;}
        public String contractorId {get; set;}
        public String policyNum {get; set;}
        public String requestNum {get; set;}
        public String operationNum {get; set;}
        public String requestType {get; set;}
        public Decimal commPercentage {get; set;}
        public Decimal premiumAmount {get; set;}
        public Decimal taxAmount {get; set;}
        public Decimal feeAmount {get; set;}
        public Decimal addPremiumAmount {get; set;}
        public Decimal addTaxAmount {get; set;}
        public Decimal addFeeAmount {get; set;}
        public Decimal totalPremiumAmount {get; set;}
        public Decimal totalTaxAmount {get; set;}
        public Decimal totalFeeAmount {get; set;} 
    }
    /**
   * @description Wrapper class para datos de cálculo de Hipotecario
   * @author jcalderr@emeal.nttdata.com
   **/
    public class fieldsHipotecarioWrapper {
        public Decimal sumAssured {get; set;}
        public Decimal sumAssuredContent {get; set;}
        public Decimal primaryComission {get; set;}
        public Decimal totalAmountExpenses {get; set;}
        public String propertyInsuredId {get; set;}
        public String requestype {get; set;}
        public Decimal totalAmountExpensesContent {get; set;}
        public String hasContent {get; set;}
    }
    public class fieldsVidaFlexWrapper {
        public Decimal totalDebtAmount {get; set;}
        public Decimal operationAmount {get; set;}
        public String requestype {get; set;}
    }
}